import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import "package:firebase_database/firebase_database.dart";
import 'package:flutter/services.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';


class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register>{

  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  FirebaseDatabase database = FirebaseDatabase.instance;

  Future LogIn() async{
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim()
    );

      final User? user = FirebaseAuth.instance.currentUser;
      final uid = user?.uid;


      database.ref("Users/$uid").update({
        'wonPrizes': "",
        'wonPrizesXP': 0,
        'SelectedSkin': '0',

        "Name": nameController.text.trim(),
        "uid": uid,
        "photo": "https://upload.wikimedia.org/wikipedia/commons/9/9a/%D0%9D%D0%B5%D1%82_%D1%84%D0%BE%D1%82%D0%BE.png",
        "Points": 0
      }
      ).then((value) => database.ref("Users/$uid/friends").update({
        "friendsUID": "null",
      }
      ).then((value) => database.ref("Users/$uid").update({
        "kills": 0,
        "deaths": 0,
      }
      ).then((value) => Navigator.pushNamed(context, 'home')) ));




  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,

      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(

          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(
            opticalSize: 50,
            color: Colors.black, //change your color here
          ),
        ),
        backgroundColor: const Color(0xFF5656f3 ),
        body: SingleChildScrollView(
          child: Center(
                  child: Container(
                    width: 300,
                    padding: EdgeInsets.only(

                        top: MediaQuery.of(context).size.height * 0.05),

                    child: Column(children: [
                      Text(
                        "Sign up",
                        style: GoogleFonts.roboto(
                            textStyle:  const TextStyle(
                                color: Color(0xFFf5f4f9 ),
                                fontSize: 60,
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
                      const SizedBox(
                        height: 80,
                      ),

                      TextField(
                        autofillHints: const [AutofillHints.email],
                        controller: emailController,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
                        style: const TextStyle(color: Colors.black, fontSize: 18),
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(color: Colors.black, width: 100),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextField(

                        autofillHints: [AutofillHints.password],
                        controller: passwordController,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.done,
                        obscureText: true,
                        style: const TextStyle(color: Colors.black, fontSize: 18),
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          hintText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            gapPadding: 10,
                            borderSide: const BorderSide(color: Colors.black, width: 100),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 65,
                      ),

                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SignInButton(
                              Buttons.GoogleDark,
                              text: "Sign up with Google",
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              padding: const EdgeInsets.all(4),
                              onPressed: () {
                                signInWithGoogle();
                              },
                            ),
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: const Color(0xff4c505b),
                              child: IconButton(
                                color: Colors.white,
                                onPressed: () {
                                  if(emailController.text.trim() != "" && passwordController.text.trim() != "" && nameController.text.trim() != "" ) {
                                    LogIn();

                                  }
                                },
                                icon: const Icon(Icons.arrow_forward),
                              ),
                            ),
                          ],),



                    ]),
                  )),
        ),
      ),
    );

  }
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}

































