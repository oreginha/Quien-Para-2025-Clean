import 'package:flutter/material.dart';
import 'package:quien_para/core/theme/app_colors.dart';

class CustomDatePicker extends StatelessWidget {
  final DateTime? selectedDate; // Fecha seleccionada
  final void Function(BuildContext context)
      onSelectDate; // Acción para abrir el selector de fecha
  final double? width; // Ancho opcional
  final double? height; // Alto opcional
  final Color? buttonColor; // Color del botón
  final Color? textColor; // Color del texto
  final String? noDateText; // Texto cuando no hay fecha seleccionada

  const CustomDatePicker({
    super.key,
    this.selectedDate,
    required this.onSelectDate,
    this.width,
    this.height,
    this.buttonColor,
    this.textColor,
    this.noDateText,
  });

  @override
  Widget build(final BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 50.0,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              selectedDate != null
                  ? 'Fecha seleccionada: ${selectedDate!.toLocal().toString().split(' ')[0]}'
                  : noDateText ?? 'Sin fecha seleccionada',
              style: TextStyle(fontSize: 16, color: textColor ?? Colors.black),
            ),
          ),
          SizedBox(
            height: height ?? 50.0,
            child: ElevatedButton(
              onPressed: () => onSelectDate(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor ?? AppColors.brandYellow,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: const Text(
                'Seleccionar fecha',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
