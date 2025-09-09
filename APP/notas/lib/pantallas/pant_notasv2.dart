import 'package:flutter/material.dart';
import 'package:notas/DDBB/db.dart';
import 'package:intl/intl.dart';

class PantNotasv2 extends StatefulWidget {
  final Map<String, dynamic>? nota; //null = nueva, con datos = editar

  const PantNotasv2({super.key, this.nota});

  @override
  State<PantNotasv2> createState() => _PantNotasv2();
}

class _PantNotasv2 extends State<PantNotasv2> {
  final TextEditingController _nota = TextEditingController();
  final TextEditingController _fecha = TextEditingController();
  String _selcate = 'seleccionar';
  String _msj = '';
  DateTime? _fechatime;

  final List<String> _categoria = [
    'seleccionar',
    'personal',
    'estudio',
    'trabajo',
  ];

  @override
  void initState() {
    super.initState();

    // 👇 Si es edición, rellenamos los campos con la nota existente
    if (widget.nota != null) {
      _selcate = widget.nota!['categoria'];
      _nota.text = widget.nota!['nota'];
      _fecha.text = widget.nota!['fecha'];
      _fechatime = DateTime.tryParse(widget.nota!['fecha']);
    }
  }

  Future<void> _selfecha(BuildContext context) async {
    final DateTime? sel = await showDatePicker(
      context: context,
      initialDate: _fechatime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (sel != null) {
      setState(() {
        _fechatime = sel;
        _fecha.text = DateFormat('yyyy-MM-dd').format(sel);
      });
    }
  }

  void _guardarnota() async {
    final categoria = _selcate;
    final fecha = _fecha.text;
    final nota = _nota.text;

    try {
      if (widget.nota == null) {
        await DBHelper.insertNota(categoria, fecha, nota);
      } else {
        await DBHelper.updateNota(widget.nota!['id'], categoria, fecha, nota);
      }

      if (mounted) Navigator.pop(context, true); // cerrar modal
    } catch (e) {
      setState(() {
        _msj = 'Error al guardar: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nota == null ? "Nueva nota" : "Editar nota"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: _categoria.contains(_selcate) ? _selcate : 'seleccionar',
              items: _categoria
                  .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
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
              controller: _fecha,
              readOnly: true,
              decoration: InputDecoration(
                labelText: "Fecha",
                suffixIcon: IconButton(
                  onPressed: () => _selfecha(context),
                  icon: const Icon(Icons.calendar_today),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nota,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Escribe nota',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _guardarnota,
              child: Text(widget.nota == null ? "Guardar" : "Actualizar"),
            ),
          ],
        ),
      ),
    );
  }
}
