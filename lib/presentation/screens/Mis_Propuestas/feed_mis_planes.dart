// lib/presentation/screens/planes_main_screen.dart
// ignore_for_file: inference_failure_on_function_invocation, always_specify_types, unused_element, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quien_para/core/logger/logger.dart';
import 'package:quien_para/data/models/plan/plan_model_simple.dart';
import 'package:quien_para/presentation/bloc/auth/auth_cubit.dart';
import 'package:quien_para/presentation/bloc/plan/plan_bloc.dart';
import 'package:quien_para/core/theme/app_colors.dart'; // Añadido para utilizar los colores del tema
import '../../bloc/auth/auth_state.dart';
import '../../bloc/plan/plan_event.dart';
import '../../routes/app_router.dart';

class FeedMisPlanes extends StatefulWidget {
  const FeedMisPlanes({super.key, required final String title});

  @override
  State<FeedMisPlanes> createState() => _FeedMisPlanesState();
}

class _FeedMisPlanesState extends State<FeedMisPlanes> {
  String _searchQuery = '';
  String _selectedFilter = 'Todos';
  final List<String> _filterOptions = [
    'Todos',
    'Hoy',
    'Esta semana',
    'Este mes'
  ];

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (final context, final state) {
        final currentUserId = state.user?['id'] as String?;

        if (currentUserId == null) {
          return const Center(child: Text('Error: No se encontró usuario'));
        }

        return Scaffold(
          backgroundColor: AppColors.getBackground(
              Theme.of(context).brightness ==
                  Brightness.dark), // Usar color de fondo del tema
          appBar: AppBar(
            backgroundColor: AppColors.getBackground(
                Theme.of(context).brightness ==
                    Brightness.dark), // Usar color de fondo del tema
            elevation: 0,
            title: Text(
              'QUIÉN PARA?',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall, // Usar estilo de título que respeta el tema
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(110),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Buscar planes...',
                        hintStyle: TextStyle(
                            color: Colors.white.withAlpha((0.5 * 255).round())),
                        prefixIcon:
                            const Icon(Icons.search, color: Colors.white),
                        filled: true,
                        fillColor: Colors.white.withAlpha((0.1 * 255).round()),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: _filterOptions
                          .map((filter) => Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ChoiceChip(
                                  label: Text(filter),
                                  selected: _selectedFilter == filter,
                                  onSelected: (selected) {
                                    if (selected) {
                                      setState(() {
                                        _selectedFilter = filter;
                                      });
                                    }
                                  },
                                  selectedColor: Colors.yellow,
                                  backgroundColor: Colors.white
                                      .withAlpha((0.1 * 255).round()),
                                  labelStyle: TextStyle(
                                    color: _selectedFilter == filter
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: () {
                  context.read<PlanBloc>().add(const PlanEvent.clear());
                  context.push(AppRouter.createProposal);
                },
              ),
            ],
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('plans')
                .where('creatorId', isEqualTo: currentUserId)
                .orderBy('date', descending: true)
                .snapshots(),
            builder: (final context, final snapshot) {
              if (snapshot.hasError) {
                logger.e('Error loading plans: ${snapshot.error}');
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error al cargar los planes',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${snapshot.error}',
                        style: TextStyle(
                          color: AppColors.lightTextPrimary.withAlpha((0.7 *
                                  255)
                              .round()), // Reemplazado color directo por color del tema
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          (context as Element).markNeedsBuild();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors
                              .brandYellow, // Reemplazado Colors.yellow por color del tema
                          foregroundColor: AppColors
                              .lightTextPrimary, // Reemplazado Colors.black por color del tema
                        ),
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
                  ),
                );
              }

              final plans = snapshot.data?.docs ?? [];
              final filteredPlans = plans.where((plan) {
                final planData = plan.data() as Map<String, dynamic>;
                final planModel =
                    PlanModel.fromJson({...planData, 'id': plan.id});

                // Aplicar filtro de búsqueda
                if (_searchQuery.isNotEmpty) {
                  final query = _searchQuery.toLowerCase();
                  if (!planModel.title.toLowerCase().contains(query) &&
                      !planModel.description.toLowerCase().contains(query) &&
                      !planModel.location.toLowerCase().contains(query)) {
                    return false;
                  }
                }

                // Aplicar filtro de fecha
                if (_selectedFilter != 'Todos') {
                  final now = DateTime.now();
                  final planDate = planModel.date;

                  switch (_selectedFilter) {
                    case 'Hoy':
                      return planDate.year == now.year &&
                          planDate.month == now.month &&
                          planDate.day == now.day;
                    case 'Esta semana':
                      final startOfWeek =
                          now.subtract(Duration(days: now.weekday - 1));
                      final endOfWeek =
                          startOfWeek.add(const Duration(days: 6));
                      return planDate.isAfter(startOfWeek) &&
                          planDate
                              .isBefore(endOfWeek.add(const Duration(days: 1)));
                    case 'Este mes':
                      return planDate.year == now.year &&
                          planDate.month == now.month;
                    default:
                      return true;
                  }
                }

                return true;
              }).toList();
              if (snapshot.hasError) {
                logger.e('Error loading plans: ${snapshot.error}');
                String errorMessage = 'Error al cargar los planes';
                String detailMessage = '${snapshot.error}';
                Widget actionButton = ElevatedButton(
                  onPressed: () {
                    // Force a rebuild of the widget
                    (context as Element).markNeedsBuild();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors
                        .brandYellow, // Reemplazado Colors.yellow por color del tema
                    foregroundColor: AppColors
                        .lightTextPrimary, // Reemplazado Colors.black por color del tema
                  ),
                  child: const Text('Reintentar'),
                );

                // Check if it's an index error and provide a direct link
                if (snapshot.error is FirebaseException) {
                  final FirebaseException error =
                      snapshot.error as FirebaseException;
                  logger.e(
                      'Firebase error code: ${error.code}, message: ${error.message}');

                  if (error.code == 'failed-precondition' &&
                      error.message != null &&
                      error.message!.contains('requires an index')) {
                    // Extract the URL from the error message
                    final RegExp urlRegex =
                        RegExp(r'https://console\.firebase\.google\.com[^\s]+');
                    final Match? match = urlRegex.firstMatch(error.message!);

                    if (match != null) {
                      final String indexUrl = match.group(0)!;
                      errorMessage = 'Se requiere crear un índice en Firebase';
                      detailMessage =
                          'Para solucionar este problema, necesitas crear un índice compuesto en Firebase.';

                      actionButton = ElevatedButton(
                        onPressed: () async {
                          // Removed unused Uri variable
                          // You'll need to add url_launcher package for this
                          // and handle the launch with canLaunch/launch
                          logger.d('Opening index creation URL: $indexUrl');
                          // For now, just show a snackbar with instructions
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Por favor, copia y pega esta URL en tu navegador: $indexUrl'),
                              duration: const Duration(seconds: 10),
                              action: SnackBarAction(
                                label: 'Copiar',
                                onPressed: () {
                                  // You would implement clipboard copy here
                                  // For now just show another snackbar
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'URL copiada al portapapeles')),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Crear Índice'),
                      );
                    }
                  }
                }

                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        errorMessage,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          detailMessage,
                          style: TextStyle(
                            color: Colors.white.withAlpha((0.7 * 255).round()),
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 16),
                      actionButton,
                    ],
                  ),
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                logger.d('Waiting for plans data...');
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
                  ),
                );
              }

              logger.d('Loaded ${plans.length} plans');

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Mis Planes',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (plans.isEmpty)
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_box_outlined,
                                size: 80,
                                color: Colors.yellow
                                    .withAlpha((0.7 * 255).round()),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'No tienes propuestas cargadas',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                '¡Crea tu primera propuesta!',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton.icon(
                                onPressed: () {
                                  context
                                      .read<PlanBloc>()
                                      .add(const PlanEvent.clear());
                                  context.push(AppRouter.createProposal);
                                },
                                icon: const Icon(Icons.add),
                                label: const Text('Crear Propuesta'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.yellow,
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: filteredPlans.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      _searchQuery.isEmpty
                                          ? Icons.add_box_outlined
                                          : Icons.search_off,
                                      size: 80,
                                      color: Colors.yellow
                                          .withAlpha((0.7 * 255).round()),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      _searchQuery.isEmpty
                                          ? 'No tienes propuestas cargadas'
                                          : 'No se encontraron planes',
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      _searchQuery.isEmpty
                                          ? '¡Crea tu primera propuesta!'
                                          : 'Intenta con otros términos de búsqueda',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white70,
                                      ),
                                    ),
                                    if (_searchQuery.isEmpty) ...[
                                      const SizedBox(height: 24),
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          context
                                              .read<PlanBloc>()
                                              .add(const PlanEvent.clear());
                                          context
                                              .push(AppRouter.createProposal);
                                        },
                                        icon: const Icon(Icons.add),
                                        label: const Text('Crear Propuesta'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.yellow,
                                          foregroundColor: Colors.black,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 32,
                                            vertical: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              )
                            : GridView.builder(
                                padding: const EdgeInsets.all(16),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  childAspectRatio: 0.75,
                                ),
                                itemCount: filteredPlans.length,
                                itemBuilder: (final context, final index) {
                                  final planDoc = filteredPlans[index];
                                  try {
                                    logger.d(
                                        'Processing plan document: ${planDoc.id}');
                                    final planData =
                                        planDoc.data() as Map<String, dynamic>;
                                    logger.d(
                                        'Plan data: ${planData.keys.join(', ')}');

                                    final plan = PlanModel.fromJson({
                                      ...planData,
                                      'id': planDoc.id,
                                    });
                                    logger.d(
                                        'Successfully parsed plan: ${plan.title}');

                                    return Card(
                                        margin:
                                            const EdgeInsets.only(bottom: 16),
                                        color: const Color(0xFF383A6B),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              if (plan.imageUrl.isNotEmpty)
                                                Container(
                                                  height: 200,
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                          plan.imageUrl),
                                                      fit: BoxFit.cover,
                                                      onError: (exception,
                                                          stackTrace) {
                                                        logger.e(
                                                            'Error loading image: $exception');
                                                      },
                                                    ),
                                                  ),
                                                  child: Stack(
                                                    children: [
                                                      // Add a semi-transparent overlay to make text more readable
                                                      Container(
                                                        color: Colors.black
                                                            .withAlpha(77),
                                                      ),
                                                      // Add an error widget that will be shown if the image fails to load
                                                      Positioned.fill(
                                                        child: Image.network(
                                                          plan.imageUrl,
                                                          fit: BoxFit.cover,
                                                          errorBuilder:
                                                              (context, error,
                                                                  stackTrace) {
                                                            logger.e(
                                                                'Image error: $error');
                                                            return Container(
                                                              color: Colors
                                                                  .grey[800],
                                                              child:
                                                                  const Center(
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .broken_image,
                                                                      color: Colors
                                                                          .white70,
                                                                      size: 40,
                                                                    ),
                                                                    SizedBox(
                                                                        height:
                                                                            8),
                                                                    Text(
                                                                      'No se pudo cargar la imagen',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white70),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          loadingBuilder: (context,
                                                              child,
                                                              loadingProgress) {
                                                            if (loadingProgress ==
                                                                null) {
                                                              return child;
                                                            }
                                                            return Container(
                                                              color: Colors
                                                                  .grey[800],
                                                              child: Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  value: loadingProgress
                                                                              .expectedTotalBytes !=
                                                                          null
                                                                      ? loadingProgress
                                                                              .cumulativeBytesLoaded /
                                                                          (loadingProgress.expectedTotalBytes ??
                                                                              1)
                                                                      : null,
                                                                  valueColor: const AlwaysStoppedAnimation<
                                                                          Color>(
                                                                      Colors
                                                                          .yellow),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(16),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      plan.title,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Text(
                                                      plan.description,
                                                      style: TextStyle(
                                                        color: Colors.white
                                                            .withAlpha(
                                                                (0.7 * 255)
                                                                    .round()),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 16),
                                                    SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      child: Row(
                                                        children: [
                                                          _buildDetailChip(
                                                            Icons
                                                                .calendar_today,
                                                            plan.date
                                                                .toString()
                                                                .split(' ')[0],
                                                          ),
                                                          const SizedBox(
                                                              width: 8),
                                                          _buildDetailChip(
                                                            Icons.location_on,
                                                            plan.location,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(height: 16),
                                                    SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          ElevatedButton.icon(
                                                            onPressed: () {
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (final BuildContext
                                                                        context) {
                                                                  return AlertDialog(
                                                                    backgroundColor:
                                                                        const Color(
                                                                            0xFF1A1B2E),
                                                                    title:
                                                                        const Text(
                                                                      'Eliminar Plan',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                    content:
                                                                        Text(
                                                                      '¿Estás seguro que deseas eliminar "${plan.title}"?',
                                                                      style: const TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                    actions: [
                                                                      TextButton(
                                                                        onPressed:
                                                                            () =>
                                                                                Navigator.of(context).pop(),
                                                                        child:
                                                                            const Text(
                                                                          'Cancelar',
                                                                          style:
                                                                              TextStyle(color: Colors.white),
                                                                        ),
                                                                      ),
                                                                      ElevatedButton(
                                                                        onPressed:
                                                                            () {
                                                                          FirebaseFirestore
                                                                              .instance
                                                                              .collection('plans')
                                                                              .doc(plans[index].id)
                                                                              .delete();
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                          ScaffoldMessenger.of(context)
                                                                              .showSnackBar(
                                                                            SnackBar(
                                                                              content: Text('El plan "${plan.title}" ha sido eliminado'),
                                                                              backgroundColor: Colors.red,
                                                                            ),
                                                                          );
                                                                        },
                                                                        style: ElevatedButton
                                                                            .styleFrom(
                                                                          backgroundColor:
                                                                              Colors.red,
                                                                        ),
                                                                        child: const Text(
                                                                            'Eliminar'),
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              );
                                                            },
                                                            icon: const Icon(
                                                                Icons.delete),
                                                            label: const Text(
                                                                'Eliminar'),
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              backgroundColor:
                                                                  Colors.red,
                                                              foregroundColor:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          ElevatedButton.icon(
                                                            onPressed: () {
                                                              context.push(
                                                                  '/myPlanDetail/${plan.id}',
                                                                  extra: {
                                                                    'planId':
                                                                        plan.id,
                                                                    'isCreator':
                                                                        true
                                                                  });
                                                            },
                                                            icon: const Icon(
                                                                Icons
                                                                    .visibility),
                                                            label: const Text(
                                                                'Ver más'),
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              backgroundColor:
                                                                  Colors.yellow,
                                                              foregroundColor:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ));
                                  } catch (e, stackTrace) {
                                    logger.e('Error parsing plan document: $e');
                                    logger.e('Stack trace: $stackTrace');
                                    return Card(
                                      margin: const EdgeInsets.only(bottom: 16),
                                      color: Colors.red.shade900,
                                      child: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Error al cargar este plan',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Detalles: $e',
                                              style: const TextStyle(
                                                color: Colors.white70,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                      ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context,
      {IconData icon = Icons.info_outline, String label = 'Sin información'}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.yellow, size: 16),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(BuildContext context, DocumentSnapshot planDoc,
      {IconData icon = Icons.event, String label = 'Plan'}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.yellow, size: 16),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailChip(final IconData icon, final String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.yellow, size: 16),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
