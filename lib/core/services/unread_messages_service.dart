// ignore_for_file: unnecessary_import, always_specify_types

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../domain/interfaces/chat_repository_interface.dart';

class UnreadMessagesService extends ChangeNotifier {
  final ChatRepository _chatRepository;
  final FirebaseAuth _auth;

  int _unreadCount = 0;
  StreamSubscription? _countSubscription;

  StreamSubscription? _authSubscription;

  UnreadMessagesService(this._chatRepository, this._auth) {
    _setupAuthListener();
  }

  int get unreadCount => _unreadCount;

  void _setupAuthListener() {
    // Cancelar suscripción anterior si existe
    _authSubscription?.cancel();

    // Configurar el listener de autenticación una sola vez
    _authSubscription = _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        _initializeMessageStream(user.uid);
      } else {
        _countSubscription?.cancel();
        _updateCount(0);
      }
    });
  }

  void _initializeMessageStream(String userId) {
    // Cancelar suscripción anterior si existe
    _countSubscription?.cancel();

    try {
      _countSubscription = _chatRepository
          .getUnreadMessagesCount(userId)
          .listen(_updateCount, onError: _handleError);
    } catch (e) {
      if (kDebugMode) {
        print('Error al inicializar el servicio de mensajes no leídos: $e');
      }
    }
  }

  void _updateCount(int count) {
    if (_unreadCount != count) {
      _unreadCount = count;
      notifyListeners();
    }
  }

  void _handleError(dynamic error) {
    if (kDebugMode) {
      print('Error en el stream de mensajes no leídos: $error');
    }
  }

  Future<void> markMessagesAsRead(String conversationId) async {
    try {
      // Obtener el ID del usuario actual
      final User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        await _chatRepository.markAsRead(conversationId, currentUser.uid);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error al marcar mensajes como leídos: $e');
      }
    }
  }

  @override
  void dispose() {
    _countSubscription?.cancel();
    _authSubscription?.cancel();
    super.dispose();
  }
}
