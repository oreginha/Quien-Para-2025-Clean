// lib/presentation/widgets/image_preview/image_preview_widget_bloc.dart
// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quien_para/core/theme/app_colors.dart';

import '../../bloc/image_preview/image_preview_bloc.dart';

/// Versión refactorizada del ImagePreviewWidget que utiliza BLoC/Cubit
/// para manejar el estado en lugar de setState()
class ImagePreviewWidgetBloc extends StatelessWidget {
  final File imageFile;
  final void Function(File) onImageEdited;
  final bool showEditControls;

  const ImagePreviewWidgetBloc({
    super.key,
    required this.imageFile,
    required this.onImageEdited,
    this.showEditControls = true,
  });

  @override
  Widget build(BuildContext context) {
    // Creamos una instancia del bloc e inicializamos
    // Usamos el método de instanciación sin tipo específico
    // para evitar problemas de inferencia
    return BlocProvider(
      create: (context) => ImagePreviewBloc(),
      child: _ImagePreviewContentWrapper(
        imageFile: imageFile,
        onImageEdited: onImageEdited,
        showEditControls: showEditControls,
      ),
    );
  }
}

/// Widget auxiliar para inicializar el bloc después de la creación
class _ImagePreviewContentWrapper extends StatefulWidget {
  final File imageFile;
  final void Function(File) onImageEdited;
  final bool showEditControls;

  const _ImagePreviewContentWrapper({
    required this.imageFile,
    required this.onImageEdited,
    required this.showEditControls,
  });

  @override
  State<_ImagePreviewContentWrapper> createState() =>
      _ImagePreviewContentWrapperState();
}

class _ImagePreviewContentWrapperState
    extends State<_ImagePreviewContentWrapper> {
  @override
  void initState() {
    super.initState();
    // Inicializamos el bloc con el evento initialize
    final bloc = BlocProvider.of<ImagePreviewBloc>(context);
    bloc.add(ImagePreviewEvent.initialize(widget.imageFile));
  }

  @override
  Widget build(BuildContext context) {
    return _ImagePreviewContent(
      onImageEdited: widget.onImageEdited,
      showEditControls: widget.showEditControls,
    );
  }
}

class _ImagePreviewContent extends StatelessWidget {
  final void Function(File) onImageEdited;
  final bool showEditControls;

  const _ImagePreviewContent({
    required this.onImageEdited,
    required this.showEditControls,
  });

