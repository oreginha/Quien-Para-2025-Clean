
#### 1.2 Sistema de Rating/Reseñas (Semana 2-3)
```dart
// Implementar en lib/domain/entities/
- ReviewEntity
- UserRatingEntity

// Casos de uso en lib/domain/usecases/review/
- CreateReviewUseCase
- GetUserReviewsUseCase
- CalculateUserRatingUseCase
```

**Tareas específicas:**
- [ ] Diseñar modelo de datos para reviews en Firestore
- [ ] Crear componente `RatingStarsWidget`
- [ ] Implementar modal de review post-evento
- [ ] Añadir sección de reviews en perfil de usuario
- [ ] Crear `ReviewBloc` para manejo de estados


#### 1.3 Gestión de Favoritos (Semana 3)
```dart
// Implementar en lib/domain/usecases/favorites/
- ToggleFavoriteUseCase
- GetUserFavoritesUseCase
- CheckIfFavoriteUseCase
```

**Tareas específicas:**
- [ ] Crear colección `favorites` en Firestore
- [ ] Añadir botón de favorito en `PlanCard`
- [ ] Crear pantalla `FavoritesScreen`
- [ ] Implementar animaciones like/unlike
- [ ] Crear `FavoritesBloc`

#### 4.2 Sistema de Gamificación (Semana 2-3)
- [ ] Crear sistema de badges y logros
- [ ] Implementar niveles de usuario con XP
- [ ] Añadir recompensas por participación activa
- [ ] Crear showcase de logros en perfil

#### 4.3 Accesibilidad y Calidad (Semana 3-4)
- [ ] Implementar soporte para screen readers
- [ ] Crear temas de alto contraste
- [ ] Añadir ajustes de tamaño de fuente
- [ ] Implementar navegación por teclado
- [ ] Crear suite completa de tests automatizados


#### 5.1 Funcionalidades Premium
- [ ] Implementar modelo freemium
- [ ] Crear funciones premium (filtros avanzados, planes ilimitados)
- [ ] Añadir sistema de suscripciones
- [ ] Implementar marketplace para organizadores

#### 5.2 Viralidad y Crecimiento
- [ ] Crear sistema de invitaciones con incentivos
- [ ] Implementar programa de referidos
- [ ] Añadir integraciones con redes sociales
- [ ] Crear programa de embajadores
