// lib/utils/sample_data_loader.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class SampleDataLoader {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Logger logger = Logger();
  final List<Map<String, dynamic>> sampleUsers = <Map<String, dynamic>>[
    <String, dynamic>{
      'userId': 'user1',
      'name': 'Laura',
      'age': 24,
      'bio': 'Amante de la naturaleza y la fotografía',
      'gender': 'Femenino',
      'interests': <String>['Naturaleza', 'Fotografía', 'Viajes'],
      'location': 'Buenos Aires',
      'photoUrls': <String>['https://randomuser.me/api/portraits/women/1.jpg'],
      'updatedAt': DateTime.now().toIso8601String(),
    },
    <String, dynamic>{
      'userId': 'user2',
      'name': 'Carlos',
      'age': 28,
      'bio': 'Músico y desarrollador de software',
      'gender': 'Masculino',
      'interests': <String>['Música', 'Tecnología', 'Deportes'],
      'location': 'Buenos Aires',
      'photoUrls': <String>['https://randomuser.me/api/portraits/men/2.jpg'],
      'updatedAt': DateTime.now().toIso8601String(),
    },
    <String, dynamic>{
      'userId': 'user3',
      'name': 'Ana',
      'age': 26,
      'bio': 'Chef profesional, apasionada por la cocina',
      'gender': 'Femenino',
      'interests': <String>['Cocina', 'Arte', 'Viajes'],
      'location': 'La Plata',
      'photoUrls': <String>['https://randomuser.me/api/portraits/women/3.jpg'],
      'updatedAt': DateTime.now().toIso8601String(),
    },
  ];

  final List<Map<String, dynamic>> samplePlans = <Map<String, dynamic>>[
    <String, dynamic>{
      'id': 'plan1',
      'title': 'Trekking en Cerro Champaquí',
      'description':
          'Excursión de día completo con guía profesional. Incluye equipo y almuerzo.',
      'imageUrl': 'https://images.unsplash.com/photo-1551632811-561732d1e306',
      'creatorId': 'user1',
      'date': DateTime.now().add(const Duration(days: 7)).toIso8601String(),
      'category': 'Deportes',
      'location': 'Córdoba',
      'likes': 0,
      'conditions': <String, String>{
        'Número de invitados': '4',
        'Condiciones de pago': 'Cada uno lo suyo',
        'Nivel de actividad': 'Intenso',
        'Edad recomendada': '18+',
        'Transporte': 'Compartido',
        'Equipamiento': 'Especializado',
      },
      'createdAt': DateTime.now().toIso8601String(),
    },
    <String, dynamic>{
      'id': 'plan2',
      'title': 'Jam Session en Casa',
      'description':
          'Noche de música y buena onda. Trae tu instrumento y algo para compartir.',
      'imageUrl':
          'https://images.unsplash.com/photo-1510915361894-db8b60106cb1',
      'creatorId': 'user2',
      'date': DateTime.now().add(const Duration(days: 3)).toIso8601String(),
      'category': 'Música',
      'location': 'Palermo, Buenos Aires',
      'likes': 0,
      'conditions': <String, String>{
        'Número de invitados': '∞',
        'Condiciones de pago': 'Cada uno lo suyo',
        'Nivel de actividad': 'Tranquilo',
        'Edad recomendada': '18+',
        'Transporte': 'No necesario',
        'Equipamiento': 'Básico',
      },
      'createdAt': DateTime.now().toIso8601String(),
    },
    <String, dynamic>{
      'id': 'plan3',
      'title': 'Clase de Cocina Italiana',
      'description':
          'Aprenderemos a hacer pasta casera y diferentes salsas. Todos los ingredientes incluidos.',
      'imageUrl': 'https://images.unsplash.com/photo-1556910103-1c02745aae4d',
      'creatorId': 'user3',
      'date': DateTime.now().add(const Duration(days: 5)).toIso8601String(),
      'category': 'Cocina',
      'location': 'La Plata',
      'likes': 0,
      'conditions': <String, String>{
        'Número de invitados': '6',
        'Condiciones de pago': '50/50',
        'Nivel de actividad': 'Moderado',
        'Edad recomendada': 'Todas las edades',
        'Transporte': 'No necesario',
        'Equipamiento': 'No necesario',
      },
      'createdAt': DateTime.now().toIso8601String(),
    },
  ];

  Future<void> loadSampleData() async {
    try {
      // Cargar usuarios
      for (final Map<String, dynamic> user in sampleUsers) {
        await _firestore
            .collection('users')
            .doc(user['userId'] as String)
            .set(user);
        if (kDebugMode) {
          logger.d('Usuario creado: ${user['name']}');
        }
      }

      // Cargar planes
      for (final Map<String, dynamic> plan in samplePlans) {
        await _firestore
            .collection('plans')
            .doc(plan['id'] as String)
            .set(plan);
        if (kDebugMode) {
          logger.d('Plan creado: ${plan['title']}');
        }
      }

      if (kDebugMode) {
        logger.d('Datos de ejemplo cargados exitosamente');
      }
    } catch (e) {
      if (kDebugMode) {
        logger.d('Error al cargar datos de ejemplo: $e');
      }
    }
  }
}
