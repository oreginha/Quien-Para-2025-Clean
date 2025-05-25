// lib/core/constants/app_icons.dart

// ignore_for_file: prefer_final_parameters

import 'package:flutter/material.dart';

/// Clase que contiene los íconos de la aplicación organizados por categorías.
///
/// Esta clase proporciona acceso centralizado a todos los íconos utilizados en la aplicación,
/// manteniendo la consistencia visual y facilitando cambios futuros.
class AppIcons {
  AppIcons._(); // Constructor privado para evitar instanciación

  /// Acciones básicas
  static const IconData pin = Icons.push_pin;
  static const String pinEmoji = '📌';

  static const IconData target = Icons.track_changes;
  static const String targetEmoji = '🎯';

  static const IconData search = Icons.search;
  static const String searchEmoji = '🔍';

  static const IconData folder = Icons.folder;
  static const String folderEmoji = '📁';

  static const IconData share = Icons.share;
  static const String shareEmoji = '📤';

  static const IconData download = Icons.download;
  static const String downloadEmoji = '📥';

  static const IconData settings = Icons.settings;
  static const String settingsEmoji = '🛠';

  static const IconData gear = Icons.settings_suggest;
  static const String gearEmoji = '⚙';

  static const IconData refresh = Icons.refresh;
  static const String refreshEmoji = '🔄';

  static const IconData edit = Icons.edit;
  static const String editEmoji = '📝';

  /// Estado y notificaciones
  static const IconData notification = Icons.notifications;
  static const String notificationEmoji = '🔔';

  static const IconData announcement = Icons.campaign;
  static const String announcementEmoji = '📢';

  static const IconData warning = Icons.warning;
  static const String warningEmoji = '⚠️';

  static const IconData alert = Icons.priority_high;
  static const String alertEmoji = '❗';

  static const IconData success = Icons.check_circle;
  static const String successEmoji = '✅';

  static const IconData cancel = Icons.cancel;
  static const String cancelEmoji = '❌';

  static const IconData loading = Icons.hourglass_empty;
  static const String loadingEmoji = '⏳';

  static const IconData battery = Icons.battery_std;
  static const String batteryEmoji = '🔋';

  static const IconData connection = Icons.signal_cellular_alt;
  static const String connectionEmoji = '📶';

  static const IconData save = Icons.save;
  static const String saveEmoji = '💾';

  /// Interacciones y comunicación
  static const IconData message = Icons.chat;
  static const String messageEmoji = '💬';

  static const IconData comments = Icons.chat_bubble;
  static const String commentsEmoji = '🗨';

  static const IconData email = Icons.email;
  static const String emailEmoji = '📧';

  static const IconData call = Icons.call;
  static const String callEmoji = '📞';

  static const IconData community = Icons.people;
  static const String communityEmoji = '👥';

  static const IconData partnership = Icons.handshake;
  static const String partnershipEmoji = '🤝';

  static const IconData favorite = Icons.star;
  static const String favoriteEmoji = '⭐';

  static const IconData like = Icons.favorite;
  static const String likeEmoji = '❤️';

  static const IconData thumbUp = Icons.thumb_up;
  static const String thumbUpEmoji = '👍';

  static const IconData thumbDown = Icons.thumb_down;
  static const String thumbDownEmoji = '👎';

  /// Ubicación y mapas
  static const IconData location = Icons.location_on;
  static const String locationEmoji = '📍';

  static const IconData map = Icons.map;
  static const String mapEmoji = '🗺';

  static const IconData marker = Icons.flag;
  static const String markerEmoji = '🚩';

  static const IconData global = Icons.public;
  static const String globalEmoji = '🌎';

  static const IconData transport = Icons.directions_car;
  static const String transportEmoji = '🚗';

  static const IconData home = Icons.home;
  static const String homeEmoji = '🏠';

  static const IconData city = Icons.location_city;
  static const String cityEmoji = '🏙';

  /// Finanzas y comercio
  static const IconData money = Icons.attach_money;
  static const String moneyEmoji = '💰';

  static const IconData creditCard = Icons.credit_card;
  static const String creditCardEmoji = '💳';

  static const IconData growth = Icons.trending_up;
  static const String growthEmoji = '📈';

  static const IconData loss = Icons.trending_down;
  static const String lossEmoji = '📉';

  static const IconData bank = Icons.account_balance;
  static const String bankEmoji = '🏦';

  /// Diversión y creatividad
  static const IconData music = Icons.music_note;
  static const String musicEmoji = '🎶';

  static const IconData camera = Icons.camera_alt;
  static const String cameraEmoji = '📷';

  static const IconData design = Icons.palette;
  static const String designEmoji = '🎨';

  static const IconData video = Icons.videocam;
  static const String videoEmoji = '🎥';

  static const IconData audio = Icons.mic;
  static const String audioEmoji = '🎤';

  /// Creación de propuesta (Inicio, Camino, Dirección)
  static const IconData track = Icons.track_changes;
  static const String trackEmoji = '🛤';

  static const IconData trafficLight = Icons.traffic;
  static const String trafficLightEmoji = '🚦';

