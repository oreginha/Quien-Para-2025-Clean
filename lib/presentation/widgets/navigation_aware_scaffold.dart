// navigation_scaffold.dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../core/utils/performance_logger.dart';

/// Un Scaffold optimizado para rendimiento que es consciente de la navegación.
/// Ayuda a reducir reconstrucciones innecesarias y mejora el rendimiento general.
class NavigationAwareScaffold extends StatefulWidget {
  final String screenName;
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? drawer;
  final Widget? endDrawer;
  final Color? darkPrimaryBackground;
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final bool resizeToAvoidBottomInset;
  final VoidCallback? onWillPop;

  const NavigationAwareScaffold({
    super.key,
    required this.screenName,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.drawer,
    this.endDrawer,
    this.darkPrimaryBackground,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.resizeToAvoidBottomInset = true,
    this.onWillPop,
  });

  @override
  State<NavigationAwareScaffold> createState() =>
      _NavigationAwareScaffoldState();
}

class _NavigationAwareScaffoldState extends State<NavigationAwareScaffold>
    with RouteAware, WidgetsBindingObserver {
  // Contador para reconstrucciones en modo debug
  int _rebuildCount = 0;
  bool _isVisible = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    PerformanceLogger.logInit('Scaffold-${widget.screenName}');
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    PerformanceLogger.logDispose('Scaffold-${widget.screenName}');
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Registrar para eventos de ruta si se necesita
    // Se puede implementar con RouteObserver si es necesario
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Optimizar cuando la app está en segundo plano
    if (state == AppLifecycleState.paused) {
      _isVisible = false;
      if (kDebugMode) {
        print('🔄 [Scaffold-${widget.screenName}] Pasando a segundo plano');
      }
    } else if (state == AppLifecycleState.resumed) {
      _isVisible = true;
      if (kDebugMode) {
        print('🔄 [Scaffold-${widget.screenName}] Volviendo a primer plano');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Log para rendimiento en modo debug
    if (kDebugMode) {
      _rebuildCount++;
      print(
          '🔄 [Scaffold-${widget.screenName}] Reconstrucción #$_rebuildCount');
    }

    // Utilizamos un enfoque compatible con versiones recientes de Flutter
    // Si el widget.onWillPop es proporcionado, evitamos el pop automático
    // y delegamos la acción al callback
    final Widget scaffoldWidget = Scaffold(
      key: _scaffoldKey,
      appBar: widget.appBar,
      body: OptimizedBodyWrapper(
        isVisible: _isVisible,
        screenName: widget.screenName,
        child: widget.body,
      ),
      bottomNavigationBar: widget.bottomNavigationBar,
      floatingActionButton: widget.floatingActionButton,
      floatingActionButtonLocation: widget.floatingActionButtonLocation,
      drawer: widget.drawer,
      endDrawer: widget.endDrawer,
      backgroundColor: widget.darkPrimaryBackground,
      extendBody: widget.extendBody,
      extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
    );

    // Si no hay un callback onWillPop, simplemente retornamos el scaffold
    if (widget.onWillPop == null) {
      return scaffoldWidget;
    }

    // Version compatible con Flutter reciente usando PopScope
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (!didPop) {
          widget.onWillPop!();
        }
      },
      child: scaffoldWidget,
    );
  }
}

/// Wrapper para el cuerpo del scaffold que mejora el rendimiento
/// reduciendo reconstrucciones y operaciones cuando no es visible
class OptimizedBodyWrapper extends StatefulWidget {
  final Widget child;
  final bool isVisible;
  final String screenName;

  const OptimizedBodyWrapper({
    super.key,
    required this.child,
    required this.isVisible,
    required this.screenName,
  });

  @override
  State<OptimizedBodyWrapper> createState() => _OptimizedBodyWrapperState();
}

class _OptimizedBodyWrapperState extends State<OptimizedBodyWrapper> {
  late Widget _cachedChild;
  bool _hasInitialized = false;

  @override
  void initState() {
    super.initState();
    _cachedChild = widget.child;
    _hasInitialized = true;
  }

  @override
  void didUpdateWidget(OptimizedBodyWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Solo actualizar el widget hijo cuando cambia significativamente
    // o cuando la pantalla vuelve a ser visible
    if (!_hasInitialized ||
        oldWidget.child.runtimeType != widget.child.runtimeType ||
        (oldWidget.isVisible != widget.isVisible && widget.isVisible)) {
      _cachedChild = widget.child;
      _hasInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Si la pantalla no es visible, mostrar la versión en caché
    // para reducir el trabajo de renderizado
    if (!widget.isVisible && _hasInitialized) {
      return _cachedChild;
    }

    // Usar un RepaintBoundary para mejorar el rendimiento de renderizado
    return RepaintBoundary(
      child: _cachedChild,
    );
  }
}
