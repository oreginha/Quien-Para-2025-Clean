# Guía para implementar la estrategia responsive en la aplicación

## Introducción

Esta guía explica la nueva estrategia responsive implementada en la aplicación. En lugar de tener dos versiones separadas para cada pantalla (móvil y web), ahora utilizamos un enfoque donde las pantallas móviles se embeben dentro de un componente contenedor web que proporciona una barra lateral consistente.

## Componentes clave

1. **WebScreenWrapper**: Componente que contiene la barra lateral y embebe las pantallas móviles.
2. **NewResponsiveScaffold**: Versión actualizada del ResponsiveScaffold que implementa la nueva estrategia.
3. **PlatformAwareBottomNav**: Reemplazo para BottomNavBar que se muestra en móvil y se oculta en web.
4. **PlatformAwareAppBar**: Componente que muestra u oculta el AppBar según la plataforma.
5. **ResponsiveLayout**: Componente que detecta la plataforma y muestra el layout adecuado.

## Pantallas migradas

Hasta ahora, se han migrado las siguientes pantallas a la nueva estrategia responsive:

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

## Cómo migrar una pantalla existente

Para migrar una pantalla existente al nuevo enfoque responsive, sigue estos pasos:

### Paso 1: Crear una nueva versión responsive

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

### Paso 2: Actualizar las rutas

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

### Alternativa: Modificar la pantalla existente

En lugar de crear un nuevo archivo, también puedes modificar la pantalla existente:

```dart
@override
Widget build(BuildContext context) {
  // 1. Definir el AppBar que se usará tanto en móvil como en web
  final appBar = AppBar(
    title: Text('Mi Pantalla'),
    // Otros elementos del AppBar...
  );
  
  // 2. Definir el contenido principal (lo que antes estaba en el Scaffold)
  final content = Column(
    children: [
      // contenido...
    ],
  );
  
  // 3. Usar NewResponsiveScaffold en lugar de Scaffold
  return NewResponsiveScaffold(
    screenName: 'my_screen',
    appBar: appBar,
    body: content,
    currentIndex: _currentIndex,
    onTap: (index) => setState(() => _currentIndex = index),
    webTitle: 'Mi Pantalla',
  );
}
```

## Características principales

- **La barra lateral en web**: Muestra las mismas opciones que la barra de navegación inferior, permitiendo una navegación coherente.
- **Contenido adaptado**: Las pantallas móviles se muestran centradas con un ancho limitado en la versión web.
- **Reutilización de código**: No es necesario duplicar la lógica o las vistas para las diferentes plataformas.
- **Implementación gradual**: Las pantallas pueden migrarse una por una, sin necesidad de cambiar toda la aplicación de una vez.

## Cómo usar NewResponsiveScaffold

El componente `NewResponsiveScaffold` es una versión actualizada del `ResponsiveScaffold` que implementa la nueva estrategia responsive. Acepta los siguientes parámetros:

- **screenName** (String): Un nombre único para la pantalla, usado para análisis y trazabilidad.
- **appBar** (PreferredSizeWidget): El AppBar de la pantalla. En la versión web, este AppBar será ocultado automáticamente.
- **body** (Widget): El contenido principal de la pantalla.
- **currentIndex** (int): El índice actual de la barra de navegación. Permite sincronizar la barra lateral en web.
- **onTap** (Function(int)): Callback cuando se toca un elemento de la barra de navegación.
- **webTitle** (String): Título específico para mostrar en la barra superior de la versión web.
- **floatingActionButton** y **floatingActionButtonLocation**: Para añadir y posicionar un FAB, si es necesario.

## Ventajas sobre el enfoque anterior

El `NewResponsiveScaffold` ofrece varias ventajas sobre el enfoque anterior:

1. **Mayor coherencia visual**: La barra lateral en web tiene el mismo aspecto en todas las pantallas.
2. **Más fácil de implementar**: No es necesario crear dos versiones separadas de cada pantalla.
3. **Mejor mantenibilidad**: Los cambios en la lógica o la UI solo necesitan hacerse una vez.
4. **Transición fluida**: Las pantallas se adaptan automáticamente según el tamaño de la pantalla.
5. **Avatar y perfil visibles**: La barra lateral muestra el avatar y el nombre del usuario, mejorando la experiencia de usuario.

## Cosas importantes a tener en cuenta

1. **AppBar**: El AppBar se ocultará automáticamente en web, pero se mostrará en móvil. Define siempre un AppBar completo para la versión móvil.

2. **Navegación**: El WebScreenWrapper maneja automáticamente la navegación a través de la barra lateral.

3. **Temas**: Los colores y estilos se adaptan automáticamente al tema seleccionado (claro/oscuro).

4. **Ancho del contenido**: El contenido en web se muestra con un ancho limitado para mantener una buena legibilidad, similar a como lo hace Bumble en su versión web.

## Mejores prácticas

1. **Dispositivos pequeños**: Asegúrate de que la pantalla se vea bien en dispositivos pequeños, como teléfonos móviles con pantallas de 4-5 pulgadas.

2. **Responsive en dispositivos grandes**: Aprovecha el espacio adicional en tabletas y desktops para mostrar más información o mejorar la legibilidad.

3. **Pruebas en diferentes plataformas**: Prueba tus pantallas tanto en móvil como en web después de migrarlas para asegurarte de que se vean correctamente en ambas plataformas.

4. **Títulos específicos para web**: Utiliza el parámetro `webTitle` para proporcionar un título más descriptivo en la versión web, donde hay más espacio disponible.

5. **Coherencia visual**: Mantén un aspecto coherente entre las diferentes pantallas de la aplicación, tanto en web como en móvil.

## Documentación adicional

Para obtener más información sobre el proceso de migración de pantallas existentes a la nueva estrategia responsive, consulta el archivo [MIGRATION_GUIDE.md](MIGRATION_GUIDE.md).
