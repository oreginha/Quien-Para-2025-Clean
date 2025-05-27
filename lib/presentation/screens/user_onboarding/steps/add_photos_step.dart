// lib/presentation/screens/user_onboarding/steps/add_photos_step.dart
// ignore_for_file: always_specify_types, prefer_final_parameters, use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quien_para/core/theme/app_colors.dart';

import 'package:quien_para/core/theme/app_typography.dart';
import 'package:quien_para/core/theme/theme_constants.dart';
import 'package:quien_para/core/theme/theme_utils.dart';
import 'package:quien_para/presentation/widgets/common/buttons/app_buttons.dart';
import 'package:quien_para/presentation/widgets/utils/styled_input.dart';
import 'package:quien_para/presentation/widgets/image_preview/image_preview_widget.dart'
    as image_preview;
import 'package:quien_para/presentation/widgets/photo_slot.dart';
import 'package:quien_para/presentation/widgets/responsive_onboarding_container.dart';

import '../../../bloc/profile/user_profile_bloc.dart';

class AddPhotosStep extends StatefulWidget {
  final VoidCallback onNext;

  const AddPhotosStep({super.key, required this.onNext});

  @override
  State<AddPhotosStep> createState() => _AddPhotosStepState();
}

class _AddPhotosStepState extends State<AddPhotosStep> {
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  int _mainPhotoIndex = 0;
  bool _canContinue = false;
  String? _bioError;
  String? _photoError;
  final TextEditingController _bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final photos = context.read<UserProfileBloc>().state.photos;
    final bio = context.read<UserProfileBloc>().state.bio;
    _bioController.text = bio;
    _updateContinueButton(photos);
  }

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }

  void _updateContinueButton(List<File> photos) {
    final String bio = _bioController.text;

    // Validate photos
    String? photoError;
    if (photos.isEmpty) {
      photoError = 'Por favor agrega al menos una foto';
    }

    // Validate bio
    String? bioError;
    if (bio.isEmpty) {
      bioError = 'Cuéntanos un poco sobre ti';
    } else if (bio.length < 10) {
      bioError = 'Tu descripción debe tener al menos 10 caracteres';
    } else if (bio.length > 500) {
      bioError = 'Tu descripción debe tener máximo 500 caracteres';
    }

    setState(() {
      _photoError = photoError;
      _bioError = bioError;
      _canContinue = photoError == null && bioError == null;
    });

    // Ensure the bio is properly updated in the bloc
    if (bio.isNotEmpty) {
      context.read<UserProfileBloc>().add(UpdateBioEvent(bio));
    }
  }

  Future<void> _pickImage(int index) async {
    if (_isLoading) return;

    setState(() => _isLoading = true);
    final userProfileBloc = context.read<UserProfileBloc>();

    try {
      final source = await showDialog<ImageSource>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: ThemeUtils.brandYellow,
          title: const Text(
            'Seleccionar imagen',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.white70),
                title: const Text(
                  'Galería',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.white70),
                title: const Text(
                  'Cámara',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
            ],
          ),
        ),
      );

      if (source == null) {
        setState(() => _isLoading = false);
        return;
      }

      final XFile? image = await _picker
          .pickImage(
        source: source,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      )
          .catchError((error) {
        throw Exception('Error al capturar la imagen: $error');
      });

      if (image == null) {
        throw Exception('No se seleccionó ninguna imagen');
      }

      if (!mounted) return;

      final file = File(image.path);
      if (!await file.exists()) {
        throw Exception('El archivo de imagen no existe');
      }

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
          backgroundColor: Colors.transparent,
          child: image_preview.ImagePreviewWidget(
            imageFile: file,
            onImageEdited: (File editedFile) {
              final currentState = userProfileBloc.state;
              final updatedPhotos = List<File>.from(currentState.photos);

              if (index < updatedPhotos.length) {
                updatedPhotos[index] = editedFile;
              } else {
                updatedPhotos.add(editedFile);
                if (updatedPhotos.length == 1) {
                  _mainPhotoIndex = 0;
                }
              }
              userProfileBloc.add(UpdatePhotosEvent(updatedPhotos));
              _updateContinueButton(updatedPhotos);
            },
          ),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toString().replaceAll('Exception: ', ''),
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _deletePhoto(int index) {
    final userProfileBloc = context.read<UserProfileBloc>();
    final currentState = userProfileBloc.state;
    final updatedPhotos = List<File>.from(currentState.photos);

    updatedPhotos.removeAt(index);

    // Adjust main photo index if needed
    if (index == _mainPhotoIndex) {
      _mainPhotoIndex = updatedPhotos.isEmpty ? 0 : 0;
    } else if (index < _mainPhotoIndex) {
      _mainPhotoIndex--;
    }

    userProfileBloc.add(UpdatePhotosEvent(updatedPhotos));
    _updateContinueButton(updatedPhotos);
  }

  void _setMainPhoto(int index) {
    setState(() {
      _mainPhotoIndex = index;
    });
  }

  void _handlePhotoTap(int index) {
    final state = context.read<UserProfileBloc>().state;
    final hasPhoto = index < state.photos.length;

    if (hasPhoto) {
      // If the photo already exists, show options
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: ThemeUtils.brandYellow,
          title: const Text(
            'Opciones de foto',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (index != _mainPhotoIndex)
                ListTile(
                  leading: const Icon(
                    Icons.star,
                    color: Colors.yellow,
                    size: 16,
                  ),
                  title: const Text(
                    'Establecer como principal',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    _setMainPhoto(index);
                    Navigator.pop(context);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hoverColor: Colors.white.withAlpha((0.1 * 255).round()),
                ),
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.white70),
                title: const Text(
                  'Cambiar foto',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(index);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                hoverColor: Colors.white.withAlpha((0.1 * 255).round()),
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text(
                  'Eliminar foto',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  _deletePhoto(index);
                  Navigator.pop(context);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                hoverColor: Colors.white.withAlpha((0.1 * 255).round()),
              ),
            ],
          ),
        ),
      );
    } else {
      // If no photo, pick a new one
      _pickImage(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProfileBloc, UserProfileState>(
      builder: (context, state) {
        return ResponsiveOnboardingContainer(
          bottomActions: AppButton(
            onPressed: _canContinue ? widget.onNext : null,
            text: 'Continuar',
            disabled: !_canContinue,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  children: [
                    Text(
                      'Tus fotos',
                      style: AppTypography.heading2(
                        Theme.of(context).brightness == Brightness.dark,
                      ),
                    ),
                    const Spacer(),
                    if (state.photos.isNotEmpty)
                      Text(
                        '${state.photos.length}/6 fotos',
                        style: ThemeUtils.bodyMedium.copyWith(
                          color: ThemeUtils.brandYellow,
                        ),
                      ),
                  ],
                ),
              ),
              if (_photoError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 4),
                  child: Text(
                    _photoError!,
                    style: TextStyle(color: ThemeUtils.accentRed, fontSize: 14),
                  ),
                ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: 6,
                itemBuilder: (context, index) {
                  final hasPhoto = index < state.photos.length;
                  final isMainPhoto = index == _mainPhotoIndex;

                  return Stack(
                    children: [
                      PhotoSlot(
                        photo: hasPhoto ? state.photos[index] : null,
                        hasPhoto: hasPhoto,
                        onTap:
                            _isLoading ? () {} : () => _handlePhotoTap(index),
                        isMain: isMainPhoto,
                      ),
                      if (_isLoading)
                        Positioned.fill(
                          child: Container(
                            color: Colors.black45,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ),
                      if (isMainPhoto && hasPhoto)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  'Principal',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ThemeUtils.textPrimary.withAlpha((255 * 0.1).round()),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      color: ThemeUtils.brandYellow,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'La foto principal será la que los demás vean primero. Puedes elegir cuál es marcándola como principal.',
                        style: TextStyle(
                          color: AppColors.lightTextPrimary.withAlpha(
                            (255 * 0.9).round(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Cuéntanos sobre ti',
                style: AppTypography.heading2(
                  Theme.of(context).brightness == Brightness.dark,
                ),
              ),
              const SizedBox(height: 12),
              StyledTextArea(
                controller: _bioController,
                labelText: '',
                hintText: 'Describe tus intereses, hobbies, personalidad...',
                errorText: _bioError,
                maxLines: 5,
                maxLength: 500,
                onChanged: (value) {
                  // Update the continue button state
                  _updateContinueButton(state.photos);
                },
              ),
              if (_bioError == null)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: AppColors.brandYellow.withAlpha((255 * 0.1).round()),
                    borderRadius: BorderRadius.circular(AppRadius.button),
                    border: Border.all(
                      color: AppColors.brandYellow.withAlpha(
                        (255 * 0.3).round(),
                      ),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.tips_and_updates,
                        color: AppColors.brandYellow,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Un buen perfil aumenta tus posibilidades. Incluye tus intereses y lo que buscas en un plan.',
                          style: TextStyle(
                            color: AppColors.lightTextPrimary.withAlpha(
                              (255 * 0.8).round(),
                            ),
                            fontSize: 13,
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
    );
  }
}
