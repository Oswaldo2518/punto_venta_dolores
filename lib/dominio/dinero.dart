String formatearPesos(int centavos) {
  final negativo = centavos < 0;
  final abs = centavos.abs();

  final pesos = (abs ~/ 100).toString();
  final cents = (abs % 100).toString().padLeft(2, '0');

  final conComas = pesos.replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => ',',
  );

  return '${negativo ? '-' : ''}\$$conComas.$cents';
}
int pesosACentavos(String texto) {
  final limpio = texto.replaceAll(RegExp(r'[\$,\s]'), '');
  final partes = limpio.split('.');

  if (partes.length > 2 ||
      partes[0].isEmpty &&
          (partes.length < 2 || partes[1].isEmpty)) {
    throw FormatException('Monto inválido: $texto');
  }

  final pesos = partes[0].isEmpty ? 0 : int.parse(partes[0]);
  var cents = 0;

  if (partes.length == 2 && partes[1].isNotEmpty) {
    cents = int.parse(
      partes[1].padRight(2, '0').substring(0, 2),
    );
  }

  return pesos * 100 + cents;
}