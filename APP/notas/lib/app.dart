import 'package:flutter/material.dart';

import 'package:notas/pantallas/pant_inises.dart';
import 'package:notas/pantallas/pant_listevent.dart';
import 'package:notas/pantallas/pant_regis.dart';
import 'pantallas/pant_home.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'app de notas',
      theme: ThemeData(primarySwatch: Colors.deepPurple),

      navigatorKey: navigatorKey,

      initialRoute: '/',

      routes: {
        '/': (context) => const PantHome(),
        '/Iniciar sesion': (context) => const PantInises(),
        '/registrate': (context) => const PantRegis(),
        '/pant_listevent': (context) => const PantListevent(),
        //'/':()=> const ;
        '/cerrar sesion': (context) => const PantHome(),
      },
    );
  }
}
