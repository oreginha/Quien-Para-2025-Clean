# Solución de Problemas Comunes en la App "¿Quién Para?"

Este documento contiene instrucciones para resolver problemas comunes que pueden surgir durante el desarrollo o ejecución de la aplicación.

## 1. Problema de Cierre Inesperado en la App

Si la aplicación se cierra inesperadamente y muestra un mensaje como:

```
I/flutter (30371): 🧹 [MemoryManager] Realizando limpieza de memoria
Lost connection to device.
Exited.
```

### Solución:
Hemos implementado un manejo de memoria mejorado. Sigue estos pasos:

1. Ejecuta el script de limpieza `clean.bat` en la raíz del proyecto
2. Reconstruye la aplicación con `flutter run`

Las correcciones incluidas:
- Manejo seguro de la limpieza de memoria
- Prevención de bucles de navegación
- Mejor manejo de errores en tiempo de ejecución

## 2. Errores de Compilación

Si encuentras errores de compilación relacionados con paquetes o dependencias:

### Solución:
1. Actualiza las dependencias con:
   ```
   flutter pub get
   flutter pub cache repair
   ```
2. Limpia completamente la caché con el script `clean.bat`
3. Si persisten los errores, verifica el archivo `pubspec.yaml` para asegurarte de que las versiones sean compatibles

## 3. Problemas con GoRouter y Navegación

Si experimentas comportamientos extraños en la navegación:

### Solución:
1. Asegúrate de usar siempre `context.go()` en lugar de `context.push()` para rutas principales
2. Evita la navegación rápida y repetitiva a la misma ruta
3. Usa la siguiente estructura para la navegación:
   ```dart
   try {
     context.go('/ruta');
   } catch (e) {
     print('Error de navegación: $e');
   }
   ```

## 4. Problemas con Firebase

Si experimentas problemas con la conexión a Firebase:

### Solución:
1. Verifica tu conexión a internet
2. Asegúrate de que `google-services.json` esté correctamente ubicado en `android/app/`
3. Verifica las reglas de Firestore en el archivo `firestore.rules`
4. Si el problema persiste, vuelve a configurar Firebase con:
   ```
   flutterfire configure
   ```

## 5. Verificando Logs de Errores

Ahora la aplicación registra automáticamente los errores que ocurren. Para acceder a estos logs:

1. En modo debug, los errores se muestran en la consola
2. Los logs de errores se guardan en el dispositivo y pueden accederse desde la pantalla de configuración
3. Para limpiar los logs, usa la opción disponible en la pantalla de configuración

## 6. Contacto para Soporte

Si continúas experimentando problemas que no puedes resolver:

1. Describe el problema detalladamente
2. Incluye los pasos para reproducir el error
3. Adjunta los logs de errores (disponibles en la sección de configuración)
4. Envía toda la información a [tu-correo@ejemplo.com]

---
Última actualización: 2025-04-06
