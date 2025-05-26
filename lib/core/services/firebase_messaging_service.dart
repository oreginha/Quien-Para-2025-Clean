// ignore_for_file: prefer_final_parameters, inference_failure_on_untyped_parameter

import 'dart:async';
import 'dart:isolate';
import 'dart:ui';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import '../utils/performance_logger.dart';

// Este handler debe estar fuera de cualquier clase, a nivel de archivo
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // No inicializamos Firebase aquí ya que debe estar inicializado en el main
  // Evitamos inicialización duplicada que puede causar problemas

  // No realizar logs extensos para evitar sobrecarga
  // No realizar operaciones de UI, red, o Firestore aquí

  // Solo registrar el ID del mensaje para debugging si es necesario
  if (kDebugMode) {
    print('[FCM-Background] Mensaje recibido: ${message.messageId}');
  }
}

class FirebaseMessagingService {
  static final FirebaseMessagingService _instance =
      FirebaseMessagingService._internal();
  factory FirebaseMessagingService() => _instance;
  FirebaseMessagingService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final StreamController<RemoteMessage> _messageStreamController =
      StreamController<RemoteMessage>.broadcast();

  Stream<RemoteMessage> get messageStream => _messageStreamController.stream;

  // Constante para el puerto de comunicación entre isolates
  static const String _isolatePortName = 'fcm_isolate_port';

  // Flag para evitar múltiples inicializaciones
  bool _isInitialized = false;

  Future<void> initialize() async {
    // Evitar inicialización múltiple
    if (_isInitialized) return;

    // Marcar como inicializado inmediatamente para evitar múltiples intentos
    _isInitialized = true;

    // Usar microtask para diferir la inicialización y no bloquear el arranque de la app
    Future<void>.microtask(() async {
      try {
        await PerformanceLogger.logAsyncOperation('FCM-Inicialización', () async {
          // Configurar manejador en segundo plano - necesario mantenerlo
          FirebaseMessaging.onBackgroundMessage(
            _firebaseMessagingBackgroundHandler,
          );

          // Configurar puerto para comunicación entre isolates (si es necesario)
          if (!kIsWeb) {
            // Registrar puerto para comunicación entre isolates
            final ReceivePort port = ReceivePort();
            IsolateNameServer.registerPortWithName(
              port.sendPort,
              _isolatePortName,
            );
          }

          // Usar un único listener para mensajes en primer plano
          // y procesar de forma eficiente
          FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

          // Inicializar listeners para mensajes que abren la app
          await initializeOpenedAppListener();

          // Solicitar permisos (solo iOS y web) - operación potencialmente lenta
          // Mover al final para no bloquear otras inicializaciones
          final NotificationSettings settings = await _messaging
              .requestPermission(
                alert: true,
                badge: true,
                sound: true,
                provisional: false,
              );

          // Reducir logs en modo debug para evitar sobrecarga
          if (kDebugMode) {
            print('[FCM] Permisos: ${settings.authorizationStatus}');
          }
        });
      } catch (e) {
        if (kDebugMode) {
          print('[FCM] Error en inicialización: $e');
        }
        // No propagar el error para evitar que la app falle
        _isInitialized =
            true; // Mantener como inicializado para evitar reintentos constantes
      }
    });
  }

  // Método separado para manejar mensajes en primer plano de forma eficiente
  void _handleForegroundMessage(RemoteMessage message) {
    // Procesamiento mínimo para evitar bloqueos de UI
    if (message.notification != null) {
      // Usar compute para procesar el mensaje en un isolate separado si contiene datos pesados
      if (message.data.isNotEmpty && message.data.length > 5) {
        compute(_processMessageData, message).then((_) {
          // Solo agregar al stream después de procesar
          _messageStreamController.add(message);
        });
      } else {
        // Para mensajes simples, procesar directamente
        _messageStreamController.add(message);
      }
    }
  }

  // Método estático para procesar datos de mensaje en un isolate separado
  static void _processMessageData(RemoteMessage message) {
    // Aquí se puede realizar procesamiento pesado de los datos del mensaje
    // sin bloquear el hilo principal
    // Por ejemplo, parsear JSON complejo, procesar imágenes, etc.

    // Este método se ejecuta en un isolate separado
    // No realizar operaciones de UI aquí

    // Comunicar resultados al hilo principal si es necesario
    final SendPort? sendPort = IsolateNameServer.lookupPortByName(
      _isolatePortName,
    );
    if (sendPort != null) {
      sendPort.send(<String, Object?>{
        'messageId': message.messageId,
        'processed': true,
      });
    }
  }

  Future<void> initializeOpenedAppListener() async {
    try {
      // Mensaje que lleva a abrir la app desde cerrada o en segundo plano
      // Usar un listener más ligero
      FirebaseMessaging.onMessageOpenedApp.listen(
        (RemoteMessage message) {
          // Verificar que el controlador esté abierto antes de agregar
          if (!_messageStreamController.isClosed) {
            _messageStreamController.add(message);
          }
        },
        // ignore: always_specify_types
        onError: (error) {
          // Minimizar logging para mejorar rendimiento
          if (kDebugMode) {
            print('[FCM] Error en listener: $error');
          }
        },
        cancelOnError: false, // No cancelar el stream en caso de error
      );

      // Verificar mensaje inicial en un Future separado para no bloquear
      // la inicialización principal
      Future<void>.microtask(() async {
        try {
          final RemoteMessage? initialMessage = await _messaging
              .getInitialMessage();
          if (initialMessage != null && !_messageStreamController.isClosed) {
            _messageStreamController.add(initialMessage);
          }
        } catch (e) {
          // Capturar errores silenciosamente en modo release
          if (kDebugMode) {
            print('[FCM] Error al obtener mensaje inicial: $e');
          }
        }
      });
    } catch (e) {
      // Capturar cualquier error para evitar que la app falle
      if (kDebugMode) {
        print('[FCM] Error al inicializar listeners de mensajes: $e');
      }
    }
  }

  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      if (kDebugMode) {
        print('[FCM] Suscrito al tema: $topic');
      }
    } catch (e) {
      if (kDebugMode) {
        print('[FCM] Error al suscribirse al tema $topic: $e');
      }
      // Reintento opcional con backoff exponencial
      // rethrow; // Descomentar si se quiere propagar el error
    }
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      if (kDebugMode) {
        print('[FCM] Desuscrito del tema: $topic');
      }
    } catch (e) {
      if (kDebugMode) {
        print('[FCM] Error al desuscribirse del tema $topic: $e');
      }
      // No propagar el error para evitar que la app falle
    }
  }

  // Método para obtener el token FCM actual
  Future<String?> getToken() async {
    try {
      return await _messaging.getToken();
    } catch (e) {
      if (kDebugMode) {
        print('[FCM] Error al obtener token: $e');
      }
      return null;
    }
  }

  void dispose() {
    // Cerrar el stream controller si está abierto
    if (!_messageStreamController.isClosed) {
      _messageStreamController.close();
    }

    // Desregistrar el puerto de comunicación entre isolates si existe
    if (!kIsWeb) {
      IsolateNameServer.removePortNameMapping(_isolatePortName);
    }

    _isInitialized = false;
  }
}
