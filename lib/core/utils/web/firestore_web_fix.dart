// lib/core/utils/web/firestore_web_fix.dart

// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Clase utilitaria para manejar de forma segura los streams de Firestore en web
///
/// Esta clase proporciona métodos para transformar streams de Firestore que pueden
/// generar problemas en entorno web, específicamente con el error:
/// "final nextWrapper = ((firestore_interop.QuerySnapshotJsImpl snapshot) {...}).toJS"
class FirestoreWebFix {
  /// Transforma un stream de QuerySnapshot para hacerlo seguro en entorno web
  ///
  /// La implementación interna usa un StreamController que evita el problema del error
  /// del wrapper en la web.
  static Stream<QuerySnapshot<T>> safeQueryStream<T>(
      Stream<QuerySnapshot<T>> originalStream) {
    if (!kIsWeb) {
      // Si no estamos en web, simplemente devolvemos el stream original
      return originalStream;
    }

    // Si estamos en web, usamos un StreamController para transformar el stream
    final StreamController<QuerySnapshot<T>> controller =
        StreamController<QuerySnapshot<T>>.broadcast();

    // Manejo mejorado de errores para modo web
    controller.onCancel = () {
      controller.close();
    };

    // Intentar procesar el stream de manera segura
    try {
      if (kDebugMode) {
        print(
            'FirestoreWebFix: Aplicando wrapper de seguridad para stream de Firestore');
      }

      // Retraso mínimo para asegurar que el stream se inicialice correctamente
      Future.delayed(const Duration(milliseconds: 20), () {
        // Usar un try/catch para manejar posibles errores
        try {
          final subscription = originalStream.listen(
            (QuerySnapshot<T> snapshot) {
              if (controller.isClosed) return;
              controller.add(snapshot);
            },
            onError: (error) {
              if (kDebugMode) {
                print('FirestoreWebFix: Error en originalStream - $error');
              }
              if (controller.isClosed) return;
              controller.addError(error);
            },
            onDone: () {
              if (controller.isClosed) return;
              controller.close();
            },
          );

          // Asegurar que la suscripción se cancele cuando se cierre el controller
          controller.onCancel = () {
            subscription.cancel();
            controller.close();
          };
        } catch (e) {
          // Si hay un error, lo añadimos al stream y cerramos
          if (kDebugMode) {
            print('FirestoreWebFix: Error inicializando stream - $e');
          }
          if (!controller.isClosed) {
            controller.addError(e);
            // No cerramos el controller aquí para permitir reintentos
          }
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print('FirestoreWebFix: Error crítico inicializando wrapper - $e');
      }
      if (!controller.isClosed) {
        controller.addError(e);
        // No cerramos el controller para mantener el stream activo
      }
    }

    return controller.stream;
  }

  /// Transforma un stream de DocumentSnapshot para hacerlo seguro en entorno web
  static Stream<DocumentSnapshot<T>> safeDocumentStream<T>(
      Stream<DocumentSnapshot<T>> originalStream) {
    if (!kIsWeb) {
      return originalStream;
    }

    final StreamController<DocumentSnapshot<T>> controller =
        StreamController<DocumentSnapshot<T>>.broadcast();

    controller.onCancel = () {
      controller.close();
    };

    // Implementación mejorada para web
    try {
      if (kDebugMode) {
        print(
            'FirestoreWebFix: Aplicando wrapper de seguridad para document stream');
      }

      Future.delayed(const Duration(milliseconds: 20), () {
        try {
          final subscription = originalStream.listen(
            (DocumentSnapshot<T> snapshot) {
              if (controller.isClosed) return;
              controller.add(snapshot);
            },
            onError: (error) {
              if (kDebugMode) {
                print('FirestoreWebFix: Error en document stream - $error');
              }
              if (controller.isClosed) return;
              controller.addError(error);
            },
            onDone: () {
              if (controller.isClosed) return;
              controller.close();
            },
          );

          controller.onCancel = () {
            subscription.cancel();
            controller.close();
          };
        } catch (e) {
          if (kDebugMode) {
            print('FirestoreWebFix: Error inicializando document stream - $e');
          }
          if (!controller.isClosed) {
            controller.addError(e);
            // No cerramos aquí para permitir reintentos
          }
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print('FirestoreWebFix: Error crítico en document stream - $e');
      }
      if (!controller.isClosed) {
        controller.addError(e);
      }
    }

    return controller.stream;
  }
}
