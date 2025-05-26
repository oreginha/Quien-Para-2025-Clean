// lib/core/widgets/styled_input.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quien_para/core/theme/app_colors.dart';
import 'package:quien_para/core/theme/theme_utils.dart';

class StyledInput extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final String? errorText;
  final bool obscureText;
  final TextInputType keyboardType;
  final Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextCapitalization textCapitalization;
  final bool autoFocus;
  final TextInputAction textInputAction;
  final bool readOnly;
  final VoidCallback? onTap;
  final int maxLines;

  const StyledInput({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.controller,
    this.errorText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.inputFormatters,
    this.focusNode,
    this.prefixIcon,
    this.suffixIcon,
    this.textCapitalization = TextCapitalization.none,
    this.autoFocus = false,
    this.textInputAction = TextInputAction.next,
    this.readOnly = false,
    this.onTap,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (labelText.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 6),
              child: Text(
                labelText,
                style: TextStyle(
                  color: ThemeUtils.textPrimary.withAlpha((255 * 0.9).round()),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
          TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            onChanged: onChanged,
            inputFormatters: inputFormatters,
            focusNode: focusNode,
            textCapitalization: textCapitalization,
            autofocus: autoFocus,
            textInputAction: textInputAction,
            readOnly: readOnly,
            onTap: onTap,
            maxLines: maxLines,
            style: TextStyle(color: ThemeUtils.textPrimary, fontSize: 16),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: ThemeUtils.textPrimary.withAlpha((255 * 0.6).round()),
                fontSize: 15,
              ),
              errorText: errorText,
              errorStyle: TextStyle(color: AppColors.accentRed, fontSize: 13),
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              filled: true,
              fillColor: ThemeUtils.textPrimary.withAlpha((255 * 0.5).round()),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppColors.darkSecondaryBackground,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppColors.brandYellow,
                  width: 1.5,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: ThemeUtils.accentRed, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: ThemeUtils.accentRed, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Variante para áreas de texto más grandes
class StyledTextArea extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final String? errorText;
  final Function(String)? onChanged;
  final FocusNode? focusNode;
  final TextCapitalization textCapitalization;
  final bool autoFocus;
  final int maxLines;
  final int? maxLength;

  const StyledTextArea({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.controller,
    this.errorText,
    this.onChanged,
    this.focusNode,
    this.textCapitalization = TextCapitalization.sentences,
    this.autoFocus = false,
    this.maxLines = 5,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (labelText.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 6),
              child: Text(
                labelText,
                style: TextStyle(
                  color: ThemeUtils.textPrimary.withAlpha((255 * 0.9).round()),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
          TextField(
            controller: controller,
            keyboardType: TextInputType.multiline,
            onChanged: onChanged,
            focusNode: focusNode,
            textCapitalization: textCapitalization,
            autofocus: autoFocus,
            maxLines: maxLines,
            maxLength: maxLength,
            style: TextStyle(color: ThemeUtils.textPrimary, fontSize: 16),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: ThemeUtils.textPrimary.withAlpha((288 * 0.5).round()),
                fontSize: 15,
              ),
              errorText: errorText,
              errorStyle: TextStyle(color: ThemeUtils.accentRed, fontSize: 13),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              filled: true,
              fillColor: ThemeUtils.textPrimary,
              counterStyle: TextStyle(
                color: ThemeUtils.textPrimary.withAlpha((255 * 0.6).round()),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: ThemeUtils.textPrimary.withAlpha((255 * 0.3).round()),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: ThemeUtils.textPrimary,
                  width: 1.5,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: ThemeUtils.accentRed, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: ThemeUtils.accentRed, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
