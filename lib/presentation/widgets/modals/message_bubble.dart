import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quien_para/core/theme/app_colors.dart';
import 'package:quien_para/core/theme/provider/theme_provider.dart';
import 'package:quien_para/domain/entities/message_entity.dart';

class MessageBubble extends StatelessWidget {
  // Soporte para ambos tipos de mensajes durante la migración
  final dynamic message; // Acepta MessageEntity o ChatMessageModel
  final bool isMine;
  final bool showTime;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMine,
    this.showTime = true,
  });
  
  // Obtener los datos del mensaje independientemente del tipo
  String get messageContent => message is MessageEntity ? message.content : message.content;
  DateTime get messageTimestamp => message is MessageEntity ? message.timestamp : message.timestamp;
  String get messageSenderId => message is MessageEntity ? message.senderId : message.senderId;

  @override
  Widget build(BuildContext context) {
    // Obtener el proveedor de tema
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    // Determinar colores según el tema y si es un mensaje propio o recibido
    final Color bubbleColor = isMine
        ? AppColors.brandYellow // Mensaje propio - color amarillo de marca
        : isDarkMode
            ? const Color(0xFF2D3748) // Mensaje recibido en modo oscuro
            : Colors.white; // Mensaje recibido en modo claro

    final Color textColor = isMine
        ? const Color(
            0xFF1E293B) // Texto en mensajes propios (oscuro en el amarillo)
        : isDarkMode
            ? Colors.white // Texto en mensajes recibidos en modo oscuro
            : Colors.black87; // Texto en mensajes recibidos en modo claro

    final Color timeColor = isMine
        ? Color(0xFF1E293B).withValues(
            red: 30,
            green: 41,
            blue: 59,
            alpha: 179) // Color de hora en mensajes propios
        : isDarkMode
            ? Colors
                .grey[400]! // Color de hora en mensajes recibidos (modo oscuro)
            : Colors
                .grey[600]!; // Color de hora en mensajes recibidos (modo claro)

    final timeStyle = TextStyle(
      color: timeColor,
      fontSize: 12,
    );

    final contentStyle = TextStyle(
      color: textColor,
      fontSize: 16,
    );

    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMine ? 16 : 4),
            bottomRight: Radius.circular(isMine ? 4 : 16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                  red: 0, green: 0, blue: 0, alpha: isDarkMode ? 77 : 26),
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 12,
                bottom: showTime ? 28 : 12,
              ),
              child: Text(
                messageContent, // Usar la propiedad auxiliar en lugar de acceder directamente
                style: contentStyle,
              ),
            ),
            if (showTime)
              Positioned(
                right: isMine ? 8 : null,
                left: isMine ? null : 8,
                bottom: 4,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _getFormattedTime(messageTimestamp), // Usar la propiedad auxiliar
                      style: timeStyle,
                    ),
                    if (isMine) ...[
                      const SizedBox(width: 4),
                      Icon(
                        // Verificar si el mensaje tiene la propiedad isRead (ChatMessageModel) o read (MessageEntity)
                        message is MessageEntity
                            ? message.read ? Icons.done_all : Icons.done
                            : (message.isRead ?? false) ? Icons.done_all : Icons.done,
                        size: 14,
                        color: timeColor,
                      ),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _getFormattedTime(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(
      timestamp.year,
      timestamp.month,
      timestamp.day,
    );

    if (messageDate == today) {
      return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else if (messageDate == yesterday) {
      return 'Ayer';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}
