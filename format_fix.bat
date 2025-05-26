@echo off
echo ==========================================
echo 🎨 APLICANDO FORMATO DART PARA CI/CD
echo ==========================================
echo.

cd /d "D:\Proyectos y Desarrollo\quien_para\quien_para"

echo 📁 Directorio actual: %CD%
echo.

echo 🎨 Aplicando formato Dart a todos los archivos...
dart format .
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Error al aplicar formato
    pause
    exit /b 1
)

echo.
echo ✅ Formato aplicado exitosamente!
echo.

echo 🔍 Verificando formato con --set-exit-if-changed...
dart format --set-exit-if-changed .
if %ERRORLEVEL% NEQ 0 (
    echo ⚠️  Algunos archivos tenían problemas de formato (ahora corregidos)
) else (
    echo ✅ Todos los archivos ya están correctamente formateados
)

echo.
echo 📋 Preparando commit para fix de formato...
git add .
git status

echo.
echo 🚀 Realizando commit con cambios de formato...
git commit -m "🎨 Fix: Apply dart format to resolve CI/CD formatting failures

- Applied dart format to all Dart files in the project
- Ensures compliance with Dart formatting standards
- Resolves CI/CD pipeline formatting job failures
- All files now properly formatted according to Dart guidelines

Fixes formatting issues blocking pipeline execution
Ready for green CI/CD pipeline ✅"

if %ERRORLEVEL% NEQ 0 (
    echo ❌ Error al crear commit (posiblemente no hay cambios)
    echo ℹ️  Verificando estado del repositorio...
    git status
) else (
    echo ✅ Commit creado exitosamente
)

echo.
echo 🚀 Haciendo push para triggear pipeline...
git push origin main
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Error al hacer push
    pause
    exit /b 1
)

echo.
echo ✅ ¡FORMATO APLICADO Y SUBIDO EXITOSAMENTE!
echo.
echo 🎯 RESULTADO ESPERADO:
echo   ✅ Pipeline CI/CD ahora debería pasar el job de formatting
echo   ✅ Todos los archivos Dart correctamente formateados
echo   ✅ Workflow automáticamente re-ejecutándose
echo.
echo 🔗 ENLACES DE MONITOREO:
echo   - GitHub Actions: https://github.com/oreginha/Quien-Para---2025/actions
echo   - Latest Commit: Verificar en GitHub que el commit se subió
echo.
pause