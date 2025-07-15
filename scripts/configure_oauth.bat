@echo off
:: Configuración OAuth 2.0 para Quién Para - Batch Script
:: Proyecto: planing-931b8
:: Autor: Claude AI Assistant

setlocal enabledelayedexpansion

set PROJECT_ID=planing-931b8

echo.
echo =======================================================
echo 🔧 CONFIGURACION OAUTH 2.0 - PROYECTO: %PROJECT_ID%
echo =======================================================
echo.

:: 1. Verificar si gcloud está instalado
echo 📋 Verificando Google Cloud CLI...
gcloud version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Google Cloud CLI no está instalado
    echo 💡 Instalar desde: https://cloud.google.com/sdk/docs/install
    pause
    exit /b 1
)
echo ✅ Google Cloud CLI instalado correctamente

:: 2. Verificar autenticación
echo.
echo 📋 Verificando autenticación...
for /f "tokens=*" %%a in ('gcloud auth list --filter="status:ACTIVE" --format="value(account)" 2^>nul') do set ACTIVE_ACCOUNT=%%a
if "!ACTIVE_ACCOUNT!"=="" (
    echo ❌ No autenticado en Google Cloud
    echo 💡 Ejecutar: gcloud auth login
    pause
    exit /b 1
)
echo ✅ Autenticado como: !ACTIVE_ACCOUNT!

:: 3. Establecer proyecto
echo.
echo 🎯 Configurando proyecto...
gcloud config set project %PROJECT_ID%

:: 4. Habilitar APIs necesarias
echo.
echo 🔌 Habilitando APIs necesarias...
echo Habilitando IAM Credentials API...
gcloud services enable iamcredentials.googleapis.com >nul 2>&1
echo Habilitando IAM API...
gcloud services enable iam.googleapis.com >nul 2>&1
echo ✅ APIs habilitadas

:: 5. Listar OAuth clients existentes
echo.
echo 📝 Listando OAuth clients existentes...
echo Clients disponibles:
gcloud iam oauth-clients list --project=%PROJECT_ID% --location=global --format="table(name.basename(),displayName)"

:: 6. Buscar el client ID web - método alternativo
echo.
echo 🔍 Buscando OAuth Client ID para web...

:: Crear archivo temporal para almacenar la lista
set TEMP_FILE=%TEMP%\oauth_clients.txt
gcloud iam oauth-clients list --project=%PROJECT_ID% --location=global --format="value(name.basename(),displayName)" > "%TEMP_FILE%"

set WEB_CLIENT_ID=
for /f "tokens=1,2 delims=	" %%a in ('type "%TEMP_FILE%"') do (
    echo %%b | findstr /i "web client" >nul && set WEB_CLIENT_ID=%%a
    if "!WEB_CLIENT_ID!"=="" (
        echo %%b | findstr /i "auto created" >nul && set WEB_CLIENT_ID=%%a
    )
)

del "%TEMP_FILE%" >nul 2>&1

if "!WEB_CLIENT_ID!"=="" (
    echo ❌ No se encontró OAuth Client ID para web
    echo 💡 Necesitas crear un OAuth Client ID manualmente:
    echo    1. Ir a: https://console.cloud.google.com/apis/credentials?project=%PROJECT_ID%
    echo    2. Crear OAuth 2.0 Client ID tipo 'Web application'
    echo    3. Ejecutar este script nuevamente
    pause
    exit /b 1
)

echo ✅ Encontrado OAuth Client ID: !WEB_CLIENT_ID!

:: 7. Mostrar configuración actual
echo.
echo 📄 Configuración actual del OAuth Client:
gcloud iam oauth-clients describe !WEB_CLIENT_ID! --project=%PROJECT_ID% --location=global

:: 8. Crear archivo JSON con configuración
echo.
echo 🔗 Preparando configuración de Redirect URIs...

