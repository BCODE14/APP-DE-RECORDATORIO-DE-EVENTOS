import 'package:flutter/material.dart';
import 'package:notas/DDBB/db.dart';
import 'package:notas/pantallas/sesion.dart';

class PantInises extends StatefulWidget {
  const PantInises({super.key});

  @override
  State<PantInises> createState() => _IniciaSesionState();
}

class _IniciaSesionState extends State<PantInises> {
  final TextEditingController _user = TextEditingController();
  final TextEditingController _contra = TextEditingController();

  String _msj = "";

  //funcion para  validar nombre
  String? _validarnombre(String? nom) {
    if (nom == null || nom.isEmpty) {
      return "La contraseña no puede ser vacia";
    }
    final result = RegExp(r'^[a-zA-Z]+$');

    if (!result.hasMatch(nom)) {
      return "El usuario solo puede tener letras";
    }
    return null;
  }

  // funcion para validar contrasena
  String? _validarcontrsena(String? value) {
    if (value == null || value.isEmpty) {
      return "La contraseña no puede ser vacia";
    }

    final result = RegExp(r'^[A-Z0-9!@#\$%\^&\*\(\)\-\+=\.,\?]{6}$');

    if (!result.hasMatch(value)) {
      return "La contraseña debe contener 6 digitos";
    }

    return null;
  }

  //funcion login
  void _login() async {
    final usuario = _user.text;
    final clave = _contra.text;

    final resul = await DBHelper.login(usuario, clave);

    if (resul != null) {
      Sesion.usuario = resul['user'];
      setState(() {
        _msj = 'login exitosos';
      });

      if (!mounted) return;

      Navigator.pushNamed(context, '/pant_listevent');
    } else {
      setState(() {
        _msj = 'Usuario o contraseña incorrectos';
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
              'Inicia Sesion',
              key: ValueKey('titinisesi'),
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
              maxLength: 6,
              validator: _validarcontrsena,
            ),

            Text(
              _msj,
              key: const ValueKey('msjconf'),
              style: const TextStyle(color: Colors.red),
            ),

            ElevatedButton(
              key: const ValueKey('btningresar'),
              onPressed: _login,
              child: const Text('Ingresar'),
            ),
          ],
        ),
      ),
    );
  }
}
