import 'dart:async';



import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';




class SharedDocs extends StatefulWidget {
  const SharedDocs({Key? key}) : super(key: key);

  @override
  State<SharedDocs> createState() => _SharedDocsState();
}

class _SharedDocsState extends State<SharedDocs> {
  final scaffoldKey = GlobalKey<ScaffoldState>();


  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<String> GetName() async {
    final ref = FirebaseDatabase.instance.ref();
    final User? user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;


    return 'lol';
  }



  @override
  Widget build(BuildContext context) {


    return Scaffold(
      key: scaffoldKey,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF3d3efd ),
        child: const Icon(Icons.add),
        onPressed: () {},
      ),
      backgroundColor: const Color(0xFF5656f3 ),

      body: Column(
        children:  [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              autofillHints: const [AutofillHints.email],

              cursorColor: Colors.black,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: 'Search in shared docs',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.black, width: 100),
                ),
              ),
            ),
          ),


        ],
      ),
    );
  }
}