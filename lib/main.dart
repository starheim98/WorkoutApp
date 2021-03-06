import 'package:firebase_core/firebase_core.dart';
import 'package:workout_app/shared/constants.dart';
import 'models/account.dart';
import 'screens/wrapper.dart';
import 'services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<Account?>.value(
      initialData: null,
      catchError: (context, error) => null,
      value: AuthService().user,
      child: MaterialApp(
        theme: ThemeData(
            backgroundColor: backgroundColor,
            appBarTheme: const AppBarTheme(color: Color(0xff245CB6)),
            primaryColor: const Color(0xff245CB6)),
        home: Wrapper(),
        routes: {
          'home': (context) => const Wrapper(),
        },
      ),
    );
  }
}
