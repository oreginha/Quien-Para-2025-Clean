// lib/presentation/screens/applicants/applicants_list_screen.dart
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:quien_para/core/theme/app_colors.dart'; // Añadido para utilizar los colores del tema
import 'package:quien_para/presentation/widgets/navigation_aware_scaffold.dart';
import '../../routes/app_router.dart';

class ApplicantsListScreen extends StatelessWidget {
  final String planId;

  const ApplicantsListScreen({super.key, required this.planId});

  @override
  Widget build(final BuildContext context) {
    // Datos de prueba hardcodeados
    final List<Map<String, dynamic>> applicants = <Map<String, dynamic>>[
      <String, dynamic>{
        'id': '1',
        'name': 'Ana García',
        'age': 25,
        'avatarUrl': 'https://randomuser.me/api/portraits/women/1.jpg',
        'description':
            'Apasionada por los deportes al aire libre y la fotografía. Me encanta conocer gente nueva y compartir experiencias.',
        'interests': <String>['Fotografía', 'Senderismo', 'Viajes'],
        'mutualFriends': 3,
        'distance': '2.5 km',
        'commonInterests': 4,
        'rating': 4.8,
      },
      <String, dynamic>{
        'id': '2',
        'name': 'Carlos Rodríguez',
        'age': 28,
        'avatarUrl': 'https://randomuser.me/api/portraits/men/2.jpg',
        'description':
            'Amante de la música y los conciertos en vivo. Toco la guitarra y siempre estoy buscando personas para hacer música.',
        'interests': <String>['Música', 'Guitarra', 'Festivales'],
        'mutualFriends': 5,
        'distance': '1.2 km',
        'commonInterests': 3,
        'rating': 4.5,
      },
      <String, dynamic>{
        'id': '3',
        'name': 'Laura Martínez',
        'age': 23,
        'avatarUrl': 'https://randomuser.me/api/portraits/women/3.jpg',
        'description':
            'Estudiante de arte. Me encanta pintar y visitar galerías. Busco personas con intereses similares.',
        'interests': <String>['Arte', 'Pintura', 'Museos'],
        'mutualFriends': 2,
        'distance': '3.7 km',
        'commonInterests': 2,
        'rating': 4.9,
      },
    ];

    return NavigationAwareScaffold(
      screenName: AppRouter.applicantsList,
      appBar: AppBar(
        backgroundColor: AppColors.getBackground(
          Theme.of(context).brightness == Brightness.dark,
        ),
        elevation: 0,
        title: Text(
          'Aplicantes',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      darkPrimaryBackground: const Color(0xFF2D2F53),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: applicants.length,
        itemBuilder: (final BuildContext context, final int index) {
          final Map<String, dynamic> applicant = applicants[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            color: const Color(0xFF1A1B2E),
            child: Column(
              children: <Widget>[
                ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundColor: Theme.of(context).brightness ==
                            Brightness.dark
                        ? AppColors.darkSecondaryBackground
                        : AppColors
                            .lightSecondaryBackground, // Reemplazado color directo por color del tema
                    backgroundImage: NetworkImage(
                      applicant['avatarUrl'] as String,
                    ),
                    onBackgroundImageError:
                        (final Object e, final StackTrace? s) =>
                            const Icon(Icons.person),
                  ),
                  title: Row(
                    children: <Widget>[
                      Text(
                        '${applicant['name']}, ${applicant['age']}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.verified, color: Colors.blue[300], size: 20),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 8),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.location_on,
                            color: Colors.grey[400],
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            applicant['distance'] as String,
                            style: TextStyle(color: Colors.grey[400]),
                          ),
                          const SizedBox(width: 16),
                          Icon(Icons.people, color: Colors.grey[400], size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '${applicant['mutualFriends']} amigos en común',
                            style: TextStyle(color: Colors.grey[400]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    applicant['description'] as String,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (applicant['interests'] as List<String>).map((
                      final String interest,
                    ) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.withAlpha(51), // 0.2 * 255 = 51
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          interest,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      _buildActionButton(
                        context,
                        Icons.close,
                        'Rechazar',
                        Colors.red,
                        () {},
                      ),
                      _buildActionButton(
                        context,
                        Icons.check,
                        'Aceptar',
                        Colors.green,
                        () {},
                      ),
                      _buildActionButton(
                        context,
                        Icons.message,
                        'Mensaje',
                        Colors.blue,
                        () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionButton(
    final BuildContext context,
    final IconData icon,
    final String label,
    final Color color,
    final VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}
