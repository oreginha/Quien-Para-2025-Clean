# Guía Completa de Exportación e Importación de Datos en Firebase para Proyecto Flutter

## 📋 Introducción

Este documento explica los procesos de exportación, importación y gestión de datos en Firebase para el proyecto "Quien Para".

## 🔍 Estructura de Colecciones

Las colecciones principales del proyecto son:
- `plans`: Planes de eventos
- `users`: Usuarios registrados
- `chats`: Conversaciones
- `applications`: Solicitudes de participación
- `notifications`: Notificaciones del sistema
- `events`: Eventos del sistema

## 🚀 Exportación de Estructura de Datos

### Métodos de Exportación

1. **Exportación Mediante Batch Script**
   - Archivo: `export_firestore_data.bat`
   - Ubicación: Raíz del proyecto
   - Comando: Ejecutar directamente haciendo doble clic
   - Proceso:
     * Crea carpeta `firebase_export` si no existe
     * Ejecuta script de Dart para exportación
     * Genera archivo JSON con estructura

2. **Exportación Programática (Dart)**
   - Ubicación: `lib/scripts/export_collections.dart`
   - Métodos principales:
     * `exportCollectionsStructure()`: Exporta toda la estructura
     * `createExampleCollectionsIfNotExist()`: Crea datos de ejemplo

### Características de la Exportación

- Detecta automáticamente tipos de campos
- Captura documentos de muestra
- Genera archivos con marca de tiempo
- Soporta subcolecciones
- Manejo de errores integrado

## 📥 Importación de Datos

### Métodos de Importación

1. **Importación Manual**
   - Usar Firebase Console
   - Herramientas de migración de datos
   - Importar archivos JSON/CSV

2. **Importación Programática**
   ```dart
   Future<void> importFirestoreData(Map<String, dynamic> data) async {
     final firestore = FirebaseFirestore.instance;
     
     data.forEach((collectionName, collectionData) async {
       final collection = firestore.collection(collectionName);
       
       // Iterar sobre documentos y agregarlos
       collectionData.forEach((docId, docData) {
         collection.doc(docId).set(docData);
       });
     });
   }
   ```

## 🛠️ Buenas Prácticas

### Exportación
- Realizar copias de seguridad antes de modificaciones importantes
- Usar control de versiones para archivos de estructura
- Validar estructura antes de importar

### Importación
- Verificar integridad de datos
- Manejar referencias entre documentos
- Gestionar duplicados

## ⚠️ Consideraciones de Seguridad

- Nunca commit archivos con credenciales
- Usar variables de entorno
- Limitar permisos de importación/exportación
- Validar datos antes de importar

## 🔧 Solución de Problemas

### Errores Comunes
1. Permisos de Firebase
2. Estructuras de datos incompatibles
3. Límites de importación/exportación

### Herramientas de Diagnóstico
- Firebase Console
- Logs de aplicación
- Validación de esquema

## 💡 Consejos Avanzados

- Implementar validación de esquema
- Crear scripts de migración
- Automatizar respaldos
- Usar transacciones para importaciones grandes

## 📦 Dependencias Necesarias

```yaml
dependencies:
  cloud_firestore: ^latest_version
  path_provider: ^latest_version
  intl: ^latest_version
```

## 🔍 Ejemplo de Estructura Exportada

```json
{
  "plans": {
    "schema": {
      "title": "string",
      "description": "string",
      "date": "timestamp"
    },
    "sample_documents": [
      // Documentos de ejemplo
    ]
  }
}
```

## 🚨 Notas Finales

- Realizar pruebas en entorno de desarrollo
- Documentar cambios en la estructura
- Mantener consistencia de datos

---

**Última Actualización:** [Fecha Actual]
**Versión:** 1.0.0
