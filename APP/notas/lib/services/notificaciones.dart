import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:notas/api/peticiones.dart';

Future<String?> firebasenotificaciones() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Solicitar permisos
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  print('Permisos: ${settings.authorizationStatus}');

  // Obtener el token del dispositivo
  String? token = await messaging.getToken();
  print("Token FCM: $token");

  //Enviar token al backend bbdd
  if (token != null) {
    await guardartoken(token);
  }
  return token;
}
