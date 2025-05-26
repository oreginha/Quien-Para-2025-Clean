// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'image_preview_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ImagePreviewEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(File imageFile) initialize,
    required TResult Function() rotateImage,
    required TResult Function() cropImage,
    required TResult Function(String filterName) applyFilter,
    required TResult Function(double brightness, double contrast) adjustImage,
    required TResult Function() resetFilter,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(File imageFile)? initialize,
    TResult? Function()? rotateImage,
    TResult? Function()? cropImage,
    TResult? Function(String filterName)? applyFilter,
    TResult? Function(double brightness, double contrast)? adjustImage,
    TResult? Function()? resetFilter,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(File imageFile)? initialize,
    TResult Function()? rotateImage,
    TResult Function()? cropImage,
    TResult Function(String filterName)? applyFilter,
    TResult Function(double brightness, double contrast)? adjustImage,
    TResult Function()? resetFilter,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initialize value) initialize,
    required TResult Function(_RotateImage value) rotateImage,
    required TResult Function(_CropImage value) cropImage,
    required TResult Function(_ApplyFilter value) applyFilter,
    required TResult Function(_AdjustImage value) adjustImage,
    required TResult Function(_ResetFilter value) resetFilter,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initialize value)? initialize,
    TResult? Function(_RotateImage value)? rotateImage,
    TResult? Function(_CropImage value)? cropImage,
    TResult? Function(_ApplyFilter value)? applyFilter,
    TResult? Function(_AdjustImage value)? adjustImage,
    TResult? Function(_ResetFilter value)? resetFilter,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initialize value)? initialize,
    TResult Function(_RotateImage value)? rotateImage,
    TResult Function(_CropImage value)? cropImage,
    TResult Function(_ApplyFilter value)? applyFilter,
    TResult Function(_AdjustImage value)? adjustImage,
    TResult Function(_ResetFilter value)? resetFilter,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ImagePreviewEventCopyWith<$Res> {
  factory $ImagePreviewEventCopyWith(
    ImagePreviewEvent value,
    $Res Function(ImagePreviewEvent) then,
  ) = _$ImagePreviewEventCopyWithImpl<$Res, ImagePreviewEvent>;
}

