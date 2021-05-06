import 'package:workmannow/providers/socket.dart';
import 'package:workmannow/providers/firebase.dart';
import 'package:workmannow/helpers/theme.dart';
import 'package:workmannow/screens/auth/login.dart';
import 'package:workmannow/screens/auth/registration.dart';
import 'package:workmannow/screens/utility/enable_location.dart';
import 'package:workmannow/screens/hiring/client.dart';
import 'package:workmannow/screens/hiring/workMan.dart';
import 'package:workmannow/screens/home/index.dart';
import 'package:workmannow/screens/profile/user.dart';
import 'package:workmannow/screens/utility/splash.dart';
import 'package:workmannow/providers/location.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:provider/provider.dart';
import 'package:workmannow/providers/user.dart';
import 'package:workmannow/providers/hiring.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  Stream<bool> locationEventStream;

  Future<PermissionStatus> requestLocationPermission() async {
    PermissionStatus permission =
        await LocationPermissions().requestPermissions();
    return permission;
  }

  @override
  void initState() {
    super.initState();
    requestLocationPermission().then((PermissionStatus status) {
      if (status == PermissionStatus.granted) {}
    });
    locationEventStream = LocationPermissions()
        .serviceStatus
        .map((s) => s == ServiceStatus.enabled ? true : false);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => HiringProvider()),
          ChangeNotifierProvider(create: (context) => UserProvider()),
          ChangeNotifierProvider(create: (context) => LocationProvider()),
          ChangeNotifierProvider(create: (context) => SocketProvider()),
          ChangeNotifierProvider(
              create: (context) => FireBaseServiceProvider()),
        ],
        child: Consumer<UserProvider>(builder: (context, userProvider, child) {
          return MaterialApp(
            title: 'WorkManNow',
            theme: ThemeHelper.theme,
            home: FutureBuilder(
              future: _initialization,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Scaffold(
                    body: Center(
                      child: Text('Something went wrong'),
                    ),
                  );
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  return StreamBuilder(
                      stream: locationEventStream,
                      builder: (context, snapshot) {
                        Widget component = Scaffold(
                          body: Center(
                            child: SplashScreen(),
                          ),
                        );
                        if (snapshot.connectionState ==
                                ConnectionState.active &&
                            snapshot.hasData) {
                          if (snapshot.data) {
                            component = userProvider.isAuthenticated
                                ? Home()
                                : FutureBuilder(
                                    future: userProvider.tryAutoLogin(),
                                    builder: (context, snapshot) =>
                                        snapshot.connectionState ==
                                                ConnectionState.waiting
                                            ? SplashScreen()
                                            : Login(),
                                  );
                          } else if (!snapshot.data) {
                            component = LocationNotificationScreen();
                          }
                        }
                        return component;
                      });
                }
                return SplashScreen();
              },
            ),
            routes: {
              '/registration': (_) => Registration(),
              '/home': (_) => Home(),
              '/user_profile': (_) => UserProfile(),
              '/client_hirings': (_) => ClientHirings(),
              '/workman_hirings': (_) => WorkManHirings(),
            },
            builder: EasyLoading.init(),
          );
        }));
  }
}
