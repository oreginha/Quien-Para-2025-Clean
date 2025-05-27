@echo off
echo 🔄 Sincronizando con el repositorio limpio...

REM Cambiar el remote origin al nuevo repositorio
git remote set-url origin https://github.com/oreginha/Quien-Para-2025-Clean.git

REM Verificar el nuevo remote
echo ✅ Nuevo remote configurado:
git remote -v

REM Hacer fetch del nuevo repositorio
echo 🔄 Obteniendo estado del repositorio limpio...
git fetch origin

REM Hacer reset hard al estado del repositorio limpio
echo ⚠️ ADVERTENCIA: Esto sobrescribirá cambios locales
echo Presiona cualquier tecla para continuar o Ctrl+C para cancelar...
pause

git reset --hard origin/main

echo ✅ Sincronización completada!
echo 📁 El directorio local ahora coincide con el repositorio limpio
echo 🚀 Próximo paso: Aplicar correcciones y hacer push

pause