// lib/core/utils/data_loading/firestore_batch_loader.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'batch_loader.dart';
import 'data_cache_manager.dart';

/// Clase para cargar datos de Firestore de manera optimizada en lotes
class FirestoreBatchLoader<T> {
  /// Instancia de Firestore
  final FirebaseFirestore _firestore;
  
  /// Nombre de la colección en Firestore
  final String _collection;
  
  /// Administrador de caché para los datos
  final DataCacheManager<T> _cacheManager;
  
  /// Cargador de lotes para optimizar solicitudes
  final BatchLoader _batchLoader;
  
  /// Función para convertir documentos a objetos
  final T Function(Map<String, dynamic> data, String id) _converter;
  
  /// Tamaño máximo de cada lote
  final int _maxBatchSize;
  
  /// Constructor con parámetros opcionales
  FirestoreBatchLoader({
    required String collection,
    required T Function(Map<String, dynamic> data, String id) converter,
    FirebaseFirestore? firestore,
    DataCacheManager<T>? cacheManager,
    BatchLoader? batchLoader,
    int maxBatchSize = 10,
    Duration? batchDelay,
    Duration? cacheExpiration,
  }) : 
    _collection = collection,
    _converter = converter,
    _firestore = firestore ?? FirebaseFirestore.instance,
    _cacheManager = cacheManager ?? DataCacheManager<T>(
      defaultExpirationTime: cacheExpiration ?? const Duration(minutes: 5),
      maxCacheSize: 100,
    ),
    _batchLoader = batchLoader ?? BatchLoader(
      batchDelay: batchDelay ?? const Duration(milliseconds: 300),
    ),
    _maxBatchSize = maxBatchSize;
  
  /// Carga documentos en lotes usando 'whereIn' para reducir solicitudes
  Future<void> loadDocuments(
    List<String> ids, {
    bool forceRefresh = false,
    Function(List<String> loadedIds)? onBatchLoaded,
    Function(String id, T item)? onDocumentLoaded,
    Function(String message)? onError,
  }) async {
    if (ids.isEmpty) return;
    
    // Filtrar IDs que no están en caché o necesitan actualización
    final List<String> idsToLoad = forceRefresh 
        ? ids 
        : _cacheManager.getMissingKeys(ids);
    
    // Si no hay nada que cargar, retornar los datos de caché
    if (idsToLoad.isEmpty) {
      _notifyFromCache(ids, onDocumentLoaded);
      return;
    }
    
    // Programar carga en lotes
    _batchLoader.scheduleBatch(() async {
      try {
        // Dividir en lotes para respetar límite de 'whereIn' (10 valores máximo)
        for (int i = 0; i < idsToLoad.length; i += _maxBatchSize) {
          final int end = (i + _maxBatchSize < idsToLoad.length) 
              ? i + _maxBatchSize 
              : idsToLoad.length;
              
          final List<String> currentBatch = idsToLoad.sublist(i, end);
          
          try {
            // Usar 'whereIn' para hacer una única solicitud por lote
            final QuerySnapshot snapshot = await _firestore
                .collection(_collection)
                .where(FieldPath.documentId, whereIn: currentBatch)
                .get();
                
            // Procesar los documentos encontrados
            final List<String> loadedIds = [];
            
            for (final doc in snapshot.docs) {
              final String docId = doc.id;
              final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              
              try {
                // Convertir datos a objeto usando la función del cliente
                final T item = _converter(data, docId);
                
                // Guardar en caché
                _cacheManager.put(docId, item);
                
                // Notificar carga individual
                if (onDocumentLoaded != null) {
                  onDocumentLoaded(docId, item);
                }
                
                loadedIds.add(docId);
              } catch (conversionError) {
                if (kDebugMode) {
                  print('Error convirtiendo documento $docId: $conversionError');
                }
              }
            }
            
            // Marcar documentos no encontrados como nulos en caché
            final List<String> notFoundIds = currentBatch
                .where((id) => !loadedIds.contains(id))
                .toList();
                
            for (final id in notFoundIds) {
              _cacheManager.put(id, null);
            }
            
            // Notificar carga del lote completo
            if (onBatchLoaded != null) {
              onBatchLoaded(loadedIds);
            }
          } catch (batchError) {
            if (kDebugMode) {
              print('Error cargando lote: $batchError');
            }
            
            if (onError != null) {
              onError('Error al cargar documentos: $batchError');
            }
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error general en carga por lotes: $e');
        }
        
        if (onError != null) {
          onError('Error general al cargar documentos: $e');
        }
      }
    });
  }
  
  /// Notifica con datos desde la caché
  void _notifyFromCache(List<String> ids, Function(String, T)? onDocumentLoaded) {
    if (onDocumentLoaded == null) return;
    
    for (final id in ids) {
      final cachedItem = _cacheManager.get(id);
      if (cachedItem != null) {
        onDocumentLoaded(id, cachedItem);
      }
    }
  }
  
  /// Obtiene un documento del caché
  T? getFromCache(String id) {
    return _cacheManager.get(id);
  }
  
  /// Verifica si un documento está en caché
  bool hasInCache(String id) {
    return _cacheManager.has(id);
  }
  
  /// Limpia la caché
  void clearCache() {
    _cacheManager.clear();
  }
  
  /// Elimina documentos expirados de la caché
  void purgeExpiredDocuments() {
    _cacheManager.purgeExpiredItems();
  }
  
  /// Limpia recursos
  void dispose() {
    _batchLoader.dispose();
  }
}
