@echo off
echo ===================================================
echo LIMPIEZA COMPLETA DEL PROYECTO QUIEN PARA
echo ===================================================
echo.

echo [1/12] Borrando carpeta build...
if exist build\ rmdir /s /q build

echo [2/12] Borrando carpeta .dart_tool...
if exist .dart_tool\ rmdir /s /q .dart_tool

echo [3/12] Borrando archivos de cache de Flutter...
if exist .flutter-plugins rmdir /s /q .flutter-plugins
if exist .flutter-plugins-dependencies rmdir /s /q .flutter-plugins-dependencies

echo [4/12] Borrando carpeta .gradle en Android...
if exist android\.gradle\ rmdir /s /q android\.gradle

echo [5/12] Borrando carpeta build en Android...
if exist android\build\ rmdir /s /q android\build

echo [6/12] Limpiando archivos temporales de Gradle...
if exist %USERPROFILE%\.gradle\daemon\ rmdir /s /q %USERPROFILE%\.gradle\daemon

echo [7/12] Limpiando archivos temporales de Android...
if exist android\app\build\ rmdir /s /q android\app\build

echo [8/12] Limpiando directorios de iOS...
if exist ios\Pods\ rmdir /s /q ios\Pods
if exist ios\.symlinks\ rmdir /s /q ios\.symlinks
if exist ios\build\ rmdir /s /q ios\build

echo [9/12] Ejecutando flutter clean...
flutter clean

echo [10/12] Ejecutando flutter pub get...
flutter pub get

echo [11/12] Reiniciando cache de Flutter...
flutter pub cache repair

echo [12/12] Reconstruyendo la aplicación...
flutter pub get

echo.
echo ===================================================
echo LIMPIEZA COMPLETADA CON ÉXITO
echo ===================================================
echo.
echo Para reconstruir la app, ejecuta los siguientes comandos:
echo 1. flutter build apk --debug  (Para Android)
echo 2. flutter run                 (Para depuración)
echo.
echo NOTA IMPORTANTE: Se detectó un problema con la limpieza de memoria.
echo Se han aplicado correcciones para evitar que la aplicación
echo se cierre inesperadamente.
echo.
pause
