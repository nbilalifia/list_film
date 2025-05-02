// todo_page.dart — tampilkan data, cari, edit, hapus, checklist

import 'package:flutter/material.dart';
import 'package:list_film/database_helper.dart';
import 'package:list_film/models/film_item.dart';
import 'package:list_film/views/todo.dart';
import 'dart:io';

class ToDoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<FilmItem> filmList = [];
  List<FilmItem> filteredList = [];
  Set<int> selectedIds = {}; // for checklist delete
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshFilmList();
  }

  void _refreshFilmList() async {
    final data = await databaseHelper.getFilmList();
    setState(() {
      filmList = data;
      filteredList = data;
    });
  }

  void _filterList(String query) {
    setState(() {
      filteredList = filmList.where((item) => item.title.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  void _deleteFilm(int id) async {
    await databaseHelper.deleteFilm(id);
    _refreshFilmList();
  }

  void _deleteSelected() async {
    await databaseHelper.deleteMultiple(selectedIds.toList());
    selectedIds.clear();
    _refreshFilmList();
  }

  void _deleteAll() async {
    await databaseHelper.deleteAll();
    selectedIds.clear();
    _refreshFilmList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "Cari Judul Film",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
              ),
              onChanged: _filterList,
              onEditingComplete: () => FocusScope.of(context).unfocus(),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton(
                  onPressed: selectedIds.isNotEmpty ? _deleteSelected : null,
                  child: Text("Hapus Terpilih"),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: filmList.isNotEmpty ? _deleteAll : null,
                  child: Text("Hapus Semua"),
                ),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  final item = filteredList[index];
                  return Card(
                    child: ListTile(
                      leading: item.imagePath.isNotEmpty
                          ? Image.file(File(item.imagePath), width: 50, fit: BoxFit.cover)
                          : Icon(Icons.image),
                      title: Text(item.title),
                      subtitle: Text(item.description),
                      trailing: Wrap(
                        spacing: 12,
                        children: [
                          Checkbox(
                            value: selectedIds.contains(item.id),
                            onChanged: (val) {
                              setState(() {
                                if (val == true) selectedIds.add(item.id!);
                                else selectedIds.remove(item.id);
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ToDo(filmItem: item)),
                              );
                              if (result == true) _refreshFilmList();
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _deleteFilm(item.id!),
                          )
                        ],
                      ),
                      onTap: () {},
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ToDo()),
          );
          if (result == true) _refreshFilmList();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
