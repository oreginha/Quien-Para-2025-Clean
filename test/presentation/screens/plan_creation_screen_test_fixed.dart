// test/presentation/screens/plan_creation_screen_test_fixed.dart
// ignore_for_file: always_specify_types

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quien_para/presentation/bloc/plan/plan_bloc.dart';
import 'package:quien_para/presentation/bloc/plan/plan_state.dart';
import 'package:quien_para/presentation/screens/create_proposal/proposal_detail_screen.dart';
import 'package:quien_para/presentation/screens/otras_propuestas/Detalles_Propuesta_Otros.dart';
import '../../helpers/firebase_test_utils.dart';

// Mock para PlanBloc
class MockPlanBloc extends Mock implements PlanBloc {}

void main() {
  late PlanBloc planBloc;

  setUp(() async {
    // Inicializar Firebase para pruebas
    await FirebaseTestUtils.initializeFirebase();

    // Usar un mock de PlanBloc en lugar del real
    planBloc = MockPlanBloc();

    // Configurar el comportamiento del mock según sea necesario
    when(planBloc.state).thenReturn(PlanState.initial());
  });

  tearDown(() {
    planBloc.close();
  });

  testWidgets('ProposalDetailScreen shows all required fields',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: planBloc,
          child: const DetallesPropuestaOtros(
            planId: '',
          ),
        ),
      ),
    );

    // Verify all required fields are present
    expect(find.byKey(const Key('plan_title_field')), findsOneWidget);
    expect(find.byKey(const Key('plan_description_field')), findsOneWidget);
    expect(find.byKey(const Key('plan_location_field')), findsOneWidget);
    expect(find.byKey(const Key('plan_category_field')), findsOneWidget);
  });

  testWidgets('ProposalDetailScreen can submit plan',
      (WidgetTester tester) async {
    // Configurar el estado del bloc para este test específico
    when(planBloc.state).thenReturn(PlanState.initial());

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: planBloc,
          child: const ProposalDetailScreen(),
        ),
      ),
    );

    // Fill in the form
    await tester.enterText(
        find.byKey(const Key('plan_title_field')), 'Test Plan');
    await tester.enterText(
        find.byKey(const Key('plan_description_field')), 'Test Description');
    await tester.enterText(
        find.byKey(const Key('plan_location_field')), 'Test Location');

    // Submit the form
    await tester.tap(find.byKey(const Key('submit_plan_button')));
    await tester.pumpAndSettle();

    // Verify the plan was created
    expect(find.text('Plan created successfully'), findsOneWidget);
  });
}
