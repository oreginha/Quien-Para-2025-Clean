// lib/presentation/screens/chat/chat_screen_responsive.dart
// ignore_for_file: use_build_context_synchronously, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Widgets y UI
import 'package:quien_para/presentation/widgets/common/error_display.dart';
import 'package:quien_para/presentation/widgets/loading/loading_overlay.dart';
import 'package:quien_para/presentation/widgets/modals/message_bubble.dart';
import 'package:quien_para/presentation/widgets/responsive/new_responsive_scaffold.dart';

import 'package:quien_para/presentation/bloc/chat/simple_chat_bloc.dart';
import 'package:quien_para/core/theme/app_colors.dart';
import 'package:quien_para/core/theme/app_typography.dart';
import 'package:quien_para/core/theme/app_spacing.dart' as spacing;
import 'package:quien_para/core/theme/theme_constants.dart';
import 'package:quien_para/core/theme/provider/theme_provider.dart';

/// Pantalla responsive para la vista de un chat individual
///
/// Esta versión consolidada incluye todas las funcionalidades:
/// - Diseño responsive para web y móvil
/// - Animaciones mejoradas
/// - Manejo robusto de errores
/// - Funciona con y sin ChatBloc (modo fallback)
class ChatScreenResponsive extends StatefulWidget {
  final String chatId;
  final String conversationId;
  final String receiverId;
  final String receiverName;
  final String? otherUserPhoto;
  final String? otherUserName;

  const ChatScreenResponsive({
    super.key,
    required this.chatId,
    required this.conversationId,
    required this.receiverId,
    required this.receiverName,
    this.otherUserPhoto,
    this.otherUserName,
  });

  @override
  State<ChatScreenResponsive> createState() => _ChatScreenResponsiveState();
}

