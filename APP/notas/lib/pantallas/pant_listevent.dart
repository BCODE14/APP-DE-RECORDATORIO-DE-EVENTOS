import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:notas/DDBB/db.dart';
import 'package:notas/api/localstorage.dart';
import 'package:notas/api/pendiente.dart';
import 'package:notas/app.dart';
import 'package:notas/pantallas/pant_calennotas.dart';
import 'package:notas/pantallas/pant_notastwo.dart';
import 'package:notas/pantallas/pant_perfil.dart';
import 'package:notas/pantallas/pant_notasv2.dart';
import 'sesion.dart';

class PantListevent extends StatefulWidget {
  const PantListevent({super.key});
  @override
  State<PantListevent> createState() => _PantListEventState();
}

class _PantListEventState extends State<PantListevent> {
  String fotoperfil = "assets/foto.jpg";
  List<Map<String, dynamic>> _eventos = [];
  String? _filcat;
  String? _filnom;
  DateTime? _filfecha;

  @override
  void initState() {
    super.initState();
    _CargarEventoHoy();
    //funcion sincronizacion con api y sqlite
    _sincronizar();

    //notificaciones
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;

      if (notification != null) {
        final ctx = navigatorKey.currentContext; // <- contexto global actual
        if (ctx != null) {
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(content: Text(notification.title ?? "Sin título")),
          );
        }
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      navigatorKey.currentState?.pushNamed('/Iniciar sesion');
    });
  }

  Future<void> _sincronizar() async {
    final rs = await usardatausuario();
    await sincronizaciondata(rs['token']);
  }

  Future<void> _CargarEventoHoy() async {
    final hoy = DateTime.now();
    final resul = await DBHelper.getNotas();
    setState(() {
      _eventos = resul
          .where(
            (x) =>
                x['fecha'] ==
                "${hoy.year}-${hoy.month.toString().padLeft(2, '0')}-${hoy.day.toString().padLeft(2, '0')}",
          )
          .toList();
    });
  }

  Future<void> _BuscarEventos() async {
    final resul = await DBHelper.getNotas();
    setState(() {
      _eventos = resul.where((x) {
        final sinfiltipo = _filcat == null || x['tipo'] == _filcat;
        final sinfilnom =
            _filnom == null ||
            x['nota'].toString().toLowerCase().contains(_filnom!.toLowerCase());
        final sinfilfech =
            _filfecha == null ||
            x['fecha'] ==
                "${_filfecha!.year}-${_filfecha!.month.toString().padLeft(2, '0')}-${_filfecha!.day.toString().padLeft(2, '0')}";

        return sinfiltipo && sinfilfech && sinfilnom;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, ${Sesion.usuario}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('Tienes los siguientes eventos por asistir'),
                  ],
                ),
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage("assets/foto.jpg"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    key: ValueKey('btnsel'),
                    isExpanded: true,
                    hint: const Text("Seleccionar"),
                    value: _filcat,
                    items: const [
                      DropdownMenuItem(
                        value: "Trabajo",
                        child: Text("Trabajo"),
                      ),
                      DropdownMenuItem(
                        value: "Estudio",
                        child: Text("Estudio"),
                      ),
                      DropdownMenuItem(value: "Amigos", child: Text("Amigos")),
                    ],
                    onChanged: (val) => setState(() => _filcat = val),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    key: ValueKey('btnfecha'),
                    decoration: const InputDecoration(labelText: "Fecha"),
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      final fecha = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (fecha != null) setState(() => _filfecha = fecha);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    key: ValueKey('btnnombre'),
                    decoration: const InputDecoration(labelText: "Nombre"),
                    onChanged: (val) => _filnom = val,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  key: ValueKey('btnfiltrar'),
                  onPressed: _BuscarEventos,
                  child: const Text("Filtrar"),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Expanded(
              child: _eventos.isEmpty
                  ? const Center(child: Text("No hay eventos"))
                  : ListView.builder(
                      itemCount: _eventos.length,
                      itemBuilder: (context, index) {
                        final e = _eventos[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.grey.shade300),
                          ),
                          child: ListTile(
                            leading: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  e['fecha'].toString().substring(8, 10),
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  _mesAbrev(
                                    e['fecha'].toString().substring(5, 7),
                                  ),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            title: Text("Tipo: ${e['tipo']}"),
                            subtitle: Text(e['hora'] + e['nota']),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  key: ValueKey('btneditar'),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => Dialog(
                                        child: SizedBox(
                                          width: double.infinity,
                                          height: 400,
                                          child: const PantNotasv2(),
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.edit),
                                ),
                                IconButton(
                                  key: ValueKey('btneliminar'),
                                  onPressed: () async {
                                    eliminarevent(e['id']);
                                    //await DBHelper.eliminarNota(e['id']);
                                    _CargarEventoHoy();
                                  },
                                  icon: const Icon(Icons.delete),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        key: ValueKey('btncrearnota'),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => Dialog(
              child: SizedBox(
                width: double.infinity,
                height: 400,
                child: const PantNotasv2(),
              ),
            ),
          );
          _CargarEventoHoy();
        },
        backgroundColor: Colors.pink,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              key: ValueKey('btnhome'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const PantListevent(),
                    fullscreenDialog: true,
                  ),
                );
              },
              icon: const Icon(Icons.home),
            ),
            IconButton(
              key: ValueKey('btnperfil'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const PantPerfil(),
                    fullscreenDialog: true,
                  ),
                );
              },
              icon: const Icon(Icons.person),
            ),
            const SizedBox(width: 40),
            IconButton(
              key: ValueKey('btncalendar'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const NotasCalendar(),
                    fullscreenDialog: true,
                  ),
                );
              },
              icon: const Icon(Icons.calendar_today),
            ),
            IconButton(
              key: ValueKey('btnsalir'),
              onPressed: () {
                Sesion.usuario = null;
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/cerrar sesion',
                  (route) => false,
                );
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
      ),
    );
  }

  String _mesAbrev(String mes) {
    const meses = {
      "01": "ENE",
      "02": "FEB",
      "03": "MAR",
      "04": "ABR",
      "05": "MAY",
      "06": "JUN",
      "07": "JUL",
      "08": "AGO",
      "09": "SEP",
      "10": "OCT",
      "11": "NOV",
      "12": "DIC",
    };
    return meses[mes] ?? "";
  }
}
