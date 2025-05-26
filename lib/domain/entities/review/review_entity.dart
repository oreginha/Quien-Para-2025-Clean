import 'package:freezed_annotation/freezed_annotation.dart';

part 'review_entity.freezed.dart';
part 'review_entity.g.dart';

@freezed
class ReviewEntity with _$ReviewEntity {
  const factory ReviewEntity({
    required String id,
    required String reviewerId,
    required String reviewedUserId,
    required String planId,
    required double rating, // 1.0 - 5.0
    required String comment,
    required DateTime createdAt,
    required ReviewType type,
    required ReviewStatus status,
    String? response, // Respuesta del usuario revisado
    DateTime? responseDate,
    @Default(0) int helpfulCount,
    @Default([]) List<String> helpfulVotes,
    @Default(false)
    bool isVerified, // Si el revisor realmente participó en el plan
    Map<String, dynamic>? metadata,
  }) = _ReviewEntity;

  factory ReviewEntity.fromJson(Map<String, dynamic> json) =>
      _$ReviewEntityFromJson(json);
}

@freezed
class UserRatingEntity with _$UserRatingEntity {
  const factory UserRatingEntity({
    required String userId,
    required double averageRating, // 0.0 - 5.0
    required int totalReviews,
    required DateTime lastUpdated,
    @Default(0) int totalPlansOrganized,
    @Default(0) int totalPlansAttended,
    @Default(0) int reliabilityScore, // 0-100
    Map<String, int>? ratingDistribution, // {1: 0, 2: 1, 3: 5, 4: 20, 5: 15}
    Map<String, double>? categoryRatings, // Ratings por categoría de planes
    List<String>? topPositiveComments,
    List<String>? commonConcerns,
  }) = _UserRatingEntity;

  factory UserRatingEntity.fromJson(Map<String, dynamic> json) =>
      _$UserRatingEntityFromJson(json);
}

enum ReviewType {
  @JsonValue('organizer')
  organizer, // Review del organizador del plan

  @JsonValue('attendee')
  attendee, // Review de un asistente al plan

  @JsonValue('general')
  general, // Review general del usuario
}

enum ReviewStatus {
  @JsonValue('pending')
  pending, // Pendiente de moderación

  @JsonValue('approved')
  approved, // Aprobada y visible

  @JsonValue('rejected')
  rejected, // Rechazada por moderación

  @JsonValue('flagged')
  flagged, // Marcada para revisión adicional
}

extension ReviewEntityExtensions on ReviewEntity {
  bool get isPositive => rating >= 4.0;
  bool get isNegative => rating <= 2.0;
  bool get isNeutral => rating > 2.0 && rating < 4.0;

  String get ratingText {
    switch (rating.round()) {
      case 5:
        return 'Excelente';
      case 4:
        return 'Muy bueno';
      case 3:
        return 'Bueno';
      case 2:
        return 'Regular';
      case 1:
        return 'Malo';
      default:
        return 'Sin calificación';
    }
  }

  bool get canBeEdited =>
      DateTime.now().difference(createdAt).inDays <= 7 &&
      status == ReviewStatus.approved;

  bool get isRecent => DateTime.now().difference(createdAt).inDays <= 30;
}

extension UserRatingEntityExtensions on UserRatingEntity {
  String get ratingLevel {
    if (averageRating >= 4.5) return 'Excelente';
    if (averageRating >= 4.0) return 'Muy bueno';
    if (averageRating >= 3.5) return 'Bueno';
    if (averageRating >= 3.0) return 'Regular';
    return 'Necesita mejorar';
  }

  bool get isHighlyRated => averageRating >= 4.0 && totalReviews >= 5;
  bool get isNewUser => totalReviews < 3;
  bool get isExperiencedOrganizer => totalPlansOrganized >= 10;
  bool get isActiveAttendee => totalPlansAttended >= 20;

  double get trustScore {
    // Algoritmo de confianza basado en varios factores
    double score = 0;

    // Rating base (40% del score)
    score += (averageRating / 5.0) * 40;

    // Cantidad de reviews (30% del score)
    double reviewScore = (totalReviews / 50.0).clamp(0.0, 1.0) * 30;
    score += reviewScore;

    // Reliability score (20% del score)
    score += (reliabilityScore / 100.0) * 20;

    // Actividad (10% del score)
    double activityScore =
        ((totalPlansOrganized + totalPlansAttended) / 100.0).clamp(0.0, 1.0) *
        10;
    score += activityScore;

    return score.clamp(0.0, 100.0);
  }
}
