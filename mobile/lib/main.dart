import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'api.dart';
import 'screens/login.dart';
import 'screens/shell.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Api.I.load();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: C.surface, statusBarIconBrightness: Brightness.dark));
  runApp(const PatientApp());
}

class PatientApp extends StatefulWidget {
  const PatientApp({super.key});
  @override
  State<PatientApp> createState() => _PatientAppState();
}

class _PatientAppState extends State<PatientApp> {
  final _nav = GlobalKey<NavigatorState>();
  late bool _in = Api.I.loggedIn;

  @override
  void initState() {
    super.initState();
    // сессия закончилась (refresh-токен устарел или отозван): назад на вход
    Api.I.onLoggedOut = () {
      if (mounted && _in) setState(() => _in = false);
    };
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _nav,
      title: 'Farhod Madad Shifo',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: _in
          ? Shell(key: const ValueKey('shell'), onLogout: () => setState(() => _in = false))
          : LoginFlow(key: const ValueKey('login'), onDone: () => setState(() => _in = true)),
    );
  }
}
