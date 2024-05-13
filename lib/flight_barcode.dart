import 'package:flutter/material.dart';
import 'package:plegado_de_boletos/main.dart';

class FlightBarcode extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
      width: double.infinity,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(4.0),
              bottomRight: Radius.circular(4.0)),
          color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14.0),
        child: MaterialButton(
            child: Image.asset('images/barcode.png', package: MyApp.pkg),
            onPressed: () {
              print('Button was pressed');
            }),
      ));
}
