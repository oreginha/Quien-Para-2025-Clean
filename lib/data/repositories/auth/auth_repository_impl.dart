import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quien_para/domain/entities/user/user_entity.dart';
import 'package:quien_para/domain/repositories/auth/auth_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

/// Implementación consolidada del AuthRepository
/// Combina todas las funcionalidades necesarias en una sola clase
class AuthRepositoryImpl implements AuthRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _firestore;
  final Logger _logger;

  // Stream controller para emitir cambios en el estado de autenticación
  final StreamController<bool> _authStateController =
      StreamController<bool>.broadcast();

  AuthRepositoryImpl({
    firebase_auth.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
    FirebaseFirestore? firestore,
    Logger? logger,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn(),
        _firestore = firestore ?? FirebaseFirestore.instance,
        _logger = logger ?? Logger() {
    // Suscribirse a los cambios de estado de autenticación
    _firebaseAuth.authStateChanges().listen((firebase_auth.User? user) {
      _authStateController.add(user != null);
      if (kDebugMode) {
        _logger.d(
            '🔐 Estado de autenticación cambiado: ${user != null ? "Autenticado" : "No autenticado"}');
      }
    });
  }

  @override
  Stream<bool> get authStateChanges => _authStateController.stream;

  @override
  Future<UserEntity?> getCurrentUser() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) return null;

      return UserEntity(
        id: user.uid,
        name: user.displayName,
        email: user.email,
        photoUrl: user.photoURL,
      );
    } catch (e) {
      _logger.e('Error al obtener usuario actual: $e');
      return null;
    }
  }

  @override
  String? getCurrentUserId() {
    return _firebaseAuth.currentUser?.uid;
  }

  @override
  Future<UserEntity?> getUserById(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (!doc.exists) return null;

      final data = doc.data();
      if (data == null) return null;

      return UserEntity(
        id: userId,
        name: data['name'],
        email: data['email'],
        photoUrl: data['photoUrl'],
      );
    } catch (e) {
      _logger.e('Error al obtener usuario por ID: $e');
      return null;
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    return _firebaseAuth.currentUser != null;
  }

  @override
  Future<UserEntity> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw Exception('Error en la autenticación con email y contraseña');
      }

      // Actualizar timestamp de último login
      await _updateLastLogin(user.uid);

      return UserEntity(
        id: user.uid,
        name: user.displayName,
        email: user.email,
        photoUrl: user.photoURL,
      );
    } catch (e) {
      _logger.e('Error al iniciar sesión con email: $e');
      rethrow;
    }
  }

  @override
  Future<UserEntity> signUpWithEmailAndPassword(
      String email, String password, String name) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw Exception('Error en el registro con email y contraseña');
      }

      // Actualizar perfil con el nombre
      await user.updateDisplayName(name);

      // Crear documento de usuario en Firestore
      await _createUserDocument(user, name);

      return UserEntity(
        id: user.uid,
        name: name,
        email: email,
      );
    } catch (e) {
      _logger.e('Error al registrar usuario: $e');
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      // Cerrar sesión de Google si está activa
      if (_googleSignIn.currentUser != null) {
        await _googleSignIn.signOut();
      }

      // Cerrar sesión en Firebase
      await _firebaseAuth.signOut();
    } catch (e) {
      _logger.e('Error al cerrar sesión: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateUser(UserEntity user) async {
    try {
      final userId = user.id;
      if (userId.isEmpty) {
        throw Exception('ID de usuario inválido');
      }

      final updateData = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Añadir solo los campos no nulos
      if (user.name != null) updateData['name'] = user.name;
      if (user.photoUrl != null) updateData['photoUrl'] = user.photoUrl;
      if (user.email != null) updateData['email'] = user.email;

      await _firestore.collection('users').doc(userId).update(updateData);
    } catch (e) {
      _logger.e('Error al actualizar usuario: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateUserData(String userId, Map<String, dynamic> data) async {
    try {
      if (userId.isEmpty) {
        throw Exception('ID de usuario inválido');
      }

      // Crear copia de los datos para evitar modificar el original
      final updateData = Map<String, dynamic>.from(data);

      // Manejar campos especiales
      if (updateData.containsKey('lastActive') &&
          updateData['lastActive'] is String) {
        updateData['lastActive'] = FieldValue.serverTimestamp();
      }

      // Agregar timestamp de actualización
      updateData['updatedAt'] = FieldValue.serverTimestamp();

      await _firestore.collection('users').doc(userId).update(updateData);
    } catch (e) {
      _logger.e('Error al actualizar datos de usuario: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      firebase_auth.User? user;

      // Manejo diferenciado para Web y Móvil
      if (kIsWeb) {
        // En Web - usar popup
        final googleProvider = firebase_auth.GoogleAuthProvider();
        googleProvider.addScope('email');
        googleProvider.addScope('profile');

        final userCredential =
            await _firebaseAuth.signInWithPopup(googleProvider);
        user = userCredential.user;
      } else {
        // En Móvil - usar flujo estándar
        final googleAccount = await _googleSignIn.signIn();
        if (googleAccount == null) {
          return {
            'status': 'cancelled',
            'message': 'Inicio de sesión cancelado',
            'success': false,
          };
        }

        final googleAuth = await googleAccount.authentication;
        final credential = firebase_auth.GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final userCredential =
            await _firebaseAuth.signInWithCredential(credential);
        user = userCredential.user;
      }

      if (user == null) {
        throw Exception('Error al iniciar sesión con Google');
      }

      // Actualizar o crear perfil de usuario
      await _updateUserProfile(user);

      return {
        'id': user.uid,
        'name': user.displayName ?? 'Usuario de Google',
        'email': user.email,
        'photoUrl': user.photoURL,
        'success': true,
      };
    } catch (e) {
      _logger.e('Error al iniciar sesión con Google: $e');
      return {
        'status': 'error',
        'message': e.toString(),
        'success': false,
      };
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        // Primero eliminar los datos del usuario de Firestore
        try {
          await _firestore.collection('users').doc(user.uid).delete();
        } catch (e) {
          _logger.w('Error al eliminar datos del usuario: $e');
        }

        // Luego eliminar la cuenta de autenticación
        await user.delete();
      }
    } catch (e) {
      _logger.e('Error al eliminar cuenta: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>?> getCurrentUserData() async {
    try {
      final userId = getCurrentUserId();
      if (userId == null) return null;

      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return doc.data();
      }

      // Si el documento no existe pero el usuario está autenticado, crear datos básicos
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        final userData = {
          'id': user.uid,
          'name': user.displayName ?? 'Usuario',
          'email': user.email,
          'photoUrl': user.photoURL,
          'createdAt': FieldValue.serverTimestamp(),
        };

        await _firestore.collection('users').doc(userId).set(userData);

        // Convertir FieldValue para retorno
        userData['createdAt'] = DateTime.now().toIso8601String();
        return userData;
      }

      return null;
    } catch (e) {
      _logger.e('Error al obtener datos del usuario: $e');
      return null;
    }
  }

  // ==================== MÉTODOS PRIVADOS ====================

  /// Actualiza el timestamp de último login
  Future<void> _updateLastLogin(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'lastLoginAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      _logger.w('Error al actualizar último login: $e');
      // No relanzar para no interrumpir el flujo de autenticación
    }
  }

  /// Crea el documento de usuario inicial en Firestore
  Future<void> _createUserDocument(firebase_auth.User user, String name) async {
    try {
      await _firestore.collection('users').doc(user.uid).set({
        'id': user.uid,
        'name': name,
        'email': user.email,
        'photoUrl': user.photoURL,
        'createdAt': FieldValue.serverTimestamp(),
        'lastLoginAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      _logger.e('Error al crear documento de usuario: $e');
      rethrow;
    }
  }

  /// Actualiza o crea el perfil del usuario en Firestore
  Future<void> _updateUserProfile(firebase_auth.User user) async {
    try {
      final userData = {
        'id': user.uid,
        'name': user.displayName ?? 'Usuario',
        'email': user.email,
        'photoUrl': user.photoURL,
        'lastLoginAt': FieldValue.serverTimestamp(),
      };

      // Verificar si el usuario ya existe
      final doc = await _firestore.collection('users').doc(user.uid).get();

      if (doc.exists) {
        // Actualizar solo los campos relevantes
        await _firestore.collection('users').doc(user.uid).update(userData);
      } else {
        // Crear nuevo documento
        userData['createdAt'] = FieldValue.serverTimestamp();
        await _firestore.collection('users').doc(user.uid).set(userData);
      }
    } catch (e) {
      _logger.w('Error al actualizar perfil de usuario: $e');
      // No relanzar para no interrumpir el proceso de autenticación
    }
  }

  /// Limpia los recursos al destruir la instancia
  void dispose() {
    _authStateController.close();
  }
}
