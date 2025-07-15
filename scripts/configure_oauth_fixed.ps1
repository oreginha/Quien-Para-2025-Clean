# Configuración OAuth 2.0 para Quién Para - Windows PowerShell
# Proyecto: planing-931b8
# Autor: Claude AI Assistant

param(
    [string]$ProjectId = "planing-931b8"
)

# Función para escribir mensajes coloreados
function Write-ColoredOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    
    $colorMap = @{
        "Red" = "Red"
        "Green" = "Green"
        "Yellow" = "Yellow"
        "Blue" = "Cyan"
        "White" = "White"
    }
    
    Write-Host $Message -ForegroundColor $colorMap[$Color]
}

Write-ColoredOutput "🔧 CONFIGURACIÓN OAUTH 2.0 - PROYECTO: $ProjectId" "Blue"
Write-ColoredOutput "=======================================================" "Blue"

# 1. Verificar si gcloud está instalado
Write-ColoredOutput "`n📋 Verificando Google Cloud CLI..." "Blue"
try {
    $gcloudCheck = gcloud version 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-ColoredOutput "✅ Google Cloud CLI instalado correctamente" "Green"
    } else {
        throw "gcloud no encontrado"
    }
} catch {
    Write-ColoredOutput "❌ Google Cloud CLI no está instalado" "Red"
    Write-ColoredOutput "💡 Instalar desde: https://cloud.google.com/sdk/docs/install" "Yellow"
    exit 1
}

# 2. Verificar autenticación
Write-ColoredOutput "`n📋 Verificando autenticación..." "Blue"
try {
    $activeAccount = gcloud auth list --filter="status:ACTIVE" --format="value(account)" 2>$null
    if ($activeAccount -and $LASTEXITCODE -eq 0) {
        Write-ColoredOutput "✅ Autenticado como: $activeAccount" "Green"
    } else {
        throw "No autenticado"
    }
} catch {
    Write-ColoredOutput "❌ No autenticado en Google Cloud" "Red"
    Write-ColoredOutput "💡 Ejecutar: gcloud auth login" "Yellow"
    exit 1
}

# 3. Establecer proyecto
Write-ColoredOutput "`n🎯 Configurando proyecto..." "Blue"
gcloud config set project $ProjectId

# 4. Habilitar APIs necesarias
Write-ColoredOutput "`n🔌 Habilitando APIs necesarias..." "Blue"
Write-ColoredOutput "Habilitando IAM Credentials API..." "White"
gcloud services enable iamcredentials.googleapis.com 2>$null
Write-ColoredOutput "Habilitando IAM API..." "White"
gcloud services enable iam.googleapis.com 2>$null

# 5. Listar OAuth clients existentes
Write-ColoredOutput "`n📝 Listando OAuth clients existentes..." "Blue"
Write-ColoredOutput "Clients disponibles:" "White"

# Usar invoke-expression para manejar las comillas correctamente
$listCommand = "gcloud iam oauth-clients list --project=$ProjectId --location=global --format='table(name.basename(),displayName)'"
Invoke-Expression $listCommand

# 6. Buscar el client ID web
Write-ColoredOutput "`n🔍 Buscando OAuth Client ID para web..." "Blue"

# Comando alternativo para buscar web client
$findCommand = "gcloud iam oauth-clients list --project=$ProjectId --location=global --format='value(name.basename(),displayName)'"
$allClients = Invoke-Expression $findCommand

$webClientId = $null
foreach ($line in $allClients) {
    if ($line -match "Web client" -or $line -match "auto created") {
        $webClientId = ($line -split "`t")[0]
        break
    }
}

if (-not $webClientId) {
    Write-ColoredOutput "❌ No se encontró OAuth Client ID para web" "Red"
    Write-ColoredOutput "💡 Necesitas crear un OAuth Client ID manualmente:" "Yellow"
    Write-ColoredOutput "   1. Ir a: https://console.cloud.google.com/apis/credentials?project=$ProjectId" "Yellow"
    Write-ColoredOutput "   2. Crear OAuth 2.0 Client ID tipo 'Web application'" "Yellow"
    Write-ColoredOutput "   3. Ejecutar este script nuevamente" "Yellow"
    exit 1
}

Write-ColoredOutput "✅ Encontrado OAuth Client ID: $webClientId" "Green"

# 7. Mostrar configuración actual
Write-ColoredOutput "`n📄 Configuración actual del OAuth Client:" "Blue"
$describeCommand = "gcloud iam oauth-clients describe $webClientId --project=$ProjectId --location=global"
Invoke-Expression $describeCommand

# 8. Configurar Redirect URIs
Write-ColoredOutput "`n🔗 Configurando Redirect URIs..." "Blue"

