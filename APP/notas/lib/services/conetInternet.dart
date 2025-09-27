//clase para probar conexion a internet

import 'package:connectivity_plus/connectivity_plus.dart';

Future<bool> conexioninternet() async {
  List<ConnectivityResult> result = await Connectivity().checkConnectivity();

  if (result.contains(ConnectivityResult.mobile) ||
      result.contains(ConnectivityResult.wifi)) {
    return true;
  } else {
    return false;
  }
}
