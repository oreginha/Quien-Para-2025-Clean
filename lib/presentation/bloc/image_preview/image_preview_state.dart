part of 'image_preview_bloc.dart';

@freezed
class ImagePreviewState with _$ImagePreviewState {
  const factory ImagePreviewState({
    required File currentImage,
    required File originalImage,
    @Default(0.0) double rotation,
    @Default('') String currentFilter,
    @Default(0.0) double brightness,
    @Default(1.0) double contrast,
    @Default(false) bool isLoading,
    @Default(false) bool hasChanges,
    String? error,
  }) = _ImagePreviewState;

  factory ImagePreviewState.initial() =>
      ImagePreviewState(currentImage: File(''), originalImage: File(''));
}
