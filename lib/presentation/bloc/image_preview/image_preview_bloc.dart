// ignore_for_file: always_specify_types

import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:quien_para/domain/interfaces/image_service_interface.dart';

part 'image_preview_bloc.freezed.dart';
part 'image_preview_event.dart';
part 'image_preview_state.dart';

class ImagePreviewBloc extends Bloc<ImagePreviewEvent, ImagePreviewState> {
  final ImageServiceInterface _imageService = GetIt.I<ImageServiceInterface>();

  ImagePreviewBloc() : super(ImagePreviewState.initial()) {
    on<_Initialize>(_onInitialize);
    on<_RotateImage>(_onRotateImage);
    on<_CropImage>(_onCropImage);
    on<_ApplyFilter>(_onApplyFilter);
    on<_AdjustImage>(_onAdjustImage);
    on<_ResetFilter>(_onResetFilter);
  }

  void _onInitialize(_Initialize event, Emitter<ImagePreviewState> emit) {
    emit(
      state.copyWith(
        currentImage: event.imageFile,
        originalImage: event.imageFile,
      ),
    );
  }

  Future<void> _onRotateImage(
    _RotateImage event,
    Emitter<ImagePreviewState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final File? rotatedImage = await _imageService.rotateImage(
        state.currentImage,
        90,
      );
      if (rotatedImage != null) {
        emit(
          state.copyWith(
            currentImage: rotatedImage,
            rotation: state.rotation + 90,
            hasChanges: true,
            isLoading: false,
          ),
        );
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: 'Error al rotar la imagen'));
    }
  }

  Future<void> _onCropImage(
    _CropImage event,
    Emitter<ImagePreviewState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final File? croppedImage = await _imageService.cropImage(
        state.currentImage,
      );
      if (croppedImage != null) {
        emit(
          state.copyWith(
            currentImage: croppedImage,
            hasChanges: true,
            isLoading: false,
          ),
        );
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      emit(
        state.copyWith(isLoading: false, error: 'Error al recortar la imagen'),
      );
    }
  }

  Future<void> _onApplyFilter(
    _ApplyFilter event,
    Emitter<ImagePreviewState> emit,
  ) async {
    if (state.currentFilter == event.filterName) {
      add(const ImagePreviewEvent.resetFilter());
      return;
    }

    emit(state.copyWith(isLoading: true));
    try {
      final File? filteredImage = await _imageService.applyFilter(
        state.currentImage,
        event.filterName,
      );
      if (filteredImage != null) {
        emit(
          state.copyWith(
            currentImage: filteredImage,
            currentFilter: event.filterName,
            hasChanges: true,
            isLoading: false,
          ),
        );
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      emit(
        state.copyWith(isLoading: false, error: 'Error al aplicar el filtro'),
      );
    }
  }

  Future<void> _onAdjustImage(
    _AdjustImage event,
    Emitter<ImagePreviewState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final File? adjustedImage = await _imageService.adjustImage(
        state.currentImage,
        brightness: event.brightness,
        contrast: event.contrast,
      );
      if (adjustedImage != null) {
        emit(
          state.copyWith(
            currentImage: adjustedImage,
            brightness: event.brightness,
            contrast: event.contrast,
            hasChanges: true,
            isLoading: false,
          ),
        );
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      emit(
        state.copyWith(isLoading: false, error: 'Error al ajustar la imagen'),
      );
    }
  }

  void _onResetFilter(_ResetFilter event, Emitter<ImagePreviewState> emit) {
    emit(state.copyWith(currentFilter: '', hasChanges: true));
  }
}
