// libcore/blocs/applications_management/applications_management_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quien_para/core/di/di.dart';
import 'applications_management_bloc.dart';

class ApplicationsManagementProvider extends StatelessWidget {
  final Widget child;

  const ApplicationsManagementProvider({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ApplicationsManagementBloc>(
      create: (context) => sl<ApplicationsManagementBloc>(),
      child: child,
    );
  }
}
