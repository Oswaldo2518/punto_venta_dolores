import 'package:flutter/material.dart';

import '../dominio/dinero.dart';
import 'caja_viewmodel.dart';

class PantallaCaja extends StatefulWidget {
  final CajaViewModel vm;

  const PantallaCaja({
    super.key,
    required this.vm,
  });

  @override
  State<PantallaCaja> createState() =>
      _PantallaCajaState();
}

class _PantallaCajaState extends State<PantallaCaja> {
  final _pago = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.vm.cargar();
  }

  @override
  void dispose() {
    _pago.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = widget.vm;

    return AnimatedBuilder(
      animation: vm,
      builder: (_, __) => Scaffold(
        appBar: AppBar(
          title: const Text('Caja · Dolores Hidalgo'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Buscar producto',
                ),
                onChanged: (t) =>
                    vm.cargar(filtro: t),
              ),
            ),

            Expanded(
              child: ListView(
                children: [
                  for (final p in vm.catalogo)
                    ListTile(
                      title: Text(p.nombre),
                      subtitle: Text(
                        '${p.existencias} disponibles',
                      ),
                      trailing: Text(
                        formatearPesos(
                          p.precioCentavos,
                        ),
                      ),
                      onTap: p.existencias == 0
                          ? null
                          : () => vm.agregar(p),
                    ),
                ],
              ),
            ),

            const Divider(height: 1),

            for (final l in vm.carrito.lineas)
              ListTile(
                dense: true,
                title: Text(
                  '${l.cantidad} × ${l.producto.nombre}',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      formatearPesos(
                        l.importeCentavos,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                      ),
                      onPressed: () =>
                          vm.quitar(l.producto.codigo),
                    ),
                  ],
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Text(
                    'IVA incluido: ${formatearPesos(vm.carrito.ivaCentavos)}',
                  ),

                  Text(
                    'TOTAL ${formatearPesos(vm.carrito.totalCentavos)}',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall,
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _pago,
                          keyboardType:
                              const TextInputType
                                  .numberWithOptions(
                            decimal: true,
                          ),
                          decoration:
                              const InputDecoration(
                            labelText: 'Paga con \$',
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      FilledButton(
                        onPressed: () async {
                          if (await vm.cobrar(
                            _pago.text,
                          )) {
                            _pago.clear();
                          }
                        },
                        child: const Text('Cobrar'),
                      ),
                    ],
                  ),

                  if (vm.mensaje != null)
                    Padding(
                      padding:
                          const EdgeInsets.only(
                        top: 8,
                      ),
                      child: Text(
                        vm.mensaje!,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}