/// @nodoc
class _$ImagePreviewEventCopyWithImpl<$Res, $Val extends ImagePreviewEvent>
    implements $ImagePreviewEventCopyWith<$Res> {
  _$ImagePreviewEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ImagePreviewEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$InitializeImplCopyWith<$Res> {
  factory _$$InitializeImplCopyWith(
    _$InitializeImpl value,
    $Res Function(_$InitializeImpl) then,
  ) = __$$InitializeImplCopyWithImpl<$Res>;
  @useResult
  $Res call({File imageFile});
}

/// @nodoc
class __$$InitializeImplCopyWithImpl<$Res>
    extends _$ImagePreviewEventCopyWithImpl<$Res, _$InitializeImpl>
    implements _$$InitializeImplCopyWith<$Res> {
  __$$InitializeImplCopyWithImpl(
    _$InitializeImpl _value,
    $Res Function(_$InitializeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ImagePreviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? imageFile = null}) {
    return _then(
      _$InitializeImpl(
        null == imageFile
            ? _value.imageFile
            : imageFile // ignore: cast_nullable_to_non_nullable
                  as File,
      ),
    );
  }
}

/// @nodoc

class _$InitializeImpl implements _Initialize {
  const _$InitializeImpl(this.imageFile);

  @override
  final File imageFile;

  @override
  String toString() {
    return 'ImagePreviewEvent.initialize(imageFile: $imageFile)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InitializeImpl &&
            (identical(other.imageFile, imageFile) ||
                other.imageFile == imageFile));
  }

  @override
  int get hashCode => Object.hash(runtimeType, imageFile);

  /// Create a copy of ImagePreviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InitializeImplCopyWith<_$InitializeImpl> get copyWith =>
      __$$InitializeImplCopyWithImpl<_$InitializeImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(File imageFile) initialize,
    required TResult Function() rotateImage,
    required TResult Function() cropImage,
    required TResult Function(String filterName) applyFilter,
    required TResult Function(double brightness, double contrast) adjustImage,
    required TResult Function() resetFilter,
  }) {
    return initialize(imageFile);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(File imageFile)? initialize,
    TResult? Function()? rotateImage,
    TResult? Function()? cropImage,
    TResult? Function(String filterName)? applyFilter,
    TResult? Function(double brightness, double contrast)? adjustImage,
    TResult? Function()? resetFilter,
  }) {
    return initialize?.call(imageFile);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(File imageFile)? initialize,
    TResult Function()? rotateImage,
    TResult Function()? cropImage,
    TResult Function(String filterName)? applyFilter,
    TResult Function(double brightness, double contrast)? adjustImage,
    TResult Function()? resetFilter,
    required TResult orElse(),
  }) {
    if (initialize != null) {
      return initialize(imageFile);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initialize value) initialize,
    required TResult Function(_RotateImage value) rotateImage,
    required TResult Function(_CropImage value) cropImage,
    required TResult Function(_ApplyFilter value) applyFilter,
    required TResult Function(_AdjustImage value) adjustImage,
    required TResult Function(_ResetFilter value) resetFilter,
  }) {
    return initialize(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initialize value)? initialize,
    TResult? Function(_RotateImage value)? rotateImage,
    TResult? Function(_CropImage value)? cropImage,
    TResult? Function(_ApplyFilter value)? applyFilter,
    TResult? Function(_AdjustImage value)? adjustImage,
    TResult? Function(_ResetFilter value)? resetFilter,
  }) {
    return initialize?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initialize value)? initialize,
    TResult Function(_RotateImage value)? rotateImage,
    TResult Function(_CropImage value)? cropImage,
    TResult Function(_ApplyFilter value)? applyFilter,
    TResult Function(_AdjustImage value)? adjustImage,
    TResult Function(_ResetFilter value)? resetFilter,
    required TResult orElse(),
  }) {
    if (initialize != null) {
      return initialize(this);
    }
    return orElse();
  }
}

abstract class _Initialize implements ImagePreviewEvent {
  const factory _Initialize(final File imageFile) = _$InitializeImpl;

  File get imageFile;

  /// Create a copy of ImagePreviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InitializeImplCopyWith<_$InitializeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RotateImageImplCopyWith<$Res> {
  factory _$$RotateImageImplCopyWith(
    _$RotateImageImpl value,
    $Res Function(_$RotateImageImpl) then,
  ) = __$$RotateImageImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$RotateImageImplCopyWithImpl<$Res>
    extends _$ImagePreviewEventCopyWithImpl<$Res, _$RotateImageImpl>
    implements _$$RotateImageImplCopyWith<$Res> {
  __$$RotateImageImplCopyWithImpl(
    _$RotateImageImpl _value,
    $Res Function(_$RotateImageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ImagePreviewEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$RotateImageImpl implements _RotateImage {
  const _$RotateImageImpl();

  @override
  String toString() {
    return 'ImagePreviewEvent.rotateImage()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$RotateImageImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(File imageFile) initialize,
    required TResult Function() rotateImage,
    required TResult Function() cropImage,
    required TResult Function(String filterName) applyFilter,
    required TResult Function(double brightness, double contrast) adjustImage,
    required TResult Function() resetFilter,
  }) {
    return rotateImage();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(File imageFile)? initialize,
    TResult? Function()? rotateImage,
    TResult? Function()? cropImage,
    TResult? Function(String filterName)? applyFilter,
    TResult? Function(double brightness, double contrast)? adjustImage,
    TResult? Function()? resetFilter,
  }) {
    return rotateImage?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(File imageFile)? initialize,
    TResult Function()? rotateImage,
    TResult Function()? cropImage,
    TResult Function(String filterName)? applyFilter,
    TResult Function(double brightness, double contrast)? adjustImage,
    TResult Function()? resetFilter,
    required TResult orElse(),
  }) {
    if (rotateImage != null) {
      return rotateImage();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initialize value) initialize,
    required TResult Function(_RotateImage value) rotateImage,
    required TResult Function(_CropImage value) cropImage,
    required TResult Function(_ApplyFilter value) applyFilter,
    required TResult Function(_AdjustImage value) adjustImage,
    required TResult Function(_ResetFilter value) resetFilter,
  }) {
    return rotateImage(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initialize value)? initialize,
    TResult? Function(_RotateImage value)? rotateImage,
    TResult? Function(_CropImage value)? cropImage,
    TResult? Function(_ApplyFilter value)? applyFilter,
    TResult? Function(_AdjustImage value)? adjustImage,
    TResult? Function(_ResetFilter value)? resetFilter,
  }) {
    return rotateImage?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initialize value)? initialize,
    TResult Function(_RotateImage value)? rotateImage,
    TResult Function(_CropImage value)? cropImage,
    TResult Function(_ApplyFilter value)? applyFilter,
    TResult Function(_AdjustImage value)? adjustImage,
    TResult Function(_ResetFilter value)? resetFilter,
    required TResult orElse(),
  }) {
    if (rotateImage != null) {
      return rotateImage(this);
    }
    return orElse();
  }
}

