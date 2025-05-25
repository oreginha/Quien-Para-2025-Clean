#!/bin/bash
# Script para regenerar pubspec.lock y hacer commit
set -e

echo "🔧 Regenerando pubspec.lock..."

# Limpiar y obtener dependencias
flutter clean
flutter pub get

# Verificar que el archivo se generó
if [ -f "pubspec.lock" ]; then
    echo "✅ pubspec.lock generado exitosamente"
    
    # Verificar el contenido
    if grep -q "packages:" "pubspec.lock" && ! grep -q "<<<<<<" "pubspec.lock"; then
        echo "✅ Archivo válido sin conflictos de merge"
        
        # Hacer commit
        git add pubspec.lock fix_pubspec.bat regenerate_pubspec.bat
        git commit -m "🐛 Fix: Regenerate corrupted pubspec.lock

- Removed Git merge conflict markers from pubspec.lock
- Added utility scripts for future pubspec.lock regeneration
- Resolves CI/CD pipeline failures in format and build jobs

Fixes #6"
        
        echo "✅ Commit realizado exitosamente"
        echo "🚀 Ahora puedes hacer push para triggear el CI/CD pipeline"
    else
        echo "❌ ERROR: El archivo aún contiene conflictos o está malformado"
        exit 1
    fi
else
    echo "❌ ERROR: No se pudo generar pubspec.lock"
    exit 1
fi