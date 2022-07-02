import 'package:evoting/themes/colors.dart';
import 'package:flutter/material.dart';

class ElectionPoll extends StatefulWidget {
  const ElectionPoll({Key? key}) : super(key: key);

  @override
  State<ElectionPoll> createState() => _ElectionPollState();
}

class _ElectionPollState extends State<ElectionPoll> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              width: size.width,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    "RESULT POLL",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 1.5,
              width: size.width,
              color: primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
