import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:plegado_de_boletos/flight_barcode.dart';
import 'package:plegado_de_boletos/flight_details.dart';
import 'package:plegado_de_boletos/flight_summary.dart';
import 'package:plegado_de_boletos/folding_ticket.dart';

import 'demo_data.dart';

class Ticket extends StatefulWidget {
  static const double nominalOpenHeight = 400;
  static const double nominalClosedHeight = 160;
  final BoardingPassData boardingPass;
  final VoidCallback? onClick;

  const Ticket({Key? key, required this.boardingPass, required this.onClick})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _TicketState();
}

class _TicketState extends State<Ticket> {
  FlightSummary? topCard;
  //Definir las 3 partes del ticket
  late FlightSummary frontCard =
      FlightSummary(boardingPass: widget.boardingPass);
  late FlightDetails middleCard = FlightDetails(widget.boardingPass);
  FlightBarcode bottomCard = FlightBarcode();
  bool _isOpen = false; //si esta abierto el ticket, inicia en cerrado

  //este es la parte debajo que se muestra al doblar el ticke
  Widget get backCard => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: Color(0xffdce6ef),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FoldingTicket(
        entries: _getEntries(), isOpen: _isOpen, onClick: _handleOnTap);
  }

  List<FoldEntry> _getEntries() {
    return [
      FoldEntry(height: 160.0, front: topCard),
      FoldEntry(height: 160.0, front: middleCard, back: frontCard),
      FoldEntry(height: 80.0, front: bottomCard, back: backCard)
    ];
  }

  void _handleOnTap() {
    widget.onClick?.call();
    setState(() {
      _isOpen = !_isOpen;
      topCard = FlightSummary(
          boardingPass: widget.boardingPass,
          theme: SummaryTheme.dark,
          isOpen: _isOpen);
    });
  }
}
