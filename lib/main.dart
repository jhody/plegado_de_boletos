import 'package:flutter/material.dart';
import 'package:plegado_de_boletos/shared/app_scroll_behavior.dart';
import 'package:plegado_de_boletos/shared/env.dart';
import 'package:plegado_de_boletos/ticket_fold_demo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static String _pkg = "plegado_de_boletos";
  static String? get pkg => Env.getPackage(_pkg);

  @override
  Widget build(BuildContext context) {
    const title = 'Ticket Fold Demo';
    return MaterialApp(
      scrollBehavior: AppScrollBehavior(),
      debugShowCheckedModeBanner: false,
      title: title,
      home: TicketFoldDemo(),
    );
  }
}
