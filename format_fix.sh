#!/bin/bash
# Script para aplicar formato Dart y resolver problemas de CI/CD
set -e

echo "=========================================="
echo "🎨 APLICANDO FORMATO DART PARA CI/CD"
echo "=========================================="
echo

cd "$(dirname "$0")"

echo "📁 Directorio actual: $(pwd)"
echo

echo "🎨 Aplicando formato Dart a todos los archivos..."
if dart format .; then
    echo "✅ Formato aplicado exitosamente!"
else
    echo "❌ Error al aplicar formato"
    exit 1
fi

echo
echo "🔍 Verificando formato con --set-exit-if-changed..."
if dart format --set-exit-if-changed .; then
    echo "✅ Todos los archivos ya están correctamente formateados"
else
    echo "⚠️  Algunos archivos tenían problemas de formato (ahora corregidos)"
fi

echo
echo "📋 Preparando commit para fix de formato..."
git add .
git status

echo
echo "🚀 Realizando commit con cambios de formato..."
if git commit -m "🎨 Fix: Apply dart format to resolve CI/CD formatting failures

- Applied dart format to all Dart files in the project
- Ensures compliance with Dart formatting standards
- Resolves CI/CD pipeline formatting job failures
- All files now properly formatted according to Dart guidelines

Fixes formatting issues blocking pipeline execution
Ready for green CI/CD pipeline ✅"; then
    echo "✅ Commit creado exitosamente"
else
    echo "ℹ️  No hay cambios para commitear (archivos ya formateados)"
fi

echo
echo "🚀 Haciendo push para triggear pipeline..."
if git push origin main; then
    echo "✅ Push exitoso"
else
    echo "❌ Error al hacer push"
    exit 1
fi

echo
echo "✅ ¡FORMATO APLICADO Y SUBIDO EXITOSAMENTE!"
echo
echo "🎯 RESULTADO ESPERADO:"
echo "  ✅ Pipeline CI/CD ahora debería pasar el job de formatting"
echo "  ✅ Todos los archivos Dart correctamente formateados"
echo "  ✅ Workflow automáticamente re-ejecutándose"
echo
echo "🔗 ENLACES DE MONITOREO:"
echo "  - GitHub Actions: https://github.com/oreginha/Quien-Para---2025/actions"
echo "  - Latest Commit: Verificar en GitHub que el commit se subió"
echo