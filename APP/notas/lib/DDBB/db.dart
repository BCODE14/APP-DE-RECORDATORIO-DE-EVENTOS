import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:bcrypt/bcrypt.dart';

class DBHelper {
  static Future<Database> initDB() async {
    //ruta donde esta nuestra bbdd
    final path = join(await getDatabasesPath(), 'usuarios.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE usuarios(
            id integer
            usuario TEXT,
            password TEXT
          )

          CREATE TABLE notas (
            id integer
            tipo TEXT,
            fecha TEXT,
            hora TEXT,
            nota TEXT,
            id_usuario text,
            sincronizado integer
          )

        ''');
      },
    );
  }

  static Future<int> insertUser(String user, String pass) async {
    final db = await initDB();
    await db.insert('usuarios', {"usuario": user, "password": pass});
    return 1;
  }

  static Future<Map<String, dynamic>?> login(String user, String pass) async {
    final db = await initDB();
    final passencript = BCrypt.hashpw(pass, BCrypt.gensalt());
    final res = await db.query(
      'usuarios',
      where: "usuario = ? AND password = ?",
      whereArgs: [user, passencript],
    );
    if (res.isNotEmpty) return res.first;
    return null;
  }

  static Future<int> insertNota(
    String id,
    String categoria,
    String fecha,
    String hora,
    String nota,
    String iduser,
    String sincro,
  ) async {
    final db = await initDB();
    return await db.insert('notas', {
      "id": id,
      "tipo": categoria,
      "fecha": fecha,
      "hora": hora,
      "nota": nota,
      "id_usuario": iduser,
      "sincronizado": sincro,
    });
  }

  static Future<List<Map<String, dynamic>>> getNotas() async {
    final db = await initDB();
    return await db.query('notas', where: "sincronizado = ?", whereArgs: [1]);
  }

  static Future<int> updateNota(
    int id,
    String categoria,
    String fecha,
    String hora,
    String nota,
    String idus,
    String sincro,
  ) async {
    final db = await initDB();
    return await db.update(
      'notas',
      {
        "tipo": categoria,
        "fecha": fecha,
        "hora": hora,
        "nota": nota,
        "id_usuario": idus,
        "sincronizado": sincro,
      },
      where: "id = ?",
      whereArgs: [id],
    );
  }

  static Future<int> eliminarNota(String id) async {
    final db = await initDB();
    return await db.update(
      'notas',
      {"sincronizado": 1},
      where: "id = ?",
      whereArgs: [int.parse(id)],
    );
  }

  static Future<void> eliminarnotatrue() async {
    final db = await initDB();
    await db.delete('notas', where: "sincronizado= ?", whereArgs: [3]);
  }
}
