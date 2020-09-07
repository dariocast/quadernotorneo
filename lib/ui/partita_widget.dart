import 'package:flutter/material.dart';
import 'package:quaderno_flutter/models/models.dart';

class PartitaWidget extends StatelessWidget {
  final PartitaModel partita;

  const PartitaWidget(this.partita);

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
        child: Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/blocnotes.png'),
              fit: BoxFit.fill)),
      child: PulsantieraWidget(),
    ));
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
              child: RaisedButton(
                child: Text(
                  'Gol',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.amber,
                onPressed: () {/** */},
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 5.0),
              child: RaisedButton(
                child: Text('Autogol', style: TextStyle(color: Colors.white)),
                color: Colors.amber,
                onPressed: () {/** */},
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 5.0),
              child: RaisedButton(
                child: Text('Ammonisci', style: TextStyle(color: Colors.white)),
                color: Colors.amber,
                onPressed: () {/** */},
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 5.0),
              child: RaisedButton(
                child: Text('Espelli', style: TextStyle(color: Colors.white)),
                color: Colors.amber,
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
              child: RaisedButton(
                child: Text(
                  'Ok',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.amber,
                onPressed: () {/** */},
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                child: Text('Cancel', style: TextStyle(color: Colors.white)),
                color: Colors.amber,
                onPressed: () {/** */},
              ),
            ),
          ],
        )
      ],
    );
  }
}
