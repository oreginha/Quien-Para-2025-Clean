import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quien_para/core/theme/provider/theme_provider.dart';
import 'package:quien_para/presentation/widgets/buttons/theme_aware_button.dart';
import 'package:quien_para/presentation/widgets/cards/theme_aware_card.dart';
import 'package:quien_para/presentation/widgets/theme/theme_switch.dart';
import 'package:quien_para/presentation/widgets/navigation_aware_scaffold.dart';

class ThemeShowcaseScreen extends StatelessWidget {
  static const String routeName = '/theme-showcase';

  const ThemeShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return NavigationAwareScaffold(
      screenName: routeName,
      appBar: AppBar(
        title: const Text('Demostración de Temas'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: ThemeModeIcon(showBorder: true),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabecera con toggle de tema
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Modo de tema actual:',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        isDarkMode ? Icons.dark_mode : Icons.light_mode,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isDarkMode ? 'Modo Oscuro' : 'Modo Claro',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      const ThemeSwitch(),
                    ],
                  ),
                ],
              ),
            ),

            const Divider(),

            // Sección de Tipografía
            _buildSection(
              context,
              title: 'Tipografía',
              children: [
                Text(
                  'Heading 1 - Playfair Display',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Heading 2 - Playfair Display',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Body Large - Inter 16pt / 24pt',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Body Medium - Inter 14pt / 20pt',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Body Small - Inter 12pt / 16pt',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),

            // Sección de Botones
            _buildSection(
              context,
              title: 'Botones',
              children: [
                ThemeAwareButton(
                  text: 'Botón Primario',
                  variant: ButtonVariant.primary,
                  onPressed: () {},
                ),
                const SizedBox(height: 16),
                ThemeAwareButton(
                  text: 'Botón Secundario',
                  variant: ButtonVariant.secondary,
                  onPressed: () {},
                ),
                const SizedBox(height: 16),
                ThemeAwareButton(
                  text: 'Botón Outline',
                  variant: ButtonVariant.outline,
                  onPressed: () {},
                ),
                const SizedBox(height: 16),
                ThemeAwareButton(
                  text: 'Botón con Icono',
                  variant: ButtonVariant.primary,
                  iconLeft: Icons.star,
                  onPressed: () {},
                ),
                const SizedBox(height: 16),
                ThemeAwareButton(
                  text: 'Botón Ancho Completo',
                  variant: ButtonVariant.primary,
                  isFullWidth: true,
                  onPressed: () {},
                ),
              ],
            ),

            // Sección de Tarjetas
            _buildSection(
              context,
              title: 'Tarjetas',
              children: [
                // Tarjeta básica
                ThemeAwareCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tarjeta Básica',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Esta es una tarjeta básica con estilo según el tema actual.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Tarjeta con acción
                ThemeAwareCard(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Tarjeta presionada')),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tarjeta con Acción',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Esta tarjeta tiene una acción al presionarla.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ThemeAwareButton(
                          text: 'Acción',
                          variant: ButtonVariant.primary,
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Tarjeta con imagen (simulada para demo)
                ThemeAwareCard(
                  imageUrl:
                      'https://images.unsplash.com/photo-1504805572947-34fad45aed93',
                  hasOverlay: true,
                  height: 180,
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tarjeta con Imagen',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Texto sobre imagen con overlay',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Sección de Colores
            _buildSection(
              context,
              title: 'Paleta de Colores',
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildColorItem(
                        context,
                        color: const Color(0xFFFFC107),
                        name: 'Brand Yellow',
                        hex: '#FFC107',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildColorItem(
                        context,
                        color: const Color(0xFFE53E3E),
                        name: 'Accent Red',
                        hex: '#E53E3E',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildColorItem(
                        context,
                        color: isDarkMode
                            ? const Color(0xFF1E293B)
                            : const Color(0xFFF7FAFC),
                        name: 'Background',
                        hex: isDarkMode ? '#1E293B' : '#F7FAFC',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildColorItem(
                        context,
                        color:
                            isDarkMode ? const Color(0xFF16202A) : Colors.white,
                        name: 'Surface',
                        hex: isDarkMode ? '#16202A' : '#FFFFFF',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildColorItem(
                        context,
                        color: isDarkMode
                            ? const Color(0xFFF7FAFC)
                            : const Color(0xFF1E293B),
                        name: 'Text Primary',
                        hex: isDarkMode ? '#F7FAFC' : '#1E293B',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildColorItem(
                        context,
                        color: isDarkMode
                            ? const Color(0xFFA0AEC0)
                            : const Color(0xFF4A5568),
                        name: 'Text Secondary',
                        hex: isDarkMode ? '#A0AEC0' : '#4A5568',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ),
        ...children,
        const SizedBox(height: 16),
        const Divider(),
      ],
    );
  }

  Widget _buildColorItem(
    BuildContext context, {
    required Color color,
    required String name,
    required String hex,
  }) {
    final textColor =
        color.computeLuminance() > 0.5 ? Colors.black : Colors.white;

    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            name,
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            hex,
            style: TextStyle(
              color: textColor.withValues(alpha: 0.8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
