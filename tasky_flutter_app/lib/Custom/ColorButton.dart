import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tasky_flutter_app/pages/homepage.dart';

Widget colorButtonSignUP(
    BuildContext context,
    bool circular,
    FirebaseAuth firebaseAuth,
    TextEditingController emailController,
    TextEditingController passwordController,
    Function setState) {
  return InkWell(
    onTap: () async {
      setState(() {
        circular = true;
      });
      try {
        UserCredential userCredential =
            await firebaseAuth.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        print(userCredential.user!.email);
        setState(() {
          circular = false;
        });
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (builder) => HomePage()),
          (route) => false,
        );
      } catch (e) {
        final snackBar = SnackBar(content: Text(e.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        setState(() {
          circular = false;
        });
      }
    },
    splashColor: Colors.white.withOpacity(0.1), // Customize splash color here
    child: Container(
      width: MediaQuery.of(context).size.width - 110,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Color(0xFF800080),
      ),
      child: Center(
        child: circular
            ? CircularProgressIndicator()
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.person_add,
                      color: Colors.white), // Replace with your signin logo
                  SizedBox(
                      width: 10), // Add some spacing between the icon and text
                  Text(
                    "Sign Up",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    ),
  );
}

Widget colorButtonSignIn(
    BuildContext context,
    bool circular,
    FirebaseAuth firebaseAuth,
    TextEditingController emailController,
    TextEditingController passwordController,
    Function setState) {
  return InkWell(
    onTap: () async {
      setState(() {
        circular = true;
      });
      try {
        UserCredential userCredential =
            await firebaseAuth.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        print(userCredential.user!.email);
        setState(() {
          circular = false;
        });
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (builder) => HomePage()),
          (route) => false,
        );
      } catch (e) {
        final snackBar = SnackBar(content: Text(e.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        setState(() {
          circular = false;
        });
      }
    },
    splashColor: Colors.white.withOpacity(0.1), // Customize splash color here
    child: Container(
      width: MediaQuery.of(context).size.width - 110,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Color(0xFF800080),
      ),
      child: Center(
        child: circular
            ? CircularProgressIndicator()
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.login,
                      color: Colors.white), // Replace with your signin logo
                  SizedBox(
                      width: 10), // Add some spacing between the icon and text
                  Text(
                    "Sign In",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    ),
  );
}