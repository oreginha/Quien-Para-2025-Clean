# Widgets Optimizados

Este directorio contiene componentes de UI refactorizados para reducir la duplicación de código y mejorar la mantenibilidad del proyecto.

## Componentes Incluidos

### 1. `loading_overlay.dart`
- Unifica `loading_overlay.dart` y `loading_overlay2.dart`
- Proporciona un componente flexible que puede mostrar un indicador de carga como overlay independiente o condicional sobre un widget
- Incluye extensiones para BuildContext para facilitar mostrar/ocultar el loading
- Contiene también los SnackBars personalizados para mostrar mensajes

### 2. `loading_state.dart`
- Consolida los tres archivos de `LoadingStateHandler` encontrados en diferentes ubicaciones
- Proporciona un componente genérico para manejar todos los estados de carga (loading, error, empty, loaded)
- Compatible con el enfoque basado en objetos `LoadingState<T>` y con propiedades individuales

### 3. `success_modal.dart`
- Unifica los modales de éxito (`success_modal.dart`, `success_plan_modal.dart`, `success_plan_modal2.dart`)
- Proporciona opciones para mostrar confeti o un modal simple
- Altamente personalizable en términos de colores, textos y botones
- Incluye una función auxiliar para mostrar el modal fácilmente

### 4. `app_button.dart`
- Consolidación de todos los tipos de botones definidos en `app_buttons.dart` y `buttons/app_buttons.dart`
- Ofrece un componente `AppButton` base con múltiples opciones de personalización
- Incluye variantes como `PrimaryButton`, `SecondaryButton`, `ActionButton`, `DangerButton` y más
- Maneja estados de carga, deshabilitado y diferentes tamaños

## Cómo usar

Importa los widgets desde el archivo barrel `optimized/index.dart`:

```dart
import 'package:quien_para/presentation/widgets/optimized/index.dart';
```

### Ejemplos

#### LoadingOverlay
```dart
// Como overlay modal
context.showLoading(message: 'Cargando datos...');
// Ocultar
context.hideLoading();

// Como widget condicional
LoadingOverlay(
  isLoading: isLoading,
  message: 'Cargando perfil...',
  child: ProfileWidget(),
)
```

#### LoadingStateHandler
```dart
// Con estado individual
LoadingStateHandler<List<Plan>>(
  isLoading: isLoading,
  errorMessage: error,
  data: plans,
  builder: (data) => PlansListView(plans: data),
)

// Con objeto LoadingState
LoadingStateHandler.fromState(
  state: plansState,
  builder: (plans) => PlansListView(plans: plans),
)
```

#### Success Modal
```dart
showSuccessModal(
  context: context,
  title: '¡Plan creado!',
  message: 'Tu plan ha sido creado exitosamente',
  primaryButtonText: 'Continuar',
  type: SuccessModalType.confetti,
);
```

#### Botones
```dart
PrimaryButton(
  text: 'Continuar',
  onPressed: () => {},
  fullWidth: true,
)

SecondaryButton(
  text: 'Cancelar',
  icon: Icons.close,
  onPressed: () => Navigator.pop(context),
)

AppButton(
  text: 'Acción personalizada',
  onPressed: handleAction,
  style: AppButtonStyle.action,
  size: AppButtonSize.large,
)
```

## Migración

Para migrar al uso de estos componentes optimizados, reemplaza los widgets antiguos por sus equivalentes optimizados según se muestra en los ejemplos anteriores.
