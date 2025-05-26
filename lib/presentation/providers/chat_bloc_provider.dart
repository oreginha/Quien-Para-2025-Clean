// lib/presentation/providers/chat_bloc_provider.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:quien_para/presentation/bloc/chat/chat_bloc.dart';

/// Bandera para controlar qué implementación del BLoC usar
/// Cambiar a true para usar la nueva arquitectura limpia
/// Cambiar a false para volver a la implementación original
// ignore: constant_identifier_names
const bool USE_REFACTORED_BLOC = true;

/// Provider que simplifica la transición del ChatBloc original al ChatBlocRefactored
///
/// Este componente permite cambiar fácilmente entre ambas implementaciones
/// con solo modificar la constante USE_REFACTORED_BLOC.
class ChatBlocProvider extends StatelessWidget {
  final Widget child;

  const ChatBlocProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    if (USE_REFACTORED_BLOC) {
      // Usar la nueva implementación refactorizada con un wrapper
      return BlocProvider<ChatBloc>(
        create: (_) => _createChatBlocWrapper(),
        child: child,
      );
    } else {
      // Usar la implementación original
      return BlocProvider<ChatBloc>(
        create: (_) => GetIt.I<ChatBloc>(),
        child: child,
      );
    }
  }

  /// Crea un wrapper alrededor de ChatBlocRefactored que implementa la interfaz
  /// de ChatBloc para mantener compatibilidad con el código existente.
  ChatBloc _createChatBlocWrapper() {
    // Obtener la instancia de ChatBlocRefactored del DI
    final refactoredBloc = GetIt.I<ChatBloc>();

    // Crear un wrapper que extiende ChatBloc pero delega al ChatBlocRefactored
    return _ChatBlocWrapper(refactoredBloc);
  }
}

/// Wrapper que extiende ChatBloc pero delega sus operaciones a ChatBlocRefactored
class _ChatBlocWrapper extends ChatBloc {
  final ChatBloc _refactoredBloc;

  _ChatBlocWrapper(this._refactoredBloc) : super(GetIt.I());

  @override
  void add(ChatEvent event) {
    // Mapear eventos del ChatBloc original a eventos del ChatBlocRefactored
    if (event is LoadConversations) {
      _refactoredBloc.add(event);
    } else if (event is LoadMessages) {
      _refactoredBloc.add(event);
    } else if (event is SendMessage) {
      _refactoredBloc.add(event);
    } else if (event is CreateConversation) {
      _refactoredBloc.add(event);
    } else if (event is MarkMessagesAsRead) {
      _refactoredBloc.add(event);
    } else {
      // Si es un evento no soportado, usar la implementación original
      super.add(event);
    }
  }

  @override
  Stream<ChatState> get stream => _refactoredBloc.stream;

  @override
  ChatState get state => _refactoredBloc.state;

  @override
  Future<void> close() {
    // Cerrar ambos blocs para evitar memory leaks
    _refactoredBloc.close();
    return super.close();
  }
}
