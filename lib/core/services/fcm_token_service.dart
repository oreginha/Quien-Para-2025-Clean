// lib/services/implementations/fcm_token_service.dart
// ignore_for_file: avoid_print, always_specify_types

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../../domain/interfaces/notification_service_interface.dart';

class FcmTokenService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final NotificationServiceInterface _notificationService;
  
  // Variables para control de estado
  bool _isProcessingToken = false;
  String? _cachedToken;
  
  // Singleton pattern
  static final FcmTokenService _instance = FcmTokenService._internal();
  factory FcmTokenService(NotificationServiceInterface notificationService) {
    _instance._notificationService = notificationService;
    return _instance;
  }
  FcmTokenService._internal();

  /// Registra el token FCM en Firestore para el usuario actual de manera asíncrona
  /// sin bloquear la interfaz de usuario
  Future<void> registerTokenForCurrentUser() async {
    // Evitar procesamiento simultáneo del token
    if (_isProcessingToken) {
      if (kDebugMode) {
        print('Ya hay un procesamiento de token en curso');
      }
      return;
    }
    
    _isProcessingToken = true;
    
    // Ejecutar en segundo plano para no bloquear la UI
    Future<void>.microtask(() async {
      try {
        final User? user = _auth.currentUser;
        if (user == null) {
          if (kDebugMode) {
            print('No hay usuario autenticado para registrar token FCM');
          }
          _isProcessingToken = false;
          return;
        }

        // Usar token en caché si está disponible para respuesta inmediata
        final String? token = _cachedToken ?? await _notificationService.getToken();
        _cachedToken = token; // Guardar en caché para usos futuros
        
        if (token == null || token.isEmpty) {
          if (kDebugMode) {
            print('No se pudo obtener token FCM');
          }
          _isProcessingToken = false;
          return;
        }

        if (kDebugMode) {
          print('Registrando token FCM para usuario ${user.uid}');
        }

        // Obtener documento de usuario actual para ver si el token ya está registrado
        final docRef = _firestore.collection('users').doc(user.uid);
        final docSnapshot = await docRef.get();

        if (docSnapshot.exists) {
          // El documento existe, actualizar array de tokens
          final userData = docSnapshot.data();
          final List<dynamic> existingTokens =
              userData?['fcmTokens'] as List<dynamic>? ?? [];

          // Verificar si el token ya existe
          if (!existingTokens.contains(token)) {
            // Si no existe, añadirlo
            existingTokens.add(token);

            // Actualizar documento
            await docRef.update({
              'fcmTokens': existingTokens,
              'lastTokenUpdate': FieldValue.serverTimestamp(),
            });

            if (kDebugMode) {
              print('Token FCM registrado correctamente');
            }
          } else {
            if (kDebugMode) {
              print('El token FCM ya está registrado para este usuario');
            }
          }
        } else {
          // El documento no existe, crearlo con el nuevo token
          await docRef.set({
            'fcmTokens': [token],
            'lastTokenUpdate': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));

          if (kDebugMode) {
            print('Token FCM registrado correctamente (nuevo documento)');
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error registrando token FCM: $e');
        }
      } finally {
        _isProcessingToken = false;
      }
    });
  }

  /// Elimina el token FCM actual de Firestore para el usuario actual
  Future<void> unregisterTokenForCurrentUser() async {
    final User? user = _auth.currentUser;
    if (user == null) {
      if (kDebugMode) {
        print('No hay usuario autenticado para eliminar token FCM');
      }
      return;
    }
    
    // Usar token en caché si está disponible para respuesta inmediata
    final String? token = _cachedToken ?? await _notificationService.getToken();
    
    // Si no hay token, no hay nada que hacer
    if (token == null || token.isEmpty) {
      if (kDebugMode) {
        print('No hay usuario autenticado para eliminar token FCM');
      }
      return;
    }
    
    // Ejecutar en segundo plano para no bloquear la UI
    Future<void>.microtask(() async {
      try {
        // Obtener documento de usuario
        final docRef = _firestore.collection('users').doc(user.uid);
        final docSnapshot = await docRef.get();

        if (docSnapshot.exists) {
          final userData = docSnapshot.data();
          final List<dynamic> existingTokens =
              userData?['fcmTokens'] as List<dynamic>? ?? [];

          // Eliminar el token si existe
          if (existingTokens.contains(token)) {
            existingTokens.remove(token);

            // Actualizar documento
            await docRef.update({
              'fcmTokens': existingTokens,
              'lastTokenUpdate': FieldValue.serverTimestamp(),
            });

            if (kDebugMode) {
              print('Token FCM eliminado correctamente');
            }
          } else {
            if (kDebugMode) {
              print('El token FCM no está registrado para este usuario');
            }
          }
        }
        
        // Limpiar caché de token
        _cachedToken = null;
      } catch (e) {
        if (kDebugMode) {
          print('Error eliminando token FCM: $e');
        }
      }
    });
  }

  /// Suscribe al usuario a un tema específico (por ejemplo, actualizaciones globales)
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _notificationService.subscribeToTopic(topic);

      if (kDebugMode) {
        print('Suscrito al tema: $topic');
      }

      // Ejecutar en segundo plano para no bloquear la UI
      Future<void>.microtask(() async {
        // Opcionalmente, guardar la suscripción en Firestore
        final User? user = _auth.currentUser;
        if (user != null) {
          final docRef = _firestore.collection('users').doc(user.uid);
          await docRef.set({
            'subscribedTopics': FieldValue.arrayUnion([topic]),
          }, SetOptions(merge: true));
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error suscribiendo al tema $topic: $e');
      }
    }
  }

  /// Desuscribe al usuario de un tema específico
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _notificationService.unsubscribeFromTopic(topic);

      if (kDebugMode) {
        print('Desuscrito del tema: $topic');
      }

      // Ejecutar en segundo plano para no bloquear la UI
      Future<void>.microtask(() async {
        // Opcionalmente, actualizar en Firestore
        final User? user = _auth.currentUser;
        if (user != null) {
          final docRef = _firestore.collection('users').doc(user.uid);
          await docRef.set({
            'subscribedTopics': FieldValue.arrayRemove([topic]),
          }, SetOptions(merge: true));
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error desuscribiendo del tema $topic: $e');
      }
    }
  }
  
  /// Obtiene el token FCM actual (desde caché si está disponible)
  Future<String?> getToken() async {
    if (_cachedToken != null) {
      return _cachedToken;
    }
    
    final String? token = await _notificationService.getToken();
    _cachedToken = token;
    return token;
  }
}
