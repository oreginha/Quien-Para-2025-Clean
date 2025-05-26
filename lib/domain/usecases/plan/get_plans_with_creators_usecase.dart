// lib/domain/usecases/plan/get_plans_with_creators_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:quien_para/domain/failures/app_failures.dart';
import 'package:quien_para/domain/repositories/plan/plan_repository.dart';
import 'package:quien_para/domain/entities/plan/plan_entity.dart';
import 'package:quien_para/domain/entities/plan/plan_with_creator_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

/// Caso de uso optimizado para obtener planes junto con los datos de sus creadores
/// utilizando batch loading para evitar múltiples consultas individuales
class GetPlansWithCreatorsUseCase {
  final PlanRepository _planRepository;
  final FirebaseFirestore _firestore;

  // Cache de datos de usuarios para evitar consultas repetidas
  final Map<String, Map<String, dynamic>> _usersCache = {};

  // Controlador para el stream optimizado de planes con creadores
  final _plansWithCreatorsController =
      StreamController<List<PlanWithCreatorEntity>>.broadcast();

  // Último ID de documento para paginación
  String? _lastDocumentId;

  // Tamaño de página para carga incremental
  final int _pageSize = 10;

  // Bandera para evitar cargas simultáneas
  bool _isLoading = false;

  GetPlansWithCreatorsUseCase(this._planRepository, this._firestore);

  /// Obtiene un stream de planes con sus creadores, cargando datos de forma eficiente
  Stream<List<PlanWithCreatorEntity>> execute({
    required String currentUserId,
    bool refresh = false,
  }) {
    if (refresh) {
      _clearCache();
    }

    // Iniciar la carga de planes
    _loadNextBatch(currentUserId);

    return _plansWithCreatorsController.stream;
  }

  /// Carga el siguiente lote de planes
  Future<void> loadMore(String currentUserId) async {
    await _loadNextBatch(currentUserId);
  }

  /// Método interno para cargar el siguiente lote de planes con sus creadores
  Future<void> _loadNextBatch(String currentUserId) async {
    // Evitar cargas simultáneas
    if (_isLoading) {
      return;
    }

    _isLoading = true;

    try {
      // 1. Obtener planes usando paginación basada en cursor
      final Either<AppFailure, List<PlanEntity>> plansResult =
          await _planRepository.getAll(
            limit: _pageSize,
            lastDocumentId: _lastDocumentId,
          );

      return plansResult.fold(
        (failure) {
          // En caso de fallo, emitir una lista vacía
          _plansWithCreatorsController.add([]);
          return;
        },
        (plans) async {
          if (plans.isEmpty) {
            // No hay más planes para cargar
            _isLoading = false;
            return;
          }

          // 2. Actualizar el cursor para la siguiente página
          _lastDocumentId = plans.isNotEmpty ? plans.last.id : null;

          // 3. Recolectar los IDs de creadores que no están en caché
          final List<String> creatorIdsToFetch = [];
          for (final plan in plans) {
            if (!_usersCache.containsKey(plan.creatorId)) {
              creatorIdsToFetch.add(plan.creatorId);
            }
          }

          // 4. Hacer una sola consulta batch para obtener todos los creadores necesarios
          if (creatorIdsToFetch.isNotEmpty) {
            // Dividir en chunks de 10 para evitar límites de Firestore
            for (int i = 0; i < creatorIdsToFetch.length; i += 10) {
              final end = (i + 10 < creatorIdsToFetch.length)
                  ? i + 10
                  : creatorIdsToFetch.length;
              final chunk = creatorIdsToFetch.sublist(i, end);

              final userDocs = await _firestore
                  .collection('users')
                  .where(FieldPath.documentId, whereIn: chunk)
                  .get();

              // Guardar datos de usuarios en caché
              for (final doc in userDocs.docs) {
                _usersCache[doc.id] = doc.data();
              }
            }
          }

          // 5. Combinar planes con datos de creadores
          final plansWithCreators = PlanWithCreatorEntity.fromPlansAndCreators(
            plans.where((plan) => plan.creatorId != currentUserId).toList(),
            _usersCache,
          );

          // 6. Emitir resultado actualizado
          _plansWithCreatorsController.add(plansWithCreators);
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error en GetPlansWithCreatorsUseCase: $e');
      }
      // En caso de error, emitir una lista vacía
      _plansWithCreatorsController.add([]);
    } finally {
      _isLoading = false;
    }
  }

  /// Limpia la caché y reinicia la paginación
  void _clearCache() {
    _usersCache.clear();
    _lastDocumentId = null;
    _isLoading = false;
  }

  /// Libera recursos cuando ya no sea necesario
  void dispose() {
    _plansWithCreatorsController.close();
  }
}
