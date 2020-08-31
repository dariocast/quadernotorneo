import 'package:flutter/material.dart';
import 'package:quaderno_flutter/src/ui/homepage.dart';
import 'package:quaderno_flutter/src/ui/vista_quaderno.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Quaderno Torneo';
    return MaterialApp(
      title: appTitle,
      initialRoute: Homepage.routeName,
      routes: {
        VistaQuaderno.routeName: (context) => VistaQuaderno(),
        Homepage.routeName: (context) => Homepage(title: appTitle),
      },
    );
  }
}
