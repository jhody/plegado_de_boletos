import 'dart:math';

import 'package:flutter/material.dart';

class FoldingTicket extends StatefulWidget {
  static const double padding = 16.0; //padding de toda la tarjeta
  final bool isOpen;
  final List<FoldEntry> entries;
  final VoidCallback? onClick;
  final Duration? duration;

  FoldingTicket(
      {this.duration,
      required this.entries,
      this.isOpen = false,
      this.onClick});

  @override
  _FoldingTicketState createState() => _FoldingTicketState();
}

class _FoldingTicketState extends State<FoldingTicket>
    with SingleTickerProviderStateMixin {
  late List<FoldEntry> _entries = widget.entries;
  late AnimationController _controller = AnimationController(vsync: this);
  //el tiempo se establecera despues, dependiendo de la cant de entradas
  double _ratio = 0.0;

  //altura abierta, sumar todas las entradas o caras de la lista
  double get openHeight =>
      _entries.fold<double>(0.0, (val, o) => val + o.height) +
      FoldingTicket.padding * 2;

  //altura cerrada
  double get closedHeight => _entries[0].height + FoldingTicket.padding * 2;

  bool get isOpen => widget.isOpen;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_tick); //Escuchar cada llamada a la animacion
    _updateFromWidget(); //inicializar controllador
  }

  @override
  void didUpdateWidget(FoldingTicket oldWidget) {
    //se llama cada vez que el estado cambia
    // Abre o cierra la casilla marcada si el estado cambió
    _updateFromWidget();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //contenedor de toda la tarjeta
      padding: EdgeInsets.all(FoldingTicket.padding),
      height: closedHeight +
          (openHeight - closedHeight) * Curves.easeOut.transform(_ratio),
      child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(.1),
                  blurRadius: 10,
                  spreadRadius: 1)
            ],
          ),
          child: _buildEntry(0)),
    );
  }

  Widget _buildEntry(int index) {
    FoldEntry entry = _entries[index];
    int count = _entries.length - 1; //para saber si ya se desplego todo
    double ratio = max(0.0, min(1.0, _ratio * count + 1.0 - index * 1.0));

    Matrix4 mtx = Matrix4.identity()
      ..setEntry(3, 2, 0.001)
      ..setEntry(1, 2, 0.2)
      ..rotateX(pi * (ratio - 1.0));

    Widget card = SizedBox(
        height: entry.height, child: ratio < 0.5 ? entry.back : entry.front);

    return Transform(
        alignment: Alignment.topCenter,
        transform: mtx,
        child: GestureDetector(
          onTap: widget.onClick,
          child: SingleChildScrollView(
            //para que no se muestre ese overflow
            physics:
                NeverScrollableScrollPhysics(), //no desplazar por parte del usuario
            // Note: El contenedor admite una propiedad de transformación, pero no su alineación.
            child: (index == count || ratio <= 0.5)
                ? card
                : // No construyas una pila si no es necesaria.
                Column(children: [
                    card,
                    _buildEntry(index + 1),
                  ]),
          ),
        ));
  }

  void _updateFromWidget() {
    //se llama cada vez q cambia el estado del widget
    _entries = widget.entries;
    _controller.duration =
        widget.duration ?? Duration(milliseconds: 400 * (_entries.length - 1));
    isOpen ? _controller.forward() : _controller.reverse();
  }

  void _tick() {
    // se llama cada vez q cambia el valor del controlador de la animacion
    setState(() {
      //retorna el valor de la curva en el punto del controlador
      _ratio = Curves.easeInQuad.transform(_controller.value);
    });
  }
}

//entrada plegable
class FoldEntry {
  final Widget? front;
  late Widget? back;
  final double height;

  FoldEntry({required this.front, required this.height, Widget? back}) {
    this.back = Transform(
        alignment: FractionalOffset.center,
        transform: Matrix4.identity()
          ..setEntry(3, 2, .001)
          ..rotateX(pi),
        child: back);
  }
}
