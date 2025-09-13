
import 'package:flutter/material.dart';
import 'package:secure_note/src/edit_note_page.dart';
import 'package:secure_note/src/note.dart';
import 'package:secure_note/src/note_database.dart';

class HomeNote extends StatefulWidget {
  const HomeNote({super.key});

  @override
  State<HomeNote> createState() => _HomeNoteState();
}

class _HomeNoteState extends State<HomeNote> {
  bool gridFlag = false;
  late final Stream<Set<Note>> _noteStream;
  late final TextEditingController _searchController;
  List<Note>? _items;
  List<Note>? _filteredItems;
  void Function(void Function())? _rebuild;
  @override
  void initState() {
    super.initState();
    _noteStream = NoteDatabase.hiveInstance.getNoteStream();
    _searchController = TextEditingController();
    _searchController.addListener(_search);
  }

  void _search() {
    final String searchItem = _searchController.text.trim().toLowerCase();
    if (searchItem.isEmpty) {
      _rebuild?.call(() {});

      _filteredItems = null;
      return;
    }
    if (_items?.isEmpty ?? true) {
      _filteredItems = [];
      return;
    }
    _filteredItems =
        _items!.where((item) => item.searchItemChecked(searchItem)).toList();
    _rebuild?.call(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: AppBar(
            backgroundColor: Color(0xffffffff),
            centerTitle: true,
            title: SizedBox(
              height: 50,
              child: TextField(
                controller: _searchController,
                cursorHeight: 20,
                cursorColor: Colors.black,
                cursorWidth: 1.5,
                textAlignVertical: TextAlignVertical.center,
                style: TextStyle(fontSize: 16, height: 1),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.menu),
                  suffixIcon: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    width: 120,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              if (gridFlag) {
                                gridFlag = false;
                              } else {
                                gridFlag = true;
                              }
                            });
                          },
                          child:
                              gridFlag
                                  ? Icon(Icons.view_agenda_outlined)
                                  : Icon(Icons.grid_view_outlined),
                        ),
                        SizedBox(width: 20),
                        CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.grey[400],
                          child: Icon(
                            Icons.person,
                            size: 20,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),

                  hintText: 'Search your notes',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 10,
                  ),
                  fillColor: Color(0xfff5f6ff),
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,

                    borderRadius: BorderRadius.circular(25),
                  ),

                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: StreamBuilder<Set<Note>>(
        stream: _noteStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            _items = null;
            return Center(child: CircularProgressIndicator.adaptive());
          }
          _items = snapshot.data!.toList();

          if (_items!.isEmpty) {
            return Center(
              child: Text('Empty Notes, Create one by pressing "+" button'),
            );
          }
          return StatefulBuilder(
            builder: (context, setState) {
              _rebuild = setState;
              final List<Note> itemToShow = _filteredItems ?? _items!;
              return gridFlag
                  ? GridView.builder(
                    padding: EdgeInsets.all(8.0),
                    itemCount: itemToShow.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                      crossAxisCount: 2,
                    ),
                    itemBuilder: (context, index) {
                      final Note item = _items![index];
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [Text(item.title), Text(item.note)],
                        ),
                      );
                    },
                  )
                  : ListView.separated(
                    itemBuilder: (context, index) {
                      final Note item = itemToShow[index];
                      return ListTile(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => EditNotePage(oldNote: item),
                            ),
                          );
                        },
                        title: Text(item.title),
                        subtitle: Text(item.note),
                        trailing: InkWell(
                          onTap: () {
                            NoteDatabase.hiveInstance.deleteNote(item.id);
                          },

                          child: Icon(Icons.delete, color: Colors.grey[400]),
                        ),
                      );
                    },
                    itemCount: itemToShow.length,
                    separatorBuilder: (context, index) => const Divider(),
                  );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            () => Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (context) => EditNotePage())),
        child: Icon(Icons.add, color: Colors.black54),
        backgroundColor: Colors.grey[400],
      ),
    );
  }
}
