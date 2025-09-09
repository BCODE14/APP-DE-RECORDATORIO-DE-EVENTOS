import 'package:flutter/material.dart';
import 'package:notas/pantallas/pant_inises.dart';
import 'pantallas/pant_home.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'app de notas',
      theme: ThemeData(primarySwatch: Colors.deepPurple),

      initialRoute: '/',

      routes: {
        '/': (context) => const PantHome(),
        '/Iniciar sesion': (context) => const PantInises(),
        '/cerrar sesion': (context) => const PantHome(),
      },
    );
  }
}
