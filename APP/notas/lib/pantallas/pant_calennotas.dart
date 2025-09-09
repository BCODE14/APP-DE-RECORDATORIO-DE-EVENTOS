import 'package:notas/DDBB/db.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class NotasCalendar extends StatefulWidget {
  const NotasCalendar({super.key});

  @override
  State<NotasCalendar> createState() => _NotasCalendarState();
}

class _NotasCalendarState extends State<NotasCalendar> {
  DateTime _fechahoy = DateTime.now();
  DateTime? _selefecha;

  Map<DateTime, List<String>> _notas = {};

  @override
  void initState() {
    super.initState();
    _cargarNotas(); //Se llama al entrar en la pantalla
  }

  Future<void> _cargarNotas() async {
    final notasDB = await DBHelper.getNotas();
    final data = <DateTime, List<String>>{};
    for (var nota in notasDB) {
      final fecha = DateTime.parse(nota['fecha']); // si guardas YYYY-MM-DD
      final fechaKey = DateTime.utc(fecha.year, fecha.month, fecha.day);
      if (data[fechaKey] == null) {
        data[fechaKey] = [];
      }
      data[fechaKey]!.add(nota['nota']);
    }

    setState(() {
      _notas = data;
    });
  }

  List<String> _getNotas(DateTime day) {
    return _notas[DateTime.utc(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calendario de eventos')),

      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TableCalendar(
              focusedDay: _fechahoy,
              firstDay: DateTime(2000),
              lastDay: DateTime(2100),
              selectedDayPredicate: (dia) => isSameDay(_selefecha, dia),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _fechahoy = focusedDay;
                  _selefecha = selectedDay;
                });
              },
              eventLoader: _getNotas,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: _getNotas(
                  _selefecha ?? _fechahoy,
                ).map((nota) => ListTile(title: Text(nota))).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