abstract class _RotateImage implements ImagePreviewEvent {
  const factory _RotateImage() = _$RotateImageImpl;
}

/// @nodoc
abstract class _$$CropImageImplCopyWith<$Res> {
  factory _$$CropImageImplCopyWith(
    _$CropImageImpl value,
    $Res Function(_$CropImageImpl) then,
  ) = __$$CropImageImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CropImageImplCopyWithImpl<$Res>
    extends _$ImagePreviewEventCopyWithImpl<$Res, _$CropImageImpl>
    implements _$$CropImageImplCopyWith<$Res> {
  __$$CropImageImplCopyWithImpl(
    _$CropImageImpl _value,
    $Res Function(_$CropImageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ImagePreviewEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$CropImageImpl implements _CropImage {
  const _$CropImageImpl();

  @override
  String toString() {
    return 'ImagePreviewEvent.cropImage()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$CropImageImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(File imageFile) initialize,
    required TResult Function() rotateImage,
    required TResult Function() cropImage,
    required TResult Function(String filterName) applyFilter,
    required TResult Function(double brightness, double contrast) adjustImage,
    required TResult Function() resetFilter,
  }) {
    return cropImage();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(File imageFile)? initialize,
    TResult? Function()? rotateImage,
    TResult? Function()? cropImage,
    TResult? Function(String filterName)? applyFilter,
    TResult? Function(double brightness, double contrast)? adjustImage,
    TResult? Function()? resetFilter,
  }) {
    return cropImage?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(File imageFile)? initialize,
    TResult Function()? rotateImage,
    TResult Function()? cropImage,
    TResult Function(String filterName)? applyFilter,
    TResult Function(double brightness, double contrast)? adjustImage,
    TResult Function()? resetFilter,
    required TResult orElse(),
  }) {
    if (cropImage != null) {
      return cropImage();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initialize value) initialize,
    required TResult Function(_RotateImage value) rotateImage,
    required TResult Function(_CropImage value) cropImage,
    required TResult Function(_ApplyFilter value) applyFilter,
    required TResult Function(_AdjustImage value) adjustImage,
    required TResult Function(_ResetFilter value) resetFilter,
  }) {
    return cropImage(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initialize value)? initialize,
    TResult? Function(_RotateImage value)? rotateImage,
    TResult? Function(_CropImage value)? cropImage,
    TResult? Function(_ApplyFilter value)? applyFilter,
    TResult? Function(_AdjustImage value)? adjustImage,
    TResult? Function(_ResetFilter value)? resetFilter,
  }) {
    return cropImage?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initialize value)? initialize,
    TResult Function(_RotateImage value)? rotateImage,
    TResult Function(_CropImage value)? cropImage,
    TResult Function(_ApplyFilter value)? applyFilter,
    TResult Function(_AdjustImage value)? adjustImage,
    TResult Function(_ResetFilter value)? resetFilter,
    required TResult orElse(),
  }) {
    if (cropImage != null) {
      return cropImage(this);
    }
    return orElse();
  }
}

