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

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool _showOTPui = false;
  String _otp = "", _verificationID = "";
  String phoneNumber = "";
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
              title: const Text("Sign In"),
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
                      // Phone Number
                      const SizedBox(height: 30),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(3.0),
                              child: Text(
                                "Enter Your Registered\nPhone Number",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
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
                        "SIGN IN",
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

      bool check = await DBqueries.checkIfUserIsRegistered("$phoneNumber");

      debugPrint(check.toString());
      await auth.signOut();

      if (check) {
        await auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await auth.signInWithCredential(credential).then((value) async {});
          },
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
          msg: "User not found, please register",
          color: Colors.red,
          positionFromBottom: 100,
        );
      }
    } catch (e) {
      commonToast(
        context: context,
        msg: e.toString(),
        color: Colors.red,
        positionFromBottom: 100,
      );
    }
  }

  void verifyOTP() async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationID, smsCode: _otp);

      usercreds =
          await auth.signInWithCredential(credential).then((value) async {
        commonToast(
          context: context,
          msg: "Signed In Successfully",
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
