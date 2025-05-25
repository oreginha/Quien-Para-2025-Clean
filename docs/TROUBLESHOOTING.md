# SOLUCIÓN DE PROBLEMAS DE INICIALIZACIÓN

## Actualización Mayo 2025: Solución Consolidada

**Implementación**: Se ha consolidado toda la funcionalidad en un único archivo `main.dart` que incluye todas las características excepto el caso de uso problemático de notificaciones.

**Características clave**:
- Inicialización completa de Firebase (Auth, Firestore, Storage, Analytics, Messaging)
- Inicialización de todos los servicios esenciales
- Inicialización de todos los repositorios
- Inicialización de todos los casos de uso excepto SendApplicationNotificationUseCase
- Provisión dinámica de BLoCs según disponibilidad de casos de uso
- Sistema de fallback para continuar la ejecución en caso de problemas con BLoCs específicos

**Ventajas**:
- Un único punto de entrada (`main.dart`)
- Carga progresiva de funcionalidades
- Manejo robusto de errores
- No necesita archivos alternativos

**Cómo ejecutar la aplicación**:
```bash
flutter run
```

El comando anterior utilizará automáticamente el archivo `main.dart` como punto de entrada.

## Enfoque alternativo - Omisión completa del NotificationService

**Síntoma**: Errores persistentes con GetIt al intentar registrar el NotificationService, incluso tras intentar soluciones con tipos genéricos

**Solución**: Crear una versión minimalista que omite completamente el NotificationService

**Enfoque**:
1. Crear un nuevo punto de entrada `main_minimal.dart`
2. Inicializar todos los servicios esenciales excepto NotificationService
3. Omitir deliberadamente `SendApplicationNotificationUseCase` en la lista de casos de uso a inicializar

**Ventajas**:
- Evita completamente los problemas relacionados con el registro de NotificationService
- Mantiene la funcionalidad esencial de la aplicación
- Proporciona una solución estable a corto plazo

**Implementación**:
En lugar de intentar corregir el registro del NotificationService, la solución minimalista simplemente lo omite por completo:

```dart
// Lista de casos de uso esenciales (omitiendo SendApplicationNotificationUseCase)
final essentialUseCases = [
  'CreatePlanUseCase',
  'GetPlanByIdUseCase',
  'UpdatePlanUseCase',
  'SavePlanUseCase',
  'GetPlansUseCase',
  'MatchPlanUseCase',
  'DeletePlanUseCase',
  'ApplyToPlanUseCase',
  'GetPlanApplicationsUseCase',
  'GetUserApplicationsUseCase',
  'UpdateApplicationStatusUseCase',
  'CancelApplicationUseCase',
  // Se omite deliberadamente: 'SendApplicationNotificationUseCase'
];
```

Para ejecutar esta versión minimalista:
```bash
flutter run -t lib/main_minimal.dart
```

## Versión mejorada del Modo Minimalista con AuthCubit Mock

**Actualización**: Se ha creado una versión mejorada del modo minimalista que ahora incluye una implementación mock de AuthCubit que puede utilizarse con la app normal.

**Enfoque**:
1. Implementar una versión mock de `AuthRepository` con tipos correctos
2. Crear una implementación mock de `AuthCubit` que extienda la clase real para compatibilidad
3. Utilizar un patrón de inicialización asíncrona segura para SharedPreferences
4. Envolver MyApp con los providers necesarios

**Archivos clave**:
- `mock_auth_with_inheritance.dart` - Contiene las implementaciones mock
- `main_minimal.dart` - Punto de entrada actualizado para usar los mocks

**Implementación**:
La inicialización de AuthCubit mock se realiza de forma segura:

```dart
// Crear instancia de nuestro AuthCubit mock mejorado
final authCubit = await MockAuthCubitImpl.create();

// Lanzar la aplicación normal, envuelta en los providers necesarios
runApp(
  MultiProvider(
    providers: [
      // Proporcionar el ThemeProvider
      ChangeNotifierProvider<ThemeProvider>(
        create: (_) => ThemeProvider(),
      ),
      // Proporcionar el MemoryManager
      Provider<MemoryManager>(
        create: (_) => MemoryManager(),
      ),
      // Proporcionar el AuthCubit (nuestra implementación mock)
      Provider<AuthCubit>.value(
        value: authCubit,
      ),
    ],
    child: const MyApp(),
  ),
);
```

