class Producto {
  final int? id;
  final String codigo;
  final String nombre;
  final int precioCentavos;
  final int existencias;

  const Producto({
    this.id,
    required this.codigo,
    required this.nombre,
    required this.precioCentavos,
    required this.existencias,
  });

  Producto copiarCon({
    int? id,
    int? existencias,
    int? precioCentavos,
    String? nombre,
  }) =>
      Producto(
        id: id ?? this.id,
        codigo: codigo,
        nombre: nombre ?? this.nombre,
        precioCentavos: precioCentavos ?? this.precioCentavos,
        existencias: existencias ?? this.existencias,
      );

  Map<String, Object?> aMapa() => {
        if (id != null) 'id': id,
        'codigo': codigo,
        'nombre': nombre,
        'precio_centavos': precioCentavos,
        'existencias': existencias,
      };

  factory Producto.desdeMapa(Map<String, Object?> m) =>
      Producto(
        id: m['id'] as int?,
        codigo: m['codigo'] as String,
        nombre: m['nombre'] as String,
        precioCentavos: m['precio_centavos'] as int,
        existencias: m['existencias'] as int,
      );
}