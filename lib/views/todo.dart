// todo.dart — Form input film lengkap dan bekerja

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:list_film/database_helper.dart';
import 'package:list_film/models/film_item.dart';
import 'package:intl/intl.dart';

class ToDo extends StatefulWidget {
  final FilmItem? filmItem;
  const ToDo({super.key, this.filmItem});

  @override
  State<ToDo> createState() => _ToDoState();
}

class _ToDoState extends State<ToDo> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseHelper dbHelper = DatabaseHelper();
  final picker = ImagePicker();

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String _recommendation = "Recommended";
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    if (widget.filmItem != null) {
      titleController.text = widget.filmItem!.title;
      descriptionController.text = widget.filmItem!.description;
      _recommendation = widget.filmItem!.recommendation;
      _imagePath = widget.filmItem!.imagePath;
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  void _saveFilm() async {
    if (_formKey.currentState!.validate()) {
      final now = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
      final film = FilmItem.withId(
        widget.filmItem?.id,
        titleController.text,
        descriptionController.text,
        _recommendation,
        now,
        _imagePath ?? '',
      );

      if (widget.filmItem == null) {
        await dbHelper.insertFilm(film);
      } else {
        await dbHelper.updateFilm(film);
      }

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.titleLarge ?? TextStyle();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.filmItem == null ? "Tambah Film" : "Edit Film"),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: _recommendation,
                items: ["Recommended", "Not Recommended"].map((label) => DropdownMenuItem(
                  value: label,
                  child: Text(label),
                )).toList(),
                onChanged: (val) => setState(() => _recommendation = val!),
                decoration: InputDecoration(labelText: 'Kategori'),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Judul Film'),
                validator: (value) => value!.isEmpty ? 'Judul tidak boleh kosong' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Komentar'),
                maxLines: 3,
                validator: (value) => value!.isEmpty ? 'Komentar tidak boleh kosong' : null,
              ),
              SizedBox(height: 10),
              _imagePath != null && _imagePath!.isNotEmpty
                  ? Image.file(File(_imagePath!), height: 200)
                  : Text('Belum ada gambar'),
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: Icon(Icons.image),
                label: Text('Pilih Gambar'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveFilm,
                child: Text('Simpan'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
