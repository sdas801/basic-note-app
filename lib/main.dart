import 'package:flutter/material.dart';
import 'package:secure_notes/src/database.dart';
import 'package:secure_notes/src/home_page.dart';
//import 'package:secure_notes/src/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NoteDatabase.instance.initialize();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
