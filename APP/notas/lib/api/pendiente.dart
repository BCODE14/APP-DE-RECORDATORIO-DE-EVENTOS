import 'package:notas/api/localstorage.dart';
import 'package:notas/api/peticiones.dart';
import 'package:notas/services/conetInternet.dart';
import 'package:notas/DDBB/db.dart' as d;

final List<Map<String, dynamic>> pendientesCrear = [];
final List<Map<String, dynamic>> pendientesActualizar = [];
final List<Map<String, dynamic>> pendientesEliminar = [];

Future<void> enviarpendientes(String token) async {
  if (pendientesCrear.isNotEmpty) //lista no vacia
  {
    for (var i = 0; i <= pendientesCrear.length; i++) {
      await crearevento(pendientesCrear[i], token);
    }
  } else {
    if (pendientesActualizar.isNotEmpty) {
      for (var i = 0; i <= pendientesActualizar.length; i++) {
        await actualizarevento(
          pendientesCrear[i],
          pendientesCrear[i]['id'],
          token,
        );
      }
    } else {
      if (pendientesEliminar.isNotEmpty) {
        for (var i = 0; i <= pendientesEliminar.length; i++) {
          eliminarevento(pendientesEliminar[i]['id'], token);
        }
      }
    }
  }
}

//funcion eliminar eventos
Future<void> eliminarevent(String id) async {
  final tk = await usardatausuario();
  if (await conexioninternet()) {
    //eliminar cuando tiene internet

    await eliminarevento(id, tk['token']);
  } else {
    //eliminar cuando no tiene internet
    pendientesEliminar.add({"id": id});
    await d.DBHelper.eliminarNota(id);
  }
}

//funcion sincronizar datos entre api y sqlite
Future<void> sincronizaciondata(String token) async {
  //eliminar todos los 3 en sqlite
  d.DBHelper.eliminarnotatrue();
  //traer todos los sinc=0 para insertarlos en el sqlite
  final result = await consultareventosin(token);

  for (var i = 0; i <= result.length; i++) {
    await d.DBHelper.insertNota(
      result[i]['id'],
      result[i]['tipo'],
      result[i]['fecha'],
      result[i]['hora'],
      result[i]['nota'],
      result[i]['id_usuario'],
      "1",
    );

    final body = {
      "id": result[i]['id'],
      "tipo": result[i]['tipo'],
      "fecha": result[i]['fecha'],
      "hora": result[i]['hora'],
      "nota": result[i]['nota'],
      "id_usuario": result[i]['id_usuario'],
      "sincronizado": "1",
    };

    await actualizarevento(body, result[i]['id'], token);
  }
}