abstract class _CropImage implements ImagePreviewEvent {
  const factory _CropImage() = _$CropImageImpl;
}

/// @nodoc
abstract class _$$ApplyFilterImplCopyWith<$Res> {
  factory _$$ApplyFilterImplCopyWith(
    _$ApplyFilterImpl value,
    $Res Function(_$ApplyFilterImpl) then,
  ) = __$$ApplyFilterImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String filterName});
}

/// @nodoc
class __$$ApplyFilterImplCopyWithImpl<$Res>
    extends _$ImagePreviewEventCopyWithImpl<$Res, _$ApplyFilterImpl>
    implements _$$ApplyFilterImplCopyWith<$Res> {
  __$$ApplyFilterImplCopyWithImpl(
    _$ApplyFilterImpl _value,
    $Res Function(_$ApplyFilterImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ImagePreviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? filterName = null}) {
    return _then(
      _$ApplyFilterImpl(
        null == filterName
            ? _value.filterName
            : filterName // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ApplyFilterImpl implements _ApplyFilter {
  const _$ApplyFilterImpl(this.filterName);

  @override
  final String filterName;

  @override
  String toString() {
    return 'ImagePreviewEvent.applyFilter(filterName: $filterName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApplyFilterImpl &&
            (identical(other.filterName, filterName) ||
                other.filterName == filterName));
  }

  @override
  int get hashCode => Object.hash(runtimeType, filterName);

  /// Create a copy of ImagePreviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApplyFilterImplCopyWith<_$ApplyFilterImpl> get copyWith =>
      __$$ApplyFilterImplCopyWithImpl<_$ApplyFilterImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(File imageFile) initialize,
    required TResult Function() rotateImage,
    required TResult Function() cropImage,
    required TResult Function(String filterName) applyFilter,
    required TResult Function(double brightness, double contrast) adjustImage,
    required TResult Function() resetFilter,
  }) {
    return applyFilter(filterName);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(File imageFile)? initialize,
    TResult? Function()? rotateImage,
    TResult? Function()? cropImage,
    TResult? Function(String filterName)? applyFilter,
    TResult? Function(double brightness, double contrast)? adjustImage,
    TResult? Function()? resetFilter,
  }) {
    return applyFilter?.call(filterName);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(File imageFile)? initialize,
    TResult Function()? rotateImage,
    TResult Function()? cropImage,
    TResult Function(String filterName)? applyFilter,
    TResult Function(double brightness, double contrast)? adjustImage,
    TResult Function()? resetFilter,
    required TResult orElse(),
  }) {
    if (applyFilter != null) {
      return applyFilter(filterName);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initialize value) initialize,
    required TResult Function(_RotateImage value) rotateImage,
    required TResult Function(_CropImage value) cropImage,
    required TResult Function(_ApplyFilter value) applyFilter,
    required TResult Function(_AdjustImage value) adjustImage,
    required TResult Function(_ResetFilter value) resetFilter,
  }) {
    return applyFilter(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initialize value)? initialize,
    TResult? Function(_RotateImage value)? rotateImage,
    TResult? Function(_CropImage value)? cropImage,
    TResult? Function(_ApplyFilter value)? applyFilter,
    TResult? Function(_AdjustImage value)? adjustImage,
    TResult? Function(_ResetFilter value)? resetFilter,
  }) {
    return applyFilter?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initialize value)? initialize,
    TResult Function(_RotateImage value)? rotateImage,
    TResult Function(_CropImage value)? cropImage,
    TResult Function(_ApplyFilter value)? applyFilter,
    TResult Function(_AdjustImage value)? adjustImage,
    TResult Function(_ResetFilter value)? resetFilter,
    required TResult orElse(),
  }) {
    if (applyFilter != null) {
      return applyFilter(this);
    }
    return orElse();
  }
}

