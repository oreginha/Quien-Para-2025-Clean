# Guía de Migración a la Nueva Estrategia Responsive

## Resumen de la Estrategia

En lugar de modificar todas las pantallas o crear nuevas versiones responsive, ahora estamos utilizando un componente envolvente para la versión web que embebe las pantallas móviles existentes. Esta estrategia nos permite:

1. **Reutilizar el código existente**: No es necesario duplicar la lógica o las vistas para diferentes plataformas.
2. **Implementación gradual**: Las pantallas se pueden migrar una por una, sin necesidad de cambiar toda la aplicación de una vez.
3. **Mantenimiento simplificado**: Solo hay que mantener un conjunto de pantallas que funcionan tanto en móvil como en web.
4. **Experiencia de usuario coherente**: La navegación es consistente en ambas plataformas.

## Componentes Clave

1. **WebScreenWrapper**: Componente que contiene la barra lateral y embebe las pantallas móviles en la versión web.
2. **NewResponsiveScaffold**: Versión actualizada del ResponsiveScaffold que implementa la nueva estrategia.
3. **PlatformAwareBottomNav**: Componente que muestra u oculta la barra de navegación inferior según la plataforma.
4. **PlatformAwareAppBar**: Componente que muestra u oculta el AppBar según la plataforma.

## Proceso de Migración de Pantallas

Para migrar una pantalla existente a la nueva estrategia responsive, sigue estos pasos:

### Paso 1: Crear una nueva versión responsive de la pantalla

Crea un nuevo archivo con el sufijo `_responsive.dart` que utilice `NewResponsiveScaffold`:

```dart
// lib/presentation/screens/example/example_screen_responsive.dart
import 'package:flutter/material.dart';
import 'package:quien_para/presentation/widgets/responsive/new_responsive_scaffold.dart';

class ExampleScreenResponsive extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 1. Definir el AppBar que se usará tanto en móvil como en web
    final appBar = AppBar(
      title: Text('Ejemplo'),
      // Otros elementos del AppBar...
    );

    // 2. Definir el contenido principal
    final content = Column(
      children: [
        // Contenido de la pantalla...
      ],
    );

    // 3. Usar NewResponsiveScaffold para tener un diseño consistente
    return NewResponsiveScaffold(
      screenName: 'example', // Nombre único para análisis
      appBar: appBar,
      body: content,
      currentIndex: 0, // Índice correspondiente en la barra de navegación
      webTitle: 'Título para la versión web', // Título específico para la versión web
    );
  }
}
```

### Paso 2: Actualizar las rutas para usar la nueva pantalla responsive

Actualiza las rutas en `app_router.dart` para usar la versión responsive:

```dart
// Antes
GoRoute(
  path: '/example',
  builder: (context, state) => const ExampleScreen(),
),

// Después
GoRoute(
  path: '/example',
  builder: (context, state) => const ExampleScreenResponsive(),
),
```

### Paso 3: Mantener retrocompatibilidad (opcional)

Si es necesario mantener retrocompatibilidad con versiones anteriores, puedes crear una pantalla wrapper:

```dart
// lib/presentation/screens/example/example_screen.dart
import 'package:flutter/material.dart';
import 'example_screen_responsive.dart';

class ExampleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExampleScreenResponsive();
  }
}
```

## Pantallas Migradas

Hasta ahora, hemos migrado las siguientes pantallas a la nueva estrategia responsive:

1. **UserFeedScreen (Perfil de Usuario)**
2. **NotificationsScreen (Notificaciones)**
3. **HomeScreen (Principal)**
4. **FeedPropuestas (Feed de Propuestas)**
5. **MyPlanDetailScreen (Detalle de Plan)**
6. **ChatScreen (Pantalla de Chat)**
7. **ConversationsListScreen (Lista de Conversaciones)**
8. **EditProfileScreen (Edición de Perfil)**
9. **OnboardingPlanFlow (Creación de Propuesta)**
10. **MyApplicationsScreen (Mis Aplicaciones)**

## Pantallas Pendientes de Migrar

Estas son algunas de las pantallas que aún necesitan ser migradas a la nueva estrategia:

