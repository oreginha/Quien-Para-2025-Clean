# Propuesta de Arquitectura Limpia para Quien Para

## Estructura de Carpetas
```
lib/
├── core/                     # Utilidades, constantes, configuraciones
│   ├── error/                # Manejo de errores
│   ├── network/              # Configuración de red 
│   └── utils/                # Funciones utilitarias
├── data/                     # Capa de datos
│   ├── datasources/          # Fuentes de datos
│   │   ├── local/            # Fuentes locales (SharedPreferences, SQLite)
│   │   └── remote/           # Fuentes remotas (Firebase, API)
│   ├── models/               # Modelos de datos (DTOs)
│   │   ├── chat/             # Modelos relacionados con chats
│   │   ├── plan/             # Modelos relacionados con planes
│   │   └── user/             # Modelos relacionados con usuarios
│   ├── repositories/         # Implementaciones de repositorios
│   └── mappers/              # Conversores entre modelos y entidades
├── domain/                   # Capa de dominio
│   ├── entities/             # Entidades de negocio
│   ├── repositories/         # Interfaces de repositorios
│   ├── usecases/             # Casos de uso
│   │   ├── auth/             # Casos de uso para autenticación
│   │   ├── chat/             # Casos de uso para chat
│   │   ├── plan/             # Casos de uso para planes
│   │   └── user/             # Casos de uso para usuarios
│   └── failures/             # Clases para manejo de errores de dominio
└── presentation/             # Capa de presentación
    ├── blocs/                # BLoCs/Cubits por funcionalidad
    ├── pages/                # Páginas/Pantallas de la app
    ├── widgets/              # Widgets reutilizables
    └── utils/                # Utilidades específicas de UI
```

## Principios a seguir

1. **Dependencias unidireccionales**: Las capas externas pueden depender de las internas, pero no al revés
   - domain ← data
   - domain ← presentation
   - data ← presentation

2. **Separación de modelos**:
   - `domain/entities/`: Contienen solo la lógica de negocio
   - `data/models/`: Contienen lógica de serialización/deserialización

3. **Contratos claros**:
   - Todas las interfaces de repositorios se definen en domain
   - Implementaciones concretas en data

4. **Casos de uso**:
   - Cada funcionalidad de negocio tiene su propio caso de uso
   - Los casos de uso dependen solo de interfaces de repositorios

5. **BLoCs delgados**:
   - Los BLoCs solo llaman a casos de uso, sin lógica de negocio
   - Solo transforman los resultados de casos de uso a estados de UI


Fase 1: Reestructurar proyecto en capas
Estructura actual y problemas detectados:
Se usa una capa de adaptadores para conectar el código nuevo con patrones antiguos
ChatRepository y ChatDataSource tienen interfaces casi idénticas
La lógica de negocio parece estar mezclada en los BLoCs
Acciones específicas:
Organizar entidades de dominio:
Las entidades (conversation_entity.dart, message_entity.dart, etc.) ya están correctamente ubicadas en domain/entities/
Asegurar que no contengan lógica de serialización/deserialización
Separar modelos de datos de entidades:
Crear mappers en data/mappers/ para convertir entre modelos y entidades
Ejemplo: ChatMessageMapper que convierta ChatMessageModel ↔ MessageEntity
Unificar fuentes de datos:
Mover lógica relevante de services/implementations/ a data/datasources/
Consolidar interfaces duplicadas entre ChatRepository y ChatDataSource
Fase 2: Definir contratos claros
Acciones específicas:
Formalizar interfaces de repositorios:
Revisar y refinar interfaces existentes en domain/repositories/
Eliminar duplicidad con interfaces en data/datasources/
Implementar repositorios en data:
Implementar todas las interfaces de repositorio en data/repositories/
Ejemplo: ChatRepositoryImpl implementa ChatRepository
Crear casos de uso para lógica de negocio:
Organizar por módulos: domain/usecases/chat/, domain/usecases/auth/, etc.
Cada caso de uso debe realizar una sola operación de negocio
Ejemplos para chat:
GetMessagesUseCase
SendMessageUseCase
CreateConversationUseCase
Fase 3: Refactorizar componentes existentes
Acciones específicas:
Mover lógica de negocio de BLoCs a casos de uso:
Extraer lógica de los métodos en ChatBloc a casos de uso correspondientes
El BLoC solo debería manejar eventos y emitir estados, delegando la lógica a casos de uso
Eliminar capa de adaptadores:
Reemplazar gradualmente referencias a ChatServiceInterface con casos de uso específicos
Eliminar ChatRepositoryAdapter cuando ya no sea necesario
Implementar mappers entre capas:
Crear mappers para convertir entre entidades de dominio y modelos de datos
Crear mappers para convertir entre entidades de dominio y modelos de presentación
Ejemplo concreto de implementación
Aquí está un ejemplo de cómo implementaría un caso de uso para obtener mensajes:

dart
CopyInsert
// domain/usecases/chat/get_messages_usecase.dart
class GetMessagesUseCase {
  final ChatRepository repository;
  
  GetMessagesUseCase(this.repository);
  
  Stream<List<MessageEntity>> execute(String conversationId) {
    return repository.getMessages(conversationId);
  }
}