abstract class _ApplyFilter implements ImagePreviewEvent {
  const factory _ApplyFilter(final String filterName) = _$ApplyFilterImpl;

  String get filterName;

  /// Create a copy of ImagePreviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApplyFilterImplCopyWith<_$ApplyFilterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AdjustImageImplCopyWith<$Res> {
  factory _$$AdjustImageImplCopyWith(
    _$AdjustImageImpl value,
    $Res Function(_$AdjustImageImpl) then,
  ) = __$$AdjustImageImplCopyWithImpl<$Res>;
  @useResult
  $Res call({double brightness, double contrast});
}

/// @nodoc
class __$$AdjustImageImplCopyWithImpl<$Res>
    extends _$ImagePreviewEventCopyWithImpl<$Res, _$AdjustImageImpl>
    implements _$$AdjustImageImplCopyWith<$Res> {
  __$$AdjustImageImplCopyWithImpl(
    _$AdjustImageImpl _value,
    $Res Function(_$AdjustImageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ImagePreviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? brightness = null, Object? contrast = null}) {
    return _then(
      _$AdjustImageImpl(
        brightness: null == brightness
            ? _value.brightness
            : brightness // ignore: cast_nullable_to_non_nullable
                  as double,
        contrast: null == contrast
            ? _value.contrast
            : contrast // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc

class _$AdjustImageImpl implements _AdjustImage {
  const _$AdjustImageImpl({required this.brightness, required this.contrast});

  @override
  final double brightness;
  @override
  final double contrast;

  @override
  String toString() {
    return 'ImagePreviewEvent.adjustImage(brightness: $brightness, contrast: $contrast)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdjustImageImpl &&
            (identical(other.brightness, brightness) ||
                other.brightness == brightness) &&
            (identical(other.contrast, contrast) ||
                other.contrast == contrast));
  }

  @override
  int get hashCode => Object.hash(runtimeType, brightness, contrast);

  /// Create a copy of ImagePreviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AdjustImageImplCopyWith<_$AdjustImageImpl> get copyWith =>
      __$$AdjustImageImplCopyWithImpl<_$AdjustImageImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(File imageFile) initialize,
    required TResult Function() rotateImage,
    required TResult Function() cropImage,
    required TResult Function(String filterName) applyFilter,
    required TResult Function(double brightness, double contrast) adjustImage,
    required TResult Function() resetFilter,
  }) {
    return adjustImage(brightness, contrast);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(File imageFile)? initialize,
    TResult? Function()? rotateImage,
    TResult? Function()? cropImage,
    TResult? Function(String filterName)? applyFilter,
    TResult? Function(double brightness, double contrast)? adjustImage,
    TResult? Function()? resetFilter,
  }) {
    return adjustImage?.call(brightness, contrast);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(File imageFile)? initialize,
    TResult Function()? rotateImage,
    TResult Function()? cropImage,
    TResult Function(String filterName)? applyFilter,
    TResult Function(double brightness, double contrast)? adjustImage,
    TResult Function()? resetFilter,
    required TResult orElse(),
  }) {
    if (adjustImage != null) {
      return adjustImage(brightness, contrast);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initialize value) initialize,
    required TResult Function(_RotateImage value) rotateImage,
    required TResult Function(_CropImage value) cropImage,
    required TResult Function(_ApplyFilter value) applyFilter,
    required TResult Function(_AdjustImage value) adjustImage,
    required TResult Function(_ResetFilter value) resetFilter,
  }) {
    return adjustImage(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initialize value)? initialize,
    TResult? Function(_RotateImage value)? rotateImage,
    TResult? Function(_CropImage value)? cropImage,
    TResult? Function(_ApplyFilter value)? applyFilter,
    TResult? Function(_AdjustImage value)? adjustImage,
    TResult? Function(_ResetFilter value)? resetFilter,
  }) {
    return adjustImage?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initialize value)? initialize,
    TResult Function(_RotateImage value)? rotateImage,
    TResult Function(_CropImage value)? cropImage,
    TResult Function(_ApplyFilter value)? applyFilter,
    TResult Function(_AdjustImage value)? adjustImage,
    TResult Function(_ResetFilter value)? resetFilter,
    required TResult orElse(),
  }) {
    if (adjustImage != null) {
      return adjustImage(this);
    }
    return orElse();
  }
}

