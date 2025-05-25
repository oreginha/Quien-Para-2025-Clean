# Configuración de Firebase para "Quien Para"

Este archivo contiene información sobre la configuración de Firebase en el proyecto.

## Proyecto de Firebase existente

Este proyecto usa el proyecto de Firebase "planing-931b8" y la aplicación Android existente con el package name `com.example.planing`.

## Configuración actual

- **Proyecto ID Firebase**: planing-931b8
- **Package name**: com.example.planing
- **Firebase configurado con**: Autenticación, Firestore, Storage, Cloud Messaging

## Notas importantes

1. El proyecto Android tiene el package name `com.example.planing` aunque la carpeta del proyecto se llame "quien_para".
2. El archivo google-services.json está ya configurado correctamente.
3. Los permisos para notificaciones ya están configurados en el AndroidManifest.xml.

## Solución de problemas comunes

### Error de compilación relacionado con google-services.json

Si obtienes un error relacionado con google-services.json, asegúrate de que:
1. El archivo está presente en `android/app/google-services.json`
2. El ID del paquete en el archivo coincide con el namespace en build.gradle

### Error de permisos de notificaciones

Si las notificaciones no funcionan:
1. Asegúrate de que tienes el permiso POST_NOTIFICATIONS en AndroidManifest.xml
2. Verifica que estás solicitando el permiso correctamente en MainActivity.kt

### Problemas con las versiones de Firebase

Si hay conflictos entre las versiones de las dependencias:
1. Asegúrate de usar la plataforma BoM (Bill of Materials) para mantener las versiones consistentes
2. Usa `flutter pub upgrade` para mantener las dependencias actualizadas

## Recursos adicionales

- [Documentación de FlutterFire](https://firebase.flutter.dev/docs/overview)
- [Guía de Firebase Cloud Messaging](https://firebase.flutter.dev/docs/messaging/overview)
- [Guía de permisos en Android](https://developer.android.com/guide/topics/permissions/overview)
