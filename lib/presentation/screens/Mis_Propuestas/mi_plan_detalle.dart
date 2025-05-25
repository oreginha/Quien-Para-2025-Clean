// lib/presentation/screens/Mis_Propuestas/mi_plan_detalle.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quien_para/core/theme/app_colors.dart';
import 'package:quien_para/core/theme/provider/theme_provider.dart';
import 'package:quien_para/presentation/widgets/responsive/new_responsive_scaffold.dart';
import '../../bloc/matching/matching_bloc.dart';
import '../../bloc/matching/matching_event.dart';
import '../../bloc/matching/matching_state.dart';
import '../../routes/app_router.dart';
import 'package:quien_para/domain/entities/application/application_entity.dart';

class MyPlanDetailScreen extends StatelessWidget {
  final String planId;
  final bool isCreator;

  const MyPlanDetailScreen({
    super.key,
    required this.planId,
    this.isCreator = false,
  });

  @override
  Widget build(final BuildContext context) {
    if (kDebugMode) {
      print('MyPlanDetailScreen - Attempting to load plan with ID: $planId');
      print('MyPlanDetailScreen - Is Creator: $isCreator');
    }

    // Intentar obtener el MatchingBloc del contexto actual
    MatchingBloc? matchingBloc;
    try {
      matchingBloc = context.read<MatchingBloc>();
    } catch (e) {
      // No hacer nada si el bloc no está disponible
      if (kDebugMode) {
        print('MatchingBloc no está disponible en el contexto actual: $e');
      }
    }

    // Si tenemos acceso al bloc, usamos la implementación completa
    if (matchingBloc != null) {
      return _buildMainContent(context, planId, isCreator);
    }

    // Si no tenemos acceso al bloc, mostramos una vista simplificada con un mensaje de error
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    // Definir el AppBar que se usará tanto en móvil como en web
    final appBar = AppBar(
      title: const Text('Detalle del Plan'),
      backgroundColor:
          isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      iconTheme: IconThemeData(
        color:
            isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Refrescando datos...')),
            );
          },
        ),
      ],
    );

    // Definir el contenido principal
    final content = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: 64,
            color: AppColors.brandYellow,
          ),
          const SizedBox(height: 16),
          const Text(
            'Error de carga',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'No se puede cargar el plan. MatchingBloc no está disponible.',
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brandYellow,
              foregroundColor: Colors.black,
            ),
            onPressed: () => context.pop(),
            child: const Text('Volver'),
          ),
        ],
      ),
    );

    // Usar NewResponsiveScaffold para tener un diseño consistente
    return NewResponsiveScaffold(
      screenName: 'ErrorScreen',
      appBar: appBar,
      body: content,
      currentIndex: -1,
      webTitle: 'Error',
    );
  }
}

