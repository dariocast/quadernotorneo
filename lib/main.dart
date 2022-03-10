import 'package:authentication_repository/authentication_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'blocs/blocs.dart';
import 'theme.dart';
import 'ui/ui.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  print("Handling a background message: ${message.data}");
}

late AndroidNotificationChannel channel;

late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Firebase.initializeApp();

  await Supabase.initialize(
    url: 'https://qadszjfdpxjteuvhtgdr.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlhdCI6MTYzNzg0OTY0NCwiZXhwIjoxOTUzNDI1NjQ0fQ.sjyG7VCc12_MyWkyPmB_Mx3gE2CYAb0TmE_DmwsMlfc',
  );

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      'quadernotorneo_channel', // id
      'Qui arrivano tutte le notifiche dell\'app.', // title
      description: 'Canale Notifiche Quaderno Torneo', // description
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

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
  late Stream<String> _tokenStream;

  void setToken(String token) {
    print('FCM Token: $token');
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // qui posso recuperare il messaggio che ha fatto aprire l'app
    FirebaseMessaging.instance.getInitialMessage().then((value) => null);
    _tokenStream = FirebaseMessaging.instance.onTokenRefresh;
    _tokenStream.listen(setToken);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: 'ic_launcher_foreground',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // qui posso andare a una sezione precisa o fare qualcosa in risposta
      // all'apertura dell'app tramite notifica
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quaderno Torneo',
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