  @override
  Widget build(BuildContext context) {
    // En esta clase no tenemos showEditControls como una propiedad de widget
    // así que definimos una constante para determinar si mostrar los controles
    const showEditControls = true;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title:
            const Text('Editar imagen', style: TextStyle(color: Colors.white)),
        actions: [
          if (showEditControls)
            IconButton(
              icon: const Icon(Icons.check, color: Colors.white),
              onPressed: () {
                // Obtenemos el bloc directamente al usarlo para acceder al estado actual
                final imagePreviewBloc = context.read<ImagePreviewBloc>();
                Navigator.of(context).pop(imagePreviewBloc.state.currentImage);
              },
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            // Uso de BlocBuilder directo en lugar de BlocLoadingBuilder
            // para mantener compatibilidad durante la migración a Clean Architecture
            child: BlocBuilder<ImagePreviewBloc, ImagePreviewState>(
              builder: (context, state) {
                // Manejo de estados de carga
                if (state.isLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                        color: AppColors.lightTextPrimary),
                  );
                }

                // Manejo de estados de error
                if (state.error != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            color: Colors.red, size: 48),
                        const SizedBox(height: 16),
                        Text(
                          state.error ?? 'Error al procesar la imagen',
                          style: const TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Volver'),
                        ),
                      ],
                    ),
                  );
                }

                // Estado con datos cargados exitosamente
                // Verifica que la imagen no sea nula antes de mostrarla
                if (state.currentImage.path.isNotEmpty) {
                  return _buildImagePreview(state.currentImage);
                }

                // Estado default para inicialización o estados inesperados
                return const Center(child: Text('Cargando vista previa...'));
              },
            ),
          ),
          if (showEditControls) _buildEditControls(context),
        ],
      ),
    );
  }

  Widget _buildImagePreview(File imageFile) {
    return InteractiveViewer(
      minScale: 0.5,
      maxScale: 3.0,
      child: Center(
        child: Image.file(
          imageFile,
          fit: BoxFit.contain,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }

  Widget _buildEditControls(BuildContext context) {
    // Eliminar variable cubit no utilizada

    return Container(
      color: Colors.black87,
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildEditButton(
                icon: Icons.rotate_right,
                label: 'Rotar',
                onPressed: () => context
                    .read<ImagePreviewBloc>()
                    .add(const ImagePreviewEvent.rotateImage()),
              ),
              _buildEditButton(
                icon: Icons.crop,
                label: 'Recortar',
                onPressed: () => context
                    .read<ImagePreviewBloc>()
                    .add(const ImagePreviewEvent.cropImage()),
              ),
              _buildEditButton(
                icon: Icons.tune,
                label: 'Ajustar',
                onPressed: () => _showAdjustmentDialog(context),
              ),
              _buildEditButton(
                icon: Icons.filter,
                label: 'Filtros',
                onPressed: () => _showFiltersDialog(context),
              ),
              _buildEditButton(
                icon: Icons.refresh,
                label: 'Reiniciar',
                onPressed: () => context
                    .read<ImagePreviewBloc>()
                    .add(const ImagePreviewEvent.resetFilter()),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEditButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    bool isActive = false,
  }) {
    return Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: isActive ? AppColors.lightTextPrimary : Colors.white,
                  size: 24,
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    color:
                        isActive ? AppColors.lightTextPrimary : Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

// Nota: Métodos no utilizados _buildImagePreview, _buildEditControls y _buildEditButton fueron eliminados
// como parte de la optimización de código durante la migración a Clean Architecture

void _showFiltersDialog(BuildContext context) {
// Implementación de diálogo para seleccionar filtros
  final bloc = context.read<ImagePreviewBloc>();
  final availableFilters = [
    'Original',
    'B&W',
    'Sepia',
    'Vintage',
    'Cold',
    'Warm',
  ];

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.black87,
    builder: (context) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Selecciona un filtro',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: availableFilters.length,
            itemBuilder: (context, index) {
              final filterName = availableFilters[index];
              final isSelected = bloc.state.currentFilter == filterName;

              return ListTile(
                title: Text(
                  filterName,
                  style: TextStyle(
                    color:
                        isSelected ? AppColors.lightTextPrimary : Colors.white,
                  ),
                ),
                leading: index == 0
                    ? const Icon(Icons.refresh, color: Colors.white)
                    : const Icon(Icons.filter, color: Colors.white),
                onTap: () {
                  Navigator.pop(context);
                  if (index == 0) {
// Usar el evento resetFilter en lugar del método resetImage
                    bloc.add(const ImagePreviewEvent.resetFilter());
                  } else {
// Usar el evento applyFilter en lugar del método applyFilter
                    bloc.add(ImagePreviewEvent.applyFilter(filterName));
                  }
                },
              );
            },
          ),
        ),
      ],
    ),
  );
}

void _showAdjustmentDialog(BuildContext context) {
// Implementación de diálogo para ajustes de brillo y contraste
  final bloc = context.read<ImagePreviewBloc>();
  double brightness = bloc.state.brightness;
  double contrast = bloc.state.contrast;

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.black87,
    isScrollControlled: true,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Ajustes de imagen',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Icon(Icons.brightness_6, color: Colors.white),
                const SizedBox(width: 8),
                const Text('Brillo', style: TextStyle(color: Colors.white)),
                Expanded(
                  child: Slider(
                    value: brightness,
                    min: -1.0,
                    max: 1.0,
                    onChanged: (value) {
                      setState(() {
                        brightness = value;
                      });
// Usar el evento adjustImage en lugar del método adjustImage
                      bloc.add(ImagePreviewEvent.adjustImage(
                          brightness: brightness, contrast: contrast));
                    },
                    activeColor: AppColors.lightTextPrimary,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.contrast, color: Colors.white),
                const SizedBox(width: 8),
                const Text('Contraste', style: TextStyle(color: Colors.white)),
                Expanded(
                  child: Slider(
                    value: contrast,
                    min: 0.5,
                    max: 1.5,
                    onChanged: (value) {
                      setState(() {
                        contrast = value;
                      });
// Usar el evento adjustImage en lugar del método adjustImage
                      bloc.add(ImagePreviewEvent.adjustImage(
                          brightness: brightness, contrast: contrast));
                    },
                    activeColor: AppColors.lightTextPrimary,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      brightness = 0.0;
                      contrast = 1.0;
                    });
// Usar el evento adjustImage en lugar del método adjustImage
                    bloc.add(ImagePreviewEvent.adjustImage(
                        brightness: brightness, contrast: contrast));
                  },
                  child: const Text('Restablecer',
                      style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lightTextPrimary,
                  ),
                  child: const Text('Aplicar'),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
