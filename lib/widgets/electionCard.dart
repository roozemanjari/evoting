import 'package:evoting/helpers/functions.dart';
import 'package:evoting/pages/candidatesPage.dart';
import 'package:evoting/themes/colors.dart';
import 'package:flutter/material.dart';

class ElectionCard extends StatelessWidget {
  final Map electionData;

  const ElectionCard({
    Key? key,
    required this.electionData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        if (checkWhoUserHasVoted(electionData["votes"]) != "NA") {
          // show toast voted
        } else {
          // Navigate to Candidate list
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CandidatesPage(electionData: electionData),
            ),
          );
        }
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
              style: const TextStyle(
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 10),
            const Text(
              "You Selected",
              style: TextStyle(
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              checkWhoUserHasVoted(electionData["votes"]),
              style: const TextStyle(color: primaryColor, fontSize: 16),
            ),
            const SizedBox(height: 5),
            const Divider(),
            const SizedBox(height: 10),
            Text(
              "Deadline: ${formatDate(electionData["expireDate"])}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
