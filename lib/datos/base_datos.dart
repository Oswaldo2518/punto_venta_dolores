import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class BaseDatos {
  static Database? _db;

  static Future<Database> abrir({String? ruta}) async {
    if (_db != null && ruta == null) {
      return _db!;
    }

    final destino = ruta ??
        p.join(
          await getDatabasesPath(),
          'punto_venta_dolores.db',
        );

    final db = await openDatabase(
      destino,
      version: 1,
      onCreate: crearTablas,
      singleInstance: ruta == null,
    );

    if (ruta == null) {
      _db = db;
    }

    return db;
  }

  static Future<void> crearTablas(
    Database db,
    int version,
  ) async {
    await db.execute('''
      CREATE TABLE productos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        codigo TEXT NOT NULL UNIQUE,
        nombre TEXT NOT NULL,
        precio_centavos INTEGER NOT NULL,
        existencias INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE ventas(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fecha TEXT NOT NULL,
        total_centavos INTEGER NOT NULL,
        iva_centavos INTEGER NOT NULL,
        pago_centavos INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE lineas_venta(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        venta_id INTEGER NOT NULL REFERENCES ventas(id),
        codigo TEXT NOT NULL,
        nombre TEXT NOT NULL,
        cantidad INTEGER NOT NULL,
        precio_centavos INTEGER NOT NULL
      )
    ''');
  }
}