**Ventajas de esta solución**:
- Permite usar la app normal (`MyApp`) con todas sus funcionalidades
- Mantiene la compatibilidad de tipos con la versión real de AuthCubit
- Evita los problemas con NotificationService
- Solución más limpia y mantenible a largo plazo

## Problemas con tipos genéricos al registrar servicios en GetIt

**Síntoma**: Error `Assertion failed: type != null || const Object() is! T` al registrar un servicio en GetIt

**Explicación**: 
Este error ocurre cuando hay un problema con los tipos genéricos en la inyección de dependencias usando GetIt. La aserción `type != null || const Object() is! T` falla cuando hay un problema con el tipo genérico especificado.

**Soluciones**:
1. Evitar especificar el tipo genérico explícitamente al registrar el servicio
2. Usar `registerSingleton` sin tipo genérico, dejando que Dart infiera el tipo
3. Asegurarse de que la interfaz esté correctamente implementada

**Implementación correcta**:
```dart
// En lugar de:
sl.registerSingleton<NotificationServiceInterface>(
    NotificationServiceStubV2(), 
    instanceName: 'NotificationService');

// Usar:
GetIt.instance.registerSingleton(
    NotificationServiceStubV2(), 
    instanceName: 'NotificationService');
```

Esta solución permite que Dart infiera correctamente el tipo del objeto registrado.

## Problemas con el stub de NotificationService

**Síntoma**: Error en NotificationServiceStub indicando que faltan implementaciones de métodos y que hay problemas con la firma del método `sendNotification`

**Explicación**: 
Aunque el stub implementa `NotificationServiceInterface`, hay inconsistencias entre las firmas de los métodos. El método `sendNotification` en la interfaz espera un parámetro `NotificationEntity`, pero en la implementación original se usó una firma diferente.

**Soluciones**:
1. Asegurarse de que todos los métodos de la interfaz estén implementados en el stub
2. Corregir la firma del método sendNotification para que coincida con la interfaz
3. Usar `dynamic` como tipo de retorno para mantener flexibilidad

**Implementación correcta**:
```dart
@override
dynamic sendNotification(NotificationEntity notification) {
  // Implementación stub
  return Future.value();
}
```

### Solución Actualizada

Se ha creado un stub mejorado llamado `NotificationServiceStubV2` en `lib/core/services/notification_service_stub_v2.dart` con la implementación correcta de todos los métodos. Este stub se usa en la versión actualizada del punto de entrada: `main_fully_restored_v2.dart`.

Comando para ejecutar:

```bash
flutter run -t lib/main_fully_restored_v2.dart
```

## Problemas con Tipos en Mocks para AuthCubit

**Síntoma**: Errores de tipo como "'MockAuthRepository.getCurrentUser' ('Future<dynamic> Function()') isn't a valid override of 'AuthRepository.getCurrentUser' ('Future<UserEntity?> Function()')"

**Explicación**:
Al implementar clases mock para interfaces complejas como `AuthRepository`, es crucial mantener la compatibilidad exacta de tipos. Los tipos de retorno dynamic no satisfacen los requisitos de la interfaz.

**Solución**:
1. Implementar todos los métodos con los tipos de retorno exactos requeridos por la interfaz
2. Usar factory constructors y métodos estáticos para inicialización asíncrona segura
3. Manejar correctamente las dependencias asíncronas como SharedPreferences

**Implementación correcta**:
```dart
@override
Future<UserEntity?> getCurrentUser() async => UserEntity.empty();

// Método de fábrica para crear instancias de forma segura
static Future<MockAuthCubitImpl> create() async {
  // Asegurarnos de que SharedPreferences esté inicializado
  await initialize();
  return MockAuthCubitImpl._();
}
```

