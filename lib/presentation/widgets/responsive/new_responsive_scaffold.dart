// lib/presentation/widgets/responsive/new_responsive_scaffold.dart
import 'package:flutter/material.dart';
import 'package:quien_para/presentation/widgets/common/platform_aware_app_bar.dart';
import 'package:quien_para/presentation/widgets/common/platform_aware_bottom_nav.dart';
import 'package:quien_para/presentation/widgets/navigation_aware_scaffold.dart';
import 'package:quien_para/presentation/widgets/responsive/responsive_layout.dart';
import 'package:quien_para/presentation/widgets/web/web_screen_wrapper.dart';

/// Una versión actualizada del ResponsiveScaffold que implementa la nueva estrategia responsive
/// Utiliza el WebScreenWrapper para la versión web y el PlatformAwareBottomNav para la versión móvil
class NewResponsiveScaffold extends StatelessWidget {
  final String screenName;
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? drawer;
  final Widget? endDrawer;
  final Color? darkPrimaryBackground;
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final bool resizeToAvoidBottomInset;
  final VoidCallback? onWillPop;
  final int currentIndex;
  final Function(int)? onTap;
  final double mobileBreakpoint;
  final String webTitle;

  const NewResponsiveScaffold({
    super.key,
    required this.screenName,
    required this.body,
    required this.currentIndex,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.drawer,
    this.endDrawer,
    this.darkPrimaryBackground,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.resizeToAvoidBottomInset = true,
    this.onWillPop,
    this.onTap,
    this.mobileBreakpoint = 800,
    this.webTitle = '',
  });

  @override
  Widget build(BuildContext context) {
    // Envolver el AppBar con PlatformAwareAppBar si existe
    final wrappedAppBar = appBar != null
        ? PlatformAwareAppBar(appBar: appBar!)
        : null;

    // Contenido móvil que se reutilizará tanto en móvil como en la versión web embebida
    final mobileContent = Scaffold(
      appBar: wrappedAppBar,
      body: body,
      bottomNavigationBar: PlatformAwareBottomNav(
        currentIndex: currentIndex,
        onTap: onTap,
      ),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      drawer: drawer,
      endDrawer: endDrawer,
      backgroundColor: darkPrimaryBackground,
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
    );

    // Para mantener la compatibilidad con el NavigationAwareScaffold que podría
    // tener funcionalidades adicionales como análisis, envolvemos el Scaffold
    final mobileLayout = NavigationAwareScaffold(
      screenName: screenName,
      appBar: wrappedAppBar,
      body: body,
      bottomNavigationBar: PlatformAwareBottomNav(
        currentIndex: currentIndex,
        onTap: onTap,
      ),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      drawer: drawer,
      endDrawer: endDrawer,
      darkPrimaryBackground: darkPrimaryBackground,
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      onWillPop: onWillPop,
    );

    // En la versión web, usar el nuevo WebScreenWrapper
    final webLayout = WebScreenWrapper(
      currentIndex: currentIndex,
      onTap: onTap,
      // No pasar el appBar al WebScreenWrapper para evitar duplicación
      // appBar: appBar,
      title: webTitle.isNotEmpty ? webTitle : screenName,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      child: mobileContent,
    );

    // Usar el layout responsive para mostrar el diseño adecuado según la plataforma
    return ResponsiveLayout(
      mobileLayout: mobileLayout,
      webLayout: webLayout,
      mobileBreakpoint: mobileBreakpoint,
    );
  }
}
