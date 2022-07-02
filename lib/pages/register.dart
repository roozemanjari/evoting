import 'package:evoting/helpers/commonToast.dart';
import 'package:evoting/helpers/functions.dart';
import 'package:evoting/helpers/globals.dart';
import 'package:evoting/pages/homepage.dart';
import 'package:evoting/pages/otpPage.dart';
import 'package:evoting/services/DBqueries.dart';
import 'package:evoting/themes/colors.dart';
import 'package:evoting/widgets/customTextFormField.dart';
import 'package:evoting/widgets/primaryButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool _showOTPui = false;
  String _otp = "", _verificationID = "";
  String phoneNumber = "", name = "", aadhar = "";
  int age = -1;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return _showOTPui
        ? OTPUIPage(
            phoneNumber: phoneNumber,
            onPop: () {
              setState(() {
                _showOTPui = false;
              });
            },
            onSubmit: (otp) {
              _otp = otp;
              verifyOTP();
            },
          )
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: const Text("Registration Form"),
            ),
            body: Container(
              color: secondaryColor,
              width: size.width,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formkey,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(height: 30),

                      // Aadhar
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              " Full Name*",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 10),
                            CustomFormField(
                              hintText: "Your Name",
                              onChanged: (val) {
                                name = val;
                              },
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return "Field Mandatory";
                                }
                              },
                            ),
                          ],
                        ),
                      ),

                      // Aadhar
                      const SizedBox(height: 30),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              " Aadhar Number*",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 10),
                            CustomFormField(
                              textInputType: TextInputType.number,
                              hintText: "Enter your 12 digit Aadhar No.",
                              onChanged: (val) {
                                aadhar = val;
                              },
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return "Field Mandatory";
                                } else if (val.length != 12 ||
                                    !isNumeric(val)) {
                                  return "Invalid Aadhar Number";
                                }
                              },
                            ),
                          ],
                        ),
                      ),

                      // Phone Number
                      const SizedBox(height: 30),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              " Phone Number*",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 10),
                            CustomFormField(
                              textInputType: TextInputType.number,
                              hintText: "Enter your 10 digit Phone No.",
                              onChanged: (val) {
                                phoneNumber = '+91 $val';
                              },
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return "Field Mandatory";
                                } else if (val.length != 10 ||
                                    !isNumeric(val)) {
                                  return "Invalid Phone Number";
                                }
                              },
                            ),
                          ],
                        ),
                      ),

                      // Phone Number
                      const SizedBox(height: 30),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              " Age*",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 10),
                            CustomFormField(
                              textInputType: TextInputType.number,
                              hintText: "Enter your age",
                              onChanged: (val) {
                                age = int.parse(val);
                              },
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return "Field Mandatory";
                                } else if (!isNumeric(val)) {
                                  return "Invalid Age";
                                }
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ),
            bottomSheet: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: PrimaryButton(
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                    : const Text(
                        "VERIFY",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                onPressed: () {
                  formValidator();
                },
              ),
            ),
          );
  }

  formValidator() async {
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();
      // Proceed to Firebase
      print("Validated");
      // Send OTP
      verifyPhone();
    }
  }

  verifyPhone() async {
    setState(() {
      _isLoading = true;
    });
    try {
      // Check if this is a new user;
      UserCredential tempuser = await auth.signInAnonymously();

      bool check = await DBqueries.checkIfUserIsNew(phoneNumber, aadhar);

      await auth.signOut();

      if (check) {
        await auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {},
          verificationFailed: (FirebaseAuthException e) {
            // Show toast
            debugPrint(e.message);
          },
          codeSent: (String verificationId, int? resendToken) {
            debugPrint("Code sent");
            _verificationID = verificationId;
            setState(() {
              _showOTPui = true;
            });
            // SHOW OTP UI
          },
          codeAutoRetrievalTimeout: (String verificationId) {},
        );
      } else {
        // SHOW ACCOUNT ALREADY EXISTS
        setState(() {
          _isLoading = false;
        });
        commonToast(
          context: context,
          msg: "Account Already Exists",
          color: Colors.red,
          positionFromBottom: 100,
        );
      }
    } catch (e) {
      print(e);
    }
  }

  void verifyOTP() async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationID, smsCode: _otp);

      await DBqueries.updateDBWithNewUser(phoneNumber, name, aadhar, age);

      usercreds = await auth.signInWithCredential(credential).then((value) {
        commonToast(
          context: context,
          msg: "Registered Successfully",
          positionFromBottom: 100,
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomePage(phoneNumber: phoneNumber),
          ),
        );
      });
    } catch (e) {
      // SHOW ERROR MESSAGE
      setState(() {
        _showOTPui = false;
      });
    }
  }
}