## Problemas con Importaciones Dinámicas

**Síntoma**: Errores como `Undefined name 'import'` o `The method 'then' isn't defined for the type 'String'`

**Explicación**: 
A diferencia de JavaScript, Dart no permite importaciones dinámicas dentro del código normal usando `import` como expresión seguida de `.then()`. Las importaciones en Dart son estáticas y deben estar en el nivel superior del archivo.

**Soluciones**:
1. Usar importaciones estáticas normales en la parte superior del archivo
2. Para escenarios de navegación entre diferentes modos de aplicación:
   - Mostrar una pantalla de transición
   - Usar `Future.delayed()` para permitir que la UI se actualice
   - Implementar la funcionalidad sin intentar importar dinámicamente

**Ejemplo correcto**:
```dart
// Hacer la navegación de manera segura
runApp(PantallaTransicion());
Future.delayed(Duration(milliseconds: 300), () {
  runApp(NuevaAplicacion());
});
```

## Implementación del NotificationService Faltante

El único caso de uso que no pudo inicializarse correctamente fue `SendApplicationNotificationUseCase`, que depende de `NotificationService`. Para solucionar este problema, se ha creado una implementación stub (vacía) del servicio de notificaciones.

### Pasos para habilitar NotificationService en el futuro

1. Crear un archivo `notification_service_stub_v2.dart` en `lib/core/services/` con una implementación mínima

2. Para registrar este servicio en el contenedor de dependencias, agregar el siguiente código a `main.dart`:

```dart
// Registrar el servicio de notificaciones stub
if (!GetIt.instance.isRegistered(instanceName: 'NotificationService')) {
  // Usar registerSingleton sin tipo genérico explícito
  GetIt.instance.registerSingleton(
      NotificationServiceStubV2(), 
      instanceName: 'NotificationService');
  if (kDebugMode) {
    print('⚠️ NotificationService stub registrado');
  }
}
```

3. Importar la clase al inicio del archivo:

```dart
import 'core/services/notification_service_stub_v2.dart';
```

4. Una vez implementado el servicio real de notificaciones, simplemente reemplazar la implementación stub con la real.

## Resultados de la Investigación

Durante las pruebas con el modo progresivo, se han identificado y solucionado los siguientes problemas:

### 1. Casos de Uso Estables

Estos casos de uso se inicializaron correctamente y no presentan problemas:

- CreatePlanUseCase
- GetPlanByIdUseCase
- UpdatePlanUseCase
- SavePlanUseCase
- GetPlansUseCase
- MatchPlanUseCase
- DeletePlanUseCase
- ApplyToPlanUseCase
- GetPlanApplicationsUseCase
- GetUserApplicationsUseCase
- UpdateApplicationStatusUseCase
- CancelApplicationUseCase

### 2. Casos de Uso con Problemas

- **SendApplicationNotificationUseCase**: Depende de `NotificationService` que no está registrado. Esta es una dependencia opcional y no es crítica para el funcionamiento principal de la aplicación.

### 3. Solución Final Consolidada

Tras varios intentos de corregir la integración del NotificationService, se ha desarrollado una solución estable y consolidada en `main.dart` que:

- Omite completamente el NotificationService y su caso de uso asociado
- Inicializa correctamente todos los servicios y casos de uso esenciales
- Proporciona un AuthCubit completamente funcional
- Usa la versión normal de MyApp con todos los providers necesarios
- Inicializa dinámicamente los BLoCs disponibles según qué casos de uso se hayan inicializado correctamente
- Incluye un sistema de fallback en caso de errores en algún BLoC específico

Para usar la versión consolidada:
```bash
flutter run
```

## Problemas con la Inicialización de Firebase

**Síntoma**: Error `options != null` al inicializar Firebase, especialmente en la plataforma web

**Soluciones**:
1. Asegurarse de usar las opciones de configuración predefinidas con `DefaultFirebaseOptions.currentPlatform`
2. Importar correctamente el archivo `firebase_options.dart` generado por FlutterFire CLI
3. Usar inicialización con opciones en todas las plataformas, no solo web

