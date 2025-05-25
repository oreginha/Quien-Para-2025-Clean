@echo off
echo ===================================================
echo    Exportador de Datos de Firebase Firestore
echo ===================================================
echo.
echo Este script exportara todos los datos de Firebase Firestore
echo a un archivo JSON en la carpeta firebase_export.
echo.

:: Crear carpeta para exportaciones si no existe
if not exist "firebase_export" mkdir firebase_export

echo Iniciando proceso de exportacion de datos...
echo.

:: Ejecutar el script de exportación desde Dart
call dart run lib/scripts/export_collections.dart --full-data

echo.
echo Si el proceso fue exitoso, se ha generado un archivo JSON
echo con todos los datos en la carpeta firebase_export.
echo.

pause
