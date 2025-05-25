# Comandos de Desarrollo - Quien Para 2025

## 🚀 Comandos Esenciales

### Instalación de dependencias
```bash
flutter pub get
```

### Ejecutar la aplicación
```bash
# Desarrollo local
flutter run

# Modo debug con hot reload
flutter run --debug

# Modo release para testing
flutter run --release
```

### Verificación de código
```bash
# Verificar formato (requerido por CI/CD)
dart format --output=none --set-exit-if-changed .

# Aplicar formato automáticamente
dart format .

# Análisis de código
flutter analyze

# Verificar todo (formato + análisis)
dart format . && flutter analyze
```

### Testing
```bash
# Ejecutar todos los tests
flutter test

# Tests con coverage
flutter test --coverage

# Tests específicos
flutter test test/widget_test.dart
```

### Build para producción
```bash
# Build para web (Firebase Hosting)
flutter build web --release --web-renderer html

# Build para Android
flutter build apk --release
flutter build appbundle --release

# Build para iOS (requiere macOS)
flutter build ios --release --no-codesign
```

## 🔧 Comandos de Firebase

### Deployment local (requiere Firebase CLI)
```bash
# Instalar Firebase CLI
npm install -g firebase-tools

# Login en Firebase
firebase login

# Deploy a hosting
firebase deploy --only hosting

# Deploy específico del proyecto
firebase deploy --only hosting --project planing-931b8
```

## 🔄 Git & GitHub

### Comandos básicos
```bash
# Ver estado
git status

# Agregar cambios
git add .

# Commit
git commit -m "Descripción del cambio"

# Push a GitHub (activa CI/CD automáticamente)
git push origin main

# Pull de cambios remotos
git pull origin main
```

## 🐛 Resolución de Problemas

### Limpiar cache
```bash
# Limpiar Flutter
flutter clean

# Reinstalar dependencias
flutter pub get

# Limpiar build completo
flutter clean && flutter pub get
```

### Problemas de dependencias
```bash
# Ver dependencias desactualizadas
flutter pub outdated

# Actualizar dependencias
flutter pub upgrade

# Resolver conflictos específicos
flutter pub deps
```