import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weedydocs/firebase_options.dart';
import 'package:weedydocs/registration.dart';
import 'package:weedydocs/upload_file.dart';
import 'Login.dart';
import 'home_page.dart';


Future<void> _messageHandler(RemoteMessage message) async {
  print('background message ${message.notification!.body}');
}

void main() async{
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  FirebaseMessaging.onBackgroundMessage(_messageHandler);





  runApp(
    MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.black,
        hintColor: Colors.black,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: 'main',

      routes: {
        'main': (context) => const mainPage(),
        'login': (context) => const Login(),
        'register': (context) => const Register(),
        'home': (context) => const Home(),
        'addFile': (context) => const AddFile(),
      },
    ),
  );





}

class mainPage extends StatelessWidget {
  const mainPage({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);


    return Scaffold(
      body: StreamBuilder<User?>(

          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {

            if (snapshot.hasData) {
              return const Home();
            } else {
              return const Login();
            }
          }
      ),
    );
  }
}