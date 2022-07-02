import 'package:evoting/themes/colors.dart';
import 'package:evoting/widgets/primaryButton.dart';
import 'package:flutter/material.dart';

class OTPUIPage extends StatefulWidget {
  final Function(String) onSubmit;
  final Function onPop;
  final String phoneNumber;
  const OTPUIPage({
    Key? key,
    required this.onSubmit,
    required this.onPop,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  _OTPUIPageState createState() => _OTPUIPageState();
}

class _OTPUIPageState extends State<OTPUIPage> {
  final TextEditingController _fieldOne = TextEditingController();
  final TextEditingController _fieldTwo = TextEditingController();
  final TextEditingController _fieldThree = TextEditingController();
  final TextEditingController _fieldFour = TextEditingController();
  final TextEditingController _fieldFive = TextEditingController();
  final TextEditingController _fieldSix = TextEditingController();

  String? _otp;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return widget.onPop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('OTP Verification'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Please enter OTP',
              style: const TextStyle(fontSize: 30),
            ),
            const SizedBox(
              height: 50,
            ),
            Text(
              'An OTP has been sent to \n${widget.phoneNumber}',
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OtpInput(_fieldOne, true),
                OtpInput(_fieldTwo, false),
                OtpInput(_fieldThree, false),
                OtpInput(_fieldFour, false),
                OtpInput(_fieldFive, false),
                OtpInput(_fieldSix, false)
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: PrimaryButton(
                isDisabled: _isLoading,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                    : const Text(
                        "SUBMIT",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _otp = _fieldOne.text +
                        _fieldTwo.text +
                        _fieldThree.text +
                        _fieldFour.text +
                        _fieldFive.text +
                        _fieldSix.text;
                  });
                  widget.onSubmit(_otp ?? "");
                },
              ),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}

class OtpInput extends StatelessWidget {
  final TextEditingController controller;
  final bool autoFocus;
  const OtpInput(this.controller, this.autoFocus, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: 60,
      width: size.width / 9,
      child: TextField(
        autofocus: autoFocus,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        controller: controller,
        maxLength: 1,
        cursorColor: Theme.of(context).primaryColor,
        decoration: const InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: primaryColor,
                width: 2.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
              ),
            ),
            counterText: '',
            hintStyle: TextStyle(color: Colors.black, fontSize: 20.0)),
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }
}
