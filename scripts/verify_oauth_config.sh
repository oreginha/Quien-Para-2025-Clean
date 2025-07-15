#!/bin/bash

# Script de verificación y configuración OAuth 2.0 para Quién Para
# Autor: Claude AI Assistant
# Fecha: $(date)

echo "🔧 VERIFICACIÓN OAUTH 2.0 - PROYECTO PLANING-931B8"
echo "=================================================="

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "\n${BLUE}📋 VERIFICANDO CONFIGURACIÓN ACTUAL...${NC}"

# Verificar que Firebase CLI esté instalado
if ! command -v firebase &> /dev/null; then
    echo -e "${RED}❌ Firebase CLI no está instalado${NC}"
    echo -e "${YELLOW}💡 Instalar con: npm install -g firebase-tools${NC}"
    exit 1
else
    echo -e "${GREEN}✅ Firebase CLI instalado${NC}"
fi

# Verificar autenticación de Firebase
if ! firebase projects:list &> /dev/null; then
    echo -e "${RED}❌ No autenticado en Firebase${NC}"
    echo -e "${YELLOW}💡 Ejecutar: firebase login${NC}"
    exit 1
else
    echo -e "${GREEN}✅ Autenticado en Firebase${NC}"
fi

# Verificar proyecto actual
CURRENT_PROJECT=$(firebase use --project planing-931b8 2>/dev/null)
if [[ $? -eq 0 ]]; then
    echo -e "${GREEN}✅ Proyecto planing-931b8 accesible${NC}"
else
    echo -e "${RED}❌ No se puede acceder al proyecto planing-931b8${NC}"
    exit 1
fi

echo -e "\n${BLUE}🌐 DOMINIOS A VERIFICAR:${NC}"
echo "• planing-931b8.web.app"
echo "• planing-931b8.firebaseapp.com"  
echo "• localhost"

echo -e "\n${BLUE}🔑 REDIRECT URIS A CONFIGURAR:${NC}"
echo "• https://planing-931b8.web.app/__/auth/handler"
echo "• https://planing-931b8.firebaseapp.com/__/auth/handler"
echo "• http://localhost:8080/__/auth/handler (desarrollo)"
echo "• http://localhost:3000/__/auth/handler (desarrollo)"

echo -e "\n${YELLOW}⚠️  PASOS MANUALES REQUERIDOS:${NC}"
echo -e "${YELLOW}1. Ir a: https://console.cloud.google.com/apis/credentials?project=planing-931b8${NC}"
echo -e "${YELLOW}2. Editar el OAuth 2.0 Client ID${NC}"
echo -e "${YELLOW}3. Agregar los Redirect URIs listados arriba${NC}"
echo -e "${YELLOW}4. Ir a: https://console.firebase.google.com/project/planing-931b8/authentication/settings${NC}"
echo -e "${YELLOW}5. Verificar dominios autorizados${NC}"

echo -e "\n${BLUE}🧪 COMANDOS DE PRUEBA:${NC}"
echo "# Test local:"
echo "flutter run -d chrome --web-hostname localhost --web-port 8080"
echo ""
echo "# Build y deploy:"
echo "flutter build web"
echo "firebase deploy --only hosting"
echo ""
echo "# Test producción:"
echo "# Ir a https://planing-931b8.web.app y probar Google Sign-In"

echo -e "\n${GREEN}✨ CONFIGURACIÓN COMPLETADA${NC}"
echo -e "${BLUE}📄 Documentación guardada en: docs/OAUTH_CONFIG_STEPS.md${NC}"