Widget _buildMainContent(
    final BuildContext context, final String planId, final bool isCreator) {
  return StreamBuilder<DocumentSnapshot>(
    stream:
        FirebaseFirestore.instance.collection('plans').doc(planId).snapshots(),
    builder: (final BuildContext context,
        final AsyncSnapshot<DocumentSnapshot<Object?>> planSnapshot) {
      if (planSnapshot.hasError) {
        return NewResponsiveScaffold(
          screenName: 'Error',
          body: const Center(child: Text('Error al cargar el plan')),
          currentIndex: -1,
          webTitle: 'Error',
        );
      }

      if (!planSnapshot.hasData) {
        return NewResponsiveScaffold(
          screenName: 'Cargando',
          body: const Center(child: CircularProgressIndicator()),
          currentIndex: -1,
          webTitle: 'Cargando',
        );
      }

      // Obtener el modo del tema
      final themeProvider = Provider.of<ThemeProvider>(context);
      final isDarkMode = themeProvider.isDarkMode;

      if (!planSnapshot.hasData || !planSnapshot.data!.exists) {
        return NewResponsiveScaffold(
          screenName: 'Error',
          appBar: AppBar(
            backgroundColor: AppColors.getBackground(isDarkMode),
            elevation: 0,
            title: Text(
              'Detalle del plan',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          body: const Center(
            child: Text(
              'El plan no existe o ha sido eliminado',
              style: TextStyle(color: Colors.white),
            ),
          ),
          currentIndex: -1,
          webTitle: 'Error',
        );
      }

      // Safely extract the data with null checking
      final documentData = planSnapshot.data!.data();
      if (documentData == null) {
        return NewResponsiveScaffold(
          screenName: 'Error',
          appBar: AppBar(
            backgroundColor: AppColors.getBackground(isDarkMode),
            elevation: 0,
            title: Text(
              'Detalle del plan',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          body: const Center(
            child: Text(
              'No se encontraron datos para este plan',
              style: TextStyle(color: Colors.white),
            ),
          ),
          currentIndex: -1,
          webTitle: 'Error',
        );
      }

      final Map<String, dynamic> planData =
          documentData as Map<String, dynamic>;

      return NewResponsiveScaffold(
        screenName: AppRouter.myPlanDetail,
        appBar: AppBar(
          backgroundColor: AppColors.getBackground(isDarkMode),
          elevation: 0,
          title: Text(
            planData['title'] as String? ?? 'Detalle del plan',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          actions: isCreator
              ? <Widget>[
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    onPressed: () {
                      context.push(
                        AppRouter.createProposal,
                        extra: <String, dynamic>{
                          'planId': planId,
                          'isEditing': true,
                          'planData': planData,
                        },
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.white),
                    onPressed: () => _showDeleteConfirmation(context, planId),
                  ),
                ]
              : null,
        ),
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Imagen del plan
                  if ((planData['imageUrl'] as String?)?.isNotEmpty ?? false)
                    Container(
                      height: 250,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(planData['imageUrl'] as String),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Creador del plan
                        FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection('users')
                              .doc(planData['creatorId'] as String)
                              .get(),
                          builder: (final BuildContext context,
                              final AsyncSnapshot<DocumentSnapshot<Object?>>
                                  creatorSnapshot) {
                            if (!creatorSnapshot.hasData) {
                              return const SizedBox.shrink();
                            }

                            final Map<String, dynamic> creatorData =
                                creatorSnapshot.data!.data()
                                    as Map<String, dynamic>;
                            return _buildCreatorInfo(creatorData);
                          },
                        ),

                        const SizedBox(height: 16),

                        // Descripción
                        Text(
                          planData['description'] as String? ?? '',
                          style: TextStyle(
                            color: Colors.white.withAlpha((0.7 * 255).round()),
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Detalles del evento
                        _buildSection(
                          'Detalles del Evento',
                          children: <Widget>[
                            _buildDetailRow(
                              Icons.category,
                              'Categoría',
                              planData['category'] as String? ??
                                  'No especificada',
                            ),
                            _buildDetailRow(
                              Icons.calendar_today,
                              'Fecha',
                              planData['date'] != null
                                  ? _formatDate(planData['date'])
                                  : 'No especificada',
                            ),
                            _buildDetailRow(
                              Icons.location_on,
                              'Ubicación',
                              planData['location'] as String? ??
                                  'No especificada',
                            ),
                            if (planData['payCondition'] != null)
                              _buildDetailRow(
                                Icons.attach_money,
                                'Condición de Pago',
                                planData['payCondition'] as String,
                              ),
                            if (planData['guestCount'] != null)
                              _buildDetailRow(
                                Icons.group,
                                'Número de Invitados',
                                '${planData['guestCount']}',
                              ),
                          ],
                        ),

                        // Condiciones
                        if (getMainConditions(planData).isNotEmpty)
                          _buildSection(
                            'Condiciones',
                            children: <Widget>[
                              ...getMainConditions(planData).toList().map(
                                  (final MapEntry<String, dynamic> entry) =>
                                      _buildDetailRow(
                                        Icons.check_circle_outline,
                                        entry.key,
                                        entry.value.toString(),
                                      )),
                            ],
                          ),

                        // Condiciones adicionales
                        if (hasExtraConditions(planData))
                          _buildSection(
                            'Condiciones adicionales',
                            children: <Widget>[
                              Text(
                                getConditionValue(
                                    planData, 'extraConditions', ''),
                                style: const TextStyle(
                                  color: Colors.white70,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),

                        // Postulantes
                        _buildSection(
                          'Postulantes',
                          children: <Widget>[
                            BlocBuilder<MatchingBloc, MatchingState>(
                              builder: (context, state) {
                                return state.when(
                                  initial: () => const Center(
                                      child: Text('Cargando aplicaciones...',
                                          style: TextStyle(
                                              color: Colors.white70))),
                                  loading: () => const Center(
                                      child: CircularProgressIndicator()),
                                  userApplicationsLoaded: (applications) =>
                                      const Center(
                                          child: Text(
                                              'No hay aplicaciones disponibles',
                                              style: TextStyle(
                                                  color: Colors.white70))),
                                  planApplicationsLoaded: (applications) =>
                                      applications.isEmpty
                                          ? const Center(
                                              child: Text(
                                                  'No hay aplicaciones para este plan',
                                                  style: TextStyle(
                                                      color: Colors.white70)))
                                          : _buildApplicantsList(context,
                                              applications, isCreator, planId),
                                  applicationActionSuccess: (_, application) =>
                                      _buildApplicantsList(
                                    context,
                                    context
                                        .read<MatchingBloc>()
                                        .state
                                        .maybeWhen(
                                          planApplicationsLoaded: (apps) =>
                                              apps,
                                          orElse: () => <ApplicationEntity>[],
                                        ),
                                    isCreator,
                                    planId,
                                  ),
                                  error: (message) => Center(
                                      child: Text('Error: $message',
                                          style: TextStyle(
                                              color: Colors.red[300]))),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Botones de acción según el rol
            if (!isCreator) _buildActionButtons(context, planId),
          ],
        ),
        currentIndex: -1, // No es una pantalla en la barra de navegación
        webTitle: planData['title'] as String? ?? 'Detalle del plan',
      );
    },
  );
}

Widget _buildCreatorInfo(final Map<String, dynamic> creatorData) {
  return Row(
    children: <Widget>[
      Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.yellow, width: 2),
        ),
        child: CircleAvatar(
          radius: 25,
          backgroundImage: creatorData['photoUrls'] != null &&
                  ((creatorData['photoUrls'] as List).isNotEmpty)
              ? NetworkImage((creatorData['photoUrls'] as List)[0] as String)
              : null,
          child: creatorData['photoUrls'] == null ||
                  (creatorData['photoUrls'] as List).isEmpty
              ? const Icon(Icons.person)
              : null,
        ),
      ),
      const SizedBox(width: 12),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '${creatorData['name'] as String? ?? 'Usuario'}, ${_formatUserAge(creatorData['age'])}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Creador del plan',
            style: TextStyle(
              color: Colors.white.withAlpha((0.7 * 255).round()),
            ),
          ),
        ],
      ),
    ],
  );
}

// Helper method to safely format user age from different possible types
String _formatUserAge(dynamic ageValue) {
  if (ageValue == null) {
    return '';
  }

  // Handle different types of age values
  if (ageValue is int) {
    return ageValue.toString();
  } else if (ageValue is double) {
    return ageValue.toInt().toString();
  } else if (ageValue is String) {
    return ageValue;
  } else {
    if (kDebugMode) {
      print('Unknown age type: ${ageValue.runtimeType}');
    }
    return '';
  }
}

Widget _buildApplicantsList(
    final BuildContext context,
    final List<ApplicationEntity> applications,
    final bool isCreator,
    final String planId) {
  return Column(
    children: <Widget>[
      ...applications.map((final ApplicationEntity application) =>
          FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(application.applicantId)
                .get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final userData = snapshot.data!.data() as Map<String, dynamic>?;
              if (userData == null) {
                return const SizedBox.shrink();
              }

              final String name = userData['name'] as String? ?? 'Usuario';
              final String age =
                  userData['age'] != null ? userData['age'].toString() : '';
              final List<dynamic> photoUrls =
                  userData['photoUrls'] as List<dynamic>? ?? [];
              final String photoUrl =
                  photoUrls.isNotEmpty ? photoUrls[0] as String : '';

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                        photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null,
                    child:
                        photoUrl.isEmpty ? Text(name[0].toUpperCase()) : null,
                  ),
                  title: Text(
                    '$name${age.isNotEmpty ? ', $age' : ''}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'Estado: ${_getStatusText(application.status)}',
                    style: TextStyle(
                      color: _getStatusColor(application.status),
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      if (isCreator &&
                          application.status == 'pending') ...<Widget>[
                        IconButton(
                          icon: const Icon(Icons.check_circle_outline,
                              color: Colors.green),
                          onPressed: () {
                            // Usar el MatchingBloc para aceptar la postulación
                            context.read<MatchingBloc>().add(
                                  MatchingEvent.acceptApplication(
                                      application.id),
                                );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.cancel_outlined,
                              color: Colors.red),
                          onPressed: () {
                            // Usar el MatchingBloc para rechazar la postulación
                            context.read<MatchingBloc>().add(
                                  MatchingEvent.rejectApplication(
                                      application.id),
                                );
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          )),
      if (isCreator && applications.isNotEmpty)
        OutlinedButton.icon(
          onPressed: () {
            // Navegar a la pantalla de postulaciones
            context.push(AppRouter.applicantsList, extra: planId);
          },
          icon: const Icon(Icons.people),
          label: const Text('Ver todas las postulaciones'),
        ),
    ],
  );
}

String _getStatusText(String status) {
  switch (status) {
    case 'pending':
      return 'Pendiente';
    case 'accepted':
      return 'Aceptado';
    case 'rejected':
      return 'Rechazado';
    case 'cancelled':
      return 'Cancelado';
    default:
      return 'Desconocido';
  }
}

Color _getStatusColor(String status) {
  switch (status) {
    case 'pending':
      return Colors.orange;
    case 'accepted':
      return Colors.green;
    case 'rejected':
      return Colors.red;
    case 'cancelled':
      return Colors.grey;
    default:
      return Colors.grey;
  }
}

// Agregar este método a la clase MyPlanDetailScreen
Map<String, dynamic> getConditionsMap(final Map<String, dynamic> planData) {
  // Si no hay condiciones, devolver un mapa vacío
  if (planData['conditions'] == null) {
    return <String, dynamic>{};
  }

  try {
    // Intentar convertir a Map<String, dynamic>
    return Map<String, dynamic>.from(
        planData['conditions'] as Map<dynamic, dynamic>);
  } catch (e) {
    if (kDebugMode) {
      print('Error al procesar condiciones: $e');
    }
    // En caso de error, devolver un mapa vacío
    return <String, dynamic>{};
  }
}

// Método para obtener una condición específica como String
String getConditionValue(final Map<String, dynamic> planData, final String key,
    final String defaultValue) {
  final Map<String, dynamic> conditions = getConditionsMap(planData);
  if (conditions.isEmpty) {
    return defaultValue;
  }

  final value = conditions[key];
  if (value == null) {
    return defaultValue;
  }

  return value.toString();
}

// Método para verificar si hay condiciones extras
bool hasExtraConditions(final Map<String, dynamic> planData) {
  final Map<String, dynamic> conditions = getConditionsMap(planData);
  return conditions.containsKey('extraConditions') &&
      conditions['extraConditions'] != null &&
      (conditions['extraConditions'] as String).isNotEmpty;
}

// Método para obtener lista de condiciones (excluyendo extraConditions)
List<MapEntry<String, dynamic>> getMainConditions(
    final Map<String, dynamic> planData) {
  final Map<String, dynamic> conditions = getConditionsMap(planData);
  return conditions.entries
      .where((final MapEntry<String, dynamic> entry) =>
          entry.key != 'extraConditions')
      .toList();
}

Widget _buildActionButtons(final BuildContext context, final String planId) {
  return Positioned(
    left: 0,
    right: 0,
    bottom: 0,
    child: Container(
      color: const Color(0xFF1A1B2E),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: <Widget>[
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                // Mostrar diálogo de confirmación
                showDialog(
                  context: context,
                  builder: (final BuildContext context) => AlertDialog(
                    backgroundColor: const Color(0xFF1A1B2E),
                    title: const Text(
                      '¿Deseas postularte a este plan?',
                      style: TextStyle(color: Colors.white),
                    ),
                    content: const Text(
                      'El creador del plan podrá ver tu perfil y decidir si acepta tu postulación.',
                      style: TextStyle(color: Colors.white70),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Cierra el diálogo
                          // Usar el MatchingBloc para enviar la postulación
                          context.read<MatchingBloc>().add(
                                MatchingEvent.applyToPlan(planId),
                              );
                        },
                        child: Text(
                          'Postularme',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.person_add),
              label: const Text('¡Me interesa!'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brandYellow,
                foregroundColor: AppColors.lightTextPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

void _deletePlan(final BuildContext context, final String planId) async {
  try {
    await FirebaseFirestore.instance.collection('plans').doc(planId).delete();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Plan eliminado exitosamente'),
          backgroundColor: AppColors.success,
        ),
      );

      // Always navigate back to profile screen after deletion
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
            context, AppRouter.profile, (route) => false);
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error eliminando plan: $e');
    }
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al eliminar el plan: $e'),
          backgroundColor: AppColors.accentRed,
        ),
      );
    }
  }
}

// Este método se ha eliminado porque no estaba siendo utilizado

void _showDeleteConfirmation(final BuildContext context, final String planId) {
  showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      backgroundColor: Colors.grey[850],
      title: const Text(
        'Confirmar eliminación',
        style: TextStyle(color: Colors.white),
      ),
      content: const Text(
        'Esta acción no se puede deshacer.',
        style: TextStyle(color: Colors.white70),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Cierra el diálogo
            _deletePlan(context, planId);
          },
          child: const Text(
            'Eliminar',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    ),
  );
}

Widget _buildSection(final String title,
    {required final List<Widget> children}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        title,
        style: const TextStyle(
          color: Colors.yellow,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 16),
      ...children,
      const SizedBox(height: 24),
    ],
  );
}

Widget _buildDetailRow(
    final IconData icon, final String label, final String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      children: <Widget>[
        Icon(icon, color: Colors.yellow, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// Helper method to format date from different possible types
String _formatDate(dynamic dateValue) {
  if (dateValue is Timestamp) {
    // Handle Firestore Timestamp
    return dateValue.toDate().toString().split(' ')[0];
  } else if (dateValue is String) {
    // Handle String date
    try {
      return DateTime.parse(dateValue).toString().split(' ')[0];
    } catch (e) {
      if (kDebugMode) {
        print('Error parsing date string: $e');
      }
      return dateValue;
    }
  } else if (dateValue is DateTime) {
    // Handle DateTime
    return dateValue.toString().split(' ')[0];
  } else {
    // Unknown type
    if (kDebugMode) {
      print('Unknown date type: ${dateValue.runtimeType}');
    }
    return 'Fecha desconocida';
  }
}
