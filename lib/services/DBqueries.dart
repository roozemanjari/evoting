import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evoting/helpers/globals.dart';
import 'package:flutter/cupertino.dart';

class DBqueries {
  static Future<bool> checkIfUserIsNew(
      String phoneNumber, String aadhar) async {
    final contactRef = FirebaseFirestore.instance
        .collection("voters")
        .where("contact", isEqualTo: phoneNumber);

    final aadharRef = FirebaseFirestore.instance
        .collection("voters")
        .where("aadhar", isEqualTo: aadhar);

    final contactDocs = await contactRef.get();
    final aadharDocs = await aadharRef.get();

    if (contactDocs.docs.isEmpty && aadharDocs.docs.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> checkIfUserIsRegistered(String phoneNumber) async {
    print(phoneNumber);
    final contactRef = FirebaseFirestore.instance
        .collection("voters")
        .where("contact", isEqualTo: phoneNumber);

    final contactDocs = await contactRef.get();

    if (contactDocs.docs.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  static updateDBWithNewUser(
      String phoneNumber, String name, String aadhar, int age) async {
    Map<String, dynamic> data = {
      "aadhar": aadhar,
      "contact": phoneNumber,
      "name": name,
      "age": age
    };

    final ref = FirebaseFirestore.instance.collection("voters").doc();

    await ref.set(data);
  }

  static Future<Map<String, dynamic>> getUserData(String phoneNumber) async {
    final contactRef = FirebaseFirestore.instance
        .collection("voters")
        .where("contact", isEqualTo: phoneNumber);

    final contactDocs = await contactRef.get();

    return contactDocs.docs.first.data();
  }

  static Future<List<Map<String, dynamic>>> fetchAllOnGoingElections() async {
    List<Map<String, dynamic>> result = [];

    final ref = FirebaseFirestore.instance.collection("elections").where(
          "expireDate",
          isGreaterThan: DateTime.now(),
        );
    final data = await ref.get();

    data.docs.forEach((element) {
      result.add(element.data());
    });

    return result;
  }

  static Future<List<Map<String, dynamic>>> fetchAllFinishedElections() async {
    List<Map<String, dynamic>> result = [];

    final ref = FirebaseFirestore.instance.collection("elections").where(
          "expireDate",
          isLessThan: DateTime.now(),
        );
    final data = await ref.get();

    data.docs.forEach((element) {
      result.add(element.data());
    });

    return result;
  }

  static updateByVote(String id, String selected) async {
    Map votesData = {
      "aadhar": "${userdata['aadhar']}",
      "selected": selected,
    };

    final ref = FirebaseFirestore.instance.collection("elections").where(
          "id",
          isEqualTo: id,
        );
    final result = await ref.get();

    Map data = result.docs.first.data();
    String dockey = result.docs.first.id;

    List options = data["options"];
    int index =
        options.indexWhere((element) => element["candidate"] == selected);
    options[index]["votes"]++;

    FirebaseFirestore.instance.collection("elections").doc(dockey).update(
      {
        "votes": FieldValue.arrayUnion([votesData]),
        "options": options,
      },
    );
  }
}
