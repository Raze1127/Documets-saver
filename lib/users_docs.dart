import 'dart:async';

import 'package:file_icon/file_icon.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';


class UserDocs extends StatefulWidget {
  const UserDocs({Key? key}) : super(key: key);

  @override
  State<UserDocs> createState() => _UserDocsState();
}

class _UserDocsState extends State<UserDocs>
    with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<String> GetName() async {
    final ref = FirebaseDatabase.instance.ref();
    final User? user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;

    return 'lol';
  } // пример получения из firebase


  String _selectedFolder = 'root';
  bool isDocs = false;

  Widget? calledWidget;


  void switchPage(int newNumber, String selectedFolder) {
    if (newNumber == 1) {
      setState(() {
        isDocs = false;
        calledWidget = buildFolders();
      },);
    } else if (newNumber == 2) {
      setState(() {
        isDocs = true;
        calledWidget = buildDocs(selectedFolder);
      },);
    }
  }

  Future<bool> _onWillPop() async {
    if (isDocs) {
      switchPage(1, _selectedFolder);
      return false; // не выходим из приложения или не возвращаемся на предыдущий экран
    }
    return true; // выходим из приложения или возвращаемся на предыдущий экран
  }


  @override
  Widget build(BuildContext context) {
    if (calledWidget == null) {
      switchPage(1, _selectedFolder);
    }
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: scaffoldKey,
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF3d3efd),
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, 'addFile');
          },
        ),
        backgroundColor: const Color(0xFF5656f3),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                autofillHints: const [AutofillHints.email],
                cursorColor: Colors.black,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'Search in your docs',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide:
                    const BorderSide(color: Colors.black, width: 100),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: SizedBox(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.70196,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: calledWidget,
                  )
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildDocs(String selectedFolder) {
    const ValueKey<int>(2);
    final dbRef = FirebaseDatabase.instance.ref();
    return Scaffold(
      key: const ValueKey<int>(2),
      backgroundColor: const Color(0xFF5656f3),
      body: StreamBuilder(
        key: UniqueKey(),
        stream: dbRef
            .child('userUid/folders/$selectedFolder')
            .onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map data = snapshot.data!.snapshot.value as Map;
            List item = [];

            data.forEach((index, data) => item.add({"key": index, ...data}));

            return GridView.builder(
                key: const ValueKey<int>(2),
                itemCount: item.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  Map<dynamic, dynamic> map = snapshot.data?.snapshot
                      .value as Map;
                  return GestureDetector(

                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      color: const Color(0xFF3d3efd),
                      elevation: 5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FileIcon("doc.${item[index]["fileFormat"]}",
                              size: 72.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.2,
                                child: Text(
                                  item[index]["key"],
                                  style: GoogleFonts.roboto(
                                      textStyle: const TextStyle(
                                          color: Color(0xFFf5f4f9),
                                          fontSize: 16,
                                          shadows: [
                                            Shadow(
                                              // bottomLeft
                                                offset: Offset(-1.0, -1.0),
                                                color: Colors.black),
                                            Shadow(
                                              // bottomRight
                                                offset: Offset(1.0, -1.0),
                                                color: Colors.black),
                                            Shadow(
                                              // topRight
                                                offset: Offset(1.0, 1.0),
                                                color: Colors.black),
                                            Shadow(
                                              // topLeft
                                                offset: Offset(-1.0, 1.0),
                                                color: Colors.black),
                                          ])),
                                  overflow: TextOverflow.fade,
                                  maxLines: 2,
                                  softWrap: false,
                                ),
                              ),
                              PopupMenuButton<String>(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                onSelected: (value) {
                                  // TODO: Handle menu selection
                                },
                                itemBuilder: (context) {
                                  return {
                                    'Delete': Icons.delete,
                                    'Share': Icons.share,
                                    'Download': Icons.cloud_download
                                  }
                                      .entries
                                      .map((entry) {
                                    return PopupMenuItem<String>(
                                      value: entry.key,
                                      child: Row(
                                        children: <Widget>[
                                          Icon(entry.value),
                                          SizedBox(width: 8.0),
                                          // Добавьте пространство между иконкой и текстом, если нужно
                                          Text(entry.key),
                                        ],
                                      ),
                                    );
                                  }).toList();
                                },
                              )

                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                });
          } else
            return CircularProgressIndicator();
        },
      ),
    );
  }

  Widget buildFolders() {
    const ValueKey<int>(1);
    final dbRef = FirebaseDatabase.instance.ref();
    return Scaffold(
      backgroundColor: const Color(0xFF5656f3),
      key: const ValueKey<int>(1),
      body: StreamBuilder(
        key: UniqueKey(),
        stream: dbRef
            .child('userUid/folders')
            .onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              !snapshot.hasError &&
              snapshot.data?.snapshot.value != null) {
            Map<dynamic, dynamic> data =
            snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
            List item = [];

            data.forEach((index, data) => item.add({"key": index, ...data}));

            return GridView.builder(
                key: const ValueKey<int>(1),
                itemCount: item.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      _selectedFolder = item[index]['key'];
                      switchPage(2, _selectedFolder);
                    },
                    child: Card(
                      elevation: 0,
                      color: Colors.transparent,
                      child: Column(
                        children: <Widget>[
                          const Icon(
                            color: Colors.white,
                            Icons.folder_rounded,
                            size: 72.0,
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.only(left: 15.0, right: 15.0),
                            child: Text(
                              item[index]['key'],
                              style: GoogleFonts.roboto(
                                  textStyle: const TextStyle(
                                      color: Color(0xFFf5f4f9),
                                      fontSize: 18,
                                      shadows: [
                                        Shadow(
                                          // bottomLeft
                                            offset: Offset(-1.0, -1.0),
                                            color: Colors.black),
                                        Shadow(
                                          // bottomRight
                                            offset: Offset(1.0, -1.0),
                                            color: Colors.black),
                                        Shadow(
                                          // topRight
                                            offset: Offset(1.0, 1.0),
                                            color: Colors.black),
                                        Shadow(
                                          // topLeft
                                            offset: Offset(-1.0, 1.0),
                                            color: Colors.black),
                                      ])),
                              overflow: TextOverflow.fade,
                              maxLines: 2,
                              softWrap: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
