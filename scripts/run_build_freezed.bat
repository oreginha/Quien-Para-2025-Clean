@echo off
echo **************************************************************
echo *                                                            *
echo *  Generando archivos Freezed para el BLoC de Aplicaciones  *
echo *                                                            *
echo **************************************************************
echo.

echo Ejecutando build_runner para generar archivos Freezed...
echo.
dart run build_runner build --delete-conflicting-outputs
echo.
echo Generación completada.
echo.
echo Si ves errores arriba, verifica:
echo   1. Las dependencias en pubspec.yaml
echo   2. La sintaxis correcta en los archivos freezed
echo   3. Que has ejecutado 'flutter pub get' recientemente
echo.
pause
