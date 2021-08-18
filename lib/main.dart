import 'package:flutter/material.dart';
import 'package:movielist_app/authentication.dart';
import 'package:movielist_app/login.dart';
import 'package:movielist_app/myhomepage.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movielist_app/splash.dart';
import 'package:movielist_app/signup.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // 2
        Provider<AuthenticationHelper>(
          create: (_) => AuthenticationHelper(FirebaseAuth.instance),
        ),
        // 3
        StreamProvider(
          create: (context) => context.read<AuthenticationHelper>().authStateChanges,
          initialData: null,
        )
      ],
      child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movies',
      initialRoute: '/',
        routes: {
          '/':(context) => Splash(),
          '/auth': (context) => AuthenticationWrapper(),
          '/signin': (context) => Login(),
          '/signup': (context) => Signup(),
          '/home': (context) => MyHomePage(),
        },
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseuser = context.watch<User>();
    if (firebaseuser != null) {
      return MyHomePage();
    }
    return Login();
  }
}