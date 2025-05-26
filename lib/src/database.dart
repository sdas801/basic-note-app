import 'dart:async';
//import 'dart:convert';

import 'package:flutter/foundation.dart';
//import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_ce/hive.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:secure_notes/src/note.dart';

abstract class NoteDatabase {
  static final NoteDatabase instance = _NoteDatabaseHive();

  Future<void> initialize(/*String password*/) async {}

  Future<void> dispose() async {}

  Future<void> saveNote(Note note);

  Future<void> deleteNote(String noteID);

  Stream<Set<Note>> getNotesStream();
}

class _NoteDatabaseHive extends NoteDatabase {
  LazyBox<String>? _box;
  StreamController<Set<Note>>? _notesStreamController;

  @override
  Future<void> initialize(/*String password*/) async {
    final String documentsPath =
        (await getApplicationDocumentsDirectory()).path;
    final String path = join(documentsPath, "SecretNotes");
    Hive.init(path);
    debugPrint(path);
    /*final List<int>? key = await DatabasePasswordManager.instance
        .getKeyForPassword(password);
    if (key == null) {
      throw "Error! Password is wrong";
    }*/
    _box = await Hive.openLazyBox<String>(
      "secret_notes.db",
      //encryptionCipher: HiveAesCipher(key),
    );
  }

  @override
  Future<void> dispose() async {
    await _box?.close();
    _box = null;
    await _notesStreamController?.close();
    _notesStreamController = null;
  }

  @override
  Stream<Set<Note>> getNotesStream() {
    if (_notesStreamController != null) {
      return _notesStreamController!.stream;
    }

    _notesStreamController = StreamController<Set<Note>>.broadcast(
      onListen: () async {
        debugPrint("Getting initial data");
        final Set<Note> values = await getNotes();
        _notesStreamController!.add(values);
        debugPrint("Sent initial data: $values");
        _notesStreamController!.addStream(
          _box!.watch().asyncMap<Set<Note>>((event) {
            return getNotes();
          }),
        );
      },
      onCancel: () async {
        await _notesStreamController!.close();
        _notesStreamController = null;
      },
    );
    debugPrint("returning stream");
    return _notesStreamController!.stream;
  }

  Future<Set<Note>> getNotes() async {
    final Iterable<String> keys = _box!.keys.cast<String>();

    final Set<Note> result = {};

    for (final String key in keys) {
      final String? value = await _box!.get(key);
      if (value != null) {
        result.add(Note.fromJson(value));
      } else {
        debugPrint("Value for key $key isn't found in the database");
      }
    }

    return result;
  }

  @override
  Future<void> saveNote(Note note) async {
    final String json = note.toJson();
    await _box!.put(note.id, json);
  }

  @override
  Future<void> deleteNote(String noteID) async {
    await _box!.delete(noteID);
  }
}

/*
abstract class DatabasePasswordManager {
  const DatabasePasswordManager();

  static const DatabasePasswordManager instance = _DatabasePasswordManagerSS();

  Future<bool> isPasswordSaved();

  Future<List<int>?> getKeyForPassword(String password);
}

class _DatabasePasswordManagerSS extends DatabasePasswordManager {
  const _DatabasePasswordManagerSS();

  @override
  Future<bool> isPasswordSaved() async {
    const FlutterSecureStorage secureStorage = FlutterSecureStorage();
    /*
    {
      "password": password,
      "key": [2, 33, 41, 52, 41...]
    }
    */

    final String? result = await secureStorage.read(key: "password");

    return result != null;
  }

  @override
  Future<List<int>?> getKeyForPassword(String password) async {
    const FlutterSecureStorage secureStorage = FlutterSecureStorage();

    final String? savedPassword = await secureStorage.read(key: "password");

    if (savedPassword == null) {
      final List<int> key = Hive.generateSecureKey();
      await secureStorage.write(key: "key", value: jsonEncode(key));
      await secureStorage.write(key: "password", value: password);

      return key;
    }

    if (savedPassword != password) {
      return null;
    }

    final String? keyJson = await secureStorage.read(key: "key");
    if (keyJson == null) {
      throw "System Error! No key saved for saved password!";
    }

    final List<int> key = (jsonDecode(keyJson) as List).cast<int>();

    return key;
  }
}
*/
