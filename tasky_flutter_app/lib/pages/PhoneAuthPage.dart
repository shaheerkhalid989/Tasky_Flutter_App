import "dart:async";
import 'package:flutter/widgets.dart';
import "package:flutter/material.dart";
import "package:otp_text_field/otp_field.dart";
import "package:otp_text_field/otp_field_style.dart";
import "package:otp_text_field/style.dart";
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import "package:tasky_flutter_app/Service/Auth_service.dart";

class PhoneAuthPage extends StatefulWidget {
  const PhoneAuthPage({Key? key}) : super(key: key);

  @override
  _PhoneAuthPage createState() => _PhoneAuthPage();
}

class _PhoneAuthPage extends State<PhoneAuthPage> with WidgetsBindingObserver {
  int start = 30;
  bool wait = false;
  bool wait2 = true;
  String buttonName = "Send OTP";
  TextEditingController phoneController = TextEditingController();
  AuthClass authClass = AuthClass();
  String verificationIdFinal = "";
  String smsCode = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      // The app is being paused (e.g., closed or backgrounded)
      // Log out the user here
      AuthClass().logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              Icons.phone,
              color: Colors.white,
              size: 30,
            ),
            SizedBox(width: 10), // Adjust the spacing as needed
            Text(
              "Phone Verification",
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xff1d1e26),
                Color(0xff252041)
              ], // Replace with your gradient colors
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff1d1e26),
              Color(0xff252041),
            ],
          ),
        ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
            child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(
                  85), // Half of the width/height for a perfect circle
              child: Image.asset(
                'assets/icon1-removebg-preview.png',
                width: 220, // Adjust the width as needed
                height: 220, // Adjust the height as needed
                fit: BoxFit.fill,
              ),
            ),
            textField2(),
            SizedBox(
              height: 20,
            ),
            Container(
                width: MediaQuery.of(context).size.width - 34,
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.white,
                        thickness: 1,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Enter 6 Digit OTP",
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.white,
                        thickness: 1,
                      ),
                    ),
                  ],
                )),
            SizedBox(
              height: 20,
            ),
            otpField(),
            SizedBox(
              height: 20,
            ),
            wait
                ? RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: "Send OTP again in ",
                        style: TextStyle(
                          color: Color(0xFFDAA520),
                          fontSize: 16,
                        ),
                      ),
                      TextSpan(
                        text: "00:$start",
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 16,
                        ),
                      ),
                      TextSpan(
                        text: " seconds",
                        style: TextStyle(
                          color: Color(0xFFDAA520),
                          fontSize: 16,
                        ),
                      ),
                    ]),
                  )
                : Container(),
            SizedBox(
              height: 20,
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Color(0xFFDAA520), width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              onPressed: !wait
                  ? null
                  : () {
                      if (start > 0) {
                        authClass.signInWithPhoneNumber(
                            verificationIdFinal, smsCode, context);
                      }
                      // Handle button press
                    },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 100,
                ),
                child: Text(
                  "Let's go",
                  style: TextStyle(
                    color: Color(0xFFDAA520),
                    fontSize: 20,
                  ),
                ),
              ),
            )
          ],
        )),
      ),
    );
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    Timer timer = Timer.periodic(oneSec, (timer) {
      if (start == 0) {
        setState(() {
          timer.cancel();
          wait = false;
        });
      } else {
        setState(() {
          start--;
        });
      }
    });
  }

  Widget otpField() {
    return OTPTextField(
      length: 6,
      width: MediaQuery.of(context).size.width - 34,
      fieldWidth: 58,
      otpFieldStyle: OtpFieldStyle(
        backgroundColor: Color(0xff3d3d3d),
        borderColor: Colors.white,
        //borderRadius: BorderRadius.circular(12.0), // Set the border radius
      ),
      style: TextStyle(fontSize: 17, color: Colors.white),
      textFieldAlignment: MainAxisAlignment.spaceAround,
      fieldStyle: FieldStyle.underline,
      onCompleted: (pin) {
        print("Completed: " + pin);
        setState(() {
          smsCode = pin;
        });
      },
    );
  }

  Widget textField2() {
    String cCode = "";
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18),
      child: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.white),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    // IntlPhoneField
                    IntlPhoneField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        labelStyle: TextStyle(color: Colors.white),
                        hintStyle: TextStyle(color: Colors.white),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      initialCountryCode: 'PK',

                      //cursorColor: Colors.white,
                      style: TextStyle(color: Colors.white),
                      onChanged: (phone) {
                        //phoneController.text = phone.completeNumber;
                        cCode = phone.countryCode;
                        print(phone.completeNumber);
                      },
                    ),
                    SizedBox(
                        height:
                            2), // Add some spacing between the phone field and the button
                    // "Send OTP" button
                    ElevatedButton(
                      onPressed: wait
                          ? null
                          : () async {
                              // Add functionality to send OTP
                              //startTimer();
                              if (phoneController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Please enter a phone number')));
                                return;
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('Verifying Phone Number...')));
                              setState(() {
                                start = 30;
                                wait = true;
                                buttonName = "Resend OTP";
                              });
                              wait = await authClass.verifyPhoneNumber(
                                  cCode + phoneController.text,
                                  context,
                                  setData);
                              print(cCode + phoneController.text);
                              print(wait);
                            },
                      style: ElevatedButton.styleFrom(
                        primary: wait
                            ? Colors.purple.shade200
                            : Color(0xFF800080), // Set button color to purple
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              8.0), // Set button border radius
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        child: Text(
                          buttonName,
                          style: TextStyle(
                            color: Colors.white,
                            //fontSize: 18.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void setData(String verificationId) {
    setState(() {
      verificationIdFinal = verificationId;
    });
    startTimer();
  }
}
