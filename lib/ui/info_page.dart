import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoPage extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => InfoPage());
  }

  const InfoPage({Key? key}) : super(key: key);

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  String appName = '';
  String packageName = '';
  String version = '';
  String buildNumber = '';
  @override
  Widget build(BuildContext context) {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        appName = packageInfo.appName;
        packageName = packageInfo.packageName;
        version = packageInfo.version;
        buildNumber = packageInfo.buildNumber;
      });
    });
    return Scaffold(
      appBar: AppBar(
        title: Text('Informazioni'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                appName,
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  '${DateTime.now().year} © Versione $version, build $buildNumber'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'by ',
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                    ),
                    TextSpan(
                      text: 'dariocast',
                      style: Theme.of(context).textTheme.headline5!.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => launch('https://dariocast.github.io'),
                    )
                  ],
                ),
              ),
            ),
            const Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: const Text('Se ti piace questa app'),
            ),
            RichText(
              text: TextSpan(
                text: 'offrimi una birra 🍺',
                style: Theme.of(context).textTheme.headline5!.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => launch('https://paypal.me/dariocast'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
