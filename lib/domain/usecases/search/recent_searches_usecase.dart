// lib/domain/usecases/search/recent_searches_usecase.dart
import '../../interfaces/search_repository_interface.dart';

class GetRecentSearchesParams {
  final String userId;
  final int limit;

  const GetRecentSearchesParams({required this.userId, this.limit = 5});
}

class SaveSearchQueryParams {
  final String userId;
  final String query;

  const SaveSearchQueryParams({required this.userId, required this.query});
}

class ClearRecentSearchesParams {
  final String userId;

  const ClearRecentSearchesParams({required this.userId});
}

class GetRecentSearchesUseCase {
  final SearchRepository _searchRepository;

  GetRecentSearchesUseCase(this._searchRepository);

  Future<List<String>> execute(GetRecentSearchesParams params) {
    return _searchRepository.getRecentSearches(
      userId: params.userId,
      limit: params.limit,
    );
  }
}

class SaveSearchQueryUseCase {
  final SearchRepository _searchRepository;

  SaveSearchQueryUseCase(this._searchRepository);

  Future<void> execute(SaveSearchQueryParams params) {
    return _searchRepository.saveSearchQuery(
      userId: params.userId,
      query: params.query,
    );
  }
}

class ClearRecentSearchesUseCase {
  final SearchRepository _searchRepository;

  ClearRecentSearchesUseCase(this._searchRepository);

  Future<void> execute(ClearRecentSearchesParams params) {
    return _searchRepository.clearRecentSearches(userId: params.userId);
  }
}