1. **SearchScreen (Búsqueda)**
2. **SettingsScreen (Configuración)**
3. **LoginScreen y RegisterScreen (Inicio de Sesión y Registro)**
4. **PlanDetailScreen (Vista de Plan)**
5. **OtherUserProfileScreen (Perfil de Otro Usuario)**
6. **OnboardingScreens (Pantallas de Onboarding)**

## Recomendaciones para la Migración

1. **Prioriza las pantallas principales**: Migra primero las pantallas más utilizadas y que más se beneficiarían de una experiencia web mejorada.
2. **Prueba en ambas plataformas**: Asegúrate de probar las pantallas migradas tanto en web como en móvil para verificar que la experiencia es consistente.
3. **Mantén la coherencia visual**: Asegúrate de que las pantallas migradas tengan un aspecto coherente con el resto de la aplicación.
4. **Reutiliza componentes**: Aprovecha los componentes del diseño existente en lugar de crear nuevos.
5. **Adapta la navegación**: Asegúrate de que la navegación entre pantallas funcione correctamente en ambas plataformas.

## Cómo usar NewResponsiveScaffold

El componente `NewResponsiveScaffold` es una versión actualizada del `ResponsiveScaffold` que implementa la nueva estrategia responsive. Acepta los siguientes parámetros:

- **screenName** (String): Un nombre único para la pantalla, usado para análisis y trazabilidad.
- **appBar** (PreferredSizeWidget): El AppBar de la pantalla. En la versión web, este AppBar será ocultado.
- **body** (Widget): El contenido principal de la pantalla.
- **currentIndex** (int): El índice actual de la barra de navegación. Permite sincronizar la barra lateral en web.
- **onTap** (Function(int)): Callback cuando se toca un elemento de la barra de navegación.
- **webTitle** (String): Título específico para mostrar en la barra superior de la versión web.
- **floatingActionButton** y **floatingActionButtonLocation**: Para añadir y posicionar un FAB, si es necesario.

## Ejemplos de Uso

### Pantalla Simple

```dart
NewResponsiveScaffold(
  screenName: 'profile',
  appBar: AppBar(title: Text('Mi Perfil')),
  body: ProfileContent(),
  currentIndex: 3, // Perfil está en índice 3
  webTitle: 'Mi Perfil',
)
```

### Pantalla con Estado

```dart
class MyScreen extends StatefulWidget {
  @override
  _MyScreenState createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return NewResponsiveScaffold(
      screenName: 'my_screen',
      appBar: AppBar(title: Text('Mi Pantalla')),
      body: _buildContent(),
      currentIndex: _currentIndex,
      onTap: (index) => setState(() => _currentIndex = index),
      webTitle: 'Mi Pantalla',
    );
  }

  Widget _buildContent() {
    // Construir el contenido según el índice actual
    switch (_currentIndex) {
      case 0:
        return Page1();
      case 1:
        return Page2();
      default:
        return Page1();
    }
  }
}
```

## Consideraciones Importantes

1. **El AppBar se ocultará automáticamente en web**, pero se mostrará en móvil. Define siempre un AppBar completo para la versión móvil.
2. **La barra de navegación inferior se ocultará automáticamente en web**, pero se mostrará en móvil. La navegación en web se realiza a través de la barra lateral.
3. **El título en web será diferente al título en móvil**. Usa el parámetro `webTitle` para definir el título específico para la versión web.
4. **El contenido en web se mostrará con un ancho limitado** para mantener una buena legibilidad, similar a como lo hace Bumble en su versión web.
5. **La barra lateral en web mostrará las mismas opciones que la barra de navegación inferior en móvil**, permitiendo una navegación coherente en ambas plataformas.

## Resolución de Problemas Comunes

1. **El AppBar no se oculta en web**: Asegúrate de estar usando `NewResponsiveScaffold` y no `Scaffold` directamente.
2. **La navegación no funciona correctamente**: Verifica que el `currentIndex` y el `onTap` estén correctamente configurados.
3. **El contenido no se muestra correctamente en web**: Asegúrate de que el contenido sea adaptable a diferentes tamaños de pantalla.
