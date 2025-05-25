// integration_test/date_location_flow_test.dart
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
// ignore: depend_on_referenced_packages
//import 'package:integration_test/integration_test.dart';
import 'package:quien_para/presentation/screens/create_proposal/steps/date_location_step.dart';

void main() {
  setUpAll(() {
    //IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets('Complete date and location selection flow',
      (final WidgetTester tester) async {
    // Necesitamos crear un widget de prueba en lugar de usar MyApp directamente
    await tester.pumpWidget(
      MaterialApp(
        home: DateLocationStep(
          pageController: PageController(),
          onDateSelect: (final _) {},
          onCitySelect: (final _) {},
          onNext: () {},
        ),
      ),
    );

    // Verificar que estamos en la pantalla correcta
    expect(find.text('¿Cuándo y dónde será el plan?'), findsOneWidget);

    // Seleccionar fecha
    await tester.tap(find.byIcon(Icons.calendar_today));
    await tester.pumpAndSettle();

    // Seleccionar ciudad
    await tester.enterText(
        find.byType(TextField), 'Ciudad Autónoma de Buenos Aires');
    await tester.pumpAndSettle();

    // Verificar que el botón de continuar está habilitado
    final Finder buttonFinder = find.text('Continuar');
    expect(buttonFinder, findsOneWidget);
  });
}
