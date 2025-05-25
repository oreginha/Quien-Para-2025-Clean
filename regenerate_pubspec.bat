@echo off
echo Regenerando pubspec.lock...
echo.

echo Limpiando cache de Flutter...
flutter clean

echo.
echo Obteniendo dependencias...
flutter pub get

echo.
echo Verificando que funcione...
flutter doctor

echo.
echo ✅ pubspec.lock regenerado exitosamente!
pause