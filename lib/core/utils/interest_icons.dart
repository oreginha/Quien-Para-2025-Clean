// lib/core/utils/interest_icons.dart
import 'package:flutter/material.dart';

class InterestIcons {
  static const Map<String, IconData> icons = <String, IconData>{
    // Deportes
    'deportes': Icons.sports_soccer,
    'fútbol': Icons.sports_soccer,
    'básquet': Icons.sports_basketball,
    'tenis': Icons.sports_tennis,
    'running': Icons.directions_run,
    'natación': Icons.pool,
    'volleyball': Icons.sports_volleyball,
    'ciclismo': Icons.pedal_bike,
    'gimnasio': Icons.fitness_center,

    // Arte y Cultura
    'arte': Icons.palette,
    'música': Icons.music_note,
    'cine': Icons.movie,
    'teatro': Icons.theater_comedy,
    'fotografía': Icons.camera_alt,
    'literatura': Icons.book,
    'danza': Icons.music_note,

    // Gastronomía
    'gastronomía': Icons.restaurant,
    'cocina': Icons.restaurant_menu,
    'café': Icons.coffee,
    'vino': Icons.wine_bar,
    'cerveza': Icons.sports_bar,

    // Viajes y Aventura
    'viajes': Icons.flight,
    'aventura': Icons.terrain,
    'camping': Icons.cabin,
    'playa': Icons.beach_access,
    'montaña': Icons.landscape,

    // Tecnología
    'tecnología': Icons.computer,
    'videojuegos': Icons.gamepad,
    'programación': Icons.code,
    'gadgets': Icons.devices,

    // Social
    'socializar': Icons.people,
    'networking': Icons.group_add,
    'fiestas': Icons.celebration,
    'karaoke': Icons.mic,

    // Educación y Desarrollo
    'educación': Icons.school,
    'idiomas': Icons.language,
    'ciencia': Icons.science,
    'historia': Icons.history_edu,

    // Bienestar
    'yoga': Icons.self_improvement,
    'meditación': Icons.spa,
    'salud': Icons.health_and_safety,
    'naturaleza': Icons.nature,

    // Entretenimiento
    'juegos': Icons.casino,
    'series': Icons.tv,
    'podcasts': Icons.headphones,
    'streaming': Icons.live_tv,

    // Otros
    'mascotas': Icons.pets,
    'jardinería': Icons.grass,
    'bricolaje': Icons.handyman,
    'moda': Icons.style,
  };

  /// Obtiene el ícono correspondiente al interés o devuelve un ícono por defecto
  static IconData getIcon(final String interest) {
    return icons[interest.toLowerCase()] ?? Icons.star;
  }

  /// Obtiene una lista de íconos para una lista de intereses
  static List<IconData> getIcons(final List<String> interests) {
    return interests.map((final String interest) => getIcon(interest)).toList();
  }

  /// Verifica si existe un ícono para el interés dado
  static bool hasIcon(final String interest) {
    return icons.containsKey(interest.toLowerCase());
  }
}
