# 🔐 Guía de Configuración de Secretos Firebase para CI/CD

## 📋 Secretos Requeridos

Para que el pipeline de CI/CD funcione correctamente, necesitas configurar los siguientes secretos en GitHub:

### 1. FIREBASE_TOKEN 🔑

**¿Qué es?** Token de autenticación para Firebase CLI.

**¿Cómo obtenerlo?**
```bash
# Instalar Firebase CLI
npm install -g firebase-tools

# Autenticarse y obtener el token
firebase login:ci
```

**¿Dónde configurarlo?**
- Ve a: [GitHub Secrets](https://github.com/oreginha/Quien-Para---2025/settings/secrets/actions)
- Click en "New repository secret"
- Name: `FIREBASE_TOKEN`
- Value: El token completo que obtuviste (ej: `1//0hbrg3tT0-lZ...`)

### 2. FIREBASE_ANDROID_APP_ID 📱

**¿Qué es?** ID de la aplicación Android en Firebase.

**¿Cómo obtenerlo?**
1. Ve a [Firebase Console](https://console.firebase.google.com/project/planing-931b8/settings/general)
2. En la sección "Your apps", encuentra tu app Android
3. Copia el "App ID" (formato: `1:308528139700:android:...`)

**¿Dónde configurarlo?**
- Ve a: [GitHub Secrets](https://github.com/oreginha/Quien-Para---2025/settings/secrets/actions)
- Click en "New repository secret"
- Name: `FIREBASE_ANDROID_APP_ID`  
- Value: El App ID completo

### 3. CODECOV_TOKEN (Opcional) 📊

**¿Qué es?** Token para reportes de cobertura de código.

**¿Cómo obtenerlo?**
1. Ve a [codecov.io](https://codecov.io)
2. Conecta tu repositorio GitHub
3. Copia el token del repositorio

## 🚀 Después de Configurar los Secretos

Una vez configurados los secretos, el pipeline debería ejecutarse automáticamente en cada push a `main`.

### 📍 URLs de Deployment

**Firebase Hosting:** 
- URL principal: `https://planing-931b8.web.app`
- URL alternativa: `https://planing-931b8.firebaseapp.com`

**Firebase App Distribution:**
- Las APKs se distribuirán automáticamente a los grupos "developers" y "testers"

## 🔍 Verificación

Para verificar que todo funciona:

1. **Configura los secretos** usando las instrucciones anteriores
2. **Haz un commit** a la rama `main`
3. **Ve a GitHub Actions** para monitorear el pipeline
4. **Verifica las URLs** de Firebase Hosting cuando el deployment sea exitoso

## 🆘 Solución de Problemas

### Error: "FIREBASE_TOKEN is not set"
- Verifica que el secreto `FIREBASE_TOKEN` esté configurado correctamente
- Asegúrate de que el token no haya expirado

### Error: "FIREBASE_ANDROID_APP_ID is not set"  
- Verifica que el secreto `FIREBASE_ANDROID_APP_ID` esté configurado
- Confirma que el App ID sea correcto en Firebase Console

### Error en Flutter analyze
- Revisa los logs del workflow para errores específicos
- Los errores de análisis no bloquearán el build (configurado con --no-fatal-infos)

---
*🤖 Generado automáticamente por el sistema de resolución de CI/CD*