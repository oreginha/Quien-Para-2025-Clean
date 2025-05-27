// lib/presentation/screens/create_proposal/steps/plan_suggestions_step.dart
// ignore_for_file: inference_failure_on_function_return_type, always_specify_types

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/theme_utils.dart';
import '../../../bloc/plan/plan_bloc.dart';
import '../../../bloc/plan/plan_event.dart';
import '../../../bloc/plan/plan_state.dart';

class PlanSuggestionsStep extends StatefulWidget {
  final PlanBloc state;
  final Function(PlanBloc) onStateUpdate;
  final Function() onNext;
  final Function() onBack;

  const PlanSuggestionsStep({
    super.key,
    required this.state,
    required this.onStateUpdate,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<PlanSuggestionsStep> createState() => _PlanSuggestionsStepState();
}

class _PlanSuggestionsStepState extends State<PlanSuggestionsStep> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();
  List<QueryDocumentSnapshot> _suggestedPlans = [];
  Timer? _debounce;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      print('🚀 Iniciando PlanSuggestionsStep');
      print('📌 Inicializando Firestore instance');
    }
    _loadSuggestedPlans();

    _searchController.addListener(() {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        if (kDebugMode) {
          print('🔍 Búsqueda iniciada con texto: ${_searchController.text}');
        }
        _searchPlans(_searchController.text);
      });
    });
  }

  Future<void> _loadSuggestedPlans() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final PlanState state = widget.state.state;
      if (state is! PlanLoaded) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final selectedThemes = state.plan.selectedThemes;
      if (kDebugMode) {
        print('📋 Temas seleccionados originales: $selectedThemes');
      }

      if (selectedThemes.isEmpty) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final List<String> firestoreCategories = selectedThemes
          .expand(
            (theme) => PlanType.planTypes[theme]!['firestoreCategories']
                as List<String>,
          )
          .toList();

      if (kDebugMode) {
        print('🎯 Categorías mapeadas para Firestore: $firestoreCategories');
        print('📝 Consulta a realizar:');
        print('  Colección: events');
        print('  Condición: categoria in $firestoreCategories');
      }

      final snapshot = await _firestore
          .collection('events')
          .where('categoria', whereIn: firestoreCategories)
          .get();

      if (kDebugMode) {
        print('📊 Resultados de la consulta:');
        print('  Total de documentos: ${snapshot.docs.length}');
        for (var doc in snapshot.docs) {
          print('  Documento encontrado:');
          print('    ID: ${doc.id}');
          print('    Nombre: ${doc['nombre_evento']}');
          print('    Categoría exacta en DB: ${doc['categoria']}');
          print('    URL de imagen: ${doc['image_url_png']}');
        }
      }

      setState(() {
        _suggestedPlans = snapshot.docs;
        _isLoading = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error cargando planes sugeridos:');
        print('Error detallado: $e');
        print('StackTrace: ${StackTrace.current}');
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _searchPlans(String query) async {
    if (query.length < 3) {
      if (kDebugMode) {
        print('🔄 Query menor a 3 caracteres, mostrando planes sugeridos');
      }
      _loadSuggestedPlans();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (kDebugMode) {
        print('🔍 Realizando búsqueda con query: "$query"');
      }

      final queryLower = query.toLowerCase();
      final snapshot = await _firestore.collection('events').get();

      // Filtrado local para búsqueda más flexible
      final filteredDocs = snapshot.docs.where((doc) {
        final nombreEvento =
            (doc['nombre_evento'] ?? '').toString().toLowerCase();
        return nombreEvento.contains(queryLower);
      }).toList();

      if (kDebugMode) {
        print('📊 Resultados encontrados: ${filteredDocs.length}');
        for (var doc in filteredDocs) {
          print('Evento encontrado:');
          print('  Nombre: ${doc['nombre_evento']}');
          print('  URL de imagen: ${doc['image_url_png']}');
        }
      }

      setState(() {
        _suggestedPlans = filteredDocs;
        _isLoading = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error en la búsqueda:');
        print('Query que causó el error: $query');
        print('Error detallado: $e');
        print('StackTrace: ${StackTrace.current}');
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [ThemeUtils.background, ThemeUtils.darkSecondaryBackground],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header con botón de crear plan
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Planes Sugeridos',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withAlpha((255 * 0.9).toInt()),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Limpiar valores de título y descripción con BLoC
                      widget.state.add(
                        const PlanEvent.updateField(field: 'title', value: ''),
                      );
                      widget.state.add(
                        const PlanEvent.updateField(
                          field: 'description',
                          value: '',
                        ),
                      );
                      widget.state.add(
                        const PlanEvent.updateField(
                          field: 'location',
                          value: '',
                        ),
                      );

                      // Notificar al padre sobre la actualización
                      widget.onStateUpdate(widget.state);

                      // Ir al siguiente paso
                      widget.onNext();
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Crea tu plan'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ThemeUtils.brandYellow,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Buscador
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Buscar planes...',
                  hintStyle: TextStyle(
                    color: Colors.white.withAlpha((0.5 * 255).toInt()),
                  ),
                  prefixIcon: const Icon(Icons.search, color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.white.withAlpha((0.3 * 255).toInt()),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: ThemeUtils.brandYellow),
                  ),
                ),
              ),
            ),
            // Indicador de carga o lista de planes sugeridos
            _isLoading
                ? const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                      ),
                    ),
                  )
                : Expanded(
                    child: _suggestedPlans.isEmpty
                        ? Center(
                            child: Text(
                              'No se encontraron planes. Intenta con otra búsqueda o crea tu propio plan.',
                              style: TextStyle(
                                color: Colors.white.withAlpha(
                                  (0.7 * 255).toInt(),
                                ),
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : ListView.builder(
                            itemCount: _suggestedPlans.length,
                            itemBuilder: (context, index) {
                              final planData = _suggestedPlans[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                color: Colors.white.withAlpha(25),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(12),
                                      ),
                                      child: Stack(
                                        children: [
                                          Image.network(
                                            planData['image_url_png'] as String,
                                            height: 200,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            loadingBuilder: (
                                              context,
                                              child,
                                              loadingProgress,
                                            ) {
                                              if (loadingProgress == null) {
                                                if (kDebugMode) {
                                                  print(
                                                    '✅ Imagen cargada correctamente: ${planData['image_url_png']}',
                                                  );
                                                }
                                                return child;
                                              }
                                              return Container(
                                                height: 200,
                                                color: Colors.grey[800],
                                                child: Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    color:
                                                        ThemeUtils.brandYellow,
                                                  ),
                                                ),
                                              );
                                            },
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              if (kDebugMode) {
                                                print(
                                                  '❌ Error cargando imagen:',
                                                );
                                                print(
                                                  'URL: ${planData['image_url_png']}',
                                                );
                                                print('Error: $error');
                                              }
                                              return Container(
                                                height: 200,
                                                color: Colors.grey[800],
                                                child: Icon(
                                                  Icons.error_outline,
                                                  size: 50,
                                                  color: Colors.white.withAlpha(
                                                    (0.3 * 255).toInt(),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            planData['nombre_evento'] as String,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white.withAlpha(
                                                (0.9 * 255).toInt(),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            (planData['categoria']
                                                    as String?) ??
                                                '',
                                            style: TextStyle(
                                              color: Colors.white.withAlpha(
                                                (0.7 * 255).toInt(),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton.icon(
                                              onPressed: () {
                                                if (kDebugMode) {
                                                  print(
                                                    'Datos del plan seleccionado:',
                                                  );
                                                  final data = planData.data()
                                                      as Map<String, dynamic>;
                                                  data.forEach((key, value) {
                                                    if (kDebugMode) {
                                                      print('$key: $value');
                                                    }
                                                  });
                                                  print(
                                                    'URL de imagen específica: ${planData['image_url_png']}',
                                                  );
                                                }

                                                // Actualizar plan con BLoC
                                                widget.state.add(
                                                  PlanEvent
                                                      .updateFromSuggestedPlan(
                                                    planData.data()
                                                        as Map<String, dynamic>,
                                                  ),
                                                );

                                                // Notificar al padre sobre la actualización
                                                widget.onStateUpdate(
                                                  widget.state,
                                                );

                                                // Ir al siguiente paso
                                                widget.onNext();
                                              },
                                              icon: const Icon(
                                                Icons.check_circle_outline,
                                              ),
                                              label: const Text(
                                                'Seleccionar este plan',
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    ThemeUtils.brandYellow,
                                                foregroundColor: Colors.black,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 12,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
            // Botón de navegación para volver
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: widget.onBack,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.withAlpha(80),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Atrás'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }
}
