// libcore/blocs/auth/auth_cubit.dart (consolidado)
// ignore_for_file: prefer_final_parameters, inference_failure_on_untyped_parameter, always_specify_types

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quien_para/domain/repositories/auth/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/fcm_token_service.dart';
import '../../../core/utils/auth_debugger.dart';
import '../../../core/utils/performance_logger.dart';
import 'auth_state.dart';
import 'package:logger/logger.dart';

/// Cubit para manejar el estado de autenticación con optimizaciones de rendimiento
/// y manejo resiliente de errores
class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  final SharedPreferences _prefs;
  final Logger logger = Logger();
  static const String _hasCompletedOnboardingKey = 'has_completed_onboarding';
  StreamSubscription<bool>? _authStateSubscription;

  // Control de estado para evitar múltiples llamadas y mejorar rendimiento
  bool _isProcessingAuth = false;
  bool _isInitialized = false;
  bool _isCheckingProfile = false;

  // Cache para evitar llamadas repetidas a Firestore
  final Map<String, bool> _profileValidationCache = <String, bool>{};
  final Map<String, Map<String, dynamic>> _userDataCache =
      <String, Map<String, dynamic>>{};

  // Servicio para gestionar tokens FCM
  FcmTokenService? _fcmTokenService;

  /// Constructor con inicialización optimizada
  AuthCubit(this._authRepository, this._prefs) : super(const AuthState()) {
    // Inicializar de manera asíncrona para evitar bloquear el hilo principal
    _initializeAsync();
  }

  /// Método para establecer el servicio FCM
  void setFcmTokenService(FcmTokenService service) {
    _fcmTokenService = service;
    if (kDebugMode) {
      logger.d('FcmTokenService establecido en AuthCubit');
    }
  }

  /// Inicialización asíncrona para evitar bloqueo del hilo principal
  Future<void> _initializeAsync() async {
    if (_isInitialized) return;

    try {
      await PerformanceLogger.logAsyncOperation('AuthCubit-Init', () async {
        // Configurar listener de estado de autenticación
        _setupAuthStateListener();

        _isInitialized = true;
        AuthDebugger.log('AuthCubit inicializado');
      });
    } catch (e) {
      AuthDebugger.logError('AuthCubit', 'Error en inicialización: $e');
    }
  }

  /// Configurar listener de cambios en el estado de autenticación
  void _setupAuthStateListener() {
    _authStateSubscription?.cancel();

    _authStateSubscription = _authRepository.authStateChanges.listen(
      (bool isAuthenticated) async {
        if (isAuthenticated) {
          final userId = _authRepository.getCurrentUserId();
          if (kDebugMode) {
            logger.d(
              '[DEBUG] AuthStateListener: Usuario autenticado: '
              '\u001b[33m\u001b[1m$userId\u001b[0m',
            );
          }
          AuthDebugger.log('Auth listener: Usuario autenticado $userId');
          // El usuario está autenticado, verificar su perfil
          checkAuthStatus();
        } else {
          if (kDebugMode) {
            logger.d('[DEBUG] AuthStateListener: Usuario no autenticado');
          }
          AuthDebugger.log('Auth listener: Usuario no autenticado');
          // Eliminar token FCM si el servicio está disponible
          if (_fcmTokenService != null) {
            await _fcmTokenService!.unregisterTokenForCurrentUser();
            if (kDebugMode) {
              logger.d('Token FCM eliminado al cerrar sesión');
            }
          }

          // Limpiar caché al cerrar sesión
          _profileValidationCache.clear();
          _userDataCache.clear();

          emit(
            const AuthState(
              status: AuthStatus.unauthenticated,
              hasUserProfile: false,
            ),
          );
        }
      },
      onError: (Object error) {
        AuthDebugger.logError('AuthCubit', 'Error en authStateChanges: $error');
        emit(
          AuthState(status: AuthStatus.error, errorMessage: error.toString()),
        );
      },
    );
  }

  /// Método optimizado para verificar perfil de usuario usando caché
  Future<bool> _checkUserProfile(String userId) async {
    // Método de logging para depuración
    void logProfile(String message) {
      AuthDebugger.log('[ProfileCheck] $message');
    }

    // Evitar múltiples llamadas simultáneas
    if (_isCheckingProfile) {
      logProfile(
        'Ya hay una verificación en progreso, usando cache: ${_profileValidationCache[userId] ?? false}',
      );
      // Si ya hay una verificación en progreso, usar el valor en caché o esperar
      return _profileValidationCache[userId] ?? false;
    }

    // Comprobar el caché primero
    if (_profileValidationCache.containsKey(userId)) {
      logProfile('Usando valor en caché: ${_profileValidationCache[userId]!}');
      return _profileValidationCache[userId]!;
    }

    // Verificar si el usuario ha completado el onboarding en SharedPreferences
    final bool hasCompletedOnboarding =
        _prefs.getBool(_hasCompletedOnboardingKey) ?? false;
    if (hasCompletedOnboarding) {
      _profileValidationCache[userId] = true;
      return true;
    }

    _isCheckingProfile = true;
    logProfile('Iniciando verificación de perfil para usuario: $userId');

    try {
      return await PerformanceLogger.logAsyncOperation(
        'Profile-Check-$userId',
        () async {
          final userData = await _authRepository.getCurrentUserData();

          if (userData == null) {
            logProfile('Datos de usuario no existen para userId: $userId');
            _profileValidationCache[userId] = false;
            return false;
          }

          // Validación rápida - si ya tenemos hasCompletedOnboarding = true
          if (userData.containsKey('hasCompletedOnboarding') &&
              userData['hasCompletedOnboarding'] == true) {
            logProfile('Usuario tiene hasCompletedOnboarding = true');
            _profileValidationCache[userId] = true;
            _userDataCache[userId] = userData;
            await _prefs.setBool(_hasCompletedOnboardingKey, true);
            return true;
          }

          // Almacenar datos en caché
          _userDataCache[userId] = userData;

          // Realizar la validación del perfil
          final bool isValid = _validateUserProfile(userData);

          // Almacenar resultado en caché
          _profileValidationCache[userId] = isValid;

          // Si tiene perfil, guardar en SharedPreferences para acceso más rápido
          if (isValid) {
            await _prefs.setBool(_hasCompletedOnboardingKey, true);
          }

          logProfile('Resultado de validación de perfil: $isValid');
          if (!isValid && kDebugMode) {
            // Log de los campos disponibles para depuración
            logger.d('Campos disponibles: ${userData.keys.join(', ')}');
          }

          return isValid;
        },
      );
    } catch (e) {
      AuthDebugger.logError(
        'AuthCubit',
        'Error comprobando perfil de usuario: $e',
      );
      _profileValidationCache[userId] = false;
      return false;
    } finally {
      _isCheckingProfile = false;
    }
  }

  // Método optimizado para validar perfil
  bool _validateUserProfile(Map<String, dynamic> userData) {
    // Verificación rápida - si ya tenemos hasCompletedOnboarding = true
    if (userData.containsKey('hasCompletedOnboarding') &&
        userData['hasCompletedOnboarding'] == true) {
      return true;
    }

    final List<String> requiredFields = [
      'name',
      'age',
      'gender',
      'location',
      'interests',
      'photoUrls',
      'bio',
    ];

    // Verificar campos requeridos de manera eficiente
    for (final String field in requiredFields) {
      if (!userData.containsKey(field)) {
        if (kDebugMode) {
          logger.d('Perfil incompleto: falta campo $field');
        }
        return false;
      }
    }

    // Validar tipos y valores mínimos
    final bool interestsValid = userData['interests'] is List &&
        (userData['interests'] as List).isNotEmpty;

    final bool photosValid = userData['photoUrls'] is List &&
        (userData['photoUrls'] as List).isNotEmpty;

    final bool isValid = userData['name'].toString().isNotEmpty &&
        (userData['age'] as num?) != null &&
        userData['gender'].toString().isNotEmpty &&
        userData['location'].toString().isNotEmpty &&
        interestsValid &&
        photosValid &&
        userData['bio'].toString().isNotEmpty;

    if (kDebugMode && !isValid) {
      logger.d(
        'Perfil incompleto: alguno de los campos requeridos no cumple con los criterios',
      );
    }

    return isValid;
  }

  // Constructor original reemplazado por el constructor optimizado en la consolidación

  /// Método para iniciar sesión con email y password
  ///
  /// Sigue el mismo patrón de implementación que signInWithGoogle
  /// para mantener consistencia con la arquitectura limpia
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    if (state.status == AuthStatus.loading) return;

    if (kDebugMode) {
      logger.d('Iniciando login con Email y Password');
    }

    emit(const AuthState(status: AuthStatus.loading));
    try {
      // Obtenemos resultado del inicio de sesión con Email/Password
      final userEntity = await _authRepository.signInWithEmailAndPassword(
        email,
        password,
      );

      // Obtener datos de usuario completos
      final Map<String, dynamic>? userData =
          await _authRepository.getCurrentUserData();

      if (userData != null) {
        final String userId = userEntity
            .id; // Non-null assertion después de verificar que no es null
        _userDataCache[userId] = userData;

        // Forzar una verificación fresca del perfil (ignorando caché)
        _profileValidationCache.remove(
          userId,
        ); // Limpiar caché para forzar verificación
        final bool hasProfile = await _checkUserProfile(userId);
        _profileValidationCache[userId] = hasProfile;

        if (kDebugMode) {
          logger.d(
            'Login con Email exitoso - Usuario: $userId, Tiene perfil: $hasProfile',
          );
        }

        emit(
          AuthState(
            status: AuthStatus.authenticated,
            user: userData,
            hasUserProfile: hasProfile,
          ),
        );

        // Registro del token FCM en el servidor puede hacerse de forma asíncrona
        // usando una técnica de fire-and-forget para no bloquear la interfaz de usuario
        Future<void>.microtask(() {
          try {
            if (_fcmTokenService != null) {
              _fcmTokenService!.registerTokenForCurrentUser();
            }
          } catch (e) {
            // Ignorar errores en este punto
            if (kDebugMode) {
              logger.e('Error registrando token FCM: $e');
            }
          }
        });

        if (kDebugMode) {
          logger.d('Token FCM registrado tras inicio de sesión con Email');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        logger.e('Error en signInWithEmailAndPassword: $e');
      }

      emit(AuthState(status: AuthStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> signInWithGoogle() async {
    if (state.status == AuthStatus.loading) return;

    if (kDebugMode) {
      logger.d('Iniciando login con Google');
    }

    emit(const AuthState(status: AuthStatus.loading));
    try {
      // Obtenemos resultado del inicio de sesión con Google
      final result = await _authRepository.signInWithGoogle();

      // Verificar si es una redirección iniciada (solo para web)
      if (kIsWeb && result['status'] == 'redirect_initiated') {
        if (kDebugMode) {
          logger.d(
            'Redirección de autenticación iniciada, esperando resultado',
          );
        }

        // Mantener el estado de carga mientras se completa la redirección
        return;
      }

      // Verificar si el usuario canceló la autenticación
      if (result['status'] == 'cancelled') {
        if (kDebugMode) {
          logger.d(
            'Autenticación cancelada por el usuario: ${result['message'] ?? 'Sin mensaje'}',
          );
        }

        // Volver al estado no autenticado
        emit(
          AuthState(
            status: AuthStatus.unauthenticated,
            hasUserProfile: false,
            errorMessage:
                null, // No mostramos mensaje de error ya que fue una cancelación voluntaria
          ),
        );
        return;
      }

      // Asegurarnos que userData tiene la estructura esperada
      final Map<String, dynamic> userData = result;
      if (!userData.containsKey('success')) {
        userData['success'] = true;
      }

      // Almacenar datos en caché
      if (userData['id'] != null) {
        final String userId = userData['id'] as String;
        _userDataCache[userId] = userData;

        // Forzar una verificación fresca del perfil (ignorando caché)
        _profileValidationCache.remove(
          userId,
        ); // Limpiar caché para forzar verificación
        final bool hasProfile = await _checkUserProfile(userId);
        _profileValidationCache[userId] = hasProfile;

        if (kDebugMode) {
          logger.d(
            'Login con Google exitoso - Usuario: $userId, Tiene perfil: $hasProfile',
          );
        }

        emit(
          AuthState(
            status: AuthStatus.authenticated,
            user: userData,
            hasUserProfile: hasProfile,
          ),
        );

        // Registro del token FCM en el servidor puede hacerse de forma asíncrona
        // usando una técnica de fire-and-forget para no bloquear la interfaz de usuario
        Future<void>.microtask(() {
          try {
            if (_fcmTokenService != null) {
              _fcmTokenService!.registerTokenForCurrentUser();
              if (kDebugMode) {
                logger.d(
                  'Token FCM registrado tras inicio de sesión con Google',
                );
              }
            }
          } catch (e) {
            // Ignorar errores en este punto
            if (kDebugMode) {
              logger.e('Error registrando token FCM: $e');
            }
          }
        });
      }
    } catch (e) {
      if (kDebugMode) {
        logger.e('Error en signInWithGoogle: $e');
      }

      // Verificar si a pesar del error el usuario está autenticado
      final bool isAuth = await _authRepository.isAuthenticated();
      if (isAuth) {
        final String? userId = _authRepository.getCurrentUserId();

        if (userId != null) {
          if (kDebugMode) {
            logger.d('Recuperando de error - Usuario autenticado: $userId');
          }

          // Forzar una verificación fresca del perfil
          _profileValidationCache.remove(
            userId,
          ); // Limpiar caché para forzar verificación
          Map<String, dynamic>? userData =
              await _authRepository.getCurrentUserData();

          if (userData != null) {
            _userDataCache[userId] = userData;
            final bool hasProfile = await _checkUserProfile(userId);
            _profileValidationCache[userId] = hasProfile;

            if (kDebugMode) {
              logger.d(
                'Recuperación exitosa - Usuario: $userId, Tiene perfil: $hasProfile',
              );
            }

            emit(
              AuthState(
                status: AuthStatus.authenticated,
                user: userData,
                hasUserProfile: hasProfile,
              ),
            );

            // Registrar token FCM incluso en caso de error de login
            if (_fcmTokenService != null) {
              await _fcmTokenService!.registerTokenForCurrentUser();
              if (kDebugMode) {
                logger.d('Token FCM registrado tras recuperación de error');
              }
            }
            return;
          }
        }
      }

      emit(AuthState(status: AuthStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> logout() async {
    emit(const AuthState(status: AuthStatus.loading));
    try {
      final String? userId = _authRepository.getCurrentUserId();
      if (userId != null) {
        // Actualizar estado de visibilidad a través del repositorio
        // En la implementación del repositorio se deben manejar los detalles de Firestore
        final Map<String, dynamic> updateData = {
          'isVisible': false,
          'lastActive': DateTime.now().toIso8601String(),
        };
        await _authRepository.updateUserData(userId, updateData);

        // Eliminar token FCM si el servicio está disponible
        if (_fcmTokenService != null) {
          await _fcmTokenService!.unregisterTokenForCurrentUser();
          if (kDebugMode) {
            logger.d('Token FCM eliminado durante logout');
          }
        }
      }

      // Usamos signOut() para coincidir con la interfaz consolidada
      await _authRepository.signOut();
      await _prefs.remove(_hasCompletedOnboardingKey);

      // Limpiar caché al cerrar sesión
      _profileValidationCache.clear();
      _userDataCache.clear();

      emit(
        const AuthState(
          status: AuthStatus.unauthenticated,
          hasUserProfile: false,
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        logger.d('Error en logout: $e');
      }
      emit(AuthState(status: AuthStatus.error, errorMessage: e.toString()));
    }
  }

  // Método checkAuthStatus original reemplazado por la versión optimizada al final del archivo

  Future<void> completeOnboarding() async {
    try {
      final String? userId = _authRepository.getCurrentUserId();
      if (userId == null) {
        throw Exception('Usuario no autenticado');
      }

      await _prefs.setBool(_hasCompletedOnboardingKey, true);

      // Asegurar que el documento del usuario tenga hasCompletedOnboarding = true
      // Actualizar estado de completado de onboarding
      final Map<String, dynamic> updateData = {'hasCompletedOnboarding': true};
      await _authRepository.updateUserData(
        userId,
        updateData,
      ); // Forzar actualización del caché de perfil
      _profileValidationCache[userId] = true;

      // Obtener datos actualizados del usuario
      Map<String, dynamic>? userData =
          await _authRepository.getCurrentUserData();
      if (userData != null) {
        _userDataCache[userId] = userData;
      }

      if (kDebugMode) {
        logger.d('Onboarding completado para el usuario: $userId');
      }

      emit(
        AuthState(
          status: AuthStatus.authenticated,
          user: userData ?? state.user,
          hasUserProfile: true, // Forzar a true después de completar onboarding
          errorMessage: null,
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        logger.e('Error en completeOnboarding: $e');
      }
      emit(AuthState(status: AuthStatus.error, errorMessage: e.toString()));
    }
  }

  Future<void> deleteAccount() async {
    emit(const AuthState(status: AuthStatus.loading));
    try {
      final String? userId = _authRepository.getCurrentUserId();
      if (userId != null) {
        // Eliminar token FCM si el servicio está disponible
        if (_fcmTokenService != null) {
          await _fcmTokenService!.unregisterTokenForCurrentUser();
          if (kDebugMode) {
            logger.d('Token FCM eliminado durante deleteAccount');
          }
        }

        // Eliminar el perfil de usuario (manejado por el repositorio)
        // La operación deleteAccount() en el repositorio debe encargarse de eliminar los datos de usuario
        // Eliminar la cuenta de autenticación
        await _authRepository.deleteAccount();
        // Limpiar preferencias
        await _prefs.remove(_hasCompletedOnboardingKey);

        // Limpiar caché
        _profileValidationCache.remove(userId);
        _userDataCache.remove(userId);
      }

      emit(
        const AuthState(
          status: AuthStatus.unauthenticated,
          hasUserProfile: false,
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        logger.d('Error en deleteAccount: $e');
      }
      emit(AuthState(status: AuthStatus.error, errorMessage: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    AuthDebugger.log('AuthCubit cerrado');
    return super.close();
  }

  /// Verificar el estado de autenticación actual con protección contra llamadas simultáneas
  /// Optimizado para web y debug en Chrome
  Future<void> checkAuthStatus() async {
    // Evitar múltiples comprobaciones simultáneas
    if (_isProcessingAuth || state.status == AuthStatus.loading) {
      AuthDebugger.log('checkAuthStatus: Ya hay una comprobación en proceso');
      return;
    }

    AuthDebugger.log(
      'checkAuthStatus: Iniciando verificación de autenticación',
    );
    _isProcessingAuth = true;
    emit(const AuthState(status: AuthStatus.loading));

    try {
      await PerformanceLogger.logAsyncOperation('AuthStatus-Check', () async {
        // Primero verificamos si hay una autenticación activa
        final bool isAuth = await _authRepository.isAuthenticated();

        if (!isAuth) {
          AuthDebugger.log('checkAuthStatus: No hay autenticación activa');
          emit(
            const AuthState(
              status: AuthStatus.unauthenticated,
              hasUserProfile: false,
            ),
          );
          return;
        }

        final String? userId = _authRepository.getCurrentUserId();
        if (kDebugMode) {
          logger.d(
            '[DEBUG] checkAuthStatus: userId obtenido: '
            '[33m[1m$userId[0m',
          );
        }
        // Si no hay usuario, marcar como no autenticado
        if (userId == null) {
          AuthDebugger.log(
            'checkAuthStatus: No hay usuario, emitiendo unauthenticated',
          );
          emit(
            const AuthState(
              status: AuthStatus.unauthenticated,
              hasUserProfile: false,
            ),
          );
          return;
        }

        // Comprobar si el usuario tiene perfil (usando caché si está disponible)
        final bool hasProfile = await _checkUserProfile(userId);
        if (kDebugMode) {
          logger.d(
            '[DEBUG] checkAuthStatus: hasProfile: '
            '[36m[1m$hasProfile[0m',
          );
        }
        // Obtener datos del usuario (usando caché si está disponible)
        final Map<String, dynamic>? userData = await _getCachedUserData(userId);
        if (kDebugMode) {
          logger.d(
            '[DEBUG] checkAuthStatus: userData: '
            '[32m[1m${userData?.toString()}[0m',
          );
        }
        if (userData != null) {
          AuthDebugger.log('checkAuthStatus: Emitiendo authenticated');
          emit(
            AuthState(
              status: AuthStatus.authenticated,
              user: userData,
              hasUserProfile: hasProfile,
            ),
          );

          // Asegurar que el token FCM esté registrado (solo en caso de autenticación exitosa)
          if (_fcmTokenService != null) {
            _fcmTokenService!.registerTokenForCurrentUser().catchError((e) {
              // Ignorar errores en este punto para no afectar la UI
              if (kDebugMode) {
                logger.e('Error registrando token FCM en checkAuthStatus: $e');
              }
            });
          }
        } else {
          AuthDebugger.log(
            'checkAuthStatus: No hay datos de usuario, emitiendo unauthenticated',
          );
          emit(
            const AuthState(
              status: AuthStatus.unauthenticated,
              hasUserProfile: false,
            ),
          );
        }
      });
    } catch (e) {
      AuthDebugger.logError('AuthCubit', 'Error en checkAuthStatus: $e');
      // Intentar recuperarse de errores verificando directamente el estado de autenticación
      final isAuth = await _authRepository.isAuthenticated();
      if (isAuth) {
        final String? userId = _authRepository.getCurrentUserId();
        if (userId != null) {
          try {
            final userData = await _authRepository.getCurrentUserData();
            if (userData != null) {
              // Forzar el estado autenticado a pesar del error
              emit(
                AuthState(
                  status: AuthStatus.authenticated,
                  user: userData,
                  hasUserProfile:
                      true, // Asumimos que tiene perfil para recuperar
                ),
              );
              return;
            }
          } catch (_) {
            // Ignorar errores secundarios
          }
        }
      }

      emit(AuthState(status: AuthStatus.error, errorMessage: e.toString()));
    } finally {
      _isProcessingAuth = false;
    }
  }

  /// Obtener datos de usuario con soporte de caché para reducir lecturas a Firestore
  Future<Map<String, dynamic>?> _getCachedUserData(String userId) async {
    // Verificar si ya tenemos datos en caché
    if (_userDataCache.containsKey(userId)) {
      return _userDataCache[userId];
    }

    try {
      final userData = await _authRepository.getCurrentUserData();
      if (userData != null) {
        _userDataCache[userId] = userData;
      }
      return userData;
    } catch (e) {
      AuthDebugger.logError(
        'AuthCubit',
        'Error obteniendo datos de usuario: $e',
      );
      return null;
    }
  }
}