/// Estado de la pantalla de chat
class _ChatScreenResponsiveState extends State<ChatScreenResponsive>
    with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final String _currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
  late AnimationController _sendButtonAnimationController;
  bool _isComposing = false;
  bool _useFallbackMode = false;

  // Firestore para modo fallback
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Stream<QuerySnapshot>? _messagesStream;

  @override
  void initState() {
    super.initState();
    // Inicializar controlador de animación
    _sendButtonAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    // Escuchar cambios en el campo de texto
    _messageController.addListener(_handleTextChange);

    // Intentar cargar con BLoC, si falla usar modo fallback
    _initializeChat();
  }

  void _initializeChat() {
    try {
      final simpleChatBloc = context.read<SimpleChatBloc>();
      simpleChatBloc.add(LoadMessages(widget.conversationId, markAsRead: true));
    } catch (e) {
      // Si no hay SimpleChatBloc disponible, usar modo fallback
      setState(() {
        _useFallbackMode = true;
      });
      _initializeFallbackMode();
    }
  }

  void _initializeFallbackMode() {
    // Crear stream directo con Firestore
    _messagesStream = _firestore
        .collection('conversations')
        .doc(widget.conversationId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(100)
        .snapshots();
  }

  void _handleTextChange() {
    final bool isNowComposing = _messageController.text.trim().isNotEmpty;
    if (_isComposing != isNowComposing) {
      setState(() {
        _isComposing = isNowComposing;
      });

      if (isNowComposing) {
        _sendButtonAnimationController.forward();
      } else {
        _sendButtonAnimationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _messageController.removeListener(_handleTextChange);
    _messageController.dispose();
    _scrollController.dispose();
    _sendButtonAnimationController.dispose();
    super.dispose();
  }

  /// Manejador para enviar un mensaje
  void _sendMessage() {
    final String messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;

    // Limpiar el campo de texto inmediatamente para mejor UX
    _messageController.clear();

    // Hacer scroll hacia abajo con animación
    _scrollToBottom();

    // Aplicar efecto de envío
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              width: 18,
              height: 18,
              margin: const EdgeInsets.only(right: 8),
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const Text('Enviando mensaje...'),
          ],
        ),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black87,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );

    if (_useFallbackMode) {
      _sendMessageFallback(messageText);
    } else {
      _sendMessageWithBloc(messageText);
    }
  }

  void _sendMessageWithBloc(String messageText) {
    try {
      context.read<SimpleChatBloc>().add(
        SendMessage(
          conversationId: widget.conversationId,
          content: messageText,
          senderId: _currentUserId,
          receiverId: widget.receiverId,
        ),
      );
    } catch (e) {
      // Si falla, intentar con modo fallback
      _sendMessageFallback(messageText);
    }
  }

  Future<void> _sendMessageFallback(String messageText) async {
    try {
      await _firestore
          .collection('conversations')
          .doc(widget.conversationId)
          .collection('messages')
          .add({
            'content': messageText,
            'senderId': _currentUserId,
            'timestamp': FieldValue.serverTimestamp(),
            'read': false,
          });

      // Actualizar último mensaje en la conversación
      await _firestore
          .collection('conversations')
          .doc(widget.conversationId)
          .update({
            'lastMessage': messageText,
            'lastMessageTimestamp': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al enviar mensaje: $e'),
            backgroundColor: Colors.red[700],
          ),
        );
      }
    }
  }

  /// Scroll animado al final de la lista de mensajes
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  /// Verifica si dos fechas son del mismo día
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// Formatea la fecha para mostrarla en el divisor
  String _getFormattedDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final dateToCheck = DateTime(date.year, date.month, date.day);

    if (dateToCheck == today) {
      return 'Hoy';
    } else if (dateToCheck == yesterday) {
      return 'Ayer';
    } else {
      return DateFormat('d MMM, yyyy').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    // Definir el AppBar
    final appBar = AppBar(
      backgroundColor: AppColors.getBackground(isDarkMode),
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: AppColors.getTextPrimary(isDarkMode),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          // Avatar
          CircleAvatar(
            backgroundColor: AppColors.brandYellow,
            radius: 18,
            backgroundImage:
                widget.otherUserPhoto != null &&
                    widget.otherUserPhoto!.isNotEmpty
                ? NetworkImage(widget.otherUserPhoto!)
                : null,
            child:
                widget.otherUserPhoto == null || widget.otherUserPhoto!.isEmpty
                ? Text(
                    widget.receiverName.isNotEmpty
                        ? widget.receiverName[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: spacing.AppSpacing.s),
          // Nombre del receptor
          Expanded(
            child: Text(
              widget.otherUserName ?? widget.receiverName,
              style: AppTypography.subtitle1(isDarkMode),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.more_vert,
            color: AppColors.getTextPrimary(isDarkMode),
          ),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: AppColors.getCardBackground(isDarkMode),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              builder: (context) =>
                  _buildOptionsBottomSheet(context, isDarkMode),
            );
          },
        ),
      ],
    );

    // Contenido principal
    Widget content;
    if (_useFallbackMode) {
      content = _buildFallbackContent(isDarkMode);
    } else {
      content = _buildBlocContent(isDarkMode);
    }

    // Usar NewResponsiveScaffold para diseño consistente
    return NewResponsiveScaffold(
      screenName: 'chat',
      appBar: appBar,
      body: content,
      currentIndex: 0,
      webTitle: 'Chat con ${widget.otherUserName ?? widget.receiverName}',
    );
  }

  Widget _buildBlocContent(bool isDarkMode) {
    return BlocConsumer<SimpleChatBloc, SimpleChatState>(
      listener: (context, state) {
        if (state.hasMessages && !state.hasError) {
          _scrollToBottom();
        } else if (state.hasError) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.errorMessage}'),
              backgroundColor: Colors.red[700],
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state.isLoading) {
          return const LoadingOverlay();
        } else if (state.hasError) {
          return ErrorDisplay(
            error: state.errorMessage!,
            onRetry: _initializeChat,
          );
        } else if (state.hasMessages) {
          return _buildChatUI(state.messages, isDarkMode);
        } else {
          return Center(
            child: Text(
              'Cargando conversación...',
              style: AppTypography.bodyLarge(isDarkMode),
            ),
          );
        }
      },
    );
  }

  Widget _buildFallbackContent(bool isDarkMode) {
    return StreamBuilder<QuerySnapshot>(
      stream: _messagesStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingOverlay();
        }

        if (snapshot.hasError) {
          return ErrorDisplay(
            error: snapshot.error.toString(),
            onRetry: _initializeFallbackMode,
          );
        }

        final messages = snapshot.data?.docs ?? [];
        return _buildChatUIFromFirestore(messages, isDarkMode);
      },
    );
  }

  Widget _buildChatUI(List<dynamic>? messages, bool isDarkMode) {
    return Column(
      children: [
        Expanded(
          child: messages?.isEmpty ?? true
              ? _buildEmptyChat(isDarkMode)
              : _buildMessageList(messages!, isDarkMode),
        ),
        _buildMessageInput(isDarkMode),
      ],
    );
  }

  Widget _buildChatUIFromFirestore(
    List<QueryDocumentSnapshot> messages,
    bool isDarkMode,
  ) {
    return Column(
      children: [
        Expanded(
          child: messages.isEmpty
              ? _buildEmptyChat(isDarkMode)
              : _buildMessageListFromFirestore(messages, isDarkMode),
        ),
        _buildMessageInput(isDarkMode),
      ],
    );
  }

  Widget _buildEmptyChat(bool isDarkMode) {
    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(milliseconds: 500),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(spacing.AppSpacing.l),
              decoration: BoxDecoration(
                color: AppColors.brandYellow.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.chat_bubble_outline,
                size: 48,
                color: AppColors.brandYellow,
              ),
            ),
            const SizedBox(height: spacing.AppSpacing.m),
            Text(
              'No hay mensajes aún. ¡Envía el primero!',
              style: AppTypography.bodyLarge(
                isDarkMode,
              ).copyWith(color: AppColors.getTextSecondary(isDarkMode)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageList(List<dynamic> messages, bool isDarkMode) {
    return ListView.builder(
      controller: _scrollController,
      reverse: true,
      padding: const EdgeInsets.all(spacing.AppSpacing.m),
      itemCount: messages.length,
      itemBuilder: (BuildContext context, int index) {
        final message = messages[index];
        final bool isMine = message.senderId == _currentUserId;

        final bool showDateDivider =
            index == messages.length - 1 ||
            !_isSameDay(message.timestamp, messages[index + 1].timestamp);

        return AnimatedOpacity(
          duration: Duration(milliseconds: 300 + (index * 30).clamp(0, 500)),
          opacity: 1.0,
          curve: Curves.easeOut,
          child: Column(
            children: [
              if (showDateDivider)
                _buildDateDivider(message.timestamp, isDarkMode),
              MessageBubble(message: message, isMine: isMine, showTime: true),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMessageListFromFirestore(
    List<QueryDocumentSnapshot> messages,
    bool isDarkMode,
  ) {
    return ListView.builder(
      controller: _scrollController,
      reverse: true,
      padding: const EdgeInsets.all(spacing.AppSpacing.m),
      itemCount: messages.length,
      itemBuilder: (BuildContext context, int index) {
        final messageDoc = messages[index];
        final messageData = messageDoc.data() as Map<String, dynamic>;

        final bool isMine = messageData['senderId'] == _currentUserId;
        final DateTime timestamp = messageData['timestamp'] is Timestamp
            ? (messageData['timestamp'] as Timestamp).toDate()
            : DateTime.now();

        final bool showDateDivider =
            index == messages.length - 1 ||
            !_isSameDay(
              timestamp,
              (messages[index + 1].data() as Map<String, dynamic>)['timestamp']
                      is Timestamp
                  ? ((messages[index + 1].data()
                                as Map<String, dynamic>)['timestamp']
                            as Timestamp)
                        .toDate()
                  : DateTime.now(),
            );

        return AnimatedOpacity(
          duration: Duration(milliseconds: 300 + (index * 30).clamp(0, 500)),
          opacity: 1.0,
          curve: Curves.easeOut,
          child: Column(
            children: [
              if (showDateDivider) _buildDateDivider(timestamp, isDarkMode),
              _buildMessageBubbleFromData(messageData, isMine, isDarkMode),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMessageBubbleFromData(
    Map<String, dynamic> messageData,
    bool isMine,
    bool isDarkMode,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: spacing.AppSpacing.xs),
      child: Row(
        mainAxisAlignment: isMine
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!isMine) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.brandYellow,
              child: Text(
                widget.receiverName.isNotEmpty
                    ? widget.receiverName[0].toUpperCase()
                    : '?',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            const SizedBox(width: spacing.AppSpacing.s),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: spacing.AppSpacing.m,
                vertical: spacing.AppSpacing.s,
              ),
              decoration: BoxDecoration(
                color: isMine
                    ? AppColors.brandYellow
                    : AppColors.getCardBackground(isDarkMode),
                borderRadius: BorderRadius.circular(spacing.AppSpacing.m),
              ),
              child: Text(
                messageData['content'] ?? '',
                style: AppTypography.bodyMedium(isDarkMode).copyWith(
                  color: isMine
                      ? Colors.black
                      : AppColors.getTextPrimary(isDarkMode),
                ),
              ),
            ),
          ),
          if (isMine) ...[
            const SizedBox(width: spacing.AppSpacing.s),
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.getSecondaryBackground(isDarkMode),
              child: Text(
                'Tú',
                style: TextStyle(
                  color: AppColors.getTextPrimary(isDarkMode),
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDateDivider(DateTime date, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: spacing.AppSpacing.m),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: AppColors.getTextSecondary(isDarkMode).withOpacity(0.3),
              thickness: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: spacing.AppSpacing.s,
            ),
            child: Text(
              _getFormattedDate(date),
              style: AppTypography.caption(
                isDarkMode,
              ).copyWith(color: AppColors.getTextSecondary(isDarkMode)),
            ),
          ),
          Expanded(
            child: Divider(
              color: AppColors.getTextSecondary(isDarkMode).withOpacity(0.3),
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput(bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.getCardBackground(isDarkMode),
        boxShadow: [
          BoxShadow(
            color: AppColors.getShadowColor(isDarkMode),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(spacing.AppSpacing.s),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.getBackground(isDarkMode),
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: spacing.AppSpacing.m,
                vertical: spacing.AppSpacing.xs,
              ),
              child: TextField(
                controller: _messageController,
                style: AppTypography.bodyMedium(isDarkMode),
                maxLines: 5,
                minLines: 1,
                decoration: InputDecoration(
                  hintText: 'Escribe un mensaje...',
                  hintStyle: AppTypography.bodyMedium(
                    isDarkMode,
                  ).copyWith(color: AppColors.getTextSecondary(isDarkMode)),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: spacing.AppSpacing.xs),
            child: ScaleTransition(
              scale: _sendButtonAnimationController,
              child: ElevatedButton(
                onPressed: _isComposing ? _sendMessage : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brandYellow,
                  elevation: 0,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(12),
                ),
                child: const Icon(Icons.send, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionsBottomSheet(BuildContext context, bool isDarkMode) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: spacing.AppSpacing.m,
          horizontal: spacing.AppSpacing.s,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.delete_outline, color: AppColors.accentRed),
              title: Text(
                'Eliminar conversación',
                style: AppTypography.bodyMedium(
                  isDarkMode,
                ).copyWith(color: AppColors.accentRed),
              ),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation(context, isDarkMode);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.block,
                color: AppColors.getTextSecondary(isDarkMode),
              ),
              title: Text(
                'Bloquear usuario',
                style: AppTypography.bodyMedium(isDarkMode),
              ),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Función próximamente')),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.report_outlined,
                color: AppColors.getTextSecondary(isDarkMode),
              ),
              title: Text(
                'Reportar',
                style: AppTypography.bodyMedium(isDarkMode),
              ),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Función próximamente')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, bool isDarkMode) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.getCardBackground(isDarkMode),
          title: Text(
            '¿Eliminar conversación?',
            style: AppTypography.subtitle1(isDarkMode),
          ),
          content: Text(
            'Esta acción eliminará permanentemente todos los mensajes.',
            style: AppTypography.bodyMedium(isDarkMode),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancelar',
                style: TextStyle(color: AppColors.getTextSecondary(isDarkMode)),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text(
                'Eliminar',
                style: TextStyle(color: AppColors.accentRed),
              ),
            ),
          ],
        );
      },
    );
  }
}
