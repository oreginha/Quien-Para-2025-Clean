part of 'image_preview_bloc.dart';

@freezed
class ImagePreviewEvent with _$ImagePreviewEvent {
  const factory ImagePreviewEvent.initialize(File imageFile) = _Initialize;
  const factory ImagePreviewEvent.rotateImage() = _RotateImage;
  const factory ImagePreviewEvent.cropImage() = _CropImage;
  const factory ImagePreviewEvent.applyFilter(String filterName) = _ApplyFilter;
  const factory ImagePreviewEvent.adjustImage({
    required double brightness,
    required double contrast,
  }) = _AdjustImage;
  const factory ImagePreviewEvent.resetFilter() = _ResetFilter;
}