import 'package:sqflite/sqflite.dart';

import '../dominio/execepciones.dart';
import '../dominio/producto.dart';

class RepositorioProductos {
  final Database db;

  RepositorioProductos(this.db);

  Future<Producto> agregar(Producto p) async {
    try {
      final id = await db.insert(
        'productos',
        p.aMapa(),
      );

      return p.copiarCon(id: id);
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        throw CodigoDuplicadoException(p.codigo);
      }
      rethrow;
    }
  }

  Future<Producto?> buscarPorCodigo(
    String codigo,
  ) async {
    final filas = await db.query(
      'productos',
      where: 'codigo = ?',
      whereArgs: [codigo],
    );

    return filas.isEmpty
        ? null
        : Producto.desdeMapa(filas.first);
  }

  Future<List<Producto>> listar({
    String filtro = '',
  }) async {
    final filas = await db.query(
      'productos',
      where: filtro.isEmpty
          ? null
          : 'nombre LIKE ? OR codigo LIKE ?',
      whereArgs: filtro.isEmpty
          ? null
          : ['%$filtro%', '%$filtro%'],
      orderBy: 'nombre',
    );

    return filas.map(Producto.desdeMapa).toList();
  }

  Future<void> actualizarExistencias(
    String codigo,
    int nuevas,
  ) async {
    await db.update(
      'productos',
      {'existencias': nuevas},
      where: 'codigo = ?',
      whereArgs: [codigo],
    );
  }

  Future<void> eliminar(String codigo) async {
    await db.delete(
      'productos',
      where: 'codigo = ?',
      whereArgs: [codigo],
    );
  }

  Future<List<Producto>> bajoInventario({
    int limite = 5,
  }) async {
    final filas = await db.query(
      'productos',
      where: 'existencias <= ?',
      whereArgs: [limite],
      orderBy: 'existencias',
    );

    return filas.map(Producto.desdeMapa).toList();
  }

  Future<void> sembrarEjemplos() async {
    if ((await listar()).isNotEmpty) return;

    const ejemplos = [
      Producto(
        codigo: 'NV-001',
        nombre: 'Nieve de limón (1 bola)',
        precioCentavos: 2500,
        existencias: 40,
      ),
      Producto(
        codigo: 'NV-002',
        nombre: 'Nieve de aguacate',
        precioCentavos: 2800,
        existencias: 30,
      ),
      Producto(
        codigo: 'NV-003',
        nombre: 'Nieve de tequila',
        precioCentavos: 3500,
        existencias: 20,
      ),
      Producto(
        codigo: 'DU-001',
        nombre: 'Dulce de leche de cajeta',
        precioCentavos: 1800,
        existencias: 50,
      ),
      Producto(
        codigo: 'DU-002',
        nombre: 'Alegría de amaranto',
        precioCentavos: 1200,
        existencias: 60,
      ),
      Producto(
        codigo: 'CE-001',
        nombre: 'Cerámica Talavera chica',
        precioCentavos: 18000,
        existencias: 8,
      ),
      Producto(
        codigo: 'AG-001',
        nombre: 'Agua de horchata 1L',
        precioCentavos: 3000,
        existencias: 25,
      ),
      Producto(
        codigo: 'ES-001',
        nombre: 'Chicharrón preparado',
        precioCentavos: 4500,
        existencias: 15,
      ),
    ];

    for (final e in ejemplos) {
      await agregar(e);
    }
  }
}