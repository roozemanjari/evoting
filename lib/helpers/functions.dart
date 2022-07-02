import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evoting/helpers/globals.dart';
import 'package:intl/intl.dart';

// CHECK WHO USER HAS VOTED
String checkWhoUserHasVoted(List votes) {
  String result = "NA";

  var itr = votes.where((element) => element["aadhar"] == userdata["aadhar"]);
  if (itr.length != 0) {
    result = itr.first["selected"];
  }
  return result;
}

String findWhoWon(List options) {
  String result = "NA";
  print(options[0]["votes"]);
  options.sort(
    ((a, b) => int.parse(a["votes"].toString()).compareTo(
          int.parse(b["votes"].toString()),
        )),
  );
  result = options[options.length - 1]["candidate"];
  return result;
}

// FORMAT DATE
formatDate(Timestamp date) {
  return DateFormat("d MMM yyyy - h:mm a").format(date.toDate());
}

// CHECKS IF STRING IS A NUMBER OR NOT
bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}
