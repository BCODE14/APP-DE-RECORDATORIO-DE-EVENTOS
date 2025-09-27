import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

Future<void> guardardatausuario(
  String token,
  String id,
  String usernom,
  String? tokenfcm,
) async {
  await storage.write(key: "token", value: token);
  await storage.write(key: "id", value: id);
  await storage.write(key: "usernom", value: usernom);
  await storage.write(key: "tokenfcm", value: tokenfcm);
}

Future<Map<String, dynamic>> usardatausuario() async {
  final Map<String, dynamic> datauser = {
    "token": await storage.read(key: "token"),
    "id": await storage.read(key: "id"),
    "usernom": await storage.read(key: "usernom"),
    "tokenfcm": await storage.read(key: "tokenfcm"),
  };
  return datauser;
}

Future<void> eliminardatauser() async {
  await storage.delete(key: "token");
  await storage.delete(key: "id");
  await storage.delete(key: "usernom");
}