// Refactorización del ChatBloc
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetMessagesUseCase _getMessagesUseCase;
  final SendMessageUseCase _sendMessageUseCase;
  // Otros casos de uso...
  
  ChatBloc(this._getMessagesUseCase, this._sendMessageUseCase, ...);
  
  Future<void> _onLoadMessages(LoadMessages event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    try {
      // Cancelar suscripción anterior
      await _messagesSubscription?.cancel();
      
      // Usar caso de uso en lugar de servicio directamente
      _messagesSubscription = _getMessagesUseCase
          .execute(event.conversationId)
          .listen((messages) {
        add(MessagesUpdated(messages));
      });
      
      // Restante del código...
    } catch (e) {
      emit(ChatError('Error al cargar mensajes: $e'));
    }
  }
  
  // Otros manejadores de eventos...
}
Plan de consolidación para la Fase 1
Basándome en la estructura actual del proyecto, veo que ya existe una migración en progreso hacia Clean Architecture. Vamos a consolidar el código evitando duplicaciones:

1. Consolidación de Interfaces y Modelos
Hay tres tipos de interfaces con funcionalidad similar:

domain/repositories/chat_repository.dart (nueva interfaz Clean Architecture)
domain/interfaces/chat_service_interface.dart (interfaz antigua)
data/datasources/chat_data_source.dart (interfaz de fuente de datos)
Recomendación: Mantener las interfaces de dominio como fuente principal y adaptar las implementaciones para usarlas.

2. Estructura propuesta para continuar la refactorización
CopyInsert
domain/
  ├── repositories/        # Interfaces de repositorios (ya existe)
  ├── entities/            # Entidades de dominio (ya existe)
  └── usecases/            # Casos de uso (ya existe)

data/
  ├── repositories/        # Implementaciones de repositorios (ya existe)
  │   ├── *_impl.dart      # Implementaciones directas de interfaces de dominio
  │   └── *_service_impl.dart # Adaptadores temporales para interfaces antiguas
  ├── datasources/
  │   ├── local/           # Fuentes de datos locales (ya existe)
  │   └── remote/          # Fuentes de datos remotas (ya existe)
  ├── models/              # Modelos de datos (ya existe)
  └── mappers/             # Conversores (creado recientemente)
3. Acciones específicas para continuación de Fase 1
Consolidar la implementación de ChatRepository:
Ya tenemos una buena implementación en chat_repository_impl.dart
Hemos creado chat_service_impl.dart como adaptador de compatibilidad
No es necesario mantener el chat_repository_adapter.dart en services/adapters
Completar la implementación de mappers:
Ya hemos creado ChatMessageMapper y ChatMapper
Si vemos modelos adicionales que necesitan mapeo, podemos crear más mappers
Verificar la coherencia de las implementaciones:
Asegurar que AuthRepositoryImpl siga el mismo patrón que ChatRepositoryImpl
Verificar que FirebaseChatDataSource implemente correctamente ChatDataSource
4. Próximos pasos más concretos:
Verificar implementación actual de FirebaseChatDataSource: Vamos a examinar si ya está utilizando mappers o si necesitamos refactorizarla para usar los que hemos creado.
Analyzed
firebase_chat_data_source.dart:(1-50)
Thought Process


Ahora que tengo una mejor comprensión del código existente, vamos a avanzar con la Fase 1 de manera más efectiva. Veo que la estructura ya está bastante avanzada hacia Clean Architecture, pero necesitamos consolidar algunos componentes.

Consolidación para Fase 1: Estructura y Datos
Estado actual:
Ya existen las interfaces adecuadas en domain/repositories
Ya existen implementaciones de repositorios en data/repositories
Ya existen implementations de fuentes de datos en data/datasources/remote
Acabamos de añadir mappers para la conversión entre modelos y entidades
Acciones específicas para completar la Fase 1:
Eliminar el adaptador redundante:
El ChatRepositoryAdapter en services/adapters se vuelve redundante ya que hemos creado ChatServiceImpl
Deberíamos mover esta implementación a services/implementations o eliminarla si ya no hay referencias
Refactorizar FirebaseChatDataSource para usar modelos:
Actualmente está creando entidades directamente, lo cual viola la separación de capas
Debería trabajar con modelos y dejar la conversión a los mappers



domain/
  ├── repositories/        # Interfaces de repositorios 
  │   └── chat_repository.dart
  ├── entities/            # Entidades de dominio
  │   ├── message_entity.dart
  │   └── conversation_entity.dart
  └── interfaces/          # Interfaces antiguas (se eliminarán gradualmente)
      └── chat_service_interface.dart

data/
  ├── repositories/        # Implementaciones de repositorios
  │   └── chat_repository_impl.dart
  ├── datasources/
  │   ├── chat_data_source.dart
  │   └── remote/
  │       └── firebase_chat_data_source.dart
  ├── models/              # Modelos de datos
  │   ├── chat/chat_model.dart
  │   └── chat_message/chat_message_model.dart
  └── mappers/             # Conversores (nuevos)
      ├── chat_mapper.dart
      └── chat_message_mapper.dart

services/
  └── adapters/            # Capa de compatibilidad
      └── chat_service_adapter.dart



      Fase 1 - Preparación (Ya completada para Chat):
Extraer casos de uso
Crear adaptadores para el repositorio
Implementar mapper para convertir entidades a modelos
Fase 2 - Refactorización de BLoCs:
Implementar constructores duales como hicimos con ChatBloc
Mantener compatibilidad con widgets existentes
Fase 3 - Actualización de Estados:
Migrar a estados más granulares y predecibles
Documentar flujos de eventos-estados
Fase 4 - Pruebas y validación:
Implementar tests unitarios para casos de uso
Validar funcionamiento en toda la aplicación