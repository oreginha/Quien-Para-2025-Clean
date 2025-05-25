# Algoritmo de Matching para Quien Para

Este documento describe el algoritmo de matching implementado para la aplicación Quien Para, que permite encontrar compatibilidades entre usuarios y planes basándose en diferentes criterios.

## Descripción General

El algoritmo de matching está diseñado para calcular la compatibilidad entre usuarios y planes basándose en tres criterios principales:

1. **Intereses**: Compara los intereses del usuario con la categoría y descripción del plan.
2. **Ubicación**: Evalúa la coincidencia entre la ubicación del usuario y la del plan.
3. **Disponibilidad**: Considera la fecha del plan para determinar su relevancia temporal.

Cada uno de estos criterios tiene un peso específico en la puntuación final:
- Intereses: 40%
- Ubicación: 40%
- Disponibilidad: 20%

## Implementación

El algoritmo está implementado en las siguientes clases:

- `MatchingService`: Servicio principal que implementa la lógica de cálculo de compatibilidad.
- `FindCompatiblePlansUseCase`: Caso de uso para encontrar planes compatibles con un usuario.
- `FindCompatibleUsersUseCase`: Caso de uso para encontrar usuarios compatibles con un plan.

## Cálculo de Puntuación

### Puntuación de Intereses (40%)

La puntuación basada en intereses se calcula de la siguiente manera:

1. Si el usuario no tiene intereses, se asigna una puntuación baja (0.3).
2. Si hay una coincidencia directa entre un interés del usuario y la categoría del plan, se asigna una puntuación alta (0.8).
3. Si un interés del usuario aparece en la descripción del plan, se asigna una buena puntuación (0.7).
4. Si hay coincidencias con categorías relacionadas, se calcula una puntuación proporcional al número de coincidencias.
5. Si no hay coincidencias, se asigna una puntuación baja (0.3).

### Puntuación de Ubicación (40%)

La puntuación basada en ubicación se calcula de la siguiente manera:

1. Si falta información de ubicación (usuario o plan), se asigna una puntuación neutra (0.5).
2. Si hay una coincidencia exacta de ubicación, se asigna la máxima puntuación (1.0).
3. Si la ubicación del usuario contiene la del plan o viceversa, se asigna una alta puntuación (0.8).
4. Si las ubicaciones son diferentes, se asigna una puntuación baja (0.2).

### Puntuación de Disponibilidad (20%)

La puntuación basada en disponibilidad se calcula de la siguiente manera:

1. Si el plan no tiene fecha, se asigna una puntuación neutra (0.5).
2. Si el plan ya pasó, se asigna la mínima puntuación (0.0).
3. Si el plan es en los próximos 3 días, se asigna la máxima puntuación (1.0).
4. Si el plan es en la próxima semana, se asigna una buena puntuación (0.8).
5. Si el plan es en las próximas 2 semanas, se asigna una puntuación media (0.6).
6. Si el plan es más lejano, se asigna una puntuación baja (0.4).

## Uso del Algoritmo

### Encontrar Planes Compatibles para un Usuario

```dart
final FindCompatiblePlansUseCase findCompatiblePlans = sl<FindCompatiblePlansUseCase>();

final List<Map<String, dynamic>> compatiblePlans = await findCompatiblePlans(
  userInterests: ['deporte', 'música', 'cine'],
  userLocation: 'Madrid',
  limit: 10,
  minimumScore: 0.4,
);
```

### Encontrar Usuarios Compatibles para un Plan

```dart
final FindCompatibleUsersUseCase findCompatibleUsers = sl<FindCompatibleUsersUseCase>();

final List<Map<String, dynamic>> compatibleUsers = await findCompatibleUsers(
  planId: 'plan123',
  planCategory: 'deporte',
  planDescription: 'Partido de fútbol amistoso',
  planLocation: 'Madrid',
  planDate: DateTime.now().add(Duration(days: 2)),
  limit: 10,
  minimumScore: 0.4,
);
```

## Pruebas

Se han implementado pruebas para verificar el correcto funcionamiento del algoritmo de matching. Estas pruebas se encuentran en:

- `matching_service_test.dart`: Pruebas manuales para verificar diferentes escenarios.
- `matching_service_test_runner.dart`: Pruebas automatizadas utilizando el framework de pruebas de Flutter.

Para ejecutar las pruebas automatizadas:

```bash
flutter test test/domain/services/matching_service_test_runner.dart
```

## Mejoras Futuras

1. **Geolocalización**: Implementar cálculo de distancia real entre ubicaciones para mejorar la puntuación de ubicación.
2. **Aprendizaje automático**: Incorporar feedback de los usuarios para mejorar el algoritmo con el tiempo.
3. **Filtros adicionales**: Añadir más criterios como edad, género, o preferencias específicas.
4. **Optimización de rendimiento**: Mejorar la eficiencia del algoritmo para grandes volúmenes de datos.

## Integración con la Aplicación

El algoritmo de matching está integrado en la aplicación a través del sistema de inyección de dependencias. Los servicios y casos de uso relacionados se registran en `matching_injection.dart` y se inicializan en `injection_container.dart`.

Para utilizar el algoritmo en un nuevo componente de la aplicación, simplemente inyecta los casos de uso necesarios y llámalos según sea necesario.