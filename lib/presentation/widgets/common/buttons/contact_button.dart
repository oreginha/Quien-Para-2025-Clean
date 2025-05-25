// ignore_for_file: always_specify_types, use_build_context_synchronously, unused_local_variable

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:quien_para/core/di/di.dart';
import 'package:quien_para/core/theme/app_colors.dart';
import 'package:quien_para/domain/repositories/auth/auth_repository.dart';
import 'package:quien_para/domain/repositories/chat/chat_repository.dart';
import '../../../bloc/chat/chat_bloc.dart';
import 'package:quien_para/presentation/routes/app_router.dart';

class ContactButton extends StatelessWidget {
  final String userId;
  final String userName;
  final bool isSmall;

  const ContactButton({
    super.key,
    required this.userId,
    required this.userName,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    final AuthRepository authRepository = sl<AuthRepository>();
    final String currentUserId = authRepository.getCurrentUserId() ?? '';

    // No mostrar botón para contactar con uno mismo
    if (currentUserId == userId) {
      return const SizedBox();
    }

    return isSmall
        ? IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            onPressed: () => _initChat(context),
            color: AppColors.lightTextPrimary,
            tooltip: 'Contactar',
          )
        : ElevatedButton.icon(
            onPressed: () => _initChat(context),
            icon: const Icon(Icons.chat_bubble_outline),
            label: const Text('Contactar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.lightTextPrimary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
  }

  Future<void> _initChat(BuildContext context) async {
    // Obtener repositorios desde di
    final ChatRepository chatRepository = sl<ChatRepository>();
    final AuthRepository authRepository = sl<AuthRepository>();
    // Obtener ChatBloc desde di
    final ChatBloc chatBloc = sl<ChatBloc>();

    // Mostrar indicador de carga
    final loadingDialog = _showLoadingDialog(context);

    try {
      // Crear o recuperar la conversación
      final String currentUserId = authRepository.getCurrentUserId() ?? '';

      // Dos opciones de implementación:
      // Opción 1: Seguir usando el ChatBloc
      chatBloc.add(CreateConversation(
        participants: [currentUserId, userId],
        initialMessage: 'Hola, me gustaría conectar contigo.',
      ));

      // Opción 2: Usar directamente el repositorio (comentado por ahora)
      // Descomentar esta sección y comentar la de arriba para usar el repositorio directamente
      /*
      final String conversationId = await chatRepository.createConversation(
        [currentUserId, userId],
        'Hola, me gustaría conectar contigo.'
      );
      
      // Cerrar diálogo de carga
      context.closeToRoot();
      
      // Navegar al chat
      context.push('/chat/$conversationId', extra: <String, String>{
        'receiverId': userId,
        'receiverName': userName,
      });
      return;
      */

      // Escuchar el resultado
      late final StreamSubscription<ChatState> subscription;
      subscription = chatBloc.stream.listen((ChatState state) {
        if (state is ConversationCreated) {
          // Cerrar diálogo de carga
          context.closeToRoot();

          // Navegar al chat
          context.push('/chat/${state.conversationId}', extra: <String, String>{
            'receiverId': userId,
            'receiverName': userName,
          });

          // Cancelar suscripción
          subscription.cancel();
        } else if (state is ChatError) {
          // Cerrar diálogo de carga
          context.closeToRoot();

          // Mostrar error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Error: ${state.errorMessage}')), // Cambiado a errorMessage que es la propiedad correcta en BaseState
          );

          // Cancelar suscripción
          subscription.cancel();
        }
      });

      // Establecer un timeout por si algo sale mal
      Future.delayed(const Duration(seconds: 5), () {
        final BuildContext? dialogContext = loadingDialog as BuildContext?;
        if (dialogContext != null) {
          context.closeToRoot();
          subscription.cancel();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Tiempo de espera agotado. Inténtalo de nuevo.')),
          );
        }
      });
    } catch (e) {
      // Cerrar diálogo de carga en caso de error usando GoRouter
      context.closeToRoot();

      // Mostrar error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al iniciar conversación: $e')),
      );
    }
  }

  dynamic _showLoadingDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: SizedBox(
            height: 100,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Iniciando conversación...'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
