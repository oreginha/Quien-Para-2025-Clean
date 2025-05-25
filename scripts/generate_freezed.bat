@echo off
echo Ejecutando build_runner para generar archivos Freezed...
flutter pub run build_runner build --delete-conflicting-outputs
echo Generación completada.
pause
