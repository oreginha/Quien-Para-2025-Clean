// lib/presentation/screens/Feed_Otros_Usuarios/widgets/profile_card_widget.dart

import 'package:flutter/material.dart';

/// Widget que muestra la tarjeta de perfil de otro usuario
class ProfileCardWidget extends StatelessWidget {
  final Map<String, dynamic> userData;
  final List<String> userPhotoUrls;
  final bool isDarkMode;
  final Color secondaryBackground;
  final Color textPrimary;
  final Color textSecondary;
  final Color borderColor;
  final Color brandYellow;

  const ProfileCardWidget({
    super.key,
    required this.userData,
    required this.userPhotoUrls,
    required this.isDarkMode,
    required this.secondaryBackground,
    required this.textPrimary,
    required this.textSecondary,
    required this.borderColor,
    required this.brandYellow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: secondaryBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Fotos del usuario
          if (userPhotoUrls.isNotEmpty)
            Container(
              height: 250,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                image: DecorationImage(
                  image: NetworkImage(userPhotoUrls.first),
                  fit: BoxFit.cover,
                ),
              ),
            )
          else
            Container(
              height: 250,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                color: borderColor,
              ),
              child: Center(
                child: Icon(Icons.person, size: 80, color: textSecondary),
              ),
            ),

          // Información del usuario
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        userData['name']?.toString() ?? 'Sin nombre',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: textPrimary,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: brandYellow,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${userData['age']?.toString() ?? '?'} años',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    Icon(Icons.location_on, size: 16, color: textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      userData['location']?.toString() ?? 'Sin ubicación',
                      style: TextStyle(color: textSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  userData['bio']?.toString() ?? 'Sin biografía',
                  style: TextStyle(color: textPrimary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
