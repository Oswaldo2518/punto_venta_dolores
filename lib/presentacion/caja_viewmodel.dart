import 'package:flutter/foundation.dart';

import '../datos/repositorio_producto.dart';
import '../datos/repositorio_ventas.dart';
import '../dominio/carrito.dart';
import '../dominio/dinero.dart';
import '../dominio/producto.dart';
import '../dominio/venta.dart';

class CajaViewModel extends ChangeNotifier {
  final RepositorioProductos productos;
  final RepositorioVentas ventas;

  Carrito carrito = Carrito();

  List<Producto> catalogo = [];

  String? mensaje;
  Venta? ultimaVenta;

  CajaViewModel(this.productos, this.ventas);

  Future<void> cargar({
    String filtro = '',
  }) async {
    catalogo = await productos.listar(
      filtro: filtro,
    );

    notifyListeners();
  }

  void agregar(Producto p) {
    try {
      carrito.agregar(p);
      mensaje = null;
    } catch (e) {
      mensaje = e.toString();
    }

    notifyListeners();
  }

  void quitar(String codigo) {
    carrito.quitar(codigo);
    notifyListeners();
  }

  Future<bool> cobrar(String textoPago) async {
    try {
      final pago = pesosACentavos(textoPago);

      ultimaVenta = await ventas.cobrar(
        carrito,
        pago,
      );

      mensaje =
          'Cambio: ${formatearPesos(ultimaVenta!.cambioCentavos)}';

      carrito = Carrito();

      await cargar();

      return true;
    } catch (e) {
      mensaje = e.toString();
      notifyListeners();

      return false;
    }
  }
}