import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:quien_para/core/theme/app_colors.dart';
import 'package:quien_para/core/theme/app_typography.dart';
import 'package:quien_para/core/theme/theme_constants.dart';
import 'package:quien_para/core/theme/provider/theme_provider.dart';
import 'package:quien_para/presentation/widgets/responsive/new_responsive_scaffold.dart';
import 'package:quien_para/presentation/routes/app_router.dart';
import 'package:quien_para/presentation/bloc/chat/simple_chat_bloc.dart';

/// Pantalla consolidada de lista de conversaciones usando SimpleChatBloc
///
/// Esta versión:
/// - Usa SimpleChatBloc para mantener arquitectura consistente
/// - Diseño responsive para web y móvil
/// - Estados de carga, error y vacío manejados
/// - Funcionalidad completa de chat
class ConversationsListScreen extends StatefulWidget {
  const ConversationsListScreen({super.key});

  @override
  State<ConversationsListScreen> createState() =>
      _ConversationsListScreenState();
}

class _ConversationsListScreenState extends State<ConversationsListScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  void _loadConversations() {
    if (_auth.currentUser != null) {
      context.read<SimpleChatBloc>().add(const LoadConversations());
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final userId = _auth.currentUser?.uid ?? '';

    final conversationsAppBar = AppBar(
      backgroundColor: AppColors.getBackground(isDarkMode),
      elevation: 0,
      centerTitle: true,
      title: Text('Mensajes', style: AppTypography.appBarTitle(isDarkMode)),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: AppColors.getTextPrimary(isDarkMode),
        ),
        onPressed: () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          } else {
            context.go('/');
          }
        },
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.add_comment, color: AppColors.brandYellow),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                  'Función de nueva conversación próximamente',
                ),
                backgroundColor: AppColors.brandYellow,
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        ),
      ],
    );

    return NewResponsiveScaffold(
      screenName: AppRouter.conversationsList,
      appBar: conversationsAppBar,
      body: userId.isEmpty
          ? _buildLoginRequired(isDarkMode)
          : _buildConversationsContent(isDarkMode),
      currentIndex: 0, // Mensajes está en índice 0
      webTitle: 'Mensajes',
    );
  }

  Widget _buildLoginRequired(bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.login,
            size: 80,
            color: AppColors.getTextSecondary(isDarkMode),
          ),
          const SizedBox(height: AppSpacing.l),
          Text(
            'Inicia sesión para ver tus conversaciones',
            style: AppTypography.heading5(isDarkMode),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.l),
          ElevatedButton(
            onPressed: () => context.go(AppRouter.login),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brandYellow,
              foregroundColor: isDarkMode
                  ? Colors.black
                  : AppColors.lightTextPrimary,
            ),
            child: const Text('Iniciar Sesión'),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationsContent(bool isDarkMode) {
    return BlocBuilder<SimpleChatBloc, SimpleChatState>(
      builder: (context, state) {
        if (state.isLoading) {
          return _buildLoading(isDarkMode);
        }

        if (state.hasError) {
          return _buildError(state.errorMessage!, isDarkMode);
        }

        if (state.hasConversations) {
          return _buildConversationsList(state.conversations!, isDarkMode);
        }

        return _buildEmptyState(isDarkMode);
      },
    );
  }

  Widget _buildLoading(bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.brandYellow),
          ),
          const SizedBox(height: AppSpacing.m),
          Text(
            'Cargando conversaciones...',
            style: AppTypography.bodyMedium(
              isDarkMode,
            ).copyWith(color: AppColors.getTextSecondary(isDarkMode)),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String error, bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 60, color: AppColors.accentRed),
          const SizedBox(height: AppSpacing.m),
          Text(
            'Error al cargar conversaciones',
            style: AppTypography.bodyLarge(isDarkMode),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.s),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Text(
              error,
              style: AppTypography.bodySmall(
                isDarkMode,
              ).copyWith(color: AppColors.getTextSecondary(isDarkMode)),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AppSpacing.l),
          ElevatedButton(
            onPressed: _loadConversations,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brandYellow,
              foregroundColor: isDarkMode
                  ? Colors.black
                  : AppColors.lightTextPrimary,
            ),
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.l),
            decoration: BoxDecoration(
              color: AppColors.getSecondaryBackground(
                isDarkMode,
              ).withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.chat_bubble_outline,
              size: 60,
              color: AppColors.getTextSecondary(isDarkMode),
            ),
          ),
          const SizedBox(height: AppSpacing.l),
          Text(
            'No tienes conversaciones activas',
            style: AppTypography.heading5(isDarkMode),
          ),
          const SizedBox(height: AppSpacing.s),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Text(
              'Cuando inicies una conversación, aparecerá aquí.',
              style: AppTypography.bodyMedium(
                isDarkMode,
              ).copyWith(color: AppColors.getTextSecondary(isDarkMode)),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationsList(
    List<Map<String, dynamic>> conversations,
    bool isDarkMode,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s),
      itemCount: conversations.length,
      itemBuilder: (context, index) {
        final conversation = conversations[index];

        return _ConversationCard(
          conversationId: conversation['id'] as String? ?? '',
          otherParticipantId:
              conversation['otherParticipantId'] as String? ?? '',
          otherParticipantName:
              conversation['otherParticipantName'] as String? ?? 'Usuario',
          otherParticipantPhoto:
              conversation['otherParticipantPhoto'] as String?,
          lastMessage: conversation['lastMessage'] as String? ?? '',
          lastMessageTimestamp: _parseTimestamp(
            conversation['lastMessageTimestamp'],
          ),
          unreadCount: conversation['unreadCount'] as int? ?? 0,
          isDarkMode: isDarkMode,
          onTap: () => _openConversation(
            context,
            conversation['id'] as String? ?? '',
            conversation['otherParticipantId'] as String? ?? '',
            conversation['otherParticipantName'] as String? ?? 'Usuario',
            conversation['otherParticipantPhoto'] as String?,
          ),
        );
      },
    );
  }

  DateTime _parseTimestamp(dynamic timestamp) {
    if (timestamp == null) return DateTime.now();

    try {
      if (timestamp is Timestamp) {
        return timestamp.toDate();
      } else if (timestamp is String) {
        return DateTime.parse(timestamp);
      }
    } catch (e) {
      // Si hay error al parsear, devolver fecha actual
    }

    return DateTime.now();
  }

  void _openConversation(
    BuildContext context,
    String conversationId,
    String otherUserId,
    String otherUserName,
    String? otherUserPhoto,
  ) {
    context.push(
      '/chat/$conversationId',
      extra: {
        'receiverId': otherUserId,
        'receiverName': otherUserName,
        'otherUserPhoto': otherUserPhoto,
      },
    );
  }
}