set CONFIG_FILE=%TEMP%\oauth_config.json
echo { > "%CONFIG_FILE%"
echo   "redirectUris": [ >> "%CONFIG_FILE%"
echo     "https://planing-931b8.web.app/__/auth/handler", >> "%CONFIG_FILE%"
echo     "https://planing-931b8.firebaseapp.com/__/auth/handler", >> "%CONFIG_FILE%"
echo     "http://localhost:8080/__/auth/handler", >> "%CONFIG_FILE%"
echo     "http://localhost:3000/__/auth/handler" >> "%CONFIG_FILE%"
echo   ] >> "%CONFIG_FILE%"
echo } >> "%CONFIG_FILE%"

echo 📄 Configuración a aplicar:
type "%CONFIG_FILE%"

:: 9. Aplicar configuración via API REST usando curl
echo.
echo 🚀 Aplicando configuración...

:: Obtener access token
for /f "tokens=*" %%a in ('gcloud auth print-access-token 2^>nul') do set ACCESS_TOKEN=%%a

if "!ACCESS_TOKEN!"=="" (
    echo ❌ No se pudo obtener access token
    goto manual_config
)

:: Verificar si curl está disponible
curl --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ⚠️ curl no está disponible, usando configuración manual
    goto manual_config
)

:: Realizar petición PATCH usando curl
set API_URL=https://iam.googleapis.com/v1/projects/%PROJECT_ID%/locations/global/oauthClients/!WEB_CLIENT_ID!

curl -s -X PATCH ^
  -H "Authorization: Bearer !ACCESS_TOKEN!" ^
  -H "Content-Type: application/json" ^
  -H "X-Goog-User-Project: %PROJECT_ID%" ^
  -d @"%CONFIG_FILE%" ^
  "%API_URL%" > "%TEMP%\response.json"

:: Verificar respuesta
findstr /i "error" "%TEMP%\response.json" >nul
if %errorlevel% equ 0 (
    echo ❌ Error al aplicar configuración:
    type "%TEMP%\response.json"
    goto manual_config
) else (
    echo ✅ Configuración OAuth aplicada exitosamente!
    goto verify_config
)

:manual_config
echo.
echo 💡 CONFIGURACIÓN MANUAL REQUERIDA:
echo ===================================
echo 1. Ir a: https://console.cloud.google.com/apis/credentials?project=%PROJECT_ID%
echo 2. Buscar y editar el OAuth Client ID: !WEB_CLIENT_ID!
echo 3. En "Authorized redirect URIs" agregar:
echo    - https://planing-931b8.web.app/__/auth/handler
echo    - https://planing-931b8.firebaseapp.com/__/auth/handler
echo    - http://localhost:8080/__/auth/handler
echo    - http://localhost:3000/__/auth/handler
echo 4. Guardar cambios
echo.
echo Presiona cualquier tecla cuando hayas completado la configuración...
pause >nul
goto verify_config

:verify_config
:: Limpiar archivos temporales
del "%CONFIG_FILE%" >nul 2>&1
del "%TEMP%\response.json" >nul 2>&1

:: 10. Verificar configuración final
echo.
echo 🔍 Verificando configuración final...
gcloud iam oauth-clients describe !WEB_CLIENT_ID! --project=%PROJECT_ID% --location=global --format="value(redirectUris)"

echo.
echo ✨ CONFIGURACIÓN COMPLETADA
echo ===============================
echo.
echo 🧪 Para probar localmente:
echo 1. Abrir nueva terminal en esta carpeta
echo 2. flutter run -d chrome --web-hostname localhost --web-port 8080
echo 3. Probar Google Sign-In en http://localhost:8080
echo.
echo 🌐 Para probar en producción:
echo 1. flutter build web
echo 2. firebase deploy --only hosting
echo 3. Probar en https://planing-931b8.web.app
echo.
echo 📚 Documentación adicional:
echo - docs\OAUTH_CONFIG_STEPS.md
echo - docs\OAUTH_EXECUTIVE_SUMMARY.md
echo - docs\CONFIGURE_OAUTH_AUTOMATED.md
echo.
echo ✅ Script completado exitosamente!
pause
