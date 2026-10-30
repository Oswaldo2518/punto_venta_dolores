import 'execepciones.dart';
import 'producto.dart';

class LineaCarrito {
  final Producto producto;
  int cantidad;

  LineaCarrito(this.producto, this.cantidad);

  int get importeCentavos =>
      producto.precioCentavos * cantidad;
}

class Carrito {
  final int tasaIva;

  final Map<String, LineaCarrito> _lineas = {};

  Carrito({this.tasaIva = 16});

  List<LineaCarrito> get lineas =>
      _lineas.values.toList();

  bool get estaVacio => _lineas.isEmpty;

  void agregar(Producto p, {int cantidad = 1}) {
    final actual = _lineas[p.codigo]?.cantidad ?? 0;

    if (actual + cantidad > p.existencias) {
      throw ExistenciasInsuficientesException(
        p.nombre,
        p.existencias,
      );
    }

    if (_lineas.containsKey(p.codigo)) {
      _lineas[p.codigo]!.cantidad += cantidad;
    } else {
      _lineas[p.codigo] = LineaCarrito(p, cantidad);
    }
  }

  void quitar(String codigo) {
    _lineas.remove(codigo);
  }

  void vaciar() {
    _lineas.clear();
  }

  int get totalCentavos => _lineas.values.fold(
        0,
        (s, l) => s + l.importeCentavos,
      );

  int get subtotalCentavos =>
      totalCentavos - ivaCentavos;

  int get ivaCentavos =>
      (totalCentavos * tasaIva +
              (100 + tasaIva) ~/ 2) ~/
          (100 + tasaIva);

  int cambio(int pagoCentavos) {
    if (estaVacio) {
      throw CarritoVacioException();
    }

    if (pagoCentavos < totalCentavos) {
      throw PagoInsuficienteException(
        totalCentavos - pagoCentavos,
      );
    }

    return pagoCentavos - totalCentavos;
  }
}