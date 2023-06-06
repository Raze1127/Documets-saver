import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weedydocs/Home.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: double.infinity,
        width: double.infinity,

        child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: const Color(0xFF5656f3 ),
            body: SingleChildScrollView(
              child: Center(child: Container( child: Container(
                 width: 300,
                padding: EdgeInsets.only(top: MediaQuery
                    .of(context)
                    .size
                    .height * 0.1),
                child: Column(

                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                       Text(
                        "Sign in",
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
                        height: 100,
                      ),

                      //Image.asset("assets/images/logo2.png"),

                      TextField(
                        autofillHints: const [AutofillHints.email],
                        controller: emailController,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.next,
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
                        height: 30,
                      ),
                      TextField(

                        autofillHints: [AutofillHints.password],
                        controller: passwordController,
                        cursorColor: Colors.black,
                        textInputAction: TextInputAction.done,
                        obscureText: true,
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
                        height: 20,
                      ),

                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SignInButton(
                                Buttons.GoogleDark,
                                text: "Sign in with Google",
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                    padding: const EdgeInsets.all(4),
                                    onPressed: () {
                                  signInWithGoogle();
                                    },
                              ),

                              CircleAvatar(
                                radius: 30,
                                backgroundColor:  Colors.black,
                                child: IconButton(
                                  color: Colors.white,
                                  onPressed: signIn,
                                  icon: const Icon(Icons.arrow_forward),
                                ),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, 'register');
                            },
                            child:  Text(
                              "Register",
                              style: GoogleFonts.roboto(
                                  textStyle:  const TextStyle(
                                      color: Color(0xFFf5f4f9 ),
                                      fontSize: 24,
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
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                      ),

                    ]),


              )),
              ),
            )
        )
    );
  }

  Future signIn() async{
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim()
    ).then((value) => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Home())));
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