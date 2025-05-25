// lib/services/implementations/persistence_service.dart
// ignore_for_file: always_specify_types, unrelated_type_equality_checks

import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/interfaces/persistence_interface.dart';

class PersistenceService implements PersistenceInterface {
  static const String _metricsKey = 'pending_metrics';
  final SharedPreferences _prefs;
  // ignore: unused_field
  final FirebaseFirestore _firestore;
  // ignore: unused_field
  final Connectivity _connectivity;

  PersistenceService({
    required final SharedPreferences prefs,
    required final FirebaseFirestore firestore,
    required final Connectivity connectivity,
  })  : _prefs = prefs,
        _firestore = firestore,
        _connectivity = connectivity {
    _startSyncMonitoring();
  }

  @override
  Future<void> savePendingMetric(
      final String city, final bool wasEnabled) async {
    try {
      final List<Map<String, dynamic>> metrics = await getPendingMetrics();
      metrics.add(<String, dynamic>{
        'city': city,
        'wasEnabled': wasEnabled,
        'timestamp': DateTime.now().toIso8601String(),
      });
      await _prefs.setString(_metricsKey, json.encode(metrics));

      _syncPendingMetrics();
    } catch (e) {
      if (kDebugMode) {
        print('Error saving metric: $e');
      }
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getPendingMetrics() async {
    final String? metricsJson = _prefs.getString(_metricsKey);
    if (metricsJson == null) {
      return [];
    }
    return List<Map<String, dynamic>>.from(
        json.decode(metricsJson) as List<dynamic>);
  }

  Future<void> _syncPendingMetrics() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        return;
      }

      final metrics = await getPendingMetrics();
      if (metrics.isEmpty) {
        return;
      }

      for (final metric in metrics) {
        await _firestore
            .collection('cityMetrics')
            .doc(metric['city'].toString())
            .set({
          'totalAttempts': FieldValue.increment(1),
          'successfulSelections':
              FieldValue.increment((metric['wasEnabled'] as bool) ? 1 : 0),
          'lastUpdated': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }

      await _prefs.setString(_metricsKey, json.encode([]));
    } catch (e) {
      if (kDebugMode) {
        print('Error syncing metrics: $e');
      }
    }
  }

  void _startSyncMonitoring() {
    _connectivity.onConnectivityChanged
        .listen((final List<ConnectivityResult> result) {
      if (result.isNotEmpty && !result.contains(ConnectivityResult.none)) {
        _syncPendingMetrics();
      }
    });
  }
}
