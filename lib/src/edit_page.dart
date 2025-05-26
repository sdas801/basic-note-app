import 'package:flutter/material.dart';
import 'package:secure_notes/src/database.dart';
import 'package:secure_notes/src/note.dart';
import 'package:uuid/uuid.dart';

class EditPage extends StatefulWidget {
  final Note? note;

  const EditPage({super.key, this.note});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late final TextEditingController _titleEditingController;
  late final TextEditingController _noteEditingController;

  @override
  void initState() {
    super.initState();
    _titleEditingController = TextEditingController(text: widget.note?.title);
    _noteEditingController = TextEditingController(text: widget.note?.note);
  }

  @override
  void dispose() {
    _titleEditingController.dispose();
    _noteEditingController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final String title = _titleEditingController.text;
    final String note = _noteEditingController.text;

    if (title.isEmpty && note.isEmpty) {
      return;
    }

    final String id = widget.note?.id ?? (const Uuid()).v1();

    final Note noteToSave = Note(id: id, title: title, note: note);

    debugPrint("Existing note: ${widget.note}");

    debugPrint("Note To Save: $noteToSave");

    debugPrint("IsEqual: ${widget.note == noteToSave}");

    if (widget.note == noteToSave) {
      return;
    }

    await NoteDatabase.instance.saveNote(noteToSave);
  }

  Future<void> _onDelete() async {
    NoteDatabase.instance.deleteNote(widget.note!.id);
    if (!mounted) {
      return;
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) =>_save(),
      child: Scaffold(
        appBar: AppBar(
          actions:
              widget.note == null
                  ? null
                  : [
                    IconButton(
                      onPressed: _onDelete,
                      icon: const Icon(Icons.delete),
                      tooltip: "Delete",
                    ),
                  ],
        ),
        /*body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Title',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
                ),
                scrollPhysics: const NeverScrollableScrollPhysics(),
                maxLines: null,
                minLines: 1,
              ),
            ),
            SliverToBoxAdapter(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Note',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                ),
                scrollPhysics: const NeverScrollableScrollPhysics(),
                maxLines: null,
                minLines: null,
                //expands: true,
              ),
            ),
          ],
        ),*/
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            //mainAxisSize: MainAxisSize.max,
            children: [
              TextField(
                controller: _titleEditingController,
                style: const TextStyle(
                  color: Color.fromARGB(255, 75, 75, 75),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                decoration: const InputDecoration(
                  hintText: 'Title',
                  hintStyle: TextStyle(
                    color: Color(0xFFBDBDBD),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  border: InputBorder.none,
                ),
                //scrollPhysics: const NeverScrollableScrollPhysics(),
                maxLines: null,
                minLines: 1,
              ),
              // Note
              Expanded(
                child: TextField(
                  style: const TextStyle(
                    color: Color.fromARGB(255, 58, 58, 58),
                    fontSize: 16,
                  ),
                  controller: _noteEditingController,
                  decoration: const InputDecoration(
                    hintText: 'Note',
                    hintStyle: TextStyle(
                      color: Color(0xFFBDBDBD),
                      fontSize: 16,
                    ),
                    border: InputBorder.none,
                  ),
                  //scrollPhysics: const NeverScrollableScrollPhysics(),
                  maxLines: null,
                  //minLines: null,
                  expands: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
