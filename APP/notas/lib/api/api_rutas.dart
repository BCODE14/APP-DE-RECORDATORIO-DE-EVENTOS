class ApiRutas {
  static const String baseurl =
      "https://mi-api-427821393332.us-central1.run.app";

  //rutas de la api
  static const String registrar = "$baseurl/registrar";
  static const String login = "$baseurl/login";
  static const String totaleventos = "$baseurl/api/eventos";
  static const String eventoscond = "$baseurl/api/sin";
  static const String crear = "$baseurl/api/eventos";
  static const String actualizar = "$baseurl/api/eventos/"; //se envia id
  static const String eleminar = "$baseurl/api/eventos/"; //se envia id

  static const String tkfcm = "$baseurl/eventos/noti";
}
