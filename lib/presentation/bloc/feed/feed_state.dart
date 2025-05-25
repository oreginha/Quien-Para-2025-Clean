// libcore/blocs/feed/feed_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:quien_para/domain/entities/plan/plan_entity.dart';

part 'feed_state.freezed.dart';

@freezed
class FeedState with _$FeedState {
  const FeedState._();

  const factory FeedState.initial() = FeedInitial;

  const factory FeedState.loading() = FeedLoading;

  const factory FeedState.refreshing({
    required final List<PlanEntity> plans,
  }) = FeedRefreshing;

  const factory FeedState.paginating({
    required final List<PlanEntity> plans,
    required final bool hasReachedEnd,
  }) = FeedPaginating;

  const factory FeedState.loaded({
    required final List<PlanEntity> plans,
    @Default(false) final bool hasReachedEnd,
    final String? lastDocumentId,
  }) = FeedLoaded;

  const factory FeedState.filtered({
    required final List<PlanEntity> plans,
    required final String filterCategory,
  }) = FeedFiltered;

  const factory FeedState.empty() = FeedEmpty;

  const factory FeedState.error({
    required final String message,
    final List<PlanEntity>? plans,
  }) = FeedError;
}
