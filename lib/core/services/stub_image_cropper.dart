// Stub implementation of image_cropper for web platform
// This file is only used when compiling for web and provides empty implementations
// of classes and methods from the image_cropper package


/// Stub implementation of ImageCropper for web
class ImageCropper {
  const ImageCropper();
  
  Future<CroppedFile?> cropImage({
    required String sourcePath,
    List<CropAspectRatioPreset>? aspectRatioPresets,
    CropStyle cropStyle = CropStyle.rectangle,
    List<PlatformUiSettings>? uiSettings,
    int? compressQuality,
    int? compressFormat,
  }) async {
    // En web, simplemente devolvemos null
    return null;
  }
}

/// Stub for CroppedFile class
class CroppedFile {
  final String path;
  CroppedFile(this.path);
}

/// Stub for CropAspectRatioPreset enum
enum CropAspectRatioPreset {
  original,
  square,
  ratio3x2,
  ratio4x3,
  ratio5x3,
  ratio5x4,
  ratio7x5,
  ratio16x9,
}

/// Stub for CropStyle enum
enum CropStyle {
  rectangle,
  circle,
}

/// Base class for platform UI settings
abstract class PlatformUiSettings {}

/// Stub for AndroidUiSettings
class AndroidUiSettings extends PlatformUiSettings {
  AndroidUiSettings({
    String? toolbarTitle,
    bool? lockAspectRatio,
    List<CropAspectRatioPreset>? aspectRatioPresets,
    // Agregar todos los parámetros que se usan en el código real
    dynamic toolbarColor,
    dynamic toolbarWidgetColor,
    dynamic initAspectRatio,
    dynamic statusBarColor,
    dynamic toolbarButtons,
    dynamic activeControlsWidgetColor,
    dynamic dimmedLayerColor,
    dynamic cropFrameColor,
    dynamic cropGridColor,
    dynamic progressIndicatorColor,
    bool? hideBottomControls,
    bool? showCropGrid,
  });
}

/// Stub for IOSUiSettings
class IOSUiSettings extends PlatformUiSettings {
  IOSUiSettings({
    String? title,
    bool? rotateClockwise,
    // Agregar todos los parámetros que se usan en el código real
    String? cancelButtonTitle,
    String? doneButtonTitle,
    bool? aspectRatioLockEnabled,
    bool? showActivitySheetOnDone,
    bool? showCancelConfirmationDialog,
    bool? resetAspectRatioEnabled,
    bool? hidesNavigationBar,
    dynamic minimumAspectRatio,
    dynamic rectX,
    dynamic rectY,
    dynamic rectWidth,
    dynamic rectHeight,
    dynamic doneButtonColor,
    dynamic cancelButtonColor,
  });
}
