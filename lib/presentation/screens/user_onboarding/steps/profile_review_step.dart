//lib/presentation/screens/user_onboarding/steps/profile_review_step.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quien_para/core/theme/app_colors.dart';
import 'package:quien_para/core/theme/theme_constants.dart';
import 'package:quien_para/presentation/widgets/common/common_widgets.dart';
import '../../../../domain/validators/profile_validator.dart';
import '../../../bloc/profile/user_profile_bloc.dart';

class ProfileReviewStep extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback onViewProfile;

  const ProfileReviewStep({
    super.key,
    required this.onConfirm,
    required this.onViewProfile,
  });

  bool _isProfileComplete(UserProfileState state) {
    try {
      ProfileValidator.validate(
        name: state.name,
        age: state.age,
        gender: state.gender,
        location: state.location,
        interests: state.interests,
        photos: state.photos,
        bio: state.bio,
        orientation: state.orientation,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  String _getMissingFieldsMessage(UserProfileState state) {
    // ignore: always_specify_types
    final List<String> missingFields = [];

    if (state.name.isEmpty) {
      missingFields.add('Nombre');
    }

    if (state.age == null) {
      missingFields.add('Edad');
    }

    if (state.gender == null || state.gender!.isEmpty) {
      missingFields.add('Género');
    }

    if (state.location == null || state.location!.isEmpty) {
      missingFields.add('Ubicación');
    }

    if (state.interests.isEmpty) {
      missingFields.add('Intereses');
    }

    if (state.photos.isEmpty) {
      missingFields.add('Fotos');
    }

    if (state.bio.isEmpty || state.bio.length < 10) {
      missingFields.add('Descripción');
    }

    if (missingFields.isEmpty) {
      return '';
    }

    return 'Por favor completa los siguientes campos: ${missingFields.join(', ')}';
  }

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<UserProfileBloc, UserProfileState>(
      builder: (final BuildContext context, final UserProfileState state) {
        final bool isComplete = _isProfileComplete(state);
        final String missingFieldsMessage = _getMissingFieldsMessage(state);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha((0.9 * 255).round()),
                    borderRadius: BorderRadius.circular(AppRadius.button),
                    border: Border.all(
                        color: isComplete
                            ? AppColors.brandYellow
                                .withAlpha((0.3 * 255).round())
                            : AppColors.brandYellow
                                .withAlpha((0.3 * 255).round())),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black.withAlpha((0.05 * 255).round()),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _buildProfileItem(
                          'Nombre',
                          state.name,
                          Icons.person_outline,
                          state.name.isEmpty,
                        ),
                        _buildDivider(),
                        _buildProfileItem(
                          'Edad',
                          state.age?.toString() ?? '',
                          Icons.cake_outlined,
                          state.age == null,
                        ),
                        _buildDivider(),
                        _buildProfileItem(
                          'Género',
                          state.gender ?? '',
                          Icons.people_outline,
                          state.gender == null || state.gender!.isEmpty,
                        ),
                        _buildDivider(),
                        _buildProfileItem(
                          'Ubicación',
                          state.location ?? '',
                          Icons.location_on_outlined,
                          state.location == null || state.location!.isEmpty,
                        ),
                        _buildDivider(),
                        _buildInterestsSection(
                            state.interests, state.interests.isEmpty),
                        _buildDivider(),
                        _buildProfileItem(
                          'Fotos',
                          '${state.photos.length} fotos agregadas',
                          Icons.photo_library_outlined,
                          state.photos.isEmpty,
                        ),
                        _buildDivider(),
                        _buildProfileItem(
                          'Descripción',
                          state.bio.length > 30
                              ? '${state.bio.substring(0, 30)}...'
                              : state.bio,
                          Icons.description_outlined,
                          state.bio.isEmpty || state.bio.length < 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (!isComplete)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color:
                          AppColors.brandYellow.withAlpha((0.1 * 255).round()),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.brandYellow),
                    ),
                    child: Text(
                      missingFieldsMessage,
                      style: TextStyle(
                        color: AppColors.brandYellow,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: 250,
                  child: StyledButton(
                    onPressed: isComplete ? onConfirm : null,
                    text: 'Confirmar y continuar',
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: onViewProfile,
                child: Text(
                  'Ver mi perfil completo',
                  style: TextStyle(
                    color: AppColors.brandYellow,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.grey.withAlpha((0.3 * 255).round()),
      height: 24,
    );
  }

  Widget _buildProfileItem(
      String label, String value, IconData icon, bool hasError) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: <Widget>[
          Icon(
            icon,
            color: hasError ? AppColors.brandYellow : AppColors.brandYellow,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  label,
                  style: TextStyle(
                    color: hasError
                        ? AppColors.brandYellow
                        : AppColors.lightTextPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  value.isEmpty ? 'No completado' : value,
                  style: TextStyle(
                    color: value.isEmpty
                        ? AppColors.brandYellow
                        : AppColors.lightTextPrimary,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            hasError ? Icons.error_outline : Icons.check_circle_outline,
            color: hasError ? AppColors.brandYellow : AppColors.brandYellow,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildInterestsSection(
    final List<String> interests,
    final bool hasError,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: hasError
                ? AppColors.brandYellow.withAlpha((0.1 * 255).round())
                : AppColors.brandYellow.withAlpha((0.1 * 255).round()),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.favorite_outline,
            color: hasError ? AppColors.brandYellow : AppColors.brandYellow,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Intereses',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color:
                      hasError ? AppColors.brandYellow : AppColors.brandYellow,
                ),
              ),
              const SizedBox(height: 4),
              if (interests.isEmpty)
                Text(
                  'No completado',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.brandYellow,
                  ),
                )
              else
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: interests
                      .map(
                        (final String interest) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.brandYellow
                                .withAlpha((0.1 * 255).round()),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            interest,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.brandYellow,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
            ],
          ),
        ),
        if (hasError)
          Icon(
            Icons.error_outline,
            color: AppColors.brandYellow,
            size: 20,
          ),
      ],
    );
  }
}
