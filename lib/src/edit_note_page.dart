import 'package:flutter/material.dart';
import 'package:secure_note/src/note.dart';
import 'package:secure_note/src/note_database.dart';
import 'package:uuid/uuid.dart';

class EditNotePage extends StatefulWidget {
  final Note? oldNote;
  const EditNotePage({super.key, this.oldNote});

  @override
  State<EditNotePage> createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  late final TextEditingController _titleController;
  late final TextEditingController _noteController;
  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.oldNote?.title);
    _noteController = TextEditingController(text: widget.oldNote?.note);
  }

  void _onSave() {
    final String title = _titleController.text;
    final String note = _noteController.text;

    if (title.isEmpty && note.isEmpty) {
      return;
    }
    final String id = widget.oldNote?.id ?? (const Uuid()).v1();
    final Note noteToSave = Note(id: id, title: title, note: note);

    if (widget.oldNote == noteToSave) {
      return;
    }else{
      NoteDatabase.hiveInstance.saveNote(noteToSave);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) => _onSave(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: AppBar(
            surfaceTintColor: Colors.white,
            scrolledUnderElevation: 0.0,
            backgroundColor: Colors.white,
            actionsPadding: EdgeInsets.symmetric(horizontal: 12.0),
            actions: [
              Icon(Icons.push_pin_outlined),
              SizedBox(width: 24),
              Icon(Icons.add_alert_outlined),
              SizedBox(width: 24),
              Icon(Icons.archive_outlined),
            ],
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextField(
                    controller: _titleController,
                    cursorHeight: 28,
                    cursorColor: Colors.black,
                    cursorWidth: 1.5,
                    style: TextStyle(fontSize: 22, height: 1),
                    decoration: InputDecoration(
                      hintText: 'Title',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 22),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      maxLines: null,
                      controller: _noteController,
      
                      cursorHeight: 20,
                      cursorColor: Colors.black,
                      cursorWidth: 1.5,
                      style: TextStyle(fontSize: 16, height: 1),
                      decoration: InputDecoration(
                        hintText: 'Note',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
