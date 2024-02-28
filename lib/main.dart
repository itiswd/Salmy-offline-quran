import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:salmy/quran.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefColor = await SharedPreferences.getInstance();
  SharedPreferences prefSound = await SharedPreferences.getInstance();
  final tdd = prefColor.getInt("Dark") ?? 0;
  final voc = prefSound.getInt("Mute") ?? 0;
  runApp(MyApp(
    tdd: tdd,
    voc: voc,
  ));
}

class MyApp extends StatelessWidget {
  final int? tdd;
  final int? voc;
  const MyApp({
    super.key,
    required this.tdd,
    required this.voc,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', 'AE'),
      ],
      home: Quran(
        tdd: tdd,
        voc: voc,
      ),
    );
  }
}
