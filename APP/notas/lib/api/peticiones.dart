import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_rutas.dart';

//definicion de peticiones a la api

//registrar usuario - 1 registro exitoso y 0 fallido
Future<int> registrausuario(Map<String, dynamic> data) async {
  try {
    print(data);
    final respuesta = await http.post(
      Uri.parse(ApiRutas.registrar),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (respuesta.statusCode == 200) {
      return 1; //registrado
    } else {
      return 0;
    }
  } catch (e) {
    print('no se pudo conectar con la api(error de red): $e');
    return 0;
  }
}

//login usuario
Future<Map<String, dynamic>?> loginusuario(Map<String, dynamic> data) async {
  try {
    print(data);
    print(ApiRutas.login);
    final respuesta = await http.post(
      Uri.parse(ApiRutas.login),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (respuesta.statusCode == 200) {
      final result = jsonDecode(respuesta.body); //devuelve el token y id
      return result; //login exitoso - creacion de token duracion 1 hora
    } else {
      return null;
    }
  } catch (e) {
    print('no se pudo conectar con la api(error de red): $e');
    return null;
  }
}

//crear un eventos
Future<String> crearevento(Map<String, dynamic> data, String token) async {
  try {
    final respt = await http.post(
      Uri.parse(ApiRutas.crear),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    if (respt.statusCode == 201) {
      final result = jsonDecode(respt.body);
      final id = result['id'];
      return id; //creado con exito devolver id para guardarlo en sqllite
    } else {
      return "0";
    }
  } catch (e) {
    print('no se pudo conectar con la api(error de red): $e');
    return "0";
  }
}

//consultar todos los eventos
Future<Map<String, dynamic>?> consultareventos(String token) async {
  try {
    final respt = await http.get(
      Uri.parse(ApiRutas.totaleventos),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (respt.statusCode == 200) {
      final resul = jsonDecode(respt.body);

      return resul; //todos los eventos retornar
    } else {
      return null;
    }
  } catch (e) {
    print('no se pudo conectar con la api(error de red): $e');
    return null;
  }
}

//consultar los eventos con condicion no sincronizados
Future<List<dynamic>> consultareventosin(String token) async {
  try {
    final result = await http.get(
      Uri.parse(ApiRutas.eventoscond),
      headers: {
        'Content-Type': 'application/json',
        'authorization': 'Bearer $token',
      },
    );

    if (result.statusCode == 200) {
      final List<dynamic> r = jsonDecode(result.body);
      return r;
    } else {
      return [];
    }
  } catch (e) {
    print('no se puede conectar con la api:$e');
    return [];
  }
}

//actualizar un evento
Future<int> actualizarevento(
  Map<String, dynamic> body,
  String id,
  String token,
) async {
  try {
    final respuesta = await http.put(
      Uri.parse(ApiRutas.actualizar + id), //falta agregar id
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    if (respuesta.statusCode == 200) {
      return 1; //actualizado con exito
    } else {
      return 0;
    }
  } catch (e) {
    print('no se pudo conectar con la api(error de red): $e');
    return 0;
  }
}

//eliminar evento
Future<int> eliminarevento(String id, String token) async {
  try {
    final rpt = await http.delete(
      Uri.parse(ApiRutas.eleminar + id),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      //body: jsonEncode(id), //flata agregar id
    );

    if (rpt.statusCode == 200) {
      return 1; //eliminado con exito
    } else {
      return 0;
    }
  } catch (e) {
    print('no se pudo conectar con la api(error de red): $e');
    return 0;
  }
}

//guardar tooken fcm-notificaciones
Future<void> guardartoken(String token) async {
  try {
    final rpt = await http.post(
      Uri.parse(ApiRutas.tkfcm),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(token),
    );

    if (rpt.statusCode == 201) {
      print('guardado con exito token');
    } else {
      print('no se pudo guardar el token');
    }
  } catch (e) {
    print('no se puede conectar a la api:$e');
  }
}
