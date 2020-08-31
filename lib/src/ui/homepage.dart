import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quaderno_flutter/src/ui/vista_quaderno.dart';

class Homepage extends StatelessWidget {
  static const routeName = '/';
  final String title;

  Homepage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Visualizza partite'),
          onPressed: () {
            Navigator.pushNamed(context, VistaQuaderno.routeName);
          },
        ),
      ),
    );
  }
}