# Redirect URIs necesarios
$redirectUris = @(
    "https://planing-931b8.web.app/__/auth/handler",
    "https://planing-931b8.firebaseapp.com/__/auth/handler",
    "http://localhost:8080/__/auth/handler",
    "http://localhost:3000/__/auth/handler"
)

# Crear configuración JSON
$config = @{
    redirectUris = $redirectUris
} | ConvertTo-Json -Depth 3

Write-ColoredOutput "📄 Configuración a aplicar:" "Yellow"
Write-Host $config

# 9. Crear archivo temporal
$tempFile = [System.IO.Path]::GetTempFileName()
$config | Out-File -FilePath $tempFile -Encoding UTF8

# 10. Aplicar configuración via API REST
Write-ColoredOutput "`n🚀 Aplicando configuración..." "Blue"

try {
    # Obtener access token
    $accessToken = gcloud auth print-access-token 2>$null
    
    if (-not $accessToken -or $LASTEXITCODE -ne 0) {
        throw "No se pudo obtener access token"
    }
    
    # Headers para la petición
    $headers = @{
        "Authorization" = "Bearer $accessToken"
        "Content-Type" = "application/json"
        "X-Goog-User-Project" = $ProjectId
    }
    
    # URL de la API
    $apiUrl = "https://iam.googleapis.com/v1/projects/$ProjectId/locations/global/oauthClients/$webClientId"
    
    Write-ColoredOutput "Enviando petición PATCH a Google Cloud IAM API..." "White"
    
    # Realizar petición PATCH
    $response = Invoke-RestMethod -Uri $apiUrl -Method Patch -Headers $headers -Body $config -ErrorAction Stop
    
    Write-ColoredOutput "✅ Configuración OAuth aplicada exitosamente!" "Green"
    
} catch {
    Write-ColoredOutput "❌ Error al aplicar configuración:" "Red"
    Write-ColoredOutput "Error: $($_.Exception.Message)" "Red"
    
    # Información adicional para debug
    if ($_.Exception.Response) {
        $statusCode = $_.Exception.Response.StatusCode
        Write-ColoredOutput "Status Code: $statusCode" "Red"
    }
    
    Remove-Item $tempFile -Force -ErrorAction SilentlyContinue
    
    Write-ColoredOutput "`n💡 Configuración manual alternativa:" "Yellow"
    Write-ColoredOutput "1. Ir a: https://console.cloud.google.com/apis/credentials?project=$ProjectId" "Yellow"
    Write-ColoredOutput "2. Editar OAuth Client ID: $webClientId" "Yellow"
    Write-ColoredOutput "3. Agregar estos Redirect URIs:" "Yellow"
    foreach ($uri in $redirectUris) {
        Write-ColoredOutput "   - $uri" "Yellow"
    }
    
    exit 1
}

# Limpiar archivo temporal
Remove-Item $tempFile -Force -ErrorAction SilentlyContinue

# 11. Verificar configuración final
Write-ColoredOutput "`n🔍 Verificando configuración final..." "Blue"
$verifyCommand = "gcloud iam oauth-clients describe $webClientId --project=$ProjectId --location=global --format='value(redirectUris)'"
$finalConfig = Invoke-Expression $verifyCommand

Write-Host "Redirect URIs configurados:"
if ($finalConfig) {
    foreach ($uri in $finalConfig -split ",") {
        Write-Host "  ✓ $($uri.Trim())" -ForegroundColor Green
    }
} else {
    Write-ColoredOutput "No se pudieron verificar los URIs configurados" "Yellow"
}

Write-ColoredOutput "`n✨ CONFIGURACIÓN COMPLETADA" "Green"
Write-ColoredOutput "===============================" "Blue"
Write-Host ""
Write-ColoredOutput "🧪 Para probar localmente:" "Yellow"
Write-Host "1. cd 'D:\Proyectos y Desarrollo\Quien-Para-2025-Clean'"
Write-Host "2. flutter run -d chrome --web-hostname localhost --web-port 8080"
Write-Host "3. Probar Google Sign-In en http://localhost:8080"
Write-Host ""
Write-ColoredOutput "🌐 Para probar en producción:" "Yellow"
Write-Host "1. flutter build web"
Write-Host "2. firebase deploy --only hosting"
Write-Host "3. Probar en https://planing-931b8.web.app"
Write-Host ""
Write-ColoredOutput "📚 Documentación adicional:" "Yellow"
Write-Host "- docs/OAUTH_CONFIG_STEPS.md"
Write-Host "- docs/OAUTH_EXECUTIVE_SUMMARY.md"
Write-Host "- docs/CONFIGURE_OAUTH_AUTOMATED.md"
