# Quien Para - App

[![Flutter CI & Deploy](https://github.com/oreginha/Quien-Para---2025/actions/workflows/flutter-ci.yml/badge.svg)](https://github.com/oreginha/Quien-Para---2025/actions/workflows/flutter-ci.yml)
[![Firebase Security Rules](https://github.com/oreginha/Quien-Para---2025/actions/workflows/firebase-security-rules.yml/badge.svg)](https://github.com/oreginha/Quien-Para---2025/actions/workflows/firebase-security-rules.yml)

## 🚀 CI/CD Pipeline Activado

**Estado**: Pipeline configurado y listo para deployment automático

### Versiones de inicio de la aplicación

| Archivo | Descripción | Comando |
| --- | --- | --- |
| `main.dart` | Modo Emergencia Extrema (sin dependencias) | `flutter run -t lib/main.dart` |
| `main_progressive.dart` | Modo Progresivo (inicialización gradual) | `flutter run -t lib/main_progressive.dart` |
| `main_restored.dart` | Modo Restaurado (sin notificaciones) | `flutter run -t lib/main_restored.dart` |
| `main_fully_restored.dart` | Modo Completo (original, con stub) | `flutter run -t lib/main_fully_restored.dart` |
| `main_fully_restored_v2.dart` | Modo Completo V2 (versión mejorada) | `flutter run -t lib/main_fully_restored_v2.dart` |
| `main_minimal.dart` | Modo Minimalista (sin NotificationService) | `flutter run -t lib/main_minimal.dart` |
| `app_launcher.dart` | Selector de Modos | `flutter run -t lib/app_launcher.dart` |

**Recomendación**: Utilizar `main_minimal.dart` para el modo completo (versión estable sin NotificationService).

## 🔧 Desarrollo

### Comandos útiles
```bash
# Ejecutar la aplicación
flutter run

# Ejecutar tests
flutter test

# Generar código (Freezed, JSON)
flutter packages pub run build_runner build

# Analizar código
flutter analyze
```

### 🌐 Deployment Automático

- **Web**: Se despliega automáticamente en [Firebase Hosting](https://planing-931b8.web.app)
- **Android**: APK se distribuye automáticamente via Firebase App Distribution
- **CI/CD**: Pipeline completo con testing, building y deployment

## Guía de Migración de Getters del Tema

Esta guía proporciona instrucciones para actualizar los getters del tema en toda la aplicación.

### Tabla de Mapeo de Getters

| Getter Antiguo | Nuevo Getter | Descripción |
|---------------|--------------|-------------|
| `bodyLarge` | `AppTheme.textTheme.bodyLarge` | Estilo de texto para cuerpo grande |
| `spacing` | `AppTheme.spacing` | Espaciado consistente en la app |
| `textTheme` | `AppTheme.textTheme` | Estilos de texto predefinidos |
| `spacing.xxl` | `AppTheme.spacing.xxl` | Espaciado extra grande |
| `appTheme.colors.cardBackground` | `AppTheme.colors.cardBackground` | Color de fondo para tarjetas |

### Ejemplos de Migración

#### Antes:
```dart
Text(
  'Ejemplo',
  style: AppTheme.textTheme.bodyLarge,
)

Container(
  padding: EdgeInsets.all(AppTheme.spacing5),
)
```

#### Después:
```dart
Text(
  'Ejemplo',
  style: AppTheme.textTheme.bodyLarge,
)

Container(
  padding: EdgeInsets.all(AppTheme.spacing5),
)
```

### Lista de Verificación para la Migración

- [ ] Actualizar imports para incluir los nuevos getters del tema
- [ ] Buscar y reemplazar todos los getters antiguos
- [ ] Verificar que los estilos se apliquen correctamente
- [ ] Probar la UI en diferentes tamaños de pantalla
- [ ] Validar la consistencia del tema en toda la app

### Mejores Prácticas

1. Mantener la consistencia usando los getters del tema en lugar de valores hardcodeados
2. Utilizar los getters apropiados para cada caso de uso
3. Documentar cualquier personalización específica del tema
4. Realizar la migración por módulos para facilitar el testing

### Comandos Útiles

Para buscar getters antiguos en el código:

```bash
# Buscar bodyLarge
grep -r "AppTheme.textTheme.bodyLarge" lib/

# Buscar spacing
grep -r "AppTheme.spacing" lib/

# Buscar textTheme
grep -r "AppTheme.textTheme" lib/

# Buscar spacing.xxl
grep -r "AppTheme.spacing.xxl" lib/

# Buscar appTheme.colors.cardBackground
grep -r "AppTheme.colors.cardBackground" lib/
```

Recuerda mantener una copia de seguridad antes de realizar cambios masivos en el código.