# 🔧 CONFIGURACIÓN OAUTH 2.0 AUTOMATIZADA - QUIÉN PARA

## Script de Configuración GCP OAuth Client

Este script utiliza Google Cloud CLI para configurar automáticamente los Redirect URIs necesarios para la autenticación web.

### Prerequisitos
```bash
# Instalar Google Cloud CLI
# https://cloud.google.com/sdk/docs/install

# Autenticarse
gcloud auth login

# Verificar proyecto actual
gcloud config get-value project
```

### Script de Configuración Automática

```bash
#!/bin/bash

# Variables de configuración
PROJECT_ID="planing-931b8"
OAUTH_CLIENT_NAME="Web client (auto created)"

echo "🔧 Configurando OAuth 2.0 para proyecto: $PROJECT_ID"

# 1. Verificar autenticación
echo "📋 Verificando autenticación..."
if ! gcloud auth list --filter=status:ACTIVE --format="value(account)" &>/dev/null; then
    echo "❌ No autenticado. Ejecutar: gcloud auth login"
    exit 1
fi

echo "✅ Autenticado correctamente"

# 2. Establecer proyecto
echo "🎯 Configurando proyecto..."
gcloud config set project $PROJECT_ID

# 3. Habilitar APIs necesarias
echo "🔌 Habilitando APIs necesarias..."
gcloud services enable iamcredentials.googleapis.com
gcloud services enable iam.googleapis.com

# 4. Listar OAuth clients existentes
echo "📝 Listando OAuth clients existentes..."
gcloud iam oauth-clients list --project=$PROJECT_ID --location=global --format="table(name,displayName)"

# 5. Buscar el client ID web
echo "🔍 Buscando OAuth Client ID para web..."
WEB_CLIENT_ID=$(gcloud iam oauth-clients list --project=$PROJECT_ID --location=global --filter="displayName:'Web client*'" --format="value(name.basename())")

if [ -z "$WEB_CLIENT_ID" ]; then
    echo "❌ No se encontró OAuth Client ID para web"
    echo "💡 Crear uno manualmente en: https://console.cloud.google.com/apis/credentials?project=$PROJECT_ID"
    exit 1
fi

echo "✅ Encontrado OAuth Client ID: $WEB_CLIENT_ID"

# 6. Configurar Redirect URIs
echo "🔗 Configurando Redirect URIs..."

# Redirect URIs necesarios
REDIRECT_URIS=(
    "https://planing-931b8.web.app/__/auth/handler"
    "https://planing-931b8.firebaseapp.com/__/auth/handler"
    "http://localhost:8080/__/auth/handler"
    "http://localhost:3000/__/auth/handler"
)

# Crear archivo temporal con configuración
TEMP_CONFIG=$(mktemp)
cat > $TEMP_CONFIG << EOF
{
  "redirectUris": [
EOF

for ((i=0; i<${#REDIRECT_URIS[@]}; i++)); do
    echo "    \"${REDIRECT_URIS[$i]}\"" >> $TEMP_CONFIG
    if [ $((i+1)) -lt ${#REDIRECT_URIS[@]} ]; then
        echo "," >> $TEMP_CONFIG
    fi
done

cat >> $TEMP_CONFIG << EOF
  ]
}
EOF

echo "📄 Configuración a aplicar:"
cat $TEMP_CONFIG

# 7. Aplicar configuración (requiere API REST ya que gcloud no soporta update directo)
echo "🚀 Aplicando configuración..."

# Obtener access token
ACCESS_TOKEN=$(gcloud auth print-access-token)

# Actualizar OAuth client via API REST
curl -X PATCH \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -H "X-Goog-User-Project: $PROJECT_ID" \
  -d @$TEMP_CONFIG \
  "https://iam.googleapis.com/v1/projects/$PROJECT_ID/locations/global/oauthClients/$WEB_CLIENT_ID"

# Limpiar archivo temporal
rm $TEMP_CONFIG

echo "✅ Configuración OAuth completada!"
echo ""
echo "🧪 Para probar:"
echo "1. cd D:\\Proyectos y Desarrollo\\Quien-Para-2025-Clean"
echo "2. flutter run -d chrome --web-hostname localhost --web-port 8080"
echo "3. Probar Google Sign-In en http://localhost:8080"
echo ""
echo "🌐 Para probar en producción:"
echo "1. flutter build web"
echo "2. firebase deploy --only hosting"
echo "3. Probar en https://planing-931b8.web.app"
```

### Ejecución del Script

1. **Guardar como** `configure_oauth.sh`
2. **Dar permisos:** `chmod +x configure_oauth.sh`
3. **Ejecutar:** `./configure_oauth.sh`

### Verificación Manual (Alternativa)

Si el script no funciona, realizar manualmente:

1. **Ir a:** https://console.cloud.google.com/apis/credentials?project=planing-931b8
2. **Buscar:** "Web client (auto created)" en OAuth 2.0 Client IDs
3. **Hacer clic en editar** (ícono de lápiz)
4. **En "Authorized redirect URIs" agregar:**
   ```
   https://planing-931b8.web.app/__/auth/handler
   https://planing-931b8.firebaseapp.com/__/auth/handler
   http://localhost:8080/__/auth/handler
   http://localhost:3000/__/auth/handler
   ```
5. **Guardar cambios**

### Comandos de Verificación

```bash
# Verificar configuración actual
gcloud iam oauth-clients describe WEB_CLIENT_ID \
  --project=planing-931b8 \
  --location=global

# Listar todos los clients
gcloud iam oauth-clients list \
  --project=planing-931b8 \
  --location=global
```

---
**🤖 Generado automáticamente**  
**📅 Fecha:** $(date)
**⚡ Siguiente paso:** Ejecutar script y probar autenticación