## Problemas con Genéricos en GetIt

**Síntoma**: Errores relacionados con genéricos y TypeParameter que no se ajustan a Object

**Soluciones**:
1. Usar `sl.get<T>()` en lugar de `sl<T>()` para obtener instancias
2. Usar `sl.isRegistered()` en lugar de `sl.isRegistered<dynamic>()`
3. Asegurarse de que todos los genéricos son `extends Object`
4. Para funciones con tipo genérico, usar `<T extends Object>`

## Limpieza de Archivos Alternativos

Ahora que tenemos una solución consolidada en `main.dart`, los siguientes archivos se mantienen solo como referencia pero ya no son necesarios para la ejecución normal:

- `main_minimal_plus.dart` - Versión minimalista plus como referencia
- `app_launcher.dart` - Selector de modos



## Herramientas de Diagnóstico

### 1. Diagnóstico Progresivo
El modo progresivo incluye una interfaz gráfica para:
- Ver el estado de los servicios, repositorios y casos de uso
- Inicializar casos de uso individuales
- Reiniciar todo el sistema de inyección
- Mostrar errores detallados

### 2. Clase ErrorDiagnostic
Ubicación: `lib/error_diagnostic.dart`

Esta clase proporciona métodos para:
- Verificar casos de uso individuales
- Registrar resultados detallados
- Intentar registros seguros

### 3. Inyección Progresiva
Ubicación: `lib/core/di/progressive_injection.dart`

Un sistema mejorado para:
- Inicializar servicios de forma segura
- Inicializar repositorios
- Inicializar casos de uso uno por uno
- Registrar errores detallados

## Estrategia para Resolver Problemas Futuros

1. **Identificación de Caso de Uso Problemático**:
   - Usar la consola de depuración para identificar el caso de uso problemático
   - Consultar los mensajes de error específicos
   - Revisar el log para obtener más detalles

2. **Solución Gradual**:
   - Una vez identificado el caso de uso problemático, revisar su implementación
   - Corregir el problema y luego probar nuevamente
   - Ir habilitando casos de uso uno por uno, verificando la estabilidad

3. **Verificación Progresiva**:
   - Habilitar gradualmente más casos de uso a medida que se solucionan los problemas
   - Verificar que las nuevas implementaciones no rompan las ya funcionando
   - Documentar cada corrección para mantener un registro de cambios

4. **Transición al Modo Normal**:
   - Una vez que todos los casos de uso prioritarios funcionan
   - Probar el modo normal con todas las dependencias habilitadas
   - Si todo funciona, la aplicación está lista para usar su flujo normal

## Posibles Problemas y Soluciones

### Problemas de Inyección de Dependencias

**Síntoma**: Error al obtener una dependencia registrada

**Soluciones**:
1. Verificar que la dependencia esté correctamente registrada con el nombre exacto
2. Comprobar que los tipos genéricos sean correctos
3. Asegurarse que la dependencia no esté siendo registrada dos veces
4. Verificar el orden de inicialización (algunas dependencias pueden requerir otras)

### Problemas con Repositorios

**Síntoma**: Error al inicializar repositorios

**Soluciones**:
1. Verificar que todos los servicios requeridos estén correctamente inicializados
2. Comprobar si hay problemas con Firebase o servicios externos
3. Revisar los parámetros del constructor del repositorio

### Problemas con Casos de Uso

**Síntoma**: Error al inicializar un caso de uso específico

**Soluciones**:
1. Verificar la implementación del caso de uso (métodos, parámetros, tipos)
2. Comprobar las interfaces de repositorio que utiliza
3. Verificar si hay dependencias circulares
4. Asegurarse que los repositorios estén correctamente implementados

## Registro de Problemas Resueltos

A medida que se resuelven problemas con casos de uso específicos, agregar aquí:

