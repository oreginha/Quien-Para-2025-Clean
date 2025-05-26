import 'package:quien_para/domain/entities/entity_base.dart';

/// Entidad de dominio que representa un usuario en la aplicación
class UserEntity extends EntityBase {
  final String? email;
  final String? name;
  final String? photoUrl;
  final int? age;
  final String? gender;
  final String? location;
  final List<String>? interests;
  final List<String>? photoUrls;
  final String? bio;
  final String? orientation;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// Constructor
  const UserEntity({
    super.id = '',
    this.email,
    this.name,
    this.photoUrl,
    this.age,
    this.gender,
    this.location,
    this.interests,
    this.photoUrls,
    this.bio,
    this.orientation,
    this.createdAt,
    this.updatedAt,
  });

  /// Crear una copia de esta entidad con campos específicos modificados
  UserEntity copyWith({
    String? id,
    String? email,
    String? name,
    String? photoUrl,
    int? age,
    String? gender,
    String? location,
    List<String>? interests,
    List<String>? photoUrls,
    String? bio,
    String? orientation,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      location: location ?? this.location,
      interests: interests ?? this.interests,
      photoUrls: photoUrls ?? this.photoUrls,
      bio: bio ?? this.bio,
      orientation: orientation ?? this.orientation,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Constructor para crear un usuario vacío
  factory UserEntity.empty() => const UserEntity(id: '');

  @override
  bool get isEmpty => id.isEmpty && (email == null || email!.isEmpty);

  @override
  bool get isValid => id.isNotEmpty && email != null && email!.isNotEmpty;

  @override
  List<Object?> get props => [
    id,
    email,
    name,
    photoUrl,
    age,
    gender,
    location,
    interests,
    photoUrls,
    bio,
    orientation,
    createdAt,
    updatedAt,
  ];
}
