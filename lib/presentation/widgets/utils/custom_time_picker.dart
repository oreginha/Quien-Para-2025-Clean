import 'package:flutter/material.dart';

class CustomTimePicker extends StatelessWidget {
  final TimeOfDay? selectedTime;
  final Future<TimeOfDay?> Function(BuildContext) onSelectTime;
  final Color buttonColor;
  final Color textColor;

  const CustomTimePicker({
    super.key,
    this.selectedTime,
    required this.onSelectTime,
    this.buttonColor = Colors.blue,
    this.textColor = Colors.black,
    required final String noTimeText,
  });

  @override
  Widget build(final BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          selectedTime != null
              ? 'Hora seleccionada: ${selectedTime!.format(context)}'
              : 'Selecciona una hora para el evento',
          style: TextStyle(color: textColor, fontSize: 16),
        ),
        ElevatedButton(
          onPressed: () async {
            final TimeOfDay? time = await onSelectTime(context);
            if (time != null) {
              // Manejo del tiempo seleccionado
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
          child: const Text('Seleccionar hora'),
        ),
      ],
    );
  }
}
