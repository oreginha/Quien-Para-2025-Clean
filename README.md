# Quien Para - 2025 🎯

[![Firebase Deploy](https://github.com/oreginha/Quien-Para---2025/workflows/Flutter%20CI%20&%20Deploy/badge.svg)](https://github.com/oreginha/Quien-Para---2025/actions)
[![Web App](https://img.shields.io/badge/Web%20App-planing--931b8.web.app-blue)](https://planing-931b8.web.app)
[![Firebase App](https://img.shields.io/badge/Firebase%20App-planing--931b8.firebaseapp.com-orange)](https://planing-931b8.firebaseapp.com)

## 🚀 URLs de la Aplicación

- **Web App**: https://planing-931b8.web.app
- **Firebase App**: https://planing-931b8.firebaseapp.com

## 📱 Aplicación Flutter para Crear Planes de Dieta

Una aplicación moderna desarrollada en Flutter que permite a los usuarios crear, personalizar y gestionar planes de dieta de manera intuitiva y eficiente.

### ✨ Características Principales

- 🎯 **Creación de Planes Personalizados**: Diseña planes de dieta adaptados a objetivos específicos
- 📊 **Seguimiento Nutricional**: Monitoreo de macronutrientes y calorías
- 🍎 **Base de Datos de Alimentos**: Amplia biblioteca de alimentos y sus valores nutricionales
- 📱 **Multiplataforma**: Disponible en Web, Android e iOS
- 🔄 **Sincronización en la Nube**: Datos sincronizados con Firebase
- 🎨 **Interfaz Moderna**: Diseño limpio y usuario-friendly

### 🏗️ Arquitectura

- **Frontend**: Flutter 3.16.0
- **Backend**: Firebase (Firestore, Authentication, Hosting)
- **Estado**: Riverpod para gestión de estado
- **Navegación**: GoRouter para navegación declarativa
- **UI**: Material Design 3

### 📦 Deployment

La aplicación se despliega automáticamente usando GitHub Actions:

- **Web**: Firebase Hosting
- **Android**: Firebase App Distribution
- **iOS**: Artifacts disponibles para distribución manual

### 🔧 Comandos Útiles

```bash
# Instalar dependencias
flutter pub get

# Ejecutar en modo desarrollo
flutter run -d chrome  # Web
flutter run             # Android/iOS

# Construir para producción
flutter build web --release
flutter build apk --release
flutter build ipa --release

# Ejecutar tests
flutter test --coverage

# Análisis de código
flutter analyze
dart format .
```

### 🚀 Estado del Proyecto

✅ **Configuración Completa**
- Flutter proyecto inicializado
- Firebase configurado
- CI/CD pipeline configurado
- GitHub Actions activado

**Deployment Status: ACTIVANDO** 🔄

*Last Updated: $(date)*

---

### 🛠️ Desarrollo Local

1. **Clonar repositorio**
   ```bash
   git clone https://github.com/oreginha/Quien-Para---2025.git
   cd Quien-Para---2025
   ```

2. **Configurar Flutter**
   ```bash
   flutter pub get
   flutter doctor
   ```

3. **Ejecutar aplicación**
   ```bash
   flutter run -d chrome  # Para web
   ```

### 📞 Soporte

Para reportar problemas o solicitar características, utiliza las [GitHub Issues](https://github.com/oreginha/Quien-Para---2025/issues).

---

**🎯 Quien Para - Creando planes de dieta inteligentes para un estilo de vida saludable.**
