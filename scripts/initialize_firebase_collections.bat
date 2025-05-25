@echo off
echo ===================================================
echo    Inicializador de Colecciones de Firebase
echo ===================================================
echo.
echo Este script creara automaticamente las colecciones en Firebase
echo con la estructura definida en los modelos de datos.
echo.
echo Asegurate de tener configurado Firebase correctamente.
echo.

:: Crear carpeta para exportaciones si no existe
if not exist "firebase_export" mkdir firebase_export

echo Iniciando proceso de creacion de colecciones...
echo.

:: Ejecutar el script de inicialización
call dart run lib/scripts/firebase_initializer_cli.dart

echo.
echo Si el proceso fue exitoso, las colecciones han sido creadas
echo y se ha generado un archivo JSON con la estructura en la
echo carpeta firebase_export.
echo.

pause