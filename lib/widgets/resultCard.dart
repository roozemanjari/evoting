import 'package:evoting/helpers/functions.dart';
import 'package:evoting/pages/candidatesPage.dart';
import 'package:evoting/themes/colors.dart';
import 'package:evoting/widgets/poll.dart';
import 'package:flutter/material.dart';

class ResultCard extends StatelessWidget {
  final Map electionData;

  const ResultCard({
    Key? key,
    required this.electionData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const ElectionPoll(),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
        padding: const EdgeInsets.all(20),
        width: size.width,
        decoration: BoxDecoration(
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Colors.grey,
              blurRadius: 5.0,
              offset: Offset(0.0, 0.55),
            )
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            SizedBox(
              width: (size.width - 40) * 0.6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    electionData["for"],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    electionData["type"],
                    style: const TextStyle(color: primaryColor, fontSize: 16),
                  ),
                  const SizedBox(height: 15),
                  const Divider(),
                  const SizedBox(height: 15),
                  const Text(
                    "Winner",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    findWhoWon(electionData["options"]),
                    style: const TextStyle(color: primaryColor, fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
            const Spacer(),
            const Text(
              "🎉",
              style: TextStyle(fontSize: 70),
            )
          ],
        ),
      ),
    );
  }
}
