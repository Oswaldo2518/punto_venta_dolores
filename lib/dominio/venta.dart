class LineaVenta {
  final String codigo;
  final String nombre;
  final int cantidad;
  final int precioCentavos;

  const LineaVenta(
    this.codigo,
    this.nombre,
    this.cantidad,
    this.precioCentavos,
  );

  int get importeCentavos =>
      cantidad * precioCentavos;
}

class Venta {
  final int? id;
  final DateTime fecha;
  final int totalCentavos;
  final int ivaCentavos;
  final int pagoCentavos;
  final List<LineaVenta> lineas;

  const Venta({
    this.id,
    required this.fecha,
    required this.totalCentavos,
    required this.ivaCentavos,
    required this.pagoCentavos,
    required this.lineas,
  });

  int get cambioCentavos =>
      pagoCentavos - totalCentavos;
}

class ResumenDia {
  final int numeroVentas;
  final int totalCentavos;
  final int ivaCentavos;

  const ResumenDia(
    this.numeroVentas,
    this.totalCentavos,
    this.ivaCentavos,
  );
}