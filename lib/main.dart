import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:secure_note/src/home_note.dart';
import 'package:secure_note/src/note_database.dart';

void main() async {
  debugPaintSizeEnabled = false;
  WidgetsFlutterBinding.ensureInitialized();
  await NoteDatabase.hiveInstance.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomeNote(), debugShowCheckedModeBanner: false);
  }
}
