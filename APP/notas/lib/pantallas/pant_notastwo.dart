import 'package:flutter/material.dart';
import 'package:notas/DDBB/db.dart';
import 'package:intl/intl.dart';

class PantNotastwo extends StatefulWidget {
  const PantNotastwo({super.key});

  @override
  State<PantNotastwo> createState() => _PantNotastwoState();
}

class _PantNotastwoState extends State<PantNotastwo> {
  final TextEditingController _nota = TextEditingController();
  final TextEditingController _fecha = TextEditingController();
  String _selcate = 'seleccionar';
  String _msj = 'mensaje';
  DateTime? _fechatime;

  final List<String> _categoria = [
    'seleccionar',
    'personal',
    'estudio',
    'trabajo',
  ];

  Future<void> _selfecha(BuildContext context) async {
    final DateTime? sel = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (sel != null) {
      setState(() {
        _fechatime = sel;
        _fecha.text = DateFormat('MM/dd/yyyy').format(sel);
      });
    }
  }

  void _guardarnota() async {
    final categoria = _selcate;
    final fecha = _fecha.text;
    final nota = _nota.text;

    try {
      //await DBHelper.insertNota(categoria, fecha, nota);
    } catch (e) {
      setState(() {
        _msj = 'Error al insertar: $e';
      });
    }
  }

  String? _validarnota(String? not) {
    if (not == null || not.isEmpty) {
      return 'Escribe un evento de recordatorio';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Crear un recordatorio de evento:',
              key: const ValueKey('textmodnota'),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            DropdownButton<String>(
              key: const ValueKey('selcat'),
              value: _categoria.contains(_selcate) ? _selcate : 'seleccionar',
              items: _categoria
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
                    _selcate = value;
                  });
                }
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              key: ValueKey('fecha'),
              controller: _fecha,
              readOnly: true,
              decoration: InputDecoration(
                labelText: "Date ",
                suffixIcon: IconButton(
                  onPressed: () => _selfecha(context),
                  icon: const Icon(Icons.calendar_today),
                ),
              ),
            ),

            TextFormField(
              key: const ValueKey('msjnota'),
              controller: _nota,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Escribe nota',
              ),
              validator: _validarnota,
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              key: ValueKey('btnguarnota'),
              onPressed: _guardarnota,
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