abstract class _AdjustImage implements ImagePreviewEvent {
  const factory _AdjustImage({
    required final double brightness,
    required final double contrast,
  }) = _$AdjustImageImpl;

  double get brightness;
  double get contrast;

  /// Create a copy of ImagePreviewEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AdjustImageImplCopyWith<_$AdjustImageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ResetFilterImplCopyWith<$Res> {
  factory _$$ResetFilterImplCopyWith(
    _$ResetFilterImpl value,
    $Res Function(_$ResetFilterImpl) then,
  ) = __$$ResetFilterImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ResetFilterImplCopyWithImpl<$Res>
    extends _$ImagePreviewEventCopyWithImpl<$Res, _$ResetFilterImpl>
    implements _$$ResetFilterImplCopyWith<$Res> {
  __$$ResetFilterImplCopyWithImpl(
    _$ResetFilterImpl _value,
    $Res Function(_$ResetFilterImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ImagePreviewEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$ResetFilterImpl implements _ResetFilter {
  const _$ResetFilterImpl();

  @override
  String toString() {
    return 'ImagePreviewEvent.resetFilter()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ResetFilterImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(File imageFile) initialize,
    required TResult Function() rotateImage,
    required TResult Function() cropImage,
    required TResult Function(String filterName) applyFilter,
    required TResult Function(double brightness, double contrast) adjustImage,
    required TResult Function() resetFilter,
  }) {
    return resetFilter();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(File imageFile)? initialize,
    TResult? Function()? rotateImage,
    TResult? Function()? cropImage,
    TResult? Function(String filterName)? applyFilter,
    TResult? Function(double brightness, double contrast)? adjustImage,
    TResult? Function()? resetFilter,
  }) {
    return resetFilter?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(File imageFile)? initialize,
    TResult Function()? rotateImage,
    TResult Function()? cropImage,
    TResult Function(String filterName)? applyFilter,
    TResult Function(double brightness, double contrast)? adjustImage,
    TResult Function()? resetFilter,
    required TResult orElse(),
  }) {
    if (resetFilter != null) {
      return resetFilter();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initialize value) initialize,
    required TResult Function(_RotateImage value) rotateImage,
    required TResult Function(_CropImage value) cropImage,
    required TResult Function(_ApplyFilter value) applyFilter,
    required TResult Function(_AdjustImage value) adjustImage,
    required TResult Function(_ResetFilter value) resetFilter,
  }) {
    return resetFilter(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initialize value)? initialize,
    TResult? Function(_RotateImage value)? rotateImage,
    TResult? Function(_CropImage value)? cropImage,
    TResult? Function(_ApplyFilter value)? applyFilter,
    TResult? Function(_AdjustImage value)? adjustImage,
    TResult? Function(_ResetFilter value)? resetFilter,
  }) {
    return resetFilter?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initialize value)? initialize,
    TResult Function(_RotateImage value)? rotateImage,
    TResult Function(_CropImage value)? cropImage,
    TResult Function(_ApplyFilter value)? applyFilter,
    TResult Function(_AdjustImage value)? adjustImage,
    TResult Function(_ResetFilter value)? resetFilter,
    required TResult orElse(),
  }) {
    if (resetFilter != null) {
      return resetFilter(this);
    }
    return orElse();
  }
}