  static const IconData soon = Icons.fast_forward;
  static const String soonEmoji = '🔜';

  static const IconData start = Icons.flag_outlined;
  static const String startEmoji = '🏁';

  static const IconData rocket = Icons.rocket_launch;
  static const String rocketEmoji = '🚀';

  static const IconData planRoute = Icons.map_outlined;
  static const String planRouteEmoji = '🗺';

  static const IconData meetingPoint = Icons.place;
  static const String meetingPointEmoji = '📍';

  static const IconData anchorIdea = Icons.push_pin;
  static const String anchorIdeaEmoji = '📌';

  static const IconData energy = Icons.bolt;
  static const String energyEmoji = '⚡';

  /// Estados y disponibilidad del usuario
  static const IconData available = Icons.circle;
  static const String availableEmoji = '🟢';

  static const IconData waiting = Icons.radio_button_checked;
  static const String waitingEmoji = '🟡';

  static const IconData unavailable = Icons.circle;
  static const String unavailableEmoji = '🔴';

  static const IconData thinking = Icons.psychology;
  static const String thinkingEmoji = '🤔';

  static const IconData popular = Icons.local_fire_department;
  static const String popularEmoji = '🔥';

  static const IconData newItem = Icons.fiber_new;
  static const String newItemEmoji = '🆕';

  /// Interacción entre usuarios y respuestas
  static const IconData agreement = Icons.handshake;
  static const String agreementEmoji = '🤝';

  static const IconData viewing = Icons.visibility;
  static const String viewingEmoji = '👀';

  static const IconData comment = Icons.chat_bubble_outline;
  static const String commentEmoji = '💬';

  static const IconData interested = Icons.thumb_up_outlined;
  static const String interestedEmoji = '👍';

  static const IconData notInterested = Icons.not_interested;
  static const String notInterestedEmoji = '❌';

  static const IconData sendProposal = Icons.send;
  static const String sendProposalEmoji = '📤';

  static const IconData idea = Icons.lightbulb_outline;
  static const String ideaEmoji = '💡';

  /// Cierre y confirmación de la propuesta
  static const IconData confirm = Icons.check;
  static const String confirmEmoji = '✔️';

  static const IconData modify = Icons.autorenew;
  static const String modifyEmoji = '🔄';

  static const IconData planConfirmed = Icons.celebration;
  static const String planConfirmedEmoji = '🎉';

  static const IconData lastPlaces = Icons.hourglass_bottom;
  static const String lastPlacesEmoji = '⌛';

  static const IconData closed = Icons.lock;
  static const String closedEmoji = '🔒';

  /// Obtiene un ícono de Material Design basado en el emoji proporcionado
  static IconData getIconFromEmoji(String emoji) {
    switch (emoji) {
      case '📌':
        return pin;
      case '🎯':
        return target;
      case '🔍':
        return search;
      case '📁':
        return folder;
      case '📤':
        return share;
      case '📥':
        return download;
      case '🛠':
        return settings;
      case '⚙':
        return gear;
      case '🔄':
        return refresh;
      case '📝':
        return edit;
      case '🔔':
        return notification;
      case '📢':
        return announcement;
      case '⚠️':
        return warning;
      case '❗':
        return alert;
      case '✅':
        return success;
      case '❌':
        return cancel;
      case '⏳':
        return loading;
      case '🔋':
        return battery;
      case '📶':
        return connection;
      case '💾':
        return save;
      case '💬':
        return message;
      case '🗨':
        return comments;
      case '📧':
        return email;
      case '📞':
        return call;
      case '👥':
        return community;
      case '🤝':
        return partnership;
      case '⭐':
        return favorite;
      case '❤️':
        return like;
      case '👍':
        return thumbUp;
      case '👎':
        return thumbDown;
      case '📍':
        return location;
      case '🗺':
        return map;
      case '🚩':
        return marker;
      case '🌎':
        return global;
      case '🚗':
        return transport;
      case '🏠':
        return home;
      case '🏙':
        return city;
      case '💰':
        return money;
      case '💳':
        return creditCard;
      case '📈':
        return growth;
      case '📉':
        return loss;
      case '🏦':
        return bank;
      case '🎶':
        return music;
      case '📷':
        return camera;
      case '🎨':
        return design;
      case '🎥':
        return video;
      case '🎤':
        return audio;
      case '🛤':
        return track;
      case '🚦':
        return trafficLight;
      case '🔜':
        return soon;
      case '🏁':
        return start;
      case '🚀':
        return rocket;
      case '⚡':
        return energy;
      case '🟢':
        return available;
      case '🟡':
        return waiting;
      case '🔴':
        return unavailable;
      case '🤔':
        return thinking;
      case '🔥':
        return popular;
      case '🆕':
        return newItem;
      case '💡':
        return idea;
      case '✔️':
        return confirm;
      case '🎉':
        return planConfirmed;
      case '⌛':
        return lastPlaces;
      case '🔒':
        return closed;
      default:
        return Icons.emoji_emotions; // Ícono predeterminado
    }
  }
}
