import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user TEXT,
            pass TEXT
          )

          CREATE TABLE notas (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            categoria TEXT,
            fecha TEXT,
            nota TEXT,
            eliminado INTEGER DEFAULT 0
          )
        ''');
      },
    );
  }

  static Future<int> insertUser(String user, String pass) async {
    final db = await initDB();
    await db.insert('usuarios', {"user": user, "pass": pass});
    return 1;
  }

  static Future<Map<String, dynamic>?> login(String user, String pass) async {
    final db = await initDB();
    final res = await db.query(
      'usuarios',
      where: "user = ? AND pass = ?",
      whereArgs: [user, pass],
    );
    if (res.isNotEmpty) return res.first;
    return null;
  }

  static Future<int> insertNota(
    String categoria,
    String fecha,
    String nota,
  ) async {
    final db = await initDB();
    return await db.insert('notas', {
      "categoria": categoria,
      "fecha": fecha,
      "nota": nota,
      "eliminado": 0,
    });
  }

  static Future<List<Map<String, dynamic>>> getNotas() async {
    final db = await initDB();
    return await db.query('notas', where: "eliminado = ?", whereArgs: [0]);
  }

  static Future<int> updateNota(
    int id,
    String categoria,
    String fecha,
    String nota,
  ) async {
    final db = await initDB();
    return await db.update(
      'notas',
      {"categoria": categoria, "fecha": fecha, "nota": nota},
      where: "id = ?",
      whereArgs: [id],
    );
  }

  static Future<int> eliminarNota(int id) async {
    final db = await initDB();
    return await db.update(
      'notas',
      {"eliminado": 1},
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
