import 'package:flutter/material.dart';

class PantNotas extends StatefulWidget {
  const PantNotas({super.key});

  @override
  State<PantNotas> createState() => _PantNotasState();
}

class _PantNotasState extends State<PantNotas> {
  final TextEditingController _notaController = TextEditingController();
  String _selectedCategory = 'seleccionar';

  final List<Map<String, String>> _notas = [];

  final List<String> _categorias = [
    'seleccionar',
    'personal',
    'estudio',
    'trabajo',
  ];

  void _addnotas() {
    if (_notaController.text.trim().isEmpty) return;

    setState(() {
      _notas.add({
        'category': _selectedCategory,
        'text': _notaController.text.trim(),
      });

      _notaController.clear();
    });
  }

  void _deleteNote(int index) {
    setState(() {
      _notas.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Notas')),

      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              'crear nueva nota:',
              key: ValueKey('nottite'),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            DropdownButton<String>(
              key: const ValueKey('catsel'),
              value: _categorias.contains(_selectedCategory)
                  ? _selectedCategory
                  : 'seleccionar',

              items: _categorias
                  .map(
                    (cat) => DropdownMenuItem(
                      key: ValueKey(cat),
                      value: cat,
                      child: Text(cat),
                    ),
                  )
                  .toList(),

              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedCategory = value;
                  });
                }
              },
            ),

            const SizedBox(height: 16),

            TextField(
              key: const ValueKey('msjnota'),
              controller: _notaController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'escribe tu nota',
              ),
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              key: const ValueKey('btnaddnota'),
              onPressed: _addnotas,

              child: const Text('agregar nota'),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                key: const ValueKey('notlist'),
                itemCount: _notas.length,
                itemBuilder: (context, index) {
                  final note = _notas[index];
                  return Card(
                    key: ValueKey('notcar$index'),
                    margin: const EdgeInsets.symmetric(vertical: 8),

                    child: ListTile(
                      title: Text(
                        note['text']!,
                        key: ValueKey('nottext$index'),
                      ),

                      subtitle: Text(note['category']!),

                      trailing: IconButton(
                        key: ValueKey('btndel$index'),
                        onPressed: () => _deleteNote(index),
                        icon: const Icon(Icons.delete, color: Colors.red),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
