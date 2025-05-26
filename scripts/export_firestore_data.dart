// ignore_for_file: unused_element, avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart'; // 👈 Necesario

Future<void> exportFullFirestoreStructure() async {
  final url = Uri.parse(
    'https://54ad-200-26-226-115.ngrok-free.app/export/full',
  );

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/export_firestore_full.json');
      await file.writeAsString(JsonEncoder.withIndent('  ').convert(data));
      print('✅ Estructura completa exportada a: ${file.path}');
    } else {
      print('❌ Error al exportar: ${response.statusCode} - ${response.body}');
    }
  } catch (e) {
    print('❌ Excepción: $e');
  }
}

Future<void> exportFirestoreCollection(String collectionName) async {
  final url = Uri.parse(
    'https://54ad-200-26-226-115.ngrok-free.app/openai/call',
  );

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'tool_call_id': 'export_$collectionName',
        'name': 'firestore_list_documents',
        'arguments': {'collection': collectionName, 'limit': 100},
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['output'];

      print('📄 Documentos de "$collectionName":');
      print(JsonEncoder.withIndent('  ').convert(data));

      // ✅ Obtener carpeta válida del sistema
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/export_$collectionName.json';
      final file = File(filePath);

      await file.writeAsString(JsonEncoder.withIndent('  ').convert(data));
      print('✅ Archivo guardado en: $filePath');
    } else {
      print('❌ Error ${response.statusCode}: ${response.body}');
    }
  } catch (e) {
    print('❌ Excepción al exportar: $e');
  }
}

Future<void> agregarDocumentoFirebase({
  required String collection,
  required Map<String, dynamic> data,
}) async {
  final url = Uri.parse(
    'https://54ad-200-26-226-115.ngrok-free.app/openai/call',
  );

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'tool_call_id': 'add_${DateTime.now().millisecondsSinceEpoch}',
      'name': 'firestore_add_document',
      'arguments': {'collection': collection, 'data': data},
    }),
  );

  if (response.statusCode == 200) {
    print('✅ Documento agregado: ${response.body}');
  } else {
    print('❌ Error al agregar documento: ${response.body}');
  }
}
