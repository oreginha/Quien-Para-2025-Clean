// ignore_for_file: unused_import, always_specify_types

import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quien_para/domain/repositories/auth/auth_repository.dart';
import 'package:quien_para/domain/repositories/plan/plan_repository.dart';
import 'package:quien_para/domain/repositories/chat/chat_repository.dart';
import 'package:quien_para/domain/repositories/matching/matching_repository.dart';
import 'package:quien_para/domain/repositories/notification/notification_repository.dart';
// Eliminada la importación de planes_api_service.dart ya que fue consolidada en los repositorios

// Generamos mocks para las interfaces consolidadas de repositorios
@GenerateMocks([
  AuthRepository,
  PlanRepository,
  ChatRepository,
  MatchingRepository,
  NotificationRepository
])
void main() {}
