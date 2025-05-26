import 'dart:convert';

import 'package:equatable/equatable.dart';

class Note extends Equatable {
  final String title;
  final String note;
  final String id;

  const Note({required this.id, required this.title, required this.note});

  @override
  String toString() {
    return toJson();
  }

  String toJson() {
    final Map<String, dynamic> map = toMap();
    return jsonEncode(map);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{"id": id, "title": title, "note": note};
  }

  factory Note.fromJson(String json) {
    final Map<String, dynamic> map = jsonDecode(json) as Map<String, dynamic>;
    return Note.fromMap(map);
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map["id"] as String,
      title: map["title"] as String,
      note: map["note"] as String,
    );
  }

  @override
  List<Object?> get props => [id, title, note];

  bool includesSearchTerm(String searchTerm) {
    return title.toLowerCase().contains(searchTerm) ||
        note.toLowerCase().contains(searchTerm);
  }
}
