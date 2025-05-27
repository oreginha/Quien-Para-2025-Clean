// lib/presentation/screens/profile/edit_profile_screen.dart
// ignore_for_file: always_specify_types

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';
import 'package:quien_para/core/theme/app_colors.dart';
import 'package:quien_para/core/theme/app_typography.dart';
import 'package:quien_para/core/theme/theme_constants.dart';
import 'package:quien_para/core/theme/provider/theme_provider.dart';

import '../../../core/theme/app_theme.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
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
      final Reference ref =
          _storage.ref().child('user_photos').child(userId).child(fileName);

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

    if (isLoading) {
      return Scaffold(
        backgroundColor: AppColors.getBackground(isDarkMode),
        appBar: AppBar(
          backgroundColor: AppColors.getBackground(isDarkMode),
          elevation: 0,
          title: Text(
            'Editar Perfil',
            style: AppTypography.appBarTitle(isDarkMode),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: AppColors.getTextPrimary(isDarkMode),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: CircularProgressIndicator(color: AppColors.brandYellow),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.getBackground(isDarkMode),
      appBar: AppBar(
        backgroundColor: AppColors.getBackground(isDarkMode),
        elevation: 0,
        title: Text(
          'Editar Perfil',
          style: AppTypography.appBarTitle(isDarkMode),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.getTextPrimary(isDarkMode),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
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
                            color: AppColors.getShadowColor(isDarkMode),
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
                          child:
                              (profileImage == null && currentPhotoUrl == null)
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
                              color: AppColors.getShadowColor(isDarkMode),
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          backgroundColor: AppColors.brandYellow,
                          radius: 20,
                          child: IconButton(
                            icon: Icon(
                              Icons.camera_alt,
                              color: isDarkMode
                                  ? Colors.black
                                  : AppColors.lightTextPrimary,
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
                isDarkMode: isDarkMode,
              ),
              const SizedBox(height: AppSpacing.xl),
              _buildTextField(
                controller: _bioController,
                label: 'Bio',
                hint: 'Cuéntanos sobre ti',
                icon: Icons.description,
                maxLines: 3,
                isDarkMode: isDarkMode,
              ),
              const SizedBox(height: AppSpacing.xl),
              _buildTextField(
                controller: _locationController,
                label: 'Ubicación',
                hint: 'Tu ciudad',
                icon: Icons.location_on,
                isDarkMode: isDarkMode,
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Icon(
                    Icons.interests,
                    color: AppColors.getTextPrimary(isDarkMode),
                    size: 20,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text('Intereses', style: AppTypography.heading5(isDarkMode)),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              Container(
                padding: const EdgeInsets.all(AppSpacing.xl),
                decoration: BoxDecoration(
                  color: AppColors.getCardBackground(isDarkMode),
                  borderRadius: BorderRadius.circular(AppRadius.l),
                  border: Border.all(
                    color: AppColors.getBorder(isDarkMode),
                    width: 1,
                  ),
                ),
                child: Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: availableInterests.map((final String interest) {
                    final bool isSelected = selectedInterests.contains(
                      interest,
                    );
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
                      selectedColor: AppColors.brandYellow,
                      checkmarkColor: isDarkMode
                          ? Colors.black
                          : AppColors.lightTextPrimary,
                      backgroundColor: AppColors.getSecondaryBackground(
                        isDarkMode,
                      ),
                      labelStyle: TextStyle(
                        color: isSelected
                            ? (isDarkMode
                                ? Colors.black
                                : AppColors.lightTextPrimary)
                            : AppColors.getTextPrimary(isDarkMode),
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
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
                    backgroundColor: AppColors.brandYellow,
                    foregroundColor:
                        isDarkMode ? Colors.black : AppColors.lightTextPrimary,
                    minimumSize: const Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.button),
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
                            const SizedBox(width: AppSpacing.s),
                            Text(
                              'Guardar Cambios',
                              style: AppTypography.buttonMedium(isDarkMode),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required final TextEditingController controller,
    required final String label,
    required final String hint,
    final IconData? icon,
    final int maxLines = 1,
    final bool required = false,
    required final bool isDarkMode,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18, color: AppColors.getTextPrimary(isDarkMode)),
              const SizedBox(width: AppSpacing.xs),
            ],
            Text(label, style: AppTypography.heading6(isDarkMode)),
            if (required) ...[
              const SizedBox(width: AppSpacing.xs),
              Text(
                '*',
                style: AppTypography.heading6(
                  isDarkMode,
                ).copyWith(color: AppColors.accentRed),
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
                color: AppColors.getShadowColor(isDarkMode),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            style: AppTypography.bodyLarge(isDarkMode),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTypography.bodyLarge(
                isDarkMode,
              ).copyWith(color: AppColors.getTextSecondary(isDarkMode)),
              prefixIcon: icon != null
                  ? Icon(icon, color: AppColors.getTextSecondary(isDarkMode))
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.l),
                borderSide: BorderSide(
                  color: AppColors.getBorder(isDarkMode),
                  width: 1.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.l),
                borderSide: BorderSide(
                  color: AppColors.getBorder(isDarkMode),
                  width: 1.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.l),
                borderSide: BorderSide(
                  color: AppColors.brandYellow,
                  width: 2.0,
                ),
              ),
              filled: true,
              fillColor: AppColors.getCardBackground(isDarkMode),
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
