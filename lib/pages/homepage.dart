import 'package:evoting/helpers/globals.dart';
import 'package:evoting/pages/results.dart';
import 'package:evoting/services/DBqueries.dart';
import 'package:evoting/themes/colors.dart';
import 'package:evoting/widgets/electionCard.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String phoneNumber;

  const HomePage({
    Key? key,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map> elections = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    fetchAllOnGoingElections();
  }

  fetchAllOnGoingElections() async {
    userdata = await DBqueries.getUserData(widget.phoneNumber);
    elections = await DBqueries.fetchAllOnGoingElections();

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
                    "VOTE INDIA APP",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Click on the cards to see the respective candidates and click \"VOTE\"",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
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
                                  "No Ongoing Elections",
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
                                ElectionCard(electionData: elections[i]),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ResultsPage(),
                    ),
                  );
                },
                label: Row(
                  children: const [
                    Icon(Icons.analytics_rounded),
                    SizedBox(width: 5),
                    Text('Results'),
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
