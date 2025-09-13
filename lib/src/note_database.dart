import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:secure_note/src/note.dart';

abstract class NoteDatabase {
  static final NoteDatabase hiveInstance = _NoteDatabaseHive();
  Future<void> initialize();
  Future<void> dispose();
  Future<void> saveNote(Note note);
  Future<void> deleteNote(String noteID);
  Stream<Set<Note>> getNoteStream();
}

class _NoteDatabaseHive extends NoteDatabase {
  LazyBox<String>? _box;
  StreamController<Set<Note>>? _streamController;

  @override
  Future<void> initialize() async {
    String documentPath = (await getApplicationDocumentsDirectory()).path;
    String path = join(documentPath, 'NewSecureNoteDB');
    Hive.init(path);
    debugPrint(path);
    _box = await Hive.openLazyBox<String>('databaseHive');
  }

  @override
  Future<void> dispose() async {
    await _box?.close();
    _box = null;
  }

  @override
  Future<void> saveNote(Note note) async {
    final String json = note.toJson();
    await _box?.put(note.id, json);
  }

  @override
  Future<void> deleteNote(String noteID) async {
    await _box?.delete(noteID);
  }

  @override
  Stream<Set<Note>> getNoteStream() {
    if (_streamController != null) {
      return _streamController!.stream;
    }
    _streamController = StreamController<Set<Note>>.broadcast(
      onListen: () async {
        _streamController!.add(await getNote());
        _streamController!.addStream(
          _box!.watch().asyncMap<Set<Note>>((BoxEvent event) {
            debugPrint(event.toString());
            return getNote();
          }),
        );
      },
    );
    return _streamController!.stream;
  }

  Future<Set<Note>> getNote() async {
    final Iterable<String> keys = _box!.keys.cast<String>();
    Set<Note> result = {};
    for (final String key in keys) {
      final String? value = await _box!.get(key);
      if (value != null) {
        result.add(Note.fromJson(value));
      } else {
        debugPrint('not consist any value in the key: $key');
      }
    }
    return result;
  }
}
