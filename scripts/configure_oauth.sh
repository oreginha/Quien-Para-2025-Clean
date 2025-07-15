#!/bin/bash

# Script de configuración OAuth 2.0 para Quién Para
# Proyecto: planing-931b8
# Autor: Claude AI Assistant

# Variables de configuración
PROJECT_ID="planing-931b8"
OAUTH_CLIENT_NAME="Web client (auto created)"

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔧 CONFIGURACIÓN OAUTH 2.0 - PROYECTO: $PROJECT_ID${NC}"
echo "======================================================="

# 1. Verificar autenticación
echo -e "\n${BLUE}📋 Verificando autenticación...${NC}"
if ! gcloud auth list --filter=status:ACTIVE --format="value(account)" &>/dev/null; then
    echo -e "${RED}❌ No autenticado en Google Cloud${NC}"
    echo -e "${YELLOW}💡 Ejecutar: gcloud auth login${NC}"
    exit 1
fi

ACTIVE_ACCOUNT=$(gcloud auth list --filter=status:ACTIVE --format="value(account)")
echo -e "${GREEN}✅ Autenticado como: $ACTIVE_ACCOUNT${NC}"

# 2. Establecer proyecto
echo -e "\n${BLUE}🎯 Configurando proyecto...${NC}"
gcloud config set project $PROJECT_ID

# 3. Habilitar APIs necesarias
echo -e "\n${BLUE}🔌 Habilitando APIs necesarias...${NC}"
gcloud services enable iamcredentials.googleapis.com
gcloud services enable iam.googleapis.com

# 4. Listar OAuth clients existentes
echo -e "\n${BLUE}📝 Listando OAuth clients existentes...${NC}"
echo "Clients disponibles:"
gcloud iam oauth-clients list --project=$PROJECT_ID --location=global --format="table(name.basename(),displayName)"

# 5. Buscar el client ID web
echo -e "\n${BLUE}🔍 Buscando OAuth Client ID para web...${NC}"
WEB_CLIENT_ID=$(gcloud iam oauth-clients list --project=$PROJECT_ID --location=global --filter="displayName~'Web client'" --format="value(name.basename())" | head -n1)

if [ -z "$WEB_CLIENT_ID" ]; then
    echo -e "${RED}❌ No se encontró OAuth Client ID para web${NC}"
    echo -e "${YELLOW}💡 Crear uno manualmente en: https://console.cloud.google.com/apis/credentials?project=$PROJECT_ID${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Encontrado OAuth Client ID: $WEB_CLIENT_ID${NC}"

# 6. Mostrar configuración actual
echo -e "\n${BLUE}📄 Configuración actual del OAuth Client:${NC}"
gcloud iam oauth-clients describe $WEB_CLIENT_ID --project=$PROJECT_ID --location=global

# 7. Configurar Redirect URIs via API REST
echo -e "\n${BLUE}🔗 Configurando Redirect URIs...${NC}"

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
    else
        echo "" >> $TEMP_CONFIG
    fi
done

cat >> $TEMP_CONFIG << EOF
  ]
}
EOF

echo -e "${YELLOW}📄 Configuración a aplicar:${NC}"
cat $TEMP_CONFIG

# 8. Aplicar configuración
echo -e "\n${BLUE}🚀 Aplicando configuración...${NC}"

# Obtener access token
ACCESS_TOKEN=$(gcloud auth print-access-token)

# Actualizar OAuth client via API REST
RESPONSE=$(curl -s -X PATCH \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -H "X-Goog-User-Project: $PROJECT_ID" \
  -d @$TEMP_CONFIG \
  "https://iam.googleapis.com/v1/projects/$PROJECT_ID/locations/global/oauthClients/$WEB_CLIENT_ID")

# Verificar respuesta
if echo "$RESPONSE" | grep -q "error"; then
    echo -e "${RED}❌ Error al aplicar configuración:${NC}"
    echo "$RESPONSE"
    rm $TEMP_CONFIG
    exit 1
fi

echo -e "${GREEN}✅ Configuración OAuth aplicada exitosamente!${NC}"

# Limpiar archivo temporal
rm $TEMP_CONFIG

# 9. Verificar configuración final
echo -e "\n${BLUE}🔍 Verificando configuración final...${NC}"
gcloud iam oauth-clients describe $WEB_CLIENT_ID --project=$PROJECT_ID --location=global --format="value(redirectUris)"

echo -e "\n${GREEN}✨ CONFIGURACIÓN COMPLETADA${NC}"
echo -e "${BLUE}===============================${NC}"
echo ""
echo -e "${YELLOW}🧪 Para probar localmente:${NC}"
echo "1. cd 'D:\\Proyectos y Desarrollo\\Quien-Para-2025-Clean'"
echo "2. flutter run -d chrome --web-hostname localhost --web-port 8080"
echo "3. Probar Google Sign-In en http://localhost:8080"
echo ""
echo -e "${YELLOW}🌐 Para probar en producción:${NC}"
echo "1. flutter build web"
echo "2. firebase deploy --only hosting"
echo "3. Probar en https://planing-931b8.web.app"
echo ""
echo -e "${YELLOW}📚 Documentación adicional:${NC}"
echo "- docs/OAUTH_CONFIG_STEPS.md"
echo "- docs/OAUTH_EXECUTIVE_SUMMARY.md"
echo "- docs/CONFIGURE_OAUTH_AUTOMATED.md"
