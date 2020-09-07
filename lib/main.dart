import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:quaderno_flutter/database.dart';
import 'package:quaderno_flutter/blocs/blocs.dart';
import 'package:quaderno_flutter/theme.dart';
import 'package:quaderno_flutter/ui/ui.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var persistence = await Database.get('persistence');
  runApp(QuadernoTorneoApp(
    persistence: persistence,
    authenticationRepository: AuthenticationRepository(),
  ));
}

class QuadernoTorneoApp extends StatelessWidget {
  const QuadernoTorneoApp({
    Key key,
    this.persistence,
    @required this.authenticationRepository,
  })  : assert(authenticationRepository != null),
        super(key: key);

  final AuthenticationRepository authenticationRepository;
  final Map persistence;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: authenticationRepository,
      child: BlocProvider(
        create: (_) => AuthenticationBloc(
            authenticationRepository: authenticationRepository),
        child: AppView(persistence),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  final Map persistence;
  AppView(this.persistence);

  @override
  _AppViewState createState() => _AppViewState(persistence);
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  final Map persistence;
  _AppViewState(this.persistence);

  NavigatorState get _navigator => _navigatorKey.currentState;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: QuadernoTheme.themeData,
      navigatorKey: _navigatorKey,
      builder: (context, child) {
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            switch (state.status) {
              case AuthenticationStatus.authenticated:
                _navigator.pushNamedAndRemoveUntil<void>(
                  HomePage.routeName,
                  (route) => false,
                );
                break;
              case AuthenticationStatus.unauthenticated:
                _navigator.pushNamedAndRemoveUntil<void>(
                    LoginPage.routeName, (route) => false,
                    arguments: persistence);
                break;
              default:
                break;
            }
          },
          child: child,
        );
      },
      initialRoute: SplashPage.routeName,
      routes: {
        HomePage.routeName: (context) => HomePage(),
        LoginPage.routeName: (context) => LoginPage(),
        SplashPage.routeName: (context) => SplashPage(),
        DettaglioPage.routeName: (context) => DettaglioPage()
      },
    );
  }
}
