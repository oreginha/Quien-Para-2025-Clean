import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quien_para/core/theme/app_colors.dart';
import 'package:quien_para/core/theme/provider/theme_provider.dart';
import 'package:quien_para/presentation/widgets/buttons/theme_aware_button.dart';

class ThemeCustomizationScreen extends StatefulWidget {
  static const String routeName = '/theme-customization';

  const ThemeCustomizationScreen({super.key});

  @override
  State<ThemeCustomizationScreen> createState() =>
      _ThemeCustomizationScreenState();
}

class _ThemeCustomizationScreenState extends State<ThemeCustomizationScreen> {
  // Color seleccionado temporalmente para vista previa
  Color? _selectedPrimaryColor;
  Color? _selectedAccentColor;

  @override
  void initState() {
    super.initState();
    // Inicializar con los colores actuales
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    _selectedPrimaryColor = themeProvider.brandYellow;
    _selectedAccentColor = themeProvider.accentColor;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    // Obtener colores según el tema
    final darkPrimaryBackground = AppColors.getBackground(isDarkMode);
    final darkTextPrimary = AppColors.getTextPrimary(isDarkMode);
    final darkTextSecondary = AppColors.getTextSecondary(isDarkMode);

    // Asegurarse de que los colores seleccionados están actualizados
    _selectedPrimaryColor ??= themeProvider.brandYellow;
    _selectedAccentColor ??= themeProvider.accentColor;

    return Scaffold(
      backgroundColor: darkPrimaryBackground,
      appBar: AppBar(
        backgroundColor: AppColors.getSecondaryBackground(isDarkMode),
        elevation: 0,
        title: Text(
          'Personalización de Tema',
          style: TextStyle(color: darkTextPrimary),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: darkTextPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Switch para activar/desactivar colores personalizados
            SwitchListTile(
              title: Text(
                'Usar colores personalizados',
                style: TextStyle(
                  color: darkTextPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Personaliza los colores principales de la aplicación',
                style: TextStyle(color: darkTextSecondary),
              ),
              value: themeProvider.useCustomColors,
              onChanged: (value) {
                themeProvider.setUseCustomColors(value);
              },
              activeColor: themeProvider.brandYellow,
            ),

            const SizedBox(height: 24),

            // Sección inhabilitada si no se están usando colores personalizados
            Opacity(
              opacity: themeProvider.useCustomColors ? 1.0 : 0.5,
              child: AbsorbPointer(
                absorbing: !themeProvider.useCustomColors,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Color principal
                    Text(
                      'Color Principal',
                      style: TextStyle(
                        color: darkTextPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Este color se usa para botones, resaltados y elementos importantes',
                      style: TextStyle(color: darkTextSecondary, fontSize: 14),
                    ),
                    const SizedBox(height: 16),

                    // Selector de color principal
                    _buildColorSelector(
                      selectedColor: _selectedPrimaryColor!,
                      onColorSelected: (color) {
                        setState(() {
                          _selectedPrimaryColor = color;
                        });
                        themeProvider.setPrimaryColor(color);
                      },
                    ),

                    const SizedBox(height: 32),

                    // Color de acento
                    Text(
                      'Color de Acento',
                      style: TextStyle(
                        color: darkTextPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Este color se usa para alertas, errores y elementos secundarios',
                      style: TextStyle(color: darkTextSecondary, fontSize: 14),
                    ),
                    const SizedBox(height: 16),

                    // Selector de color de acento
                    _buildColorSelector(
                      selectedColor: _selectedAccentColor!,
                      onColorSelected: (color) {
                        setState(() {
                          _selectedAccentColor = color;
                        });
                        themeProvider.setAccentColor(color);
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Vista previa de componentes
            if (themeProvider.useCustomColors) ...[
              Text(
                'Vista Previa',
                style: TextStyle(
                  color: darkTextPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Ejemplos de componentes con los colores seleccionados
              _buildPreviewComponents(),

              const SizedBox(height: 32),

              // Botón para resetear a colores por defecto
              Center(
                child: ThemeAwareButton(
                  text: 'Restaurar Colores Predeterminados',
                  variant: ButtonVariant.outline,
                  onPressed: () {
                    themeProvider.resetToDefaultColors();
                    setState(() {
                      _selectedPrimaryColor = themeProvider.brandYellow;
                      _selectedAccentColor = themeProvider.accentColor;
                    });
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Construir selector de colores con los colores predefinidos
  Widget _buildColorSelector({
    required Color selectedColor,
    required Function(Color) onColorSelected,
  }) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        // Opciones de colores predefinidos
        ...AppColors.predefinedColors.map((color) {
          final isSelected =
              color.r == selectedColor.r &&
              color.g == selectedColor.g &&
              color.b == selectedColor.b;

          return GestureDetector(
            onTap: () => onColorSelected(color),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.white : Colors.transparent,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      red: 0,
                      green: 0,
                      blue: 0,
                      alpha: 0.1,
                    ),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white)
                  : null,
            ),
          );
        }),

        // Opción para abrir selector de color personalizado
        GestureDetector(
          onTap: () => _openColorPicker(selectedColor, onColorSelected),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey, width: 1),
            ),
            child: const Icon(Icons.add, color: Colors.grey),
          ),
        ),
      ],
    );
  }

  // Abrir el selector de color personalizado
  void _openColorPicker(
    Color initialColor,
    Function(Color) onColorSelected,
  ) async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.isDarkMode;

    final Color? result = await showDialog<Color>(
      context: context,
      builder: (context) => _ColorPickerDialog(
        initialColor: initialColor,
        isDarkMode: isDarkMode,
      ),
    );

    if (result != null) {
      onColorSelected(result);
    }
  }

  // Vista previa de componentes con los colores seleccionados
  Widget _buildPreviewComponents() {
    return Column(
      children: [
        // Botón primario
        ThemeAwareButton(
          text: 'Botón Primario',
          variant: ButtonVariant.primary,
          isFullWidth: true,
          onPressed: () {},
        ),

        const SizedBox(height: 16),

        // Botón secundario
        ThemeAwareButton(
          text: 'Botón Secundario',
          variant: ButtonVariant.secondary,
          isFullWidth: true,
          onPressed: () {},
        ),

        const SizedBox(height: 16),

        // Tarjeta con el color primario
        Card(
          color: _selectedPrimaryColor,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.star,
                  color: AppColors.getContrastColor(_selectedPrimaryColor!),
                ),
                const SizedBox(width: 16),
                Text(
                  'Tarjeta con Color Principal',
                  style: TextStyle(
                    color: AppColors.getContrastColor(_selectedPrimaryColor!),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Tarjeta con el color de acento
        Card(
          color: _selectedAccentColor,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.warning,
                  color: AppColors.getContrastColor(_selectedAccentColor!),
                ),
                const SizedBox(width: 16),
                Text(
                  'Tarjeta con Color de Acento',
                  style: TextStyle(
                    color: AppColors.getContrastColor(_selectedAccentColor!),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Diálogo para seleccionar un color personalizado
class _ColorPickerDialog extends StatefulWidget {
  final Color initialColor;
  final bool isDarkMode;

  const _ColorPickerDialog({
    required this.initialColor,
    required this.isDarkMode,
  });

  @override
  State<_ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<_ColorPickerDialog> {
  late Color _selectedColor;

  // Valores HSV para el selector
  late double _hue;
  late double _saturation;
  late double _value;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.initialColor;

    // Convertir a HSV
    final HSVColor hsvColor = HSVColor.fromColor(_selectedColor);
    _hue = hsvColor.hue;
    _saturation = hsvColor.saturation;
    _value = hsvColor.value;
  }

  // Actualizar el color seleccionado
  void _updateColor() {
    setState(() {
      _selectedColor = HSVColor.fromAHSV(
        1.0,
        _hue,
        _saturation,
        _value,
      ).toColor();
    });
  }

  @override
  Widget build(BuildContext context) {
    final darkPrimaryBackground = widget.isDarkMode
        ? AppColors.darkSecondaryBackground
        : AppColors.lightSecondaryBackground;

    final textColor = widget.isDarkMode
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;

    return AlertDialog(
      backgroundColor: darkPrimaryBackground,
      title: Text('Seleccionar Color', style: TextStyle(color: textColor)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Muestra del color seleccionado
          Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              color: _selectedColor,
              borderRadius: BorderRadius.circular(8),
            ),
          ),

          const SizedBox(height: 24),

          // Slider para Hue (tono)
          Text('Tono', style: TextStyle(color: textColor)),
          Slider(
            value: _hue,
            min: 0,
            max: 360,
            onChanged: (value) {
              setState(() {
                _hue = value;
                _updateColor();
              });
            },
            activeColor: HSVColor.fromAHSV(1.0, _hue, 1.0, 1.0).toColor(),
          ),

          // Slider para Saturation (saturación)
          Text('Saturación', style: TextStyle(color: textColor)),
          Slider(
            value: _saturation,
            min: 0,
            max: 1,
            onChanged: (value) {
              setState(() {
                _saturation = value;
                _updateColor();
              });
            },
            activeColor: HSVColor.fromAHSV(
              1.0,
              _hue,
              _saturation,
              1.0,
            ).toColor(),
          ),

          // Slider para Value (valor/brillo)
          Text('Brillo', style: TextStyle(color: textColor)),
          Slider(
            value: _value,
            min: 0,
            max: 1,
            onChanged: (value) {
              setState(() {
                _value = value;
                _updateColor();
              });
            },
            activeColor: HSVColor.fromAHSV(1.0, _hue, 1.0, _value).toColor(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar', style: TextStyle(color: textColor)),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, _selectedColor),
          style: ElevatedButton.styleFrom(
            backgroundColor: _selectedColor,
            foregroundColor: AppColors.getContrastColor(_selectedColor),
          ),
          child: const Text('Aceptar'),
        ),
      ],
    );
  }
}
