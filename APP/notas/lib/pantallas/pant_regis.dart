import 'package:flutter/material.dart';
import 'package:notas/DDBB/db.dart';
import 'package:notas/api/peticiones.dart';

class PantRegis extends StatefulWidget {
  const PantRegis({super.key});

  @override
  State<PantRegis> createState() => _IniciaSesionState();
}

class _IniciaSesionState extends State<PantRegis> {
  final TextEditingController _user = TextEditingController();

  final TextEditingController _contra = TextEditingController();
  final TextEditingController _contraconfir = TextEditingController();

  final _formKey = GlobalKey<FormState>(); //para validar los campos de entrada

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
      return "La contrasena es obligatoria";
    }

    final resul = RegExp(r'^[A-Z0-9!@#\$%\^&\*\(\)\-\+=\.,\?]{6}$');

    if (!resul.hasMatch(contra)) {
      return "La contrasena puede contener letras, digitos y simbolos";
    }

    return null;
  }

  //funcion para registrar
  void _registrar() async {
    final usuario = _user.text;
    final clave = _contra.text;
    final claveconfir = _contraconfir.text;

    if (clave == claveconfir) {
      // final resul = await DBHelper.insertUser(usuario, clave);
      final data = {'usuario': usuario, 'password': clave};

      //registrarse solo funciona cuando tiene internet
      final resul = await registrausuario(data);

      print('envio a la base de datos');

      if (resul == 1) {
        setState(() {
          _msj = 'registro exitosos';
        });
        if (!mounted) return;
        Navigator.pushNamed(context, '/Iniciar sesion');
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

  void _login() {
    if (!mounted) return;
    Navigator.pushNamed(context, '/Iniciar sesion');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
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
                controller: _user,
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
              const SizedBox(height: 20),
              TextFormField(
                key: const ValueKey('contraconfir'),
                controller: _contraconfir,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Confirmar Contraseña',
                ),
                obscureText: true,
                validator: _validarcontrasena,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                key: const ValueKey('btnregistara'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _registrar();
                  }
                },
                child: const Text('Registrar'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                key: const ValueKey('btnlogin'),
                onPressed: _login,
                child: const Text('iniciar sesion'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
