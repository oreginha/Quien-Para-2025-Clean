// lib/presentation/widgets/image_preview/image_preview_widget.dart
// ignore_for_file: always_specify_types, unused_field

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quien_para/core/theme/app_colors.dart';
import 'package:quien_para/presentation/routes/app_router.dart';

import '../../bloc/image_preview/image_preview_bloc.dart';

class ImagePreviewWidget extends StatefulWidget {
  final File imageFile;
  final void Function(File) onImageEdited;
  final bool showEditControls;

  const ImagePreviewWidget({
    super.key,
    required this.imageFile,
    required this.onImageEdited,
    this.showEditControls = true,
  });

  @override
  State<ImagePreviewWidget> createState() => _ImagePreviewWidgetState();
}

class _ImagePreviewWidgetState extends State<ImagePreviewWidget> {
  final bool _isLoading = false;
  final String _currentFilter = '';
  late final ImagePreviewBloc _imagePreviewBloc;

  @override
  void initState() {
    super.initState();
    _imagePreviewBloc = ImagePreviewBloc();
    _imagePreviewBloc.add(ImagePreviewEvent.initialize(widget.imageFile));
  }

  void _rotateImage() {
    _imagePreviewBloc.add(const ImagePreviewEvent.rotateImage());
  }

  void _cropImage() {
    _imagePreviewBloc.add(const ImagePreviewEvent.cropImage());
  }

  void _applyFilter(String filterName) {
    _imagePreviewBloc.add(ImagePreviewEvent.applyFilter(filterName));
  }

  void _adjustImage(double brightness, double contrast) {
    _imagePreviewBloc.add(
      ImagePreviewEvent.adjustImage(brightness: brightness, contrast: contrast),
    );
  }

  void _saveChanges() {
    final state = _imagePreviewBloc.state;
    if (state.hasChanges) {
      widget.onImageEdited(state.currentImage);
    }
    context.closeScreen();
  }

  static _buildEditButton({
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
                  color: isActive ? AppColors.lightTextPrimary : Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static _buildSliderRow({
    required IconData icon,
    required String label,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
    required ValueChanged<double> onChangeEnd,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 24),
          const SizedBox(width: 8),
          Expanded(
            child: Slider(
              value: value,
              min: min,
              max: max,
              onChanged: onChanged,
              onChangeEnd: onChangeEnd,
              activeColor: AppColors.lightTextPrimary,
              inactiveColor: Colors.white70,
              label: label,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _imagePreviewBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery to make el widget más responsivo
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenHeight < 700;

    return BlocProvider(
      create: (context) => _imagePreviewBloc,
      child: BlocBuilder<ImagePreviewBloc, ImagePreviewState>(
        builder: (context, state) {
          return LayoutBuilder(
            builder: (context, constraints) {
              // Calcular máximos para asegurar que todo quepa
              final double maxDialogHeight = screenHeight * 0.85;
              final double maxPreviewHeight = isSmallScreen
                  ? maxDialogHeight * 0.35
                  : maxDialogHeight * 0.45;
              final double maxControlsHeight = widget.showEditControls
                  ? (isSmallScreen
                      ? maxDialogHeight * 0.45
                      : maxDialogHeight * 0.35)
                  : 0;

              return Container(
                constraints: BoxConstraints(
                  maxHeight: maxDialogHeight,
                  maxWidth: screenWidth * 0.9,
                ),
                decoration: BoxDecoration(
                  color: AppColors.lightCardBackground,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      // Header with title
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Editar imagen',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                              onPressed: () => context.closeScreen(),
                            ),
                          ],
                        ),
                      ),

                      // Image preview area
                      SizedBox(
                        height: maxPreviewHeight,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  if (widget.showEditControls) {
                                    _cropImage();
                                  }
                                },
                                child: Container(
                                  constraints: BoxConstraints(
                                    maxHeight: maxPreviewHeight - 32, // padding
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.white24),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Transform.rotate(
                                      angle: state.rotation * 3.14159 / 180,
                                      child: Image.file(
                                        state.currentImage,
                                        fit: BoxFit.contain,
                                        height: maxPreviewHeight - 32,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            if (_isLoading)
                              Container(
                                color: Colors.black54,
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),

                      if (widget.showEditControls) ...[
                        // Control section with limited height and scrollable content if needed
                        Container(
                          constraints: BoxConstraints(
                            maxHeight: maxControlsHeight,
                          ),
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Edit controls
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        _buildEditButton(
                                          icon: Icons.rotate_right,
                                          label: 'Rotar',
                                          onPressed: _rotateImage,
                                        ),
                                        const SizedBox(width: 16),
                                        _buildEditButton(
                                          icon: Icons.crop,
                                          label: 'Recortar',
                                          onPressed: _cropImage,
                                        ),
                                        const SizedBox(width: 16),
                                        _buildEditButton(
                                          icon: Icons.filter_b_and_w,
                                          label: 'B/N',
                                          isActive:
                                              _currentFilter == 'grayscale',
                                          onPressed: () =>
                                              _applyFilter('grayscale'),
                                        ),
                                        const SizedBox(width: 16),
                                        _buildEditButton(
                                          icon: Icons.filter_vintage,
                                          label: 'Sepia',
                                          isActive: _currentFilter == 'sepia',
                                          onPressed: () =>
                                              _applyFilter('sepia'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 8),

                                // Adjustment sliders
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      const Padding(
                                        padding: EdgeInsets.only(bottom: 4.0),
                                        child: Text(
                                          'Ajustes',
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      _buildSliderRow(
                                        icon: Icons.brightness_6,
                                        label: 'Brillo',
                                        value: state.brightness,
                                        min: -1.0,
                                        max: 1.0,
                                        onChanged: (value) {
                                          _adjustImage(value, state.contrast);
                                        },
                                        onChangeEnd: (value) {},
                                      ),
                                      _buildSliderRow(
                                        icon: Icons.contrast,
                                        label: 'Contraste',
                                        value: state.contrast,
                                        min: 0.5,
                                        max: 2.0,
                                        onChanged: (value) {
                                          _adjustImage(state.brightness, value);
                                        },
                                        onChangeEnd: (value) {},
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Action buttons - always visible at bottom
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.white70,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                  ),
                                  onPressed: () => context.closeScreen(),
                                  child: const Text('Cancelar'),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.lightTextPrimary,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                  ),
                                  onPressed: _saveChanges,
                                  child: const Text('Guardar'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
