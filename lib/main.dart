import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quaderno_flutter/blocs/blocs.dart';
import 'package:quaderno_flutter/database.dart';
import 'package:quaderno_flutter/models/models.dart';
import 'package:quaderno_flutter/theme.dart';
import 'package:quaderno_flutter/ui/ui.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(QuadernoTorneoApp(
    authenticationRepository: AuthenticationRepository(),
  ));
}

class QuadernoTorneoApp extends StatelessWidget {
  const QuadernoTorneoApp({
    Key? key,
    required this.authenticationRepository,
  }) : super(key: key);

  final AuthenticationRepository authenticationRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: authenticationRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            lazy: false,
            create: (_) => AuthenticationBloc(
                authenticationRepository: authenticationRepository),
          ),
          BlocProvider(
            lazy: false,
            create: (_) {
              return LoginBloc(
                authenticationRepository: authenticationRepository,
              )..add(LoginLoaded());
            },
          ),
        ],
        child: AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  AppView();

  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  _AppViewState();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: QuadernoTheme.themeData,
      navigatorKey: _navigatorKey,
      // builder: (context, child) {
      //   return BlocListener<AuthenticationBloc, AuthenticationState>(
      //     listener: (context, state) {
      //       switch (state.status) {
      //         case AuthenticationStatus.authenticated:
      //           _navigator.pushAndRemoveUntil<void>(
      //             HomePage.route(),
      //             (route) => false,
      //           );
      //           break;
      //         case AuthenticationStatus.unauthenticated:
      //           _navigator.pushAndRemoveUntil<void>(
      //               LoginPage.route(), (route) => false);
      //           break;
      //         default:
      //           break;
      //       }
      //     },
      //     child: child,
      //   );
      // },
      onGenerateRoute: (_) => HomePage.route(),
    );
  }
}
