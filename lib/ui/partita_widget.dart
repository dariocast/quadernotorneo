import 'package:flutter/material.dart';
import 'package:quaderno_flutter/models/models.dart';
import 'package:quaderno_flutter/ui/style_helpers.dart';

class PartitaWidget extends StatelessWidget {
  final PartitaModel partita;

  const PartitaWidget(this.partita);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Size.infinite.height,
      width: Size.infinite.width,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/blocnotes.png'),
              fit: BoxFit.fill)),
      child: PulsantieraWidget(),
    );
  }
}

class PulsantieraWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 5.0),
              child: ElevatedButton(
                child: Text(
                  'Gol',
                  style: TextStyle(color: Colors.white),
                ),
                style: elevatedButtonStyle,
                onPressed: () {/** */},
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 5.0),
              child: ElevatedButton(
                child: Text('Autogol', style: TextStyle(color: Colors.white)),
                style: elevatedButtonStyle,
                onPressed: () {/** */},
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 5.0),
              child: ElevatedButton(
                child: Text('Ammonisci', style: TextStyle(color: Colors.white)),
                style: elevatedButtonStyle,
                onPressed: () {/** */},
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 5.0),
              child: ElevatedButton(
                child: Text('Espelli', style: TextStyle(color: Colors.white)),
                style: elevatedButtonStyle,
                onPressed: () {/** */},
              ),
            ),
          ],
        ),
        Expanded(
          child: Column(),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                child: Text(
                  'Ok',
                  style: TextStyle(color: Colors.white),
                ),
                style: elevatedButtonStyle,
                onPressed: () {/** */},
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                child: Text('Cancel', style: TextStyle(color: Colors.white)),
                style: elevatedButtonStyle,
                onPressed: () {/** */},
              ),
            ),
          ],
        )
      ],
    );
  }
}
