# Guía de Estilos UI para Quien Para

Este documento proporciona directrices para mantener la consistencia visual en las pantallas de la aplicación, siguiendo el sistema de diseño definido en `AppTheme`.

## Principios Generales

1. **Usa siempre los colores de AppTheme**
   - No utilices colores hardcodeados (como `Color(0xFF1A1B2E)` o `Colors.black`)
   - Usa las constantes como `AppTheme.colors.primary `, `AppTheme.colors.background `, etc.

2. **Usa los estilos de texto predefinidos**
   - En lugar de `TextStyle(color: Colors.white, fontSize: 24)`, usa `AppTypography.heading2`
   - Si necesitas personalizar, parte de los estilos base: `AppTheme.bodyMedium.copyWith(color: AppTheme.colors.primary )`

3. **Utiliza los espaciados consistentes**
   - Usa las constantes como `AppTheme.spacing1`, `AppTheme.spacing3`, etc. en lugar de valores hardcodeados
   - Ejemplo: `EdgeInsets.all(AppTheme.spacing5)` en lugar de `EdgeInsets.all(16)`

4. **Usa la gestión de opacidad correcta**
   - En lugar de `.withOpacity()` o `.withAlpha()`, usa la utilidad `ColorUtils.withAlpha()`
   - Ejemplo: `ColorUtils.withAlpha(AppTheme.shadowColor, 0.2)` en lugar de `Colors.black.withOpacity(0.2)`

5. **Usa los radios de borde consistentes**
   - Usa `AppTheme.borderRadiusS`, `AppTheme.borderRadiusM`, etc.
   - Ejemplo: `BorderRadius.circular(AppTheme.borderRadiusL)`

6. **Usa los gradientes predefinidos**
   - Usa `Theme.of(context).extension<AppTheme>()?.backgroundGradient` o `AppTheme.primaryGradient` cuando sea posible

## Mejoras Específicas para Pantallas de Perfil

### Edit Profile Screen

1. **Fondo de pantalla:**
   ```dart
   Container(
     decoration: BoxDecoration(
       gradient: Theme.of(context).extension<AppTheme>()?.backgroundGradient,
     ),
     child: ...
   )
   ```

2. **Campos de texto mejorados:**
   ```dart
   TextField(
     style: AppTheme.bodyMedium,
     decoration: AppTheme.getInputDecoration(
       hintText: 'Tu texto de ayuda',
       prefixIcon: Icons.person, // Opcional
     ),
   )
   ```

3. **Chips de intereses:**
   ```dart
   FilterChip(
     selected: isSelected,
     label: Text(interest),
     selectedColor: AppTheme.colors.primary ,
     checkmarkColor: AppTheme.colors.text ,
     darkPrimaryBackground: ColorUtils.withAlpha(AppTheme.darkSurfaceColor, 0.7),
     labelStyle: TextStyle(
       color: isSelected ? AppTheme.colors.text  : AppTheme. darkTextPrimary,
       fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
     ),
   )
   ```

4. **Botón de guardar:**
   ```dart
   ElevatedButton(
     style: ElevatedButton.styleFrom(
       darkPrimaryBackground: AppTheme.colors.primary ,
       foregroundColor: AppTheme.colors.text ,
       shape: RoundedRectangleBorder(
         borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
       ),
     ),
     onPressed: onPressFunction,
     child: Text('Guardar', style: AppTheme.button),
   )
   ```

### User Feed Screen

1. **AppBar mejorado:**
   ```dart
   AppBar(
     darkPrimaryBackground: AppTheme.colors.background ,
     elevation: 0,
     title: Text(
       'Mi Perfil',
       style: AppTypography.heading2.copyWith(
         color: AppTheme.colors.primary ,
       ),
     ),
     centerTitle: true,
   )
   ```

2. **Secciones de perfil:**
   ```dart
   Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
       _buildSectionHeader('Título Sección', Icons.icon_name),
       Container(
         padding: const EdgeInsets.all(AppTheme.spacing3),
         decoration: BoxDecoration(
           color: ColorUtils.withAlpha(AppTheme.colors.cardBackground, 0.7),
           borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
           border: Border.all(
             color: ColorUtils.withAlpha(AppTheme.dividerColor, 0.3),
           ),
         ),
         child: // contenido...
       ),
     ],
   )
   ```

3. **Tarjetas de planes:**
   ```dart
   Container(
     margin: const EdgeInsets.fromLTRB(
       AppTheme.spacing5, 0, AppTheme.spacing5, AppTheme.spacing3
     ),
     decoration: BoxDecoration(
       color: AppTheme.colors.cardBackground,
       borderRadius: BorderRadius.circular(AppTheme.borderRadiusL),
       boxShadow: [
         BoxShadow(
           color: ColorUtils.withAlpha(AppTheme.shadowColor, 0.2),
           blurRadius: 8,
           offset: const Offset(0, 4),
         ),
       ],
     ),
     child: // contenido...
   )
   ```

## Notas Adicionales

1. Utiliza los widgets de error y carga predefinidos cuando sea posible.
2. Para estados de UI como carga y errores, aprovecha los colores semánticos: `AppTheme. accentGreen`, `AppTheme.colors.accent     `, etc.
3. Utiliza `AppTheme.colors.text.withAlpha()` para estados como deshabilitado o énfasis medio.
4. Para efectos de sombra, utiliza siempre `ColorUtils.withAlpha(AppTheme.shadowColor, valor)`.

---

Siguiendo estas directrices, las pantallas de la aplicación mantendrán una apariencia visual consistente y profesional.
