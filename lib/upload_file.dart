import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:docx_to_text/docx_to_text.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_ml_kit/google_ml_kit.dart' as mlkit;
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:http/http.dart' as http;

class AddFile extends StatefulWidget {
  const AddFile({Key? key}) : super(key: key);

  @override
  State<AddFile> createState() => _AddFileState();
}

class _AddFileState extends State<AddFile> {
  final scaffoldKey = GlobalKey<ScaffoldState>();


  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<String?> uploadFile(File file) async {
    try {
      // Make sure that the Firebase app has been initialized
      await Firebase.initializeApp();

      // Create a reference to the location you want to upload to in Firebase Storage
      String filePath = 'files/${basename(file.path)}'; // this is just an example path, you can choose your own
      Reference storageReference = FirebaseStorage.instance.ref().child(filePath);

      // Upload the file to Firebase Storage
      UploadTask uploadTask = storageReference.putFile(file);

      // Wait until the file is uploaded
      final TaskSnapshot downloadUrl = (await uploadTask);
      final String url = await downloadUrl.ref.getDownloadURL();

      print("File URL: $url");

      return url;
    } on FirebaseException catch (e) {
      // If any error occurs, print the error
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }
  List<String> tagsMain = [];
  String titleMain = '';
  String categoryMain = '';

  String fileFormat = '';

  Future<String> fileUpload(File file) async {
    final ref = FirebaseDatabase.instance.ref();
    final User? user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;
    var link = await uploadFile(file);
    ref.child('Users/$uid/folders/$categoryMain/$titleMain').update(  {

      'fileFormat': fileFormat,
      'tags': tagsMain,
      'documentLink': link,
    }).then((value) {
      
    });

    return 'lol';
  }

  String fileName = '';
  String fileCategory = '';

  Widget fileSnip = Column(
    children: [
      const Icon(
        Icons.file_copy,
        size: 100,
        color: Colors.white,
      ),
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          'Add your document',
          style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                  color: Color(0xFFf5f4f9),
                  fontSize: 14,
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
        ),
      )
    ],
  );
  Widget filePdf = const Icon(
    Icons.picture_as_pdf,
    size: 100,
    color: Colors.white,
  );

  Widget filePhoto = const Icon(
    Icons.photo,
    size: 100,
    color: Colors.white,
  );

  Widget fileTxt = const Icon(
    Icons.text_snippet,
    size: 100,
    color: Colors.white,
  );

  Widget butune = ElevatedButton(
    onPressed: () {

    },
    style: ElevatedButton.styleFrom(
      primary: const Color(0xFF3d3efd),
      onPrimary: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32.0),
      ),
    ),
    child: const Text(
      'Save',
      style: TextStyle(fontSize: 21),
    ),
  );

  Widget butun = Text('');

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: fileName);
    final controller2 = TextEditingController(text: fileCategory);
    List<String> tagsMain = [];
    String titleMain = '';
    String categoryMain = '';
    File fileMain;
    void parseString(String input) {
      List<String> parts = input.split(':');
      String title = parts[1].split('Tags')[0].trim();
      List<String> tags = parts[2]
          .split('Folder')[0]
          .split(',')
          .map((tag) => tag.trim())
          .toList();
      String category = parts[3].trim();

      print('Title: $title');
      print('Tags: $tags');
      print('Category: $category');

      setState(() {
        fileName = title;
        fileCategory = category;
        butun = butune;
        titleMain = title;
        categoryMain = category;
        //controller2.dropDownValue = DropDownValueModel(name: category, value: category);
        tagsMain = tags;
      });
    }

    Future<List> getInfo(String doc) async {
      setState(() {
        butun = const CircularProgressIndicator();
      });
      if (doc.length <= 150) {
      } else {
        doc = doc.substring(0, 150);
      }
      final url = Uri.parse(
          "https://api.writesonic.com/v2/business/content/chatsonic?engine=premium&language=en");
      final headers = {
        "accept": "application/json",
        "content-type": "application/json",
        "X-API-KEY": "f4fdb61d-72bf-498f-92d6-df103e4a9204"
      };
      final payload = {
        "enable_google_results": false,
        "enable_memory": false,
        "input_text":
            'Given the following document text, identify a possible title (maximum of two words in the language of the document), tags (maximum of two words in the language of the document, not less then 5 tags), and folder (maximum of two words in the language of the document): $doc Please submit your answer in the following format: Title: [Your name here] Tags: [Your tags here] Folder: [Your folder here]',
      };
      final response =
          await http.post(url, headers: headers, body: json.encode(payload));

      var message = utf8.decode(response.bodyBytes);
      var decodedMessage = json.decode(message);
      var text2 = decodedMessage['message'];

      if (response.statusCode == 200) {
        print(text2);
        parseString(text2.replaceAll('"', ''));
      } else {
        print("Чет не работает");
      }

      return [doc];
    }

    Future<String?> pickAndExtractText() async {
      // Open the file explorer
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['txt', 'pdf', 'docx', 'jpg', 'jpeg', 'png', 'doc'],
      );

      if (result != null) {
        PlatformFile file = result.files.first;

        if (file.extension == 'pdf') {
          print('PDF');
          // Load the PDF document
          PdfDocument document =
              PdfDocument(inputBytes: File(file.path!).readAsBytesSync());

          // Initialize the PDF text extractor
          PdfTextExtractor extractor = PdfTextExtractor(document);
          print('PDF');
          // Extract text from the PDF document
          String text = extractor.extractText();
          setState(() {
            fileSnip = filePdf;
          });
          getInfo(text);
          print(text);
          fileMain = File(file.path!);
          fileFormat = 'pdf';
          return text;
        } else if (file.extension == 'txt') {


          // Read the text file
          String text = await File(file.path!).readAsString();
          getInfo(text);
          fileFormat = 'txt';
          setState(() {
            fileSnip = fileTxt;
          });
          fileMain = File(file.path!);
          return text;
        } else if (file.extension == 'docx' || file.extension == 'doc') {
          // Extract text from the docx file
          final files = File(file.path!);
          final bytes = await files.readAsBytes();
          final text = docxToText(bytes, handleNumbering: false);
          getInfo(text);
          fileMain = File(file.path!);
          fileFormat = 'docx';
          return text;
        } else if (file.extension == 'jpg' ||
            file.extension == 'jpeg' ||
            file.extension == 'png') {
          // Extract text from the image
          final textDetector = mlkit.GoogleMlKit.vision.textRecognizer();
          final inputImage = InputImage.fromFilePath(file.path!);
          final recognizedText = await textDetector.processImage(inputImage);
          String extractedText = '';
          for (TextBlock block in recognizedText.blocks) {
            for (mlkit.TextLine line in block.lines) {
              extractedText += '${line.text}\n';
            }
          }
          getInfo(extractedText);
          fileMain = File(file.path!);
          fileFormat = 'png';
          setState(() {
            fileSnip = filePhoto;
          });
          return extractedText;
        }
      } else {
        return null;
      }
      return null;
    }


    Future<List<DropDownValueModel>> dropDownList;

    Future<List<DropDownValueModel>>? getFolders() async {
      final ref = FirebaseDatabase.instance.ref();
      final snapshot = await ref.child('userUid/folders').get();
      final foldersData = Map<String, dynamic>.from(snapshot.value as Map);
      final list = foldersData.keys.map((folderName) {
        return DropDownValueModel(name: folderName, value: folderName);
      }).toList();

      return list;
    }

    @override
    void initState() {
      super.initState();
      dropDownList = getFolders()!;
    }








    return FutureBuilder(
        future: getFolders(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                iconTheme: const IconThemeData(
                  opticalSize: 50,
                  color: Colors.black, //change your color here
                ),
              ),
              backgroundColor: const Color(0xFF5656f3),
              body: Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: fileSnip,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, bottom: 80.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: const Color(0xFF3d3efd),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              onPressed: () {
                                          pickAndExtractText();

                              },
                              child: Text(
                                'Upload 📂',
                                style: GoogleFonts.roboto(
                                    textStyle: const TextStyle(
                                        color: Color(0xFFf5f4f9),
                                        fontSize: 17,
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
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: const Color(0xFF3d3efd),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              onPressed: () async {

                                final imagesPath =
                                    await CunningDocumentScanner.getPictures();

                                if (imagesPath != null) {
                                  final textDetector =
                                      mlkit.GoogleMlKit.vision.textRecognizer();
                                  final inputImage =
                                      InputImage.fromFilePath(imagesPath.first);
                                  final recognizedText = await textDetector
                                      .processImage(inputImage);
                                  String extractedText = '';
                                  for (TextBlock block
                                      in recognizedText.blocks) {
                                    for (mlkit.TextLine line in block.lines) {
                                      extractedText += '${line.text}\n';
                                    }
                                  }
                                  getInfo(extractedText);
                                  print(extractedText);
                                } else {}
                              },
                              child: Text(
                                'Take photo 📷',
                                style: GoogleFonts.roboto(
                                    textStyle: const TextStyle(
                                        color: Color(0xFFf5f4f9),
                                        fontSize: 17,
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
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextField(
                          controller: controller,
                          cursorColor: Colors.black,
                          textInputAction: TextInputAction.done,
                          obscureText: false,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: 'File name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              gapPadding: 10,
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 100),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextField(
                          controller: controller2,
                          cursorColor: Colors.black,
                          textInputAction: TextInputAction.done,
                          obscureText: false,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: 'File folder',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              gapPadding: 10,
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 100),
                            ),
                          ),
                        ),





                        // DropDownTextField(
                        //   dropDownList: snapshot.data as List<DropDownValueModel>,
                        //   enableSearch: false,
                        //   dropDownItemCount: 4,
                        //   readOnly: false,
                        //   isEnabled: true,
                        //   controller: controller2,
                        //   textFieldDecoration: InputDecoration(
                        //     fillColor: Colors.white,
                        //     filled: true,
                        //     hintText: 'File category',
                        //     border: OutlineInputBorder(
                        //       borderRadius: BorderRadius.circular(20),
                        //       gapPadding: 10,
                        //       borderSide: const BorderSide(
                        //           color: Colors.black, width: 100),
                        //     ),
                        //   ),
                        // ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: butun,
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {}
          return const Center(child: CircularProgressIndicator());
        });
  }
}