class _ConversationCard extends StatelessWidget {
  final String conversationId;
  final String otherParticipantId;
  final String otherParticipantName;
  final String? otherParticipantPhoto;
  final String lastMessage;
  final DateTime lastMessageTimestamp;
  final int unreadCount;
  final bool isDarkMode;
  final VoidCallback onTap;

  const _ConversationCard({
    required this.conversationId,
    required this.otherParticipantId,
    required this.otherParticipantName,
    this.otherParticipantPhoto,
    required this.lastMessage,
    required this.lastMessageTimestamp,
    required this.unreadCount,
    required this.isDarkMode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final String formattedTime = _formatTime(lastMessageTimestamp);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.m,
        vertical: AppSpacing.s,
      ),
      decoration: BoxDecoration(
        color: unreadCount > 0
            ? AppColors.getCardBackground(isDarkMode)
            : AppColors.getCardBackground(isDarkMode).withOpacity(0.7),
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: [
          BoxShadow(
            color: AppColors.getShadowColor(isDarkMode),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.card),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.m),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar del usuario
                Hero(
                  tag: 'avatar_$conversationId',
                  child: Container(
                    width: 48,
                    height: 48,
                    margin: const EdgeInsets.only(right: AppSpacing.m),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: unreadCount > 0
                          ? Border.all(color: AppColors.brandYellow, width: 2)
                          : null,
                    ),
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.getSecondaryBackground(
                        isDarkMode,
                      ),
                      backgroundImage:
                          otherParticipantPhoto != null &&
                              otherParticipantPhoto!.isNotEmpty
                          ? NetworkImage(otherParticipantPhoto!)
                          : null,
                      child:
                          otherParticipantPhoto == null ||
                              otherParticipantPhoto!.isEmpty
                          ? Text(
                              otherParticipantName.isNotEmpty
                                  ? otherParticipantName[0].toUpperCase()
                                  : '?',
                              style: AppTypography.heading6(isDarkMode),
                            )
                          : null,
                    ),
                  ),
                ),

                // Contenido de la conversación
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Fila superior: nombre y hora
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Nombre del usuario
                          Expanded(
                            child: Text(
                              otherParticipantName,
                              style: AppTypography.heading6(isDarkMode)
                                  .copyWith(
                                    color: unreadCount > 0
                                        ? AppColors.brandYellow
                                        : null,
                                    fontWeight: unreadCount > 0
                                        ? FontWeight.bold
                                        : null,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.s),
                          // Hora del último mensaje
                          if (formattedTime.isNotEmpty)
                            Text(
                              formattedTime,
                              style: AppTypography.bodySmall(isDarkMode)
                                  .copyWith(
                                    color: AppColors.getTextSecondary(
                                      isDarkMode,
                                    ),
                                  ),
                            ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      // Fila inferior: mensaje y contador de no leídos
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Último mensaje
                          Expanded(
                            child: Text(
                              lastMessage.isNotEmpty
                                  ? lastMessage
                                  : 'No hay mensajes',
                              style: AppTypography.bodyMedium(isDarkMode)
                                  .copyWith(
                                    color: unreadCount > 0
                                        ? AppColors.getTextPrimary(isDarkMode)
                                        : AppColors.getTextSecondary(
                                            isDarkMode,
                                          ),
                                    fontWeight: unreadCount > 0
                                        ? FontWeight.w500
                                        : FontWeight.normal,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // Indicador de mensajes no leídos
                          if (unreadCount > 0) ...[
                            const SizedBox(width: AppSpacing.s),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.s,
                                vertical: AppSpacing.xxs,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.brandYellow,
                                borderRadius: BorderRadius.circular(
                                  AppRadius.full,
                                ),
                              ),
                              child: Text(
                                unreadCount.toString(),
                                style: AppTypography.labelSmall(isDarkMode)
                                    .copyWith(
                                      color: isDarkMode
                                          ? Colors.black
                                          : AppColors.lightTextPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime date) {
    final DateTime now = DateTime.now();
    final int difference = now.difference(date).inDays;

    if (difference == 0) {
      // Hoy - mostrar hora
      return DateFormat('HH:mm').format(date);
    } else if (difference == 1) {
      // Ayer
      return 'Ayer';
    } else if (difference < 7) {
      // Hace menos de una semana - mostrar día
      return DateFormat('EEEE', 'es').format(date);
    } else {
      // Hace más de una semana - mostrar fecha
      return DateFormat('dd/MM/yyyy').format(date);
    }
  }
}
