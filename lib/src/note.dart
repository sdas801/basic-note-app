import 'dart:convert';

class Note {
  final String title;
  final String note;
  final String id;

  const Note({required this.id, required this.title, required this.note});
  String toJson() {
    return jsonEncode(toMap());
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': this.id,
      'title': this.title,
      'note': this.note,
    };
  }

  factory Note.fromJson(String json) {
    Map<String, dynamic> map = jsonDecode(json) as Map<String, dynamic>;
    return Note.fromMap(map);
  }
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(id: map['id'], title: map['title'], note: map['note']);
  }
  bool searchItemChecked(String searchedItem) {
    return title.contains(searchedItem) || note.contains(searchedItem);
  }
}
