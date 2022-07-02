import 'package:evoting/pages/register.dart';
import 'package:evoting/pages/signIn.dart';
import 'package:evoting/themes/colors.dart';
import 'package:evoting/widgets/primaryButton.dart';
import 'package:evoting/widgets/secondaryButton.dart';
import 'package:flutter/material.dart';

class LoginAndRegisterPage extends StatefulWidget {
  const LoginAndRegisterPage({Key? key}) : super(key: key);

  @override
  State<LoginAndRegisterPage> createState() => _LoginAndRegisterPageState();
}

class _LoginAndRegisterPageState extends State<LoginAndRegisterPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: secondaryColor,
      width: size.width,
      padding: const EdgeInsets.all(20),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 200),
            Image.asset("images/logo.png"),
            const SizedBox(height: 50),
            const Text(
              "Vote India App",
              style: TextStyle(
                color: textColor,
                decoration: TextDecoration.none,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            const Text(
              "चलो इंडिया वोट करे",
              style: TextStyle(
                color: textColor,
                decoration: TextDecoration.none,
                fontSize: 23,
                fontWeight: FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            SecondaryButton(
              name: "Register",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Register(),
                  ),
                );
              },
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 1.5,
                  width: size.width / 4,
                  color: textColor,
                  margin: const EdgeInsets.only(right: 10.0),
                ),
                const Text(
                  "OR",
                  style: TextStyle(
                    color: textColor,
                    decoration: TextDecoration.none,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  height: 1.5,
                  width: size.width / 4,
                  color: textColor,
                  margin: const EdgeInsets.only(left: 10.0),
                ),
              ],
            ),
            const SizedBox(height: 15),
            PrimaryButton(
              child: const Text(
                "SIGN IN",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignIn(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
