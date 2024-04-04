import 'dart:io';

import 'package:erp_teacher/widgets/done.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../../../services/firebase_database_services.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  FilePickerResult? result;
  String? _class;
  bool processing = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Notes"),
          centerTitle: true,
        ),
        body: (result == null)
            ? Center(
                child: ElevatedButton(
                  onPressed: () {
                    _pickFile();
                  },
                  child: const Text("Select File"),
                ),
              )
            :(processing)?const Center(child: CircularProgressIndicator(),): Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: FutureBuilder(
                        future: FirebaseDatabaseServices().getListOfClasses(),
                        builder: (context, snapShot) {
                          if (snapShot.hasData) {
                            return DropdownMenu<String>(
                              width: MediaQuery.of(context).size.width,
                              hintText: "Select Class",
                              dropdownMenuEntries: snapShot.data!
                                  .map<DropdownMenuEntry<String>>((e) =>
                                      DropdownMenuEntry(value: e, label: e))
                                  .toList(),
                              onSelected: (value) {
                                _class = value;
                                setState(() {});
                              },
                            );
                          } else if (snapShot.hasError) {
                            return Center(
                              child: Text(snapShot.error.toString()),
                            );
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        controller: titleController,
                        validator: (value) {
                          if (value == "") {
                            return "Title Can't be remained empty";
                          } else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(), labelText: "Title*"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: contentController,
                        validator: (value) {
                          if (value == "") {
                            return "Content Can't be remained empty";
                          } else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Content*"),
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate() &&
                              _class != null) {
                            setState(() {
                              processing = true;
                            });
                            await uploadNotes();

                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Done()));
                          }
                        },
                        child: const Text("Submit"))
                  ],
                ),
              ));
  }

  _pickFile() async {
    result = await FilePicker.platform.pickFiles();
    if (result?.files.first != null) {
      setState(() {});
    }
  }

  uploadNotes() async {
    final file = File(result!.files.first.path!);
    final snapshot = await FirebaseStorage.instance
        .ref()
        .child("Notes/${result!.files.first.name}")
        .putFile(file)
        .whenComplete(() => {});

    var url = await snapshot.ref.getDownloadURL();
    await FirebaseDatabaseServices().uploadNotes(
        url, titleController.text, contentController.text, _class!);
  }
}
