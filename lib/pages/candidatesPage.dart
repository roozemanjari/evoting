import 'package:evoting/helpers/functions.dart';
import 'package:evoting/helpers/globals.dart';
import 'package:evoting/pages/homepage.dart';
import 'package:evoting/services/DBqueries.dart';
import 'package:evoting/themes/colors.dart';
import "package:flutter/material.dart";

class CandidatesPage extends StatefulWidget {
  final Map electionData;

  const CandidatesPage({
    Key? key,
    required this.electionData,
  }) : super(key: key);

  @override
  State<CandidatesPage> createState() => _CandidatesPageState();
}

class _CandidatesPageState extends State<CandidatesPage> {
  String selected = "";
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    TableRow customTableRow(
      Map data,
    ) {
      bool isSelected = (data["candidate"] == selected);

      return TableRow(
        children: [
          TableCell(
            child: SizedBox(
              height: 35,
              child: Text(
                data["value"],
              ),
            ),
          ),
          TableCell(
            child: Text(data["candidate"]),
          ),
          TableCell(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selected = data["candidate"];
                });
              },
              child: SizedBox(
                height: 18,
                child: Container(
                  height: 10,
                  width: 10,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: primaryColor,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: isSelected
                      ? Center(
                          child: Container(
                            height: 10,
                            width: 10,
                            decoration: const BoxDecoration(
                              color: primaryColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        )
                      : const SizedBox(),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.electionData["for"],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.electionData["type"],
                    style: const TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Container(
              height: 1.0,
              width: size.width,
              color: primaryColor,
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(6),
                  2: FlexColumnWidth(1.2),
                },
                children: [
                  const TableRow(
                    children: [
                      TableCell(
                        child: SizedBox(
                          height: 40,
                          child: Text(
                            "Party",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Text(
                          "Candidate",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                      TableCell(
                        child: Text(
                          "Select",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  for (int i = 0;
                      i < widget.electionData["options"].length;
                      i++)
                    customTableRow(
                      widget.electionData["options"][i],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: selected == ""
          ? const SizedBox()
          : isLoading
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 35.0),
                  child: FloatingActionButton(
                    backgroundColor: primaryColor,
                    onPressed: () {},
                    child: const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(bottom: 35.0),
                  child: FloatingActionButton.extended(
                    backgroundColor: primaryColor,
                    onPressed: () {
                      if (!isLoading) {
                        // Update DB
                        setState(() {
                          isLoading = true;
                        });

                        updateDB();
                        // On success go back to home page

                      }
                    },
                    label: Row(
                      children: const [
                        Icon(Icons.check),
                        SizedBox(width: 5),
                        Text('Vote'),
                      ],
                    ),
                  ),
                ),
      bottomSheet: Container(
        width: size.width,
        height: 40,
        color: Colors.white,
        child: Center(
          child: Text(
            "Deadline: ${formatDate(widget.electionData["expireDate"])}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  updateDB() async {
    await DBqueries.updateByVote(widget.electionData["id"], selected);

    navigateToHomeScreen();
  }

  navigateToHomeScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomePage(
          phoneNumber: userdata["contact"],
        ),
      ),
    );
  }
}
