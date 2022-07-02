import 'package:evoting/helpers/globals.dart';
import 'package:evoting/services/DBqueries.dart';
import 'package:evoting/themes/colors.dart';
import 'package:evoting/widgets/electionCard.dart';
import 'package:evoting/widgets/resultCard.dart';
import 'package:flutter/material.dart';

class ResultsPage extends StatefulWidget {
  const ResultsPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  List<Map> elections = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    fetchAllFinsihedElections();
  }

  fetchAllFinsihedElections() async {
    elections = await DBqueries.fetchAllFinishedElections();

    setState(() {
      _loading = false;
    });
  }

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
                    "ELECTION RESULTS",
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
            Expanded(
              child: _loading
                  ? const Padding(
                      padding: EdgeInsets.only(bottom: 100.0),
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(primaryColor),
                        ),
                      ),
                    )
                  : elections.isEmpty
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 70.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  "🙏",
                                  style: TextStyle(
                                    fontSize: 60,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  "No Results",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              for (int i = 0; i < elections.length; i++)
                                ResultCard(electionData: elections[i]),
                              const SizedBox(height: 100),
                            ],
                          ),
                        ),
            )
          ],
        ),
      ),
      floatingActionButton: _loading
          ? const SizedBox()
          : Padding(
              padding: const EdgeInsets.only(bottom: 35.0),
              child: FloatingActionButton.extended(
                backgroundColor: primaryColor,
                onPressed: () {
                  Navigator.pop(context);
                },
                label: Row(
                  children: const [
                    Icon(Icons.chevron_left),
                    SizedBox(width: 5),
                    Text('Go Back'),
                    SizedBox(width: 5),
                  ],
                ),
              ),
            ),
      bottomSheet: Container(
        width: size.width,
        height: 40,
        decoration: const BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20),
          ),
        ),
        child: const Center(
          child: Text(
            "©️ Made with ❤️ in India",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
