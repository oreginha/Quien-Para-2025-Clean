// lib/data/repositories/search_filters_repository.dart
// ignore_for_file: always_specify_types

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../presentation/bloc/search/search_filters_state.dart';

class SearchFiltersRepository {
  static const String _filtersKey = 'search_filters';
  final SharedPreferences _prefs;

  SearchFiltersRepository(this._prefs);

  Future<void> saveFilters(SearchFiltersState filters) async {
    final Map<String, dynamic> filtersMap = {
      'distanceValue': filters.distanceValue,
      'conditions': filters.conditions,
      'additionalServices': filters.additionalServices,
    };
    await _prefs.setString(_filtersKey, json.encode(filtersMap));
  }

  Future<SearchFiltersState?> getSavedFilters() async {
    final String? filtersJson = _prefs.getString(_filtersKey);
    if (filtersJson == null) return null;

    try {
      final Map<String, dynamic> filtersMap =
          json.decode(filtersJson) as Map<String, dynamic>;
      return SearchFiltersState(
        distanceValue: filtersMap['distanceValue'] as double,
        conditions: Map<String, bool>.from(
            filtersMap['conditions'] as Map<dynamic, dynamic>),
        additionalServices: Map<String, bool>.from(
            filtersMap['additionalServices'] as Map<dynamic, dynamic>),
      );
    } catch (e) {
      return null;
    }
  }

  Future<void> clearFilters() async {
    await _prefs.remove(_filtersKey);
  }
}
