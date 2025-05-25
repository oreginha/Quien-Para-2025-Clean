@echo off
echo ===================================================
echo    Cargador de Datos Ficticios para Firebase
echo ===================================================
echo.
echo Este script cargara automaticamente datos ficticios en Firebase
echo para facilitar el testeo de la aplicacion.
echo.
echo Asegurate de tener configurado Firebase correctamente.
echo.

:: Crear carpeta para exportaciones si no existe
if not exist "firebase_export" mkdir firebase_export

echo Iniciando proceso de carga de datos ficticios...
echo.

:: Ejecutar el script de carga de datos ficticios
call dart run lib/scripts/firebase_test_data_loader.dart

echo.
echo Si el proceso fue exitoso, se han cargado datos ficticios en Firebase
echo y se ha generado un informe en la carpeta firebase_export.
echo.

pause