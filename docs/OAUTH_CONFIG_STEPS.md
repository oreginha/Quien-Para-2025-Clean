# Configuración OAuth 2.0 para Autenticación Web - "Quién Para"

## Estado Actual del Proyecto
- **Proyecto Firebase:** planing-931b8
- **Dominio Auth Actual:** planing-931b8.firebaseapp.com
- **Apps Configuradas:**
  - Android: com.example.planing y com.planing.app
  - iOS: 1:308528139700:ios:03b1297f58567d143076e1
  - Web: 3 aplicaciones web configuradas

## ⚠️ PASOS CRÍTICOS PARA RESOLVER AUTENTICACIÓN WEB

### Paso 1: Google Cloud Console (MÁS IMPORTANTE)
1. **Ir a:** https://console.cloud.google.com/apis/credentials?project=planing-931b8
2. **Buscar:** "OAuth 2.0 Client IDs" (puede aparecer como "Web client (auto created)")
3. **Hacer clic en editar** en el OAuth Client ID para Web
4. **En "Authorized redirect URIs" AGREGAR EXACTAMENTE:**
   ```
   https://planing-931b8.web.app/__/auth/handler
   https://planing-931b8.firebaseapp.com/__/auth/handler
   ```
5. **Para desarrollo local (opcional):**
   ```
   http://localhost:8080/__/auth/handler
   http://localhost:3000/__/auth/handler
   ```
6. **Guardar cambios**

### Paso 2: Firebase Console
1. **Ir a:** https://console.firebase.google.com/project/planing-931b8/authentication/settings
2. **En sección "Authorized domains" verificar que estén:**
   ```
   planing-931b8.web.app
   planing-931b8.firebaseapp.com
   localhost (para desarrollo)
   ```
3. **Si no están, agregarlos usando el botón "Add domain"**

### Paso 3: Verificar Configuración en Código
En `lib/firebase_options.dart` confirmar que tengas:
```dart
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'AIzaSyCA9CQ_w9JkSfkeKw-cyJir2Ck9wqRCbHg',
  appId: '1:308528139700:web:2231ff2600f285ae3076e1',
  messagingSenderId: '308528139700',
  projectId: 'planing-931b8',
  authDomain: 'planing-931b8.firebaseapp.com',
  storageBucket: 'planing-931b8.firebasestorage.app',
  measurementId: 'G-WTRN7PH6MR',
);
```

## 🔍 Verificación Post-Configuración

### Test en desarrollo local:
```bash
flutter run -d chrome --web-hostname localhost --web-port 8080
```

### Test en producción:
1. Hacer build: `flutter build web`
2. Deploy: `firebase deploy --only hosting`
3. Probar en: https://planing-931b8.web.app

## 📋 Checklist de Verificación
- [ ] OAuth Client ID configurado con redirect URIs correctos
- [ ] Dominios autorizados en Firebase Authentication
- [ ] AuthDomain correcto en firebase_options.dart
- [ ] Test local funciona con Google Sign-In
- [ ] Test en producción funciona con Google Sign-In

## 🚨 Errores Comunes
1. **"Error 400: redirect_uri_mismatch"** → Verificar Paso 1
2. **"unauthorized_client"** → Verificar que el dominio esté autorizado en Paso 2  
3. **"Access blocked"** → Verificar que el OAuth client esté configurado para aplicación web

## 📞 Contacto de Soporte
- Firebase Support: https://firebase.google.com/support
- Google Cloud Support: https://cloud.google.com/support

---
**Última actualización:** $(date)
**Estado:** PENDIENTE DE CONFIGURACIÓN MANUAL
