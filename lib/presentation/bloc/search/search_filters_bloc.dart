// libcore/blocs/search_filters/search_filters_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'search_filters_event.dart';
import 'search_filters_state.dart';

class SearchFiltersBloc extends Bloc<SearchFiltersEvent, SearchFiltersState> {
  SearchFiltersBloc() : super(SearchFiltersState.initial()) {
    on<SearchFiltersEvent>((
      final SearchFiltersEvent event,
      final Emitter<SearchFiltersState> emit,
    ) {
      event.when(
        updateSearchQuery: (final String query) =>
            _onUpdateSearchQuery(query, emit),
        updateCategoryFilter: (final String category) =>
            _onUpdateCategoryFilter(category, emit),
        updateTagFilter: (final String tag, final bool selected) =>
            _onUpdateTagFilter(tag, selected, emit),
        clearFilters: () => _onClearFilters(emit),
        distanceChanged: (final double value) =>
            _onDistanceChanged(value, emit),
        conditionToggled: (final String condition, final bool value) =>
            _onConditionToggled(condition, value, emit),
        additionalServiceToggled: (final String service, final bool value) =>
            _onAdditionalServiceToggled(service, value, emit),
        resetFilters: () => _onResetFilters(emit),
        applyFilters: () => _onApplyFilters(emit),
        saveFilters: () => _onSaveFilters(emit),
        loadSavedFilters: () => _onLoadSavedFilters(emit),
      );
    });
  }

  void _onUpdateSearchQuery(
    final String query,
    final Emitter<SearchFiltersState> emit,
  ) {
    emit(state.copyWith(searchQuery: query));
  }

  void _onUpdateCategoryFilter(
    final String category,
    final Emitter<SearchFiltersState> emit,
  ) {
    emit(state.copyWith(selectedCategory: category));
  }

  void _onUpdateTagFilter(
    final String tag,
    final bool selected,
    final Emitter<SearchFiltersState> emit,
  ) {
    final List<String> updatedTags = List<String>.from(state.selectedTags);
    if (selected && !updatedTags.contains(tag)) {
      updatedTags.add(tag);
    } else if (!selected) {
      updatedTags.remove(tag);
    }
    emit(state.copyWith(selectedTags: updatedTags));
  }

  void _onClearFilters(final Emitter<SearchFiltersState> emit) {
    emit(SearchFiltersState.initial());
  }

  void _onDistanceChanged(
    final double value,
    final Emitter<SearchFiltersState> emit,
  ) {
    emit(state.copyWith(distanceValue: value));
  }

  void _onConditionToggled(
    final String condition,
    final bool value,
    final Emitter<SearchFiltersState> emit,
  ) {
    final Map<String, bool> updatedConditions = Map<String, bool>.from(
      state.conditions,
    );
    updatedConditions[condition] = value;
    emit(state.copyWith(conditions: updatedConditions));
  }

  void _onAdditionalServiceToggled(
    final String service,
    final bool value,
    final Emitter<SearchFiltersState> emit,
  ) {
    final Map<String, bool> updatedServices = Map<String, bool>.from(
      state.additionalServices,
    );
    updatedServices[service] = value;
    emit(state.copyWith(additionalServices: updatedServices));
  }

  void _onResetFilters(final Emitter<SearchFiltersState> emit) {
    emit(SearchFiltersState.initial());
  }

  void _onApplyFilters(final Emitter<SearchFiltersState> emit) {
    // Implement the logic to apply filters
  }

  void _onSaveFilters(final Emitter<SearchFiltersState> emit) {
    // Implement the logic to save filters
  }

  void _onLoadSavedFilters(final Emitter<SearchFiltersState> emit) {
    // Implement the logic to load saved filters
  }
}
