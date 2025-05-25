@echo off
echo ===================================================
echo    Exportador de Estructura de Firebase
echo ===================================================
echo.
echo Este script exportara la estructura completa de Firebase
echo a un archivo JSON en la carpeta firebase_export.
echo.

:: Crear carpeta para exportaciones si no existe
if not exist "firebase_export" mkdir firebase_export

echo Iniciando proceso de exportacion...
echo.

:: Ejecutar el script de exportación desde Dart
call dart run lib/scripts/export_collections.dart

echo.
echo Si el proceso fue exitoso, se ha generado un archivo JSON
echo con la estructura en la carpeta firebase_export.
echo.

pause
