import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FirestoreListScreen extends StatefulWidget {
  const FirestoreListScreen({super.key});

  @override
  State<FirestoreListScreen> createState() => _FirestoreListScreenState();
}

class _FirestoreListScreenState extends State<FirestoreListScreen> {
  List<dynamic> documentos = [];
  bool cargando = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    obtenerDocumentos();
  }

  Future<void> obtenerDocumentos() async {
    final url =
        Uri.parse('https://54ad-200-26-226-115.ngrok-free.app/openai/call');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'tool_call_id': 'desde_flutter',
          'name': 'firestore_list_documents',
          'arguments': {
            'collection': 'usuarios', // Cambiá por tu colección real
            'limit': 20
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          documentos = data['output'];
          cargando = false;
        });
      } else {
        setState(() {
          error = 'Error ${response.statusCode}: ${response.body}';
          cargando = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Excepción: $e';
        cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (cargando) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (error.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Firestore')),
        body: Center(child: Text(error)),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Documentos de Firestore')),
      body: ListView.builder(
        itemCount: documentos.length,
        itemBuilder: (context, index) {
          final doc = documentos[index];
          final id = doc['id'];
          final data = doc['data'];

          return ListTile(
            leading: const Icon(Icons.person),
            title: Text(
              data['name'] ?? data['title'] ?? 'Documento sin nombre',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('ID: $id'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Podés abrir otra pantalla, mostrar detalles, etc.
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text('Datos de $id'),
                  content: Text(JsonEncoder.withIndent('  ').convert(data)),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cerrar'),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
