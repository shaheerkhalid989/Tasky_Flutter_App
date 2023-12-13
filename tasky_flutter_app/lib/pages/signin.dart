import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:tasky_flutter_app/Service/Auth_service.dart';
import 'package:tasky_flutter_app/pages/PhoneAuthPage.dart';
import 'package:tasky_flutter_app/pages/homepage.dart';
import 'package:tasky_flutter_app/pages/signup.dart';
import 'package:tasky_flutter_app/Custom/TextItem.dart';
import 'package:tasky_flutter_app/Custom/ButtonItem.dart';
import 'package:tasky_flutter_app/Custom/ColorButton.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPage createState() => _SignInPage();
}

class _SignInPage extends State<SignInPage> {
  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool circular = false;
  AuthClass authClass = AuthClass();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff1d1e26),
              Color(0xff252041),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Text(
              //   "Sign In",
              //   style: TextStyle(
              //     color: Colors.white,
              //     fontSize: 35,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              // SizedBox(
              //   height: 20,
              // ),
              SizedBox(
                height: 70,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(
                    85), // Half of the width/height for a perfect circle
                child: Image.asset(
                  'assets/login-hand.png',
                  width: 220, // Adjust the width as needed
                  height: 220, // Adjust the height as needed
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              buttonItem(
                  context, "assets/google.svg", "Continue with Google", 30,
                  () async {
                await authClass.googleSignIn(context);
              }),
              SizedBox(
                height: 20,
              ),
              buttonItem(context, "assets/phone.svg", "Continue with Phone", 30,
                  () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (builder) => PhoneAuthPage()));
              }),
              SizedBox(
                height: 12,
              ),
              Text("OR",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  )),
              SizedBox(
                height: 12,
              ),
              textItem(context, "Email", emailController, false),
              SizedBox(
                height: 15,
              ),
              textItem(context, "Password", passwordController, true),
              SizedBox(
                height: 15,
              ),
              colorButtonSignIn(context, circular, firebaseAuth,
                  emailController, passwordController, setState),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (builder) => SignUpPage()),
                          (route) => false);
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Color(0xFFDAA520),
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Forget Password?",
                style: TextStyle(
                  color: Color(0xFFDAA520),
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 70,
              ),
            ],
          ),
        ),
      ),
    ));
  }

  // Widget buttonItem(
  //     String btnSVG, String btnText, double size, Function onTap) {
  //   return InkWell(
  //     onTap: onTap as void Function()?,
  //     child: Container(
  //       width: MediaQuery.of(context).size.width - 60,
  //       height: 60,
  //       child: Card(
  //         color: Colors.black,
  //         elevation: 8,
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(15),
  //           side: BorderSide(width: 1, color: Colors.grey),
  //         ),
  //         child: DecoratedBox(
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(15),
  //             gradient: LinearGradient(
  //               colors: [
  //                 Color(0xFF123456),
  //                 Color(0xFF789abc)
  //               ], // Replace with your gradient colors
  //               begin: Alignment.centerLeft,
  //               end: Alignment.centerRight,
  //             ),
  //           ),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               SvgPicture.asset(
  //                 btnSVG,
  //                 height: size,
  //                 width: size,
  //               ),
  //               SizedBox(
  //                 width: 15,
  //               ),
  //               Text(
  //                 btnText,
  //                 style: TextStyle(color: Colors.grey.shade300, fontSize: 18),
  //               )
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget textItem(
  //     String labelText, TextEditingController controller, bool obscureText) {
  //   return Container(
  //     width: MediaQuery.of(context).size.width - 70,
  //     height: 55,
  //     child: TextFormField(
  //       controller: controller,
  //       obscureText: obscureText,
  //       style: TextStyle(
  //         color: Colors.white,
  //         fontSize: 17,
  //       ),
  //       decoration: InputDecoration(
  //         labelText: labelText,
  //         labelStyle: TextStyle(
  //           fontSize: 17,
  //           color: Colors.white,
  //         ),
  //         focusedBorder: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(15),
  //           borderSide: BorderSide(
  //             color: Colors.amber,
  //             width: 1.5,
  //           ),
  //         ),
  //         enabledBorder: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(15),
  //           borderSide: BorderSide(
  //             color: Colors.white,
  //             width: 1,
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget colorButton() {
  //   return InkWell(
  //     onTap: () async {
  //       setState(() {
  //         circular = true;
  //       });
  //       try {
  //         firebase_auth.UserCredential userCredential =
  //             await firebaseAuth.signInWithEmailAndPassword(
  //                 email: emailController.text,
  //                 password: passwordController.text);
  //         print(userCredential.user!.email);
  //         setState(() {
  //           circular = false;
  //         });
  //         Navigator.pushAndRemoveUntil(
  //             context,
  //             MaterialPageRoute(builder: (builder) => HomePage()),
  //             (route) => false);
  //       } catch (e) {
  //         final snackBar = SnackBar(content: Text(e.toString()));
  //         ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //         setState(() {
  //           circular = false;
  //         });
  //       }
  //     },
  //     child: Container(
  //       width: MediaQuery.of(context).size.width - 110,
  //       height: 60,
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(50),
  //         color: Color(0xFF800080),
  //       ),
  //       child: Center(
  //         child: circular
  //             ? CircularProgressIndicator()
  //             : Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: <Widget>[
  //                   Icon(Icons.login,
  //                       color: Colors.white), // Replace with your signin logo
  //                   SizedBox(
  //                       width:
  //                           10), // Add some spacing between the icon and text
  //                   Text(
  //                     "Sign In",
  //                     style: TextStyle(
  //                       color: Colors.white,
  //                       fontSize: 20,
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //       ),
  //     ),
  //   );
  // }
}