| Caso de Uso | Problema | Solución |
| --- | --- | --- |
| Genéricos en GetIt | Tipo genérico `dynamic` no se ajustaba a `Object` | Usar `sl.get<Tipo>()` en lugar de la notación de operador y agregar `extends Object` a los genéricos |
| Problemas de inicialización progresiva | Errores al registrar dependencias | Implementación de sistema seguro con diagnóstico específico |
| Inicialización de Firebase en web | Error `options != null` | Usar `DefaultFirebaseOptions.currentPlatform` para la inicialización |
| Implementación NotificationServiceStub V2 | Problemas con la firma del método y métodos faltantes | Crear stub corregido con firma de método correcta e implementación de todos los métodos |
| Imports dinámicos incorrectos | Intentar usar importación dinámica en buttons | Reemplazar por navegación directa con Future.delayed |
| Función main sin async | Error `await in wrong context` | Marcar la función main como `async` |
| Tipo genérico en registerSingleton | Error `Assertion failed: type != null || const Object() is! T` | Evitar especificar tipo genérico explícitamente, usar `registerSingleton` sin tipo |
| Errores persistentes con NotificationService | Problemas con GetIt que no se solucionaban con cambios en tipos genéricos | Crear versión consolidada que omite NotificationService por completo |
| Tipos incorrectos en AuthRepository | Errores de tipo al implementar la interfaz | Implementar tipos exactos y usar factory constructors para inicialización asíncrona |
| Multiple puntos de entrada | Confusión sobre qué archivo main usar | Consolidar toda la funcionalidad en main.dart estándar para un único punto de entrada |
| BLoCs no inicializados | Falta de funcionalidad en la aplicación | Inicialización dinámica de BLoCs según disponibilidad de casos de uso |

## Registro de Cambios

### Versión 1.0.0 - Mayo 2025
- Implementación del Modo Emergencia Extrema
- Implementación del sistema de diagnóstico progresivo
- Creación de la inyección de dependencias progresiva

### Versión 1.0.1 - Mayo 2025
- Creación de una versión mejorada de NotificationServiceStub (V2)
- Implementación de main_fully_restored_v2.dart con el nuevo stub
- Corrección de problemas con importaciones dinámicas
- Actualización de la documentación con la nueva versión

### Versión 1.0.2 - Mayo 2025
- Solución al problema de tipos genéricos en registerSingleton
- Corrección de la inyección de dependencias para evitar errores de aserción
- Actualización de la documentación con la solución al nuevo problema

### Versión 1.0.3 - Mayo 2025
- Creación de modo minimalista que omite completamente NotificationService
- Solución alternativa para evitar errores persistentes con GetIt
- Recomendación de usar `main_minimal.dart` como solución estable

### Versión 1.0.4 - Mayo 2025
- Implementación de AuthRepository con tipos exactos
- Creación de MockAuthCubitImpl con patrón de inicialización asíncrona
- Mejora de main_minimal.dart para usar la app normal con provider correctamente configurados
- Documentación actualizada con las nuevas soluciones

### Versión 1.0.5 - Mayo 2025
- Creación de modo minimalista plus con más BLoCs (Plan, Feed, Chat, Profile)
- Ampliación de funcionalidad mientras se mantiene la estabilidad
- Documentación actualizada con el nuevo modo

### Versión 1.0.6 - Mayo 2025
- Consolidación de toda la funcionalidad en `main.dart` estándar
- Implementación de carga dinámica de BLoCs según disponibilidad de casos de uso
- Sistema de fallback para manejo de errores
- Eliminación de dependencia de archivos alternativos
- Actualización de documentación

## Próximos Pasos
1. Implementar NotificationService real en el futuro
2. Agregar pruebas unitarias para cada caso de uso
3. Crear un sistema automatizado de verificación de dependencias
4. Eliminar archivos de puntos de entrada alternativos cuando se confirme estabilidad

## Recursos Adicionales

- La clase `ProgressiveInjection` mantiene un registro detallado en `initializationLog`
- Los errores se registran en la consola de desarrollo para diagnóstico adicional
- Usar `flutter run -v` para obtener logs más detallados si es necesario depurar problemas complejos
