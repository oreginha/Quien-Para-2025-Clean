import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quien_para/core/constants/app_icons.dart';
import 'package:quien_para/core/theme/app_colors.dart';
import 'package:quien_para/core/theme/app_typography.dart';
import 'package:quien_para/core/theme/theme_constants.dart';
import 'package:quien_para/core/theme/provider/theme_provider.dart';
import 'package:quien_para/presentation/widgets/responsive/new_responsive_scaffold.dart';
import 'package:quien_para/presentation/routes/app_router.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final userId = _auth.currentUser?.uid ?? '';

    final notificationsAppBar = AppBar(
      backgroundColor: AppColors.getBackground(isDarkMode),
      elevation: 0,
      centerTitle: true,
      title: Text(
        'Notificaciones',
        style: AppTypography.appBarTitle(isDarkMode),
      ),
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
          icon: Icon(Icons.refresh, color: AppColors.brandYellow),
          onPressed: () {
            setState(() {}); // Refresca la pantalla
          },
        ),
      ],
    );

    return NewResponsiveScaffold(
      screenName: AppRouter.notifications,
      appBar: notificationsAppBar,
      body: userId.isEmpty
          ? _buildLoginRequired(isDarkMode)
          : _buildNotificationsList(userId, isDarkMode),
      currentIndex: 4,
      webTitle: 'Notificaciones',
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
            'Inicia sesión para ver tus notificaciones',
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

  Widget _buildNotificationsList(String userId, bool isDarkMode) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('notifications')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .limit(50)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoading(isDarkMode);
        }

        if (snapshot.hasError) {
          return _buildError(snapshot.error.toString(), isDarkMode);
        }

        final notifications = snapshot.data?.docs ?? [];

        if (notifications.isEmpty) {
          return _buildEmptyState(isDarkMode);
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.s),
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            final data = notification.data() as Map<String, dynamic>? ?? {};

            return _NotificationCard(
              notificationId: notification.id,
              title: data['title'] as String? ?? 'Notificación',
              body: data['message'] as String? ?? data['body'] as String? ?? '',
              createdAt: _formatDate(data['createdAt']),
              isRead: data['isRead'] as bool? ?? false,
              type: data['type'] as String? ?? 'general',
              isDarkMode: isDarkMode,
              onTap: () => _markAsRead(notification.id, userId),
            );
          },
        );
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
            'Cargando notificaciones...',
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
            'Error al cargar notificaciones',
            style: AppTypography.bodyLarge(isDarkMode),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.l),
          ElevatedButton(
            onPressed: () => setState(() {}),
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
              AppIcons.notification,
              size: 60,
              color: AppColors.getTextSecondary(isDarkMode),
            ),
          ),
          const SizedBox(height: AppSpacing.l),
          Text(
            'No tienes notificaciones',
            style: AppTypography.heading5(isDarkMode),
          ),
          const SizedBox(height: AppSpacing.s),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Text(
              'Cuando recibas notificaciones, aparecerán aquí.',
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

  String _formatDate(dynamic timestamp) {
    if (timestamp == null) return 'Ahora';

    try {
      final DateTime date = timestamp is Timestamp
          ? timestamp.toDate()
          : DateTime.parse(timestamp.toString());
      final Duration difference = DateTime.now().difference(date);

      if (difference.inMinutes < 1) {
        return 'Ahora';
      } else if (difference.inHours < 1) {
        return 'Hace ${difference.inMinutes} min';
      } else if (difference.inDays < 1) {
        return 'Hace ${difference.inHours}h';
      } else {
        return 'Hace ${difference.inDays}d';
      }
    } catch (e) {
      return 'Ahora';
    }
  }

  Future<void> _markAsRead(String notificationId, String userId) async {
    try {
      await _firestore.collection('notifications').doc(notificationId).update({
        'isRead': true,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Notificación marcada como leída'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Error al marcar como leída'),
            backgroundColor: AppColors.accentRed,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}

class _NotificationCard extends StatelessWidget {
  final String notificationId;
  final String title;
  final String body;
  final String createdAt;
  final bool isRead;
  final String type;
  final bool isDarkMode;
  final VoidCallback onTap;

  const _NotificationCard({
    required this.notificationId,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.isRead,
    required this.type,
    required this.isDarkMode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.m,
        vertical: AppSpacing.s,
      ),
      decoration: BoxDecoration(
        color: isRead
            ? AppColors.getCardBackground(isDarkMode).withOpacity(0.7)
            : AppColors.getCardBackground(isDarkMode),
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
                // Indicador de no leído
                if (!isRead)
                  Padding(
                    padding: const EdgeInsets.only(
                      right: AppSpacing.s,
                      top: AppSpacing.s,
                    ),
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.brandYellow,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),

                // Icono según tipo
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.getSecondaryBackground(isDarkMode),
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    backgroundColor: AppColors.getSecondaryBackground(
                      isDarkMode,
                    ),
                    radius: 24,
                    child: Icon(
                      _getIconForType(type),
                      color: AppColors.brandYellow,
                      size: 20,
                    ),
                  ),
                ),

                const SizedBox(width: AppSpacing.m),

                // Contenido
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTypography.heading6(isDarkMode).copyWith(
                          fontWeight: isRead
                              ? FontWeight.normal
                              : FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        body,
                        style: AppTypography.bodyMedium(isDarkMode).copyWith(
                          color: isRead
                              ? AppColors.getTextSecondary(isDarkMode)
                              : AppColors.getTextPrimary(isDarkMode),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.s),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            createdAt,
                            style: AppTypography.labelSmall(isDarkMode)
                                .copyWith(
                                  color: AppColors.getTextSecondary(isDarkMode),
                                ),
                          ),
                          if (!isRead)
                            Text(
                              'Sin leer',
                              style: AppTypography.labelSmall(isDarkMode)
                                  .copyWith(
                                    color: AppColors.brandYellow,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
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

  IconData _getIconForType(String type) {
    switch (type) {
      case 'application':
        return Icons.person_add;
      case 'plan':
        return Icons.event;
      case 'chat':
        return Icons.chat;
      case 'system':
        return Icons.info;
      default:
        return Icons.notifications;
    }
  }
}
