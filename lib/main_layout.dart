// lib/main_layout.dart
import 'package:flutter/material.dart' hide ThemeMode;
import 'package:provider/provider.dart';
import 'package:quien_para/core/theme/provider/theme_provider.dart';
import 'package:quien_para/presentation/screens/chat/chat_screen_responsive.dart';
import 'package:quien_para/presentation/widgets/common/platform_aware_bottom_nav.dart';
import 'package:quien_para/presentation/widgets/responsive/responsive_layout.dart';
import 'package:quien_para/presentation/widgets/web/web_screen_wrapper.dart';
import 'presentation/screens/profile/user_feed_screen.dart';
import 'presentation/screens/notifications/notifications_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> with WidgetsBindingObserver {
  int _currentIndex = 1; // Iniciamos en Home

  final List<Widget> _screens = <Widget>[
    const ChatScreenResponsive(
      conversationId: '',
      receiverId: '',
      receiverName: '',
      chatId: '',
    ),
    const UserFeedScreen(),
    const NotificationsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Registrarse como observador para detectar cambios en el sistema
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // Eliminar observador al destruir el widget
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    // Cuando cambia el brillo del sistema, actualizar el tema si está en modo automático
    if (mounted) {
      final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
      if (themeProvider.themeMode == ThemeMode.system) {
        // Forzar la reconstrucción del widget para aplicar el nuevo tema
        setState(() {});
      }
    }
    super.didChangePlatformBrightness();
  }

  @override
  Widget build(final BuildContext context) {
    // Obtener el proveedor de tema
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    // Configurar el color de fondo según el tema
    final backgroundColor = isDarkMode
        ? const Color(0xFF1E293B) // Dark theme background
        : const Color(0xFFF7FAFC); // Light theme background

    // Contenido principal compartido entre layouts
    final mainContent = IndexedStack(index: _currentIndex, children: _screens);

    // Layout compartido con barra de navegación adaptativa
    final sharedLayout = Scaffold(
      backgroundColor: backgroundColor,
      body: mainContent,
      bottomNavigationBar: PlatformAwareBottomNav(
        currentIndex: _currentIndex,
        onTap: (final int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );

    // Layout para web usando el nuevo WebScreenWrapper
    final webLayout = WebScreenWrapper(
      currentIndex: _currentIndex,
      onTap: (final int index) {
        setState(() {
          _currentIndex = index;
        });
      },
      title: 'Quién Para...?',
      child: mainContent, // Título para mostrar en la AppBar
    );

    // Usar el layout responsive para mostrar el diseño adecuado según la plataforma
    return ResponsiveLayout(
      mobileLayout: sharedLayout,
      webLayout: webLayout,
      mobileBreakpoint: 800, // Ajustar este valor según sea necesario
    );
  }
}
