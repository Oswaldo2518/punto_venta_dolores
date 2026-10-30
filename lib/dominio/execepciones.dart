class CodigoDuplicadoException implements Exception {
  final String codigo;

  CodigoDuplicadoException(this.codigo);

  @override
  String toString() =>
      'Ya existe un producto con el código $codigo';
}

class ExistenciasInsuficientesException implements Exception {
  final String producto;
  final int disponibles;

  ExistenciasInsuficientesException(
    this.producto,
    this.disponibles,
  );

  @override
  String toString() =>
      'Solo quedan $disponibles de $producto';
}

class PagoInsuficienteException implements Exception {
  final int faltanCentavos;

  PagoInsuficienteException(this.faltanCentavos);

  @override
  String toString() =>
      'Faltan $faltanCentavos centavos para cubrir la cuenta';
}

class CarritoVacioException implements Exception {
  @override
  String toString() => 'No hay productos en el carrito';
}