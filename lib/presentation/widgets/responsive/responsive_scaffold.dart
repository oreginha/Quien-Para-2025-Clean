// lib/presentation/widgets/responsive/responsive_scaffold.dart
import 'package:flutter/material.dart';
import 'package:quien_para/presentation/widgets/common/bottom_nav_bar.dart';
import 'package:quien_para/presentation/widgets/navigation_aware_scaffold.dart';
import 'package:quien_para/presentation/widgets/responsive/responsive_layout.dart';
import 'package:quien_para/presentation/widgets/responsive/web_layout.dart';

/// Un Scaffold responsive que adapta su diseño según la plataforma
/// En móvil muestra un NavigationAwareScaffold con BottomNavBar
/// En web muestra un WebLayout con menú lateral
class ResponsiveScaffold extends StatelessWidget {
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

  const ResponsiveScaffold({
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
  });

  @override
  Widget build(BuildContext context) {
    // Layout para dispositivos móviles
    final mobileLayout = NavigationAwareScaffold(
      screenName: screenName,
      appBar: appBar,
      body: body,
      bottomNavigationBar: BottomNavBar(
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

    // Layout para web
    final webLayout = WebLayout(
      currentIndex: currentIndex,
      onTap: onTap,
      appBar: appBar,
      body: body,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );

    // Usar el layout responsive para mostrar el diseño adecuado según la plataforma
    return ResponsiveLayout(
      mobileLayout: mobileLayout,
      webLayout: webLayout,
      mobileBreakpoint: mobileBreakpoint,
    );
  }
}
