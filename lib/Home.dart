


import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';
import 'package:weedydocs/shared_docs.dart';
import 'package:weedydocs/userDocs.dart';



class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final scaffoldKey = GlobalKey<ScaffoldState>();


  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;




  /// Controller to handle PageView and also handles initial page
  final _pageController = PageController(initialPage: 0);

  /// Controller to handle bottom nav bar and also handles initial page
  int selectedIndex = 0;
  late PageController pageController;
  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: selectedIndex);
  }
  @override
  Widget build(BuildContext context) {



    return KeyboardVisibilityBuilder(
        builder: (context, isKeyboardVisible) {
          bool isKeyboardOpen = isKeyboardVisible;
          print('The keyboard is: ${isKeyboardVisible ? 'VISIBLE' : 'NOT VISIBLE'}');
      return Scaffold(


          key: scaffoldKey,
          appBar: AppBar(
            backgroundColor: const Color(0xFF3d3efd ),
            automaticallyImplyLeading: false,
            elevation: 10.0,
            shape: const RoundedRectangleBorder(
              side: BorderSide(color: Colors.black, width: 1),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
            title:  Text(
              'Documents',
              style: GoogleFonts.roboto(
                  textStyle:  const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFf5f4f9 ),
                      shadows: [
                        Shadow( // bottomLeft
                            offset: Offset(-1.0, -1.0),
                            color: Colors.black
                        ),
                        Shadow( // bottomRight
                            offset: Offset(1.0, -1.0),
                            color: Colors.black
                        ),
                        Shadow( // topRight
                            offset: Offset(1.0, 1.0),
                            color: Colors.black
                        ),
                        Shadow( // topLeft
                            offset: Offset(-1.0, 1.0),
                            color: Colors.black
                        ),
                      ]
                  )),
            ),
            actions: const <Widget>[
              Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: IconButton(
                      onPressed: null,
                      icon: Icon(Icons.settings, color: Colors.white, size: 26.0, shadows: [
                        Shadow( // bottomLeft
                            offset: Offset(-1.0, -1.0),
                            color: Colors.black
                        ),
                        Shadow( // bottomRight
                            offset: Offset(1.0, -1.0),
                            color: Colors.black
                        ),
                        Shadow( // topRight
                            offset: Offset(1.0, 1.0),
                            color: Colors.black
                        ),
                        Shadow( // topLeft
                            offset: Offset(-1.0, 1.0),
                            color: Colors.black
                        ),
                      ]),

                    ),

              ),

            ],
            centerTitle: false,

          ),
          backgroundColor: const Color(0xFF5656f3 ),
          bottomNavigationBar:
          isKeyboardOpen
              ? null
              : WaterDropNavBar(

                  waterDropColor: const Color(0xFF5656f3 ),
                  backgroundColor: Colors.white,
                  onItemSelected: (index) {
                    setState(() {
                      selectedIndex = index;
                    });
                    pageController.animateToPage(selectedIndex,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutQuad);
                  },
                  selectedIndex: selectedIndex,
                  barItems: [
                    BarItem(
                      filledIcon: Icons.home_filled,
                      outlinedIcon: Icons.home_outlined,
                    ),
                    BarItem(
                        filledIcon: Icons.group_rounded,
                        outlinedIcon: Icons.group_outlined),

            ],
          ),
          body: PageView(
            controller: pageController,
            onPageChanged: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
            children:  const [
              UserDocs(),
              SharedDocs(),
            ],
          ),
      );
  }
  );
  }
}
