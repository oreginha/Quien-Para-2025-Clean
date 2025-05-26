// lib/presentation/screens/profile/edit_profile_screen_responsive.dart
// ignore_for_file: always_specify_types

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:quien_para/core/theme/app_colors.dart';
import 'package:quien_para/core/theme/app_typography.dart';
import 'package:quien_para/core/theme/theme_constants.dart';
import 'package:quien_para/core/theme/provider/theme_provider.dart';
import 'package:quien_para/presentation/widgets/responsive/new_responsive_scaffold.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';

class EditProfileScreenResponsive extends StatefulWidget {
  const EditProfileScreenResponsive({super.key});

  @override
  State<EditProfileScreenResponsive> createState() =>
      _EditProfileScreenResponsiveState();
}

class _EditProfileScreenResponsiveState
    extends State<EditProfileScreenResponsive> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  List<String> selectedInterests = <String>[];
  File? profileImage;
  String? currentPhotoUrl;
  bool isLoading = true;
  bool isSaving = false;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final List<String> availableInterests = <String>[
    'Deportes',
    'Música',
    'Arte',
    'Tecnología',
    'Viajes',
    'Gastronomía',
    'Cine',
    'Literatura',
    'Fotografía',
    'Naturaleza',
    'Fitness',
    'Gaming',
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      setState(() => isLoading = true);

      final String? userId = _auth.currentUser?.uid;
      if (userId == null) {
        throw Exception('No user authenticated');
      }

      final DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await _firestore.collection('users').doc(userId).get();
      if (!docSnapshot.exists) {
        throw Exception('User profile not found');
      }

      final Map<String, dynamic> userData = docSnapshot.data()!;

      _nameController.text = userData['name'] as String? ?? '';
      _bioController.text = userData['bio'] as String? ?? '';
      _locationController.text = userData['location'] as String? ?? '';

      if (userData['interests'] != null) {
        selectedInterests = List<String>.from(userData['interests'] as List);
      }

      if (userData['photoUrls'] != null &&
          (userData['photoUrls'] as List).isNotEmpty) {
        currentPhotoUrl = (userData['photoUrls'] as List).first.toString();
      }

      setState(() => isLoading = false);
    } catch (e) {
      if (kDebugMode) {
        print('Error loading user data: $e');
      }
      setState(() => isLoading = false);
      _showErrorSnackBar('Error al cargar los datos del perfil');
    }
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1440,
        maxHeight: 1440,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          profileImage = File(image.path);
        });
      }
    } catch (e) {
      _showErrorSnackBar('Error al seleccionar la imagen');
    }
  }

  Future<String?> _uploadProfileImage() async {
    if (profileImage == null) return currentPhotoUrl;

    try {
      final String? userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('No user authenticated');

      final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final Reference ref = _storage
          .ref()
          .child('user_photos')
          .child(userId)
          .child(fileName);

      final SettableMetadata metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: <String, String>{'userId': userId},
      );

      await ref.putFile(profileImage!, metadata);
      return await ref.getDownloadURL();
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading image: $e');
      }
      throw Exception('Error al subir la imagen');
    }
  }

  Future<void> _saveChanges() async {
    // Validar campos obligatorios
    if (_nameController.text.trim().isEmpty) {
      _showErrorSnackBar('El nombre es obligatorio');
      return;
    }

    try {
      setState(() => isSaving = true);

      final String? userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('No user authenticated');

      // Subir nueva foto si se seleccionó una
      String? photoUrl;
      if (profileImage != null) {
        photoUrl = await _uploadProfileImage();
      }

      final Map<String, Object> userData = <String, Object>{
        'name': _nameController.text.trim(),
        'bio': _bioController.text.trim(),
        'location': _locationController.text.trim(),
        'interests': selectedInterests,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Solo actualizar photoUrls si se subió una nueva foto
      if (photoUrl != null) {
        userData['photoUrls'] = <String>[photoUrl];
      }

      await _firestore.collection('users').doc(userId).update(userData);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Perfil actualizado exitosamente'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error saving changes: $e');
      }
      _showErrorSnackBar('Error al guardar los cambios');
    } finally {
      if (mounted) {
        setState(() => isSaving = false);
      }
    }
  }

  void _showErrorSnackBar(final String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.accentRed,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(final BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    // Definir el AppBar que se usará tanto en móvil como en web (aunque en web será ocultado)
    final appBar = AppBar(
      backgroundColor: AppColors.getBackground(isDarkMode),
      elevation: 0,
      title: Text('Editar Perfil', style: AppTypography.heading2(isDarkMode)),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: AppColors.getTextPrimary(isDarkMode),
        ),
        onPressed: () => Navigator.pop(context),
      ),
    );

    // Si todavía está cargando, mostrar un indicador de carga
    if (isLoading) {
      return NewResponsiveScaffold(
        screenName: 'edit_profile',
        appBar: appBar,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.brandYellow),
        ),
        currentIndex: 3, // Perfil está en índice 3
        webTitle: 'Editar Perfil',
      );
    }

    // Contenido principal
    final content = Container(
      decoration: BoxDecoration(
        gradient: Theme.of(context).extension<AppTheme>()?.backgroundGradient,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.darkBackground.withAlpha(
                            (0.25 * 255).round(),
                          ),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 65,
                        backgroundColor: AppColors.getCardBackground(
                          isDarkMode,
                        ),
                        backgroundImage: profileImage != null
                            ? FileImage(profileImage!)
                            : (currentPhotoUrl != null
                                  ? NetworkImage(currentPhotoUrl!)
                                        as ImageProvider
                                  : null),
                        child: (profileImage == null && currentPhotoUrl == null)
                            ? Icon(
                                Icons.person,
                                size: 65,
                                color: AppColors.brandYellow,
                              )
                            : null,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.darkBackground.withAlpha(
                              (0.25 * 255).round(),
                            ),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        backgroundColor: AppColors.darkBorder,
                        radius: 20,
                        child: IconButton(
                          icon: Icon(
                            Icons.camera_alt,
                            color: AppColors.lightTextPrimary,
                          ),
                          onPressed: _pickImage,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            _buildTextField(
              controller: _nameController,
              label: 'Nombre',
              hint: 'Tu nombre completo',
              icon: Icons.person,
              required: true,
            ),
            const SizedBox(height: AppSpacing.xl),
            _buildTextField(
              controller: _bioController,
              label: 'Bio',
              hint: 'Cuéntanos sobre ti',
              icon: Icons.description,
              maxLines: 3,
            ),
            const SizedBox(height: AppSpacing.xl),
            _buildTextField(
              controller: _locationController,
              label: 'Ubicación',
              hint: 'Tu ciudad',
              icon: Icons.location_on,
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Icon(Icons.interests, color: AppColors.darkBorder, size: 20),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  'Intereses',
                  style: TextStyle(
                    fontFamily: AppTypography.primaryFont,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBorder,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: AppColors.lightCardBackground,
                borderRadius: BorderRadius.circular(AppRadius.l),
                border: Border.all(color: AppColors.darkBorder, width: 1),
              ),
              child: Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: availableInterests.map((final String interest) {
                  final bool isSelected = selectedInterests.contains(interest);
                  return FilterChip(
                    selected: isSelected,
                    label: Text(interest),
                    onSelected: (final bool selected) {
                      setState(() {
                        if (selected) {
                          selectedInterests.add(interest);
                        } else {
                          selectedInterests.remove(interest);
                        }
                      });
                    },
                    selectedColor: AppColors.lightTextPrimary,
                    checkmarkColor: AppColors.lightTextPrimary,
                    backgroundColor: AppColors.getSecondaryBackground(
                      isDarkMode,
                    ).withAlpha((0.7 * 255).round()),
                    labelStyle: TextStyle(
                      color: isSelected
                          ? AppColors.lightTextPrimary
                          : AppColors.lightTextPrimary,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs,
                      vertical: AppSpacing.xs,
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.darkBorder,
                  foregroundColor: AppColors.lightTextPrimary,
                  minimumSize: const Size(200, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.l),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                    vertical: AppSpacing.xl,
                  ),
                ),
                onPressed: isSaving ? null : _saveChanges,
                child: isSaving
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.black,
                          ),
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.save),
                          const SizedBox(width: AppSpacing.xl),
                          Text(
                            'Guardar Cambios',
                            style: AppTypography.heading1(false),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );

    // Usar NewResponsiveScaffold para tener un diseño consistente en web y móvil
    return NewResponsiveScaffold(
      screenName: 'edit_profile',
      appBar: appBar,
      body: content,
      currentIndex: 3, // Perfil está en índice 3
      webTitle: 'Editar Perfil',
    );
  }

  Widget _buildTextField({
    required final TextEditingController controller,
    required final String label,
    required final String hint,
    final IconData? icon,
    final int maxLines = 1,
    final bool required = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18, color: AppColors.darkBorder),
              const SizedBox(width: AppSpacing.xs),
            ],
            Text(
              label,
              style: TextStyle(
                fontFamily: AppTypography.primaryFont,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (required) ...[
              const SizedBox(width: AppSpacing.xs),
              Text(
                '*',
                style: TextStyle(
                  fontFamily: AppTypography.primaryFont,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkBorder,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.l),
            boxShadow: [
              BoxShadow(
                color: AppColors.darkBackground.withAlpha((0.1 * 255).round()),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            style: AppTypography.heading1(false),
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: icon != null
                  ? Icon(icon, color: AppColors.darkBorder)
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: AppColors.darkBorder, width: 2.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: AppColors.darkBorder, width: 2.0),
              ),
              filled: true,
              fillColor: Colors.white.withValues(
                alpha: 230,
                red: 255,
                green: 255,
                blue: 255,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}
