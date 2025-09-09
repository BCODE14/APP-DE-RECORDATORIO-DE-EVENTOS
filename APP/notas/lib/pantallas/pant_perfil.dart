import 'package:notas/DDBB/db.dart';
import 'sesion.dart';
import 'package:flutter/material.dart';

class PantPerfil extends StatefulWidget {
  const PantPerfil({super.key});

  @override
  State<PantPerfil> createState() => _PantPerfilState();
}

class _PantPerfilState extends State<PantPerfil> {
  String fotoperfil = "assets/foto.jpg";

  Map<String, int> _contnotascat = {};

  @override
  void initState() {
    super.initState();
    _cargarnotas();
  }

  Future<void> _cargarnotas() async {
    final result = await DBHelper.getNotas();
    final data = <String, int>{};

    for (var nota in result) {
      final Categoria = nota['categoria'] ?? "general";
      data[Categoria] = (data[Categoria] ?? 0) + 1;
    }

    setState(() {
      _contnotascat = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Perfil")),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            CircleAvatar(radius: 50, backgroundImage: AssetImage(fotoperfil)),

            const SizedBox(height: 10),

            Text(
              '${Sesion.usuario}',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const Divider(height: 40, thickness: 1),

            Expanded(
              child: _contnotascat.isEmpty
                  ? const Center(
                      child: Text(
                        'Sin eventos por recordar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  : ListView(
                      children: _contnotascat.entries.map((entrada) {
                        return ListTile(
                          title: Text(entrada.key),
                          trailing: Text(
                            "${entrada.value} notas",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        );
                      }).toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
