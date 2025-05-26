// lib/core/utils/date_formatter.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

/// Utilidades para el formateo de fechas
class DateFormatter {
  DateFormatter._(); // Constructor privado para evitar instanciación

  /// Formatea una fecha en formato dd/MM/yyyy
  static String formatDate(
    DateTime? date, {
    String defaultText = 'Fecha no disponible',
  }) {
    if (date == null) return defaultText;
    return DateFormat('dd/MM/yyyy').format(date);
  }

  /// Formatea una fecha en formato dd/MM/yyyy HH:mm
  static String formatDateTime(
    DateTime? date, {
    String defaultText = 'Fecha no disponible',
  }) {
    if (date == null) return defaultText;
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  /// Convierte un Timestamp o un String a DateTime
  static DateTime? parseDate(dynamic value) {
    if (value == null) return null;

    try {
      if (value is Timestamp) {
        return value.toDate();
      } else if (value is String) {
        // Intentar diferentes formatos de fecha
        try {
          return DateTime.parse(value);
        } catch (_) {
          // Si es formato DD/MM/YYYY
          if (value.contains('/')) {
            final parts = value.split('/');
            if (parts.length == 3) {
              final day = int.tryParse(parts[0]) ?? 1;
              final month = int.tryParse(parts[1]) ?? 1;
              final year = int.tryParse(parts[2]) ?? DateTime.now().year;
              return DateTime(year, month, day);
            }
          }
        }
      } else if (value is DateTime) {
        return value;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error parseando fecha: $e');
        print('Valor original: $value');
      }
    }

    return null;
  }

  /// Retorna un texto relativo a la fecha actual (hace X minutos, hoy, ayer, etc.)
  static String getRelativeTime(DateTime? date) {
    if (date == null) return 'Fecha desconocida';

    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return 'Hace un momento';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return 'Hace $minutes ${minutes == 1 ? 'minuto' : 'minutos'}';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return 'Hace $hours ${hours == 1 ? 'hora' : 'horas'}';
    } else if (difference.inDays < 2) {
      return 'Ayer';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return 'Hace $days días';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return 'Hace $weeks ${weeks == 1 ? 'semana' : 'semanas'}';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return 'Hace $months ${months == 1 ? 'mes' : 'meses'}';
    } else {
      final years = (difference.inDays / 365).floor();
      return 'Hace $years ${years == 1 ? 'año' : 'años'}';
    }
  }

  /// Obtiene la edad a partir de una fecha de nacimiento
  static int? calculateAge(DateTime? birthDate) {
    if (birthDate == null) return null;

    final now = DateTime.now();
    int age = now.year - birthDate.year;

    // Ajusta la edad si aún no se ha cumplido el cumpleaños este año
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }

    return age;
  }
}
