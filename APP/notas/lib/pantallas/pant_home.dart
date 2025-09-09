import 'package:flutter/material.dart';

class PantHome extends StatelessWidget {
  const PantHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'EVENTY RECORDIS',
              key: ValueKey('msjbien'),
              style: TextStyle(fontSize: 20),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              key: const ValueKey('btnsig'),
              onPressed: () {
                Navigator.pushNamed(context, '/Iniciar sesion');
              },

              child: const Text('Siguiente'),
            ),
          ],
        ),
      ),
    );
  }
}
