// lib/presentation/screens/create_proposal/steps/event_details_step.dart

// ignore_for_file: inference_failure_on_function_invocation, prefer_final_locals, always_specify_types, inference_failure_on_function_return_type

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quien_para/domain/entities/plan/plan_entity.dart';
import '../../../bloc/plan/plan_bloc.dart';
import '../../../bloc/plan/plan_event.dart';
import '../../../bloc/plan/plan_state.dart';

class EventDetailsStep extends StatefulWidget {
  final PageController pageController;

  const EventDetailsStep({
    super.key,
    required this.pageController,
    required final String title,
    required final String description,
    required final String location,
    required final void Function(dynamic value) onTitleChange,
    required final void Function(dynamic value) onDescriptionChange,
    required final void Function(dynamic value) onLocationChange,
    required final void Function() onNext,
  });

  @override
  State<EventDetailsStep> createState() => _EventDetailsStepState();
}

class _EventDetailsStepState extends State<EventDetailsStep> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  String? _selectedImageUrl;
  bool _isImageLoading = false;
  bool _hasImageError = false;
  bool _isInitialized = false;

  // Lista de imágenes predeterminadas de fallback
  final List<String> _defaultImageUrls = [
    'https://via.placeholder.com/400x200/3498db/ffffff?text=Evento+Social',
    'https://via.placeholder.com/400x200/e74c3c/ffffff?text=Festival+Musical',
    'https://via.placeholder.com/400x200/2ecc71/ffffff?text=Evento+Deportivo',
    'https://via.placeholder.com/400x200/9b59b6/ffffff?text=Teatro',
    'https://via.placeholder.com/400x200/f1c40f/ffffff?text=Cine',
  ];

  @override
  void initState() {
    super.initState();

    if (kDebugMode) {
      print('EventDetailsStep - initState()');
    }

    // Inicializar controladores con texto vacío
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _locationController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      try {
        final state = context.read<PlanBloc>().state;

        if (state is PlanLoaded) {
          if (kDebugMode) {
            print('EventDetailsStep - Cargando datos del PlanBloc:');
            print('- Título: ${state.plan.title}');
            print('- Descripción: ${state.plan.description}');
            print('- Ubicación: ${state.plan.location}');
            print('- Imagen URL: ${state.plan.imageUrl}');
          }

          // Actualizar controladores con datos del estado
          _titleController.text = state.plan.title;
          _descriptionController.text = state.plan.description;
          _locationController.text = state.plan.location;

          // Establecer imagen seleccionada
          _selectedImageUrl = state.plan.imageUrl;

          // Si no hay imagen o es una imagen de tipo data:image, usar una predeterminada
          if (_selectedImageUrl == null ||
              _selectedImageUrl!.isEmpty ||
              _selectedImageUrl!.startsWith('data:image/')) {
            _selectRandomDefaultImage();
          }
        }

        _isInitialized = true;
      } catch (e) {
        if (kDebugMode) {
          print('Error inicializando EventDetailsStep: $e');
          print('Stack trace: ${StackTrace.current}');
        }
      }
    }
  }

  void _selectRandomDefaultImage() {
    // Evitar seleccionar una imagen aleatoria si ya hay una válida
    if (_selectedImageUrl != null &&
        _selectedImageUrl!.isNotEmpty &&
        !_selectedImageUrl!.startsWith('data:image/')) {
      return;
    }

    // Seleccionar una imagen aleatoria de la lista de fallback
    final imageIndex =
        DateTime.now().millisecondsSinceEpoch % _defaultImageUrls.length;
    _selectedImageUrl = _defaultImageUrls[imageIndex];

    if (kDebugMode) {
      print('Seleccionando imagen predeterminada: $_selectedImageUrl');
    }

    // Actualizar en el BLoC
    if (_selectedImageUrl != null && _selectedImageUrl!.isNotEmpty) {
      context.read<PlanBloc>().add(
            PlanEvent.updateField(field: 'imageUrl', value: _selectedImageUrl),
          );
    }
  }

  void _preloadImage(final String url) {
    if (url.startsWith('data:image/')) {
      if (kDebugMode) {
        print('Omitiendo precarga de imagen data:URL');
      }
      setState(() {
        _isImageLoading = false;
        _hasImageError = true; // Consideramos imágenes data:image como errores
      });
      return;
    }

    setState(() {
      _isImageLoading = true;
      _hasImageError = false;
    });

    NetworkImage(url).resolve(const ImageConfiguration()).addListener(
          ImageStreamListener(
            (final info, final synchronousCall) {
              if (mounted) {
                setState(() {
                  _isImageLoading = false;
                  _hasImageError = false;
                });
              }
            },
            onError: (final exception, final stackTrace) {
              if (kDebugMode) {
                print('Error cargando imagen: $exception');
                print('URL de imagen: $url');
              }
              if (mounted) {
                setState(() {
                  _isImageLoading = false;
                  _hasImageError = true;
                });

                // Seleccionar una imagen predeterminada en caso de error
                _selectRandomDefaultImage();
              }
            },
          ),
        );
  }

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<PlanBloc, PlanState>(
      builder: (final context, final state) {
        if (state is! PlanLoaded) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
            ),
          );
        }

        final plan = state.plan;

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.surface,
                Theme.of(context).colorScheme.surface,
              ],
            ),
          ),
          child: LayoutBuilder(
            builder: (final context, final constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 24),
                          // Selector de imagen mejorado
                          _buildImageSelector(plan),
                          const SizedBox(height: 24),
                          _buildInputField(
                            label: 'Título del plan',
                            hint: 'Ej: Partido de fútbol en el parque',
                            icon: Icons.title,
                            controller: _titleController,
                            onChanged: (final value) {
                              if (kDebugMode) {
                                print('Actualizando título: $value');
                              }
                              context.read<PlanBloc>().add(
                                    PlanEvent.updateField(
                                        field: 'title', value: value),
                                  );
                            },
                            maxLines: 1,
                          ),
                          const SizedBox(height: 16),
                          _buildInputField(
                            label: 'Descripción',
                            hint:
                                'Ej: Partido amistoso de fútbol 5vs5, todos los niveles son bienvenidos',
                            icon: Icons.description,
                            controller: _descriptionController,
                            onChanged: (final value) {
                              if (kDebugMode) {
                                print('Actualizando descripción: $value');
                              }
                              context.read<PlanBloc>().add(
                                    PlanEvent.updateField(
                                        field: 'description', value: value),
                                  );
                            },
                            maxLines: 3,
                          ),
                          const SizedBox(height: 16),
                          _buildInputField(
                            label: 'Ubicación específica',
                            hint:
                                'Ej: Parque del Retiro, junto a la fuente principal',
                            icon: Icons.location_on,
                            controller: _locationController,
                            onChanged: (final value) {
                              if (kDebugMode) {
                                print('Actualizando ubicación: $value');
                              }
                              context.read<PlanBloc>().add(
                                    PlanEvent.updateField(
                                        field: 'location', value: value),
                                  );
                            },
                            maxLines: 1,
                          ),
                          const Spacer(),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _isFormValid()
                                  ? () {
                                      if (kDebugMode) {
                                        print(
                                            'Avanzando al siguiente paso con:');
                                        print(
                                            '- Título: ${_titleController.text}');
                                        print(
                                            '- Descripción: ${_descriptionController.text}');
                                        print(
                                            '- Ubicación: ${_locationController.text}');
                                        print('- Imagen: $_selectedImageUrl');
                                      }
                                      widget.pageController.nextPage(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        curve: Curves.easeInOut,
                                      );
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.yellow,
                                foregroundColor: Colors.black,
                                disabledBackgroundColor: Colors.grey[800],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Continuar',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  // Verifica si el formulario es válido para habilitar el botón de continuar
  bool _isFormValid() {
    return _titleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _locationController.text.isNotEmpty &&
        _selectedImageUrl != null &&
        _selectedImageUrl!.isNotEmpty;
  }

  // Widget para selección de imagen mejorado
  Widget _buildImageSelector(final PlanEntity plan) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Imagen para tu plan',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white.withAlpha((0.9 * 255).round()),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showImagePicker(context, plan),
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha((0.1 * 255).round()),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _selectedImageUrl != null
                    ? Colors.yellow
                    : Colors.transparent,
                width: 2,
              ),
            ),
            child: _isImageLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
                    ),
                  )
                : _selectedImageUrl != null &&
                        _selectedImageUrl!.isNotEmpty &&
                        !_hasImageError &&
                        !_selectedImageUrl!.startsWith('data:image/')
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          _selectedImageUrl!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder:
                              (final context, final error, final stackTrace) {
                            if (kDebugMode) {
                              print(
                                  'Error al cargar imagen en selector: $error');
                            }
                            return _buildImagePlaceholder(true);
                          },
                        ),
                      )
                    : _buildImagePlaceholder(_hasImageError ||
                        (_selectedImageUrl?.startsWith('data:image/') ??
                            false)),
          ),
        ),
      ],
    );
  }

  Widget _buildImagePlaceholder(final bool hasError) {
    // Si la URL de la imagen es de tipo data:image, considerarlo como error
    bool isDataUrl = _selectedImageUrl?.startsWith('data:image/') ?? false;
    String message = isDataUrl
        ? 'No se permiten imágenes en formato base64'
        : hasError
            ? 'Error al cargar imagen'
            : 'Agregar una imagen';

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isDataUrl
                ? Icons.warning_amber_rounded
                : hasError
                    ? Icons.broken_image
                    : Icons.add_photo_alternate,
            size: 48,
            color: isDataUrl || hasError
                ? Colors.amber.withAlpha((0.7 * 255).round())
                : Colors.white.withAlpha((0.5 * 255).round()),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(
              color: isDataUrl || hasError
                  ? Colors.amber.withAlpha((0.7 * 255).round())
                  : Colors.white.withAlpha((0.7 * 255).round()),
            ),
          ),
          if (isDataUrl || hasError)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ElevatedButton(
                onPressed: _selectRandomDefaultImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                  textStyle: const TextStyle(fontSize: 12),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                child: const Text('Usar imagen predeterminada'),
              ),
            ),
        ],
      ),
    );
  }

  void _showImagePicker(final BuildContext context, final PlanEntity plan) {
    // Determinar categoría para mostrar imágenes relevantes
    final category =
        plan.selectedThemes.isNotEmpty ? plan.selectedThemes.first : '';

    // Obtener imágenes según la categoría
    List<String> imageOptions = _getImagesByCategory(category);

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1B2E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (final context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selecciona una imagen para tu plan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withAlpha((0.9 * 255).round()),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: imageOptions.length,
                  itemBuilder: (final context, final index) {
                    final imageUrl = imageOptions[index];

                    // Verificar si es una imagen de tipo data:image
                    bool isDataUrl = imageUrl.startsWith('data:image/');
                    if (isDataUrl) {
                      if (kDebugMode) {
                        print(
                            'Omitiendo imagen data:URL en selector: $imageUrl');
                      }
                      return Container(); // Skip this image
                    }

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedImageUrl = imageUrl;
                          _hasImageError = false;
                          _isImageLoading = true;
                        });

                        // Precargar imagen para verificar si es válida
                        _preloadImage(imageUrl);

                        // Actualizar el modelo de datos
                        context.read<PlanBloc>().add(
                              PlanEvent.updateField(
                                  field: 'imageUrl', value: imageUrl),
                            );
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _selectedImageUrl == imageUrl
                                ? Colors.yellow
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (final context, final error, final stackTrace) {
                              if (kDebugMode) {
                                print('Error al cargar miniatura: $error');
                              }
                              return Container(
                                color: Colors.grey[800],
                                child: Icon(
                                  Icons.error,
                                  color: Colors.white
                                      .withAlpha((0.7 * 255).round()),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Método mejorado para obtener imágenes según la categoría seleccionada
  List<String> _getImagesByCategory(final String category) {
    // Imágenes por categoría con URLs válidas
    Map<String, List<String>> categoryImages = {
      'Recitales': [
        'https://via.placeholder.com/400x200/e74c3c/ffffff?text=Recital+1',
        'https://via.placeholder.com/400x200/e74c3c/ffffff?text=Recital+2',
        'https://images.unsplash.com/photo-1501281668745-f7f57925c3b4?w=500&auto=format',
        'https://images.unsplash.com/photo-1540039155733-5bb30b53aa14?w=500&auto=format',
      ],
      'Deportes': [
        'https://via.placeholder.com/400x200/2ecc71/ffffff?text=Deporte+1',
        'https://via.placeholder.com/400x200/2ecc71/ffffff?text=Deporte+2',
        'https://images.unsplash.com/photo-1556009609-0b1e5d4f1f6e?w=500&auto=format',
        'https://images.unsplash.com/photo-1579952363873-27f3bade9f55?w=500&auto=format',
      ],
      'Teatro': [
        'https://via.placeholder.com/400x200/9b59b6/ffffff?text=Teatro+1',
        'https://via.placeholder.com/400x200/9b59b6/ffffff?text=Teatro+2',
        'https://images.unsplash.com/photo-1503095396549-807759245b35?w=500&auto=format',
        'https://images.unsplash.com/photo-1576736499083-4e8ec5dfe1c6?w=500&auto=format',
      ],
      'Cine': [
        'https://via.placeholder.com/400x200/34495e/ffffff?text=Cine+1',
        'https://via.placeholder.com/400x200/34495e/ffffff?text=Cine+2',
        'https://images.unsplash.com/photo-1517604931442-7e0c8ed2963c?w=500&auto=format',
        'https://images.unsplash.com/photo-1485846234645-a62644f84728?w=500&auto=format',
      ],
      'Festivales': [
        'https://via.placeholder.com/400x200/f39c12/ffffff?text=Festival+1',
        'https://via.placeholder.com/400x200/f39c12/ffffff?text=Festival+2',
        'https://images.unsplash.com/photo-1506157786151-b8491531f063?w=500&auto=format',
        'https://images.unsplash.com/photo-1570872626485-d8ffea69f463?w=500&auto=format',
      ],
    };

    if (kDebugMode) {
      print('Solicitando imágenes para la categoría: $category');
    }

    return categoryImages[category] ?? _defaultImageUrls;
  }

  Widget _buildInputField({
    required final String label,
    required final String hint,
    required final IconData icon,
    required final TextEditingController controller,
    required final Function(String) onChanged,
    required final int maxLines,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white.withAlpha((0.9 * 255).round()),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withAlpha((0.1 * 255).round()),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: controller.text.isNotEmpty
                  ? Colors.yellow
                  : Colors.transparent,
              width: 2,
            ),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            style: TextStyle(
              color: Colors.white.withAlpha((0.9 * 255).round()),
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.white.withAlpha((0.5 * 255).round()),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
              prefixIcon: Icon(
                icon,
                color: Colors.white.withAlpha((0.7 * 255).round()),
              ),
            ),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}
