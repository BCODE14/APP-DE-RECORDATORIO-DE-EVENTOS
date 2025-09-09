import 'package:flutter/material.dart';
import 'package:notas/DDBB/db.dart';

class PantInises extends StatefulWidget {
  const PantInises({super.key});

  @override
  State<PantInises> createState() => _IniciaSesionState();
}

class _IniciaSesionState extends State<PantInises> {
  final TextEditingController _user = TextEditingController();

  final TextEditingController _contra = TextEditingController();
  final TextEditingController _contraconfir = TextEditingController();

  String _msj = "";

  //funcion para validar nombre
  String? _validarnombre(String? nom) {
    if (nom == null || nom.isEmpty) {
      return "El usuario no puede estar vacio.";
    }

    final result = RegExp(r'^[a-zA-Z]+$');

    if (!result.hasMatch(nom)) {
      return "El usuario solo puede contener letras";
    }
    return null;
  }

  //funcion para validar contrasena
  String? _validarcontrasena(String? contra) {
    if (contra == null || contra.isEmpty) {
      return "La contraseña es obligatoria";
    }

    final resul = RegExp(r'^[A-Z0-9!@#\$%\^&\*\(\)\-\+=\.,\?]{6}$');

    if (!resul.hasMatch(contra)) {
      return "La contraseña puede contener letras, digitos y simbolos";
    }

    return null;
  }

  //funcion para login
  void _login() async {
    final usuario = _user.text;
    final clave = _contra.text;
    final claveconfir = _contraconfir.text;
    final ctx = context;

    if (clave == claveconfir) {
      final resul = await DBHelper.insertUser(usuario, clave);

      if (resul == 1) {
        setState(() {
          _msj = 'registro exitosos';
        });
        Navigator.pushNamed(ctx, '/pant_inises');
      } else {
        setState(() {
          _msj = 'Error al registrar usuario';
        });
      }
    } else {
      setState(() {
        _msj = 'Las contrasenas no son coinciden';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Registrate',
              key: ValueKey('titregis'),
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            TextFormField(
              key: const ValueKey('user'),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Usuario',
              ),
              validator: _validarnombre,
            ),

            const SizedBox(height: 20),

            TextFormField(
              key: const ValueKey('contra'),
              controller: _contra,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Contraseña',
              ),
              obscureText: true,
              validator: _validarcontrasena,
            ),

            TextFormField(
              key: const ValueKey('contraconfir'),
              controller: _contra,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Confirmar Contraseña',
              ),
              obscureText: true,
              validator: _validarcontrasena,
            ),

            ElevatedButton(
              key: const ValueKey('btningresar'),
              onPressed: _login,
              child: const Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }
}
