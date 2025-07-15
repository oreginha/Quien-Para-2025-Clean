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
    $gcloudVersion = gcloud version --format="value(Google Cloud SDK)" 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-ColoredOutput "✅ Google Cloud CLI instalado: $gcloudVersion" "Green"
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
    if ($activeAccount) {
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
gcloud services enable iamcredentials.googleapis.com
gcloud services enable iam.googleapis.com

# 5. Listar OAuth clients existentes
Write-ColoredOutput "`n📝 Listando OAuth clients existentes..." "Blue"
Write-ColoredOutput "Clients disponibles:" "White"
gcloud iam oauth-clients list --project=$ProjectId --location=global --format='table(name.basename(),displayName)'

# 6. Buscar el client ID web
Write-ColoredOutput "`n🔍 Buscando OAuth Client ID para web..." "Blue"
$webClientId = gcloud iam oauth-clients list --project=$ProjectId --location=global --filter='displayName~Web client' --format='value(name.basename())' 2>$null | Select-Object -First 1

if (-not $webClientId) {
    Write-ColoredOutput "❌ No se encontró OAuth Client ID para web" "Red"
    Write-ColoredOutput "💡 Crear uno manualmente en: https://console.cloud.google.com/apis/credentials?project=$ProjectId" "Yellow"
    exit 1
}

Write-ColoredOutput "✅ Encontrado OAuth Client ID: $webClientId" "Green"

# 7. Mostrar configuración actual
Write-ColoredOutput "`n📄 Configuración actual del OAuth Client:" "Blue"
gcloud iam oauth-clients describe $webClientId --project=$ProjectId --location=global

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
    
    # Headers para la petición
    $headers = @{
        "Authorization" = "Bearer $accessToken"
        "Content-Type" = "application/json"
        "X-Goog-User-Project" = $ProjectId
    }
    
    # URL de la API
    $apiUrl = "https://iam.googleapis.com/v1/projects/$ProjectId/locations/global/oauthClients/$webClientId"
    
    # Realizar petición PATCH
    $response = Invoke-RestMethod -Uri $apiUrl -Method Patch -Headers $headers -Body $config
    
    Write-ColoredOutput "✅ Configuración OAuth aplicada exitosamente!" "Green"
    
} catch {
    Write-ColoredOutput "❌ Error al aplicar configuración:" "Red"
    Write-Host $_.Exception.Message
    Remove-Item $tempFile -Force
    exit 1
}

# Limpiar archivo temporal
Remove-Item $tempFile -Force

# 11. Verificar configuración final
Write-ColoredOutput "`n🔍 Verificando configuración final..." "Blue"
$finalConfig = gcloud iam oauth-clients describe $webClientId --project=$ProjectId --location=global --format='value(redirectUris)'
Write-Host "Redirect URIs configurados: $finalConfig"

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