abstract class _ResetFilter implements ImagePreviewEvent {
  const factory _ResetFilter() = _$ResetFilterImpl;
}

/// @nodoc
mixin _$ImagePreviewState {
  File get currentImage => throw _privateConstructorUsedError;
  File get originalImage => throw _privateConstructorUsedError;
  double get rotation => throw _privateConstructorUsedError;
  String get currentFilter => throw _privateConstructorUsedError;
  double get brightness => throw _privateConstructorUsedError;
  double get contrast => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get hasChanges => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  /// Create a copy of ImagePreviewState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ImagePreviewStateCopyWith<ImagePreviewState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ImagePreviewStateCopyWith<$Res> {
  factory $ImagePreviewStateCopyWith(
    ImagePreviewState value,
    $Res Function(ImagePreviewState) then,
  ) = _$ImagePreviewStateCopyWithImpl<$Res, ImagePreviewState>;
  @useResult
  $Res call({
    File currentImage,
    File originalImage,
    double rotation,
    String currentFilter,
    double brightness,
    double contrast,
    bool isLoading,
    bool hasChanges,
    String? error,
  });
}

/// @nodoc
class _$ImagePreviewStateCopyWithImpl<$Res, $Val extends ImagePreviewState>
    implements $ImagePreviewStateCopyWith<$Res> {
  _$ImagePreviewStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ImagePreviewState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentImage = null,
    Object? originalImage = null,
    Object? rotation = null,
    Object? currentFilter = null,
    Object? brightness = null,
    Object? contrast = null,
    Object? isLoading = null,
    Object? hasChanges = null,
    Object? error = freezed,
  }) {
    return _then(
      _value.copyWith(
            currentImage: null == currentImage
                ? _value.currentImage
                : currentImage // ignore: cast_nullable_to_non_nullable
                      as File,
            originalImage: null == originalImage
                ? _value.originalImage
                : originalImage // ignore: cast_nullable_to_non_nullable
                      as File,
            rotation: null == rotation
                ? _value.rotation
                : rotation // ignore: cast_nullable_to_non_nullable
                      as double,
            currentFilter: null == currentFilter
                ? _value.currentFilter
                : currentFilter // ignore: cast_nullable_to_non_nullable
                      as String,
            brightness: null == brightness
                ? _value.brightness
                : brightness // ignore: cast_nullable_to_non_nullable
                      as double,
            contrast: null == contrast
                ? _value.contrast
                : contrast // ignore: cast_nullable_to_non_nullable
                      as double,
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            hasChanges: null == hasChanges
                ? _value.hasChanges
                : hasChanges // ignore: cast_nullable_to_non_nullable
                      as bool,
            error: freezed == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ImagePreviewStateImplCopyWith<$Res>
    implements $ImagePreviewStateCopyWith<$Res> {
  factory _$$ImagePreviewStateImplCopyWith(
    _$ImagePreviewStateImpl value,
    $Res Function(_$ImagePreviewStateImpl) then,
  ) = __$$ImagePreviewStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    File currentImage,
    File originalImage,
    double rotation,
    String currentFilter,
    double brightness,
    double contrast,
    bool isLoading,
    bool hasChanges,
    String? error,
  });
}

/// @nodoc
class __$$ImagePreviewStateImplCopyWithImpl<$Res>
    extends _$ImagePreviewStateCopyWithImpl<$Res, _$ImagePreviewStateImpl>
    implements _$$ImagePreviewStateImplCopyWith<$Res> {
  __$$ImagePreviewStateImplCopyWithImpl(
    _$ImagePreviewStateImpl _value,
    $Res Function(_$ImagePreviewStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ImagePreviewState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentImage = null,
    Object? originalImage = null,
    Object? rotation = null,
    Object? currentFilter = null,
    Object? brightness = null,
    Object? contrast = null,
    Object? isLoading = null,
    Object? hasChanges = null,
    Object? error = freezed,
  }) {
    return _then(
      _$ImagePreviewStateImpl(
        currentImage: null == currentImage
            ? _value.currentImage
            : currentImage // ignore: cast_nullable_to_non_nullable
                  as File,
        originalImage: null == originalImage
            ? _value.originalImage
            : originalImage // ignore: cast_nullable_to_non_nullable
                  as File,
        rotation: null == rotation
            ? _value.rotation
            : rotation // ignore: cast_nullable_to_non_nullable
                  as double,
        currentFilter: null == currentFilter
            ? _value.currentFilter
            : currentFilter // ignore: cast_nullable_to_non_nullable
                  as String,
        brightness: null == brightness
            ? _value.brightness
            : brightness // ignore: cast_nullable_to_non_nullable
                  as double,
        contrast: null == contrast
            ? _value.contrast
            : contrast // ignore: cast_nullable_to_non_nullable
                  as double,
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        hasChanges: null == hasChanges
            ? _value.hasChanges
            : hasChanges // ignore: cast_nullable_to_non_nullable
                  as bool,
        error: freezed == error
            ? _value.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$ImagePreviewStateImpl implements _ImagePreviewState {
  const _$ImagePreviewStateImpl({
    required this.currentImage,
    required this.originalImage,
    this.rotation = 0.0,
    this.currentFilter = '',
    this.brightness = 0.0,
    this.contrast = 1.0,
    this.isLoading = false,
    this.hasChanges = false,
    this.error,
  });

  @override
  final File currentImage;
  @override
  final File originalImage;
  @override
  @JsonKey()
  final double rotation;
  @override
  @JsonKey()
  final String currentFilter;
  @override
  @JsonKey()
  final double brightness;
  @override
  @JsonKey()
  final double contrast;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool hasChanges;
  @override
  final String? error;

  @override
  String toString() {
    return 'ImagePreviewState(currentImage: $currentImage, originalImage: $originalImage, rotation: $rotation, currentFilter: $currentFilter, brightness: $brightness, contrast: $contrast, isLoading: $isLoading, hasChanges: $hasChanges, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ImagePreviewStateImpl &&
            (identical(other.currentImage, currentImage) ||
                other.currentImage == currentImage) &&
            (identical(other.originalImage, originalImage) ||
                other.originalImage == originalImage) &&
            (identical(other.rotation, rotation) ||
                other.rotation == rotation) &&
            (identical(other.currentFilter, currentFilter) ||
                other.currentFilter == currentFilter) &&
            (identical(other.brightness, brightness) ||
                other.brightness == brightness) &&
            (identical(other.contrast, contrast) ||
                other.contrast == contrast) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.hasChanges, hasChanges) ||
                other.hasChanges == hasChanges) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    currentImage,
    originalImage,
    rotation,
    currentFilter,
    brightness,
    contrast,
    isLoading,
    hasChanges,
    error,
  );

  /// Create a copy of ImagePreviewState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ImagePreviewStateImplCopyWith<_$ImagePreviewStateImpl> get copyWith =>
      __$$ImagePreviewStateImplCopyWithImpl<_$ImagePreviewStateImpl>(
        this,
        _$identity,
      );
}

abstract class _ImagePreviewState implements ImagePreviewState {
  const factory _ImagePreviewState({
    required final File currentImage,
    required final File originalImage,
    final double rotation,
    final String currentFilter,
    final double brightness,
    final double contrast,
    final bool isLoading,
    final bool hasChanges,
    final String? error,
  }) = _$ImagePreviewStateImpl;

  @override
  File get currentImage;
  @override
  File get originalImage;
  @override
  double get rotation;
  @override
  String get currentFilter;
  @override
  double get brightness;
  @override
  double get contrast;
  @override
  bool get isLoading;
  @override
  bool get hasChanges;
  @override
  String? get error;

  /// Create a copy of ImagePreviewState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ImagePreviewStateImplCopyWith<_$ImagePreviewStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
