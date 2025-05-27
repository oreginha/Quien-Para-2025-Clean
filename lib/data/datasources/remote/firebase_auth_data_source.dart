import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:quien_para/core/services/google_sign_in_fix.dart';
import 'package:quien_para/data/datasources/auth_data_source.dart';
import 'package:quien_para/domain/entities/user/user_entity.dart';

/// Firebase implementation of [AuthDataSource]
class FirebaseAuthDataSource implements AuthDataSource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final Logger _logger;

  FirebaseAuthDataSource({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    Logger? logger,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _logger = logger ?? Logger();

  @override
  Future<UserEntity?> getCurrentUser() async {
    final User? firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return null;

    try {
      final doc =
          await _firestore.collection('users').doc(firebaseUser.uid).get();
      if (!doc.exists) return null;

      final userData = doc.data() ?? {};
      return UserEntity(
        id: firebaseUser.uid,
        email: firebaseUser.email,
        name: userData['name'] as String? ?? firebaseUser.displayName,
        photoUrl: userData['photoUrls'] != null &&
                (userData['photoUrls'] as List).isNotEmpty
            ? (userData['photoUrls'] as List).first as String?
            : firebaseUser.photoURL,
        // Add other fields as needed
      );
    } catch (e) {
      _logger.e('Error getting current user data: $e');
      return null;
    }
  }

  @override
  Future<UserEntity?> getUserById(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (!doc.exists) return null;

      final userData = doc.data() ?? {};
      return UserEntity(
        id: userId,
        email: userData['email'] as String?,
        name: userData['name'] as String?,
        photoUrl: userData['photoUrls'] != null &&
                (userData['photoUrls'] as List).isNotEmpty
            ? (userData['photoUrls'] as List).first as String?
            : null,
        // Add other fields as needed
      );
    } catch (e) {
      _logger.e('Error getting user by ID: $e');
      return null;
    }
  }

  @override
  Future<UserEntity> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = credential.user;
      if (user == null) {
        throw Exception('Authentication failed: No user returned');
      }

      final userEntity = await getCurrentUser();
      if (userEntity == null) {
        throw Exception('Failed to get user data after sign in');
      }

      return userEntity;
    } catch (e) {
      _logger.e('Error signing in: $e');
      throw Exception('Authentication failed: $e');
    }
  }

  @override
  Future<UserEntity> signUpWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) async {
    try {
      final UserCredential credential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      final User? user = credential.user;
      if (user == null) {
        throw Exception('Registration failed: No user returned');
      }

      // Update display name
      await user.updateDisplayName(name);

      // Create initial user profile in Firestore
      await _firestore.collection('users').doc(user.uid).set({
        'email': email,
        'name': name,
        'createdAt': FieldValue.serverTimestamp(),
        'userId': user.uid,
      });

      return UserEntity(id: user.uid, email: email, name: name, photoUrl: null);
    } catch (e) {
      _logger.e('Error signing up: $e');
      throw Exception('Registration failed: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      _logger.e('Error signing out: $e');
      throw Exception('Sign out failed: $e');
    }
  }

  @override
  String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

  @override
  bool isAuthenticated() {
    return _auth.currentUser != null;
  }

  /// Sign in with Google and return the authenticated user
  @override
  Future<UserEntity> signInWithGoogle() async {
    try {
      // Importar el servicio de Google Sign In
      final googleSignInService = GoogleSignInService();

      // Iniciar el flujo de Google Sign In
      final googleUser = await googleSignInService.signIn();

      if (googleUser == null) {
        throw Exception('Google Sign In cancelado por el usuario');
      }

      // Obtener la autenticación de Google
      final googleAuth = await googleUser.authentication;

      // Crear credenciales para Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Iniciar sesión en Firebase con las credenciales de Google
      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user == null) {
        throw Exception('Authentication failed: No user returned');
      }

      // Verificar si el usuario ya existe en Firestore
      final userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (!userDoc.exists) {
        // Si el usuario no existe, crear un nuevo documento
        await _firestore.collection('users').doc(user.uid).set({
          'email': user.email,
          'name': user.displayName,
          'photoUrl': user.photoURL,
          'createdAt': FieldValue.serverTimestamp(),
          'userId': user.uid,
        });
      }

      // Obtener el usuario actualizado
      final userEntity = await getCurrentUser();
      if (userEntity == null) {
        throw Exception('Failed to get user data after sign in with Google');
      }

      return userEntity;
    } catch (e) {
      _logger.e('Error signing in with Google: $e');
      throw Exception('Google authentication failed: $e');
    }
  }
}
