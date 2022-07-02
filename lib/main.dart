import 'package:evoting/pages/authPage.dart';
import 'package:evoting/pages/homepage.dart';
import 'package:evoting/themes/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import "package:flutter/material.dart";

void main() async {
  await WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  // FIXME:
  await FirebaseAuth.instance.signOut();
  runApp(const EVotingApp());
}

class EVotingApp extends StatelessWidget {
  const EVotingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryColor,
        appBarTheme: const AppBarTheme(
          color: Color.fromARGB(255, 233, 233, 233),
          foregroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
          ),
        ),
      ),
      // FIXME:
      // home: const HomePage(
      //   phoneNumber: "+91 7983553007",
      // ),
      home: const LoginAndRegisterPage(),
    );
  }
}
