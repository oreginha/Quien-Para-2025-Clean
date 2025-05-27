import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:quien_para/data/datasources/matching_data_source.dart';
import 'package:quien_para/domain/entities/application/application_entity.dart';

/// Firebase implementation of [MatchingDataSource]
class FirebaseMatchingDataSource implements MatchingDataSource {
  final FirebaseFirestore _firestore;
  final Logger _logger;

  FirebaseMatchingDataSource({FirebaseFirestore? firestore, Logger? logger})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _logger = logger ?? Logger();

  @override
  Future<ApplicationEntity> acceptApplication(String applicationId) async {
    try {
      await _firestore.collection('applications').doc(applicationId).update({
        'status': 'accepted',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Get the updated application
      final docSnapshot =
          await _firestore.collection('applications').doc(applicationId).get();
      return _mapDocToApplicationEntity(docSnapshot);
    } catch (e) {
      _logger.e('Error accepting application: $e');
      throw Exception('Failed to accept application: $e');
    }
  }

  @override
  Future<ApplicationEntity> applyToPlan({
    required String planId,
    required String applicantId,
    required String message,
    required String planTitle,
    required String? applicantName,
    required String? applicantPhotoUrl,
  }) async {
    try {
      // Create a new application document
      final applicationRef = await _firestore.collection('applications').add({
        'planId': planId,
        'applicantId': applicantId,
        'message': message,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
        'planTitle': planTitle,
        'applicantName': applicantName,
        'applicantPhotoUrl': applicantPhotoUrl,
      });

      // Get the created application
      final docSnapshot = await applicationRef.get();
      return _mapDocToApplicationEntity(docSnapshot);
    } catch (e) {
      _logger.e('Error applying to plan: $e');
      throw Exception('Failed to apply to plan: $e');
    }
  }

  @override
  Future<List<ApplicationEntity>> findSimilarPlans(String planId) async {
    try {
      // Get the current plan to determine its attributes
      final planDoc = await _firestore.collection('plans').doc(planId).get();

      if (!planDoc.exists) {
        return [];
      }

      final planData = planDoc.data() ?? {};
      final category = planData['category'];
      // No usamos tags por ahora, pero podría implementarse en el futuro
      // final tags = planData['tags'] ?? [];

      // Find other plans with similar category or tags
      // Note: This is a simplistic implementation - in a real app, you might use more sophisticated matching
      var query = _firestore
          .collection('plans')
          .where('id', isNotEqualTo: planId) // Exclude current plan
          .limit(10); // Limit results

      if (category != null) {
        query = query.where('category', isEqualTo: category);
      }

      final querySnapshot = await query.get();

      // Convert to applications format
      List<ApplicationEntity> similarPlans = [];
      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        // En caso de que la fecha de creación sea nula, usamos la fecha actual
        final DateTime createdAtDate =
            (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now();

        similarPlans.add(
          ApplicationEntity(
            id: doc.id,
            planId: doc.id,
            planTitle: data['title'] as String? ?? 'Unknown Plan',
            applicantId: data['creatorId'] as String? ?? '',
            applicantName: data['creatorName'] as String? ?? 'Unknown',
            applicantPhotoUrl: data['creatorPhotoUrl'] as String?,
            status: 'similar', // Mark as similar for UI distinction
            message: data['description'] as String? ?? '',
            appliedAt: createdAtDate, // Usar fecha no nula
          ),
        );
      }

      return similarPlans;
    } catch (e) {
      _logger.e('Error finding similar plans: $e');
      return [];
    }
  }

  @override
  Future<List<ApplicationEntity>> loadPlanApplications(String planId) async {
    try {
      final querySnapshot = await _firestore
          .collection('applications')
          .where('planId', isEqualTo: planId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => _mapDocToApplicationEntity(doc))
          .toList();
    } catch (e) {
      _logger.e('Error loading plan applications: $e');
      return [];
    }
  }

  @override
  Future<List<ApplicationEntity>> loadUserApplications(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('applications')
          .where('applicantId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => _mapDocToApplicationEntity(doc))
          .toList();
    } catch (e) {
      _logger.e('Error loading user applications: $e');
      return [];
    }
  }

  @override
  Future<ApplicationEntity> rejectApplication(String applicationId) async {
    try {
      await _firestore.collection('applications').doc(applicationId).update({
        'status': 'rejected',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Get the updated application
      final docSnapshot =
          await _firestore.collection('applications').doc(applicationId).get();
      return _mapDocToApplicationEntity(docSnapshot);
    } catch (e) {
      _logger.e('Error rejecting application: $e');
      throw Exception('Failed to reject application: $e');
    }
  }

  /// Maps a Firestore document to an ApplicationEntity
  ApplicationEntity _mapDocToApplicationEntity(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    // En caso de que la fecha de aplicación sea nula, usamos la fecha actual
    final DateTime appliedAtDate =
        (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now();

    return ApplicationEntity(
      id: doc.id,
      planId: data['planId'] as String? ?? '',
      planTitle: data['planTitle'] as String?,
      applicantId: data['applicantId'] as String? ?? '',
      applicantName: data['applicantName'] as String?,
      applicantPhotoUrl: data['applicantPhotoUrl'] as String?,
      status: data['status'] as String? ?? 'pending',
      message: data['message'] as String?,
      appliedAt: appliedAtDate,
      processedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }
}
