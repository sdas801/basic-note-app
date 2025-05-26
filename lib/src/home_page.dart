import 'package:flutter/material.dart';
import 'package:secure_notes/src/database.dart';
import 'package:secure_notes/src/edit_page.dart';
import 'package:secure_notes/src/note.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Stream<Set<Note>> _notesStream;
  late final TextEditingController _searchController;
  List<Note>? _items;
  List<Note>? _filteredItems;
  void Function(void Function())? _rebuildListView;

  @override
  void initState() {
    super.initState();
    _notesStream = NoteDatabase.instance.getNotesStream();
    _searchController = TextEditingController()..addListener(_search);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _search() {
    final String searchTerm = _searchController.text.trim().toLowerCase();

    debugPrint("Called search function: $searchTerm");

    if (searchTerm.isEmpty) {
      _filteredItems = null;
      return;
    }

    if (_items?.isEmpty ?? true) {
      _filteredItems = [];
      return;
    }

    _filteredItems =
        _items!.where((item) => item.includesSearchTerm(searchTerm)).toList();

    _rebuildListView?.call(() {});
  }

  /*void _onEditPageOpen() {
    Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => const EditPage()));
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search Notes',
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<Set<Note>>(
                stream: _notesStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    _items = null;
                    return const Center(child: CircularProgressIndicator());
                  }

                  _items = snapshot.data!.toList();

                  if (_items!.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(36),
                        child: Text(
                          "No notes! Create one by pressing '+ New' button!",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  return StatefulBuilder(
                    builder: (context, setState) {
                      _rebuildListView = setState;
                      final List<Note> itemsToShow = _filteredItems ?? _items!;
                      return ListView.separated(
                        itemBuilder: (context, index) {
                          final Note item = itemsToShow[index];
                          return ListTile(
                            title: Text(item.title),
                            subtitle: Text(item.note),
                            titleTextStyle: const TextStyle(
                              color: Color.fromARGB(255, 75, 75, 75),
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            subtitleTextStyle: const TextStyle(
                              color: Color.fromARGB(255, 58, 58, 58),
                              fontSize: 16,
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => EditPage(note: item),
                                ),
                              );
                            },
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const Divider();
                        },
                        itemCount: itemsToShow.length,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => const EditPage()));
        },
        label: const Text("New"),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
