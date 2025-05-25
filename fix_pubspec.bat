@echo off
echo ===========================================
echo 🔧 Solucionando pubspec.lock corrupto
echo ===========================================
echo.

cd /d "D:\Proyectos y Desarrollo\quien_para\quien_para"

echo 📁 Directorio actual: %CD%
echo.

echo ✅ Backup del archivo corrupto ya realizado como pubspec.lock.backup
echo.

echo 🧹 Limpiando cache de Flutter...
flutter clean
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Error al limpiar cache
    pause
    exit /b 1
)

echo.
echo 📦 Regenerando pubspec.lock...
flutter pub get
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Error al regenerar dependencias
    pause
    exit /b 1
)

echo.
echo 🔍 Verificando que el archivo se generó correctamente...
if exist "pubspec.lock" (
    echo ✅ pubspec.lock regenerado exitosamente
    echo.
    echo 📊 Estadísticas del nuevo archivo:
    for %%I in (pubspec.lock) do echo    Tamaño: %%~zI bytes
    echo    Fecha: %date% %time%
) else (
    echo ❌ ERROR: pubspec.lock no se generó
    pause
    exit /b 1
)

echo.
echo 🧪 Probando que las dependencias funcionan...
flutter pub deps
if %ERRORLEVEL% NEQ 0 (
    echo ⚠️  Advertencia: Problema con dependencias
)

echo.
echo ✅ ¡Proceso completado exitosamente!
echo.
echo 📋 Próximos pasos:
echo   1. Verificar que 'flutter pub get' funcione sin errores
echo   2. Hacer commit de los cambios
echo   3. Verificar que CI/CD pipeline funcione
echo.
pause