import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tasky_flutter_app/pages/PhoneAuthPage.dart';
import 'package:tasky_flutter_app/pages/homepage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthClass {
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  FirebaseAuth auth = FirebaseAuth.instance;
  final storage = new FlutterSecureStorage();

  Future<void> googleSignIn(BuildContext context) async {
    try {
      GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );

        try {
          UserCredential userCredential =
              await auth.signInWithCredential(credential);
          storeTokenAndData(userCredential);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (builder) => HomePage()),
              (route) => false);
        } catch (e) {
          final snackBar = SnackBar(content: Text(e.toString()));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } else {
        final snackBar = SnackBar(content: Text("Not able to sign in"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      final snackBar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> storeTokenAndData(UserCredential userCredential) async {
    await storage.write(
        key: "token", value: userCredential.credential!.token.toString());
    await storage.write(
        key: "userCredential", value: userCredential.toString());
  }

  Future<String?> getToken() async {
    return await storage.read(key: "token");
  }

  Future<void> logout() async {
    try {
      await _googleSignIn.signOut();
      await auth.signOut();
      await storage.delete(key: "token");
    } catch (e) {
      print("error");
    }
  }

  Future<bool> verifyPhoneNumber(
      String phoneNumber, BuildContext context, Function setData) async {
    Completer<bool> verificationCompleter = Completer<bool>();

    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      showSnackBar(context, "Verification Completed");
      verificationCompleter.complete(true);
    };

    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException firebaseAuthException) {
      showSnackBar(context, firebaseAuthException.message!);
      verificationCompleter.complete(false);
    };

    PhoneCodeSent codeSent =
        (String verificationId, [int? forceResendingToken]) async {
      showSnackBar(context, "Verification Code Sent on the Phone Number");
      setData(verificationId);
    };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      showSnackBar(context, "Time out");
      verificationCompleter.complete(false);
    };

    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );
    } catch (e) {
      showSnackBar(context, e.toString());
      verificationCompleter.complete(false);
    }

    return verificationCompleter.future;
  }

  void showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> signInWithPhoneNumber(
      String verificationId, String smsCode, BuildContext context) async {
    if (smsCode.length == 0) {
      showSnackBar(context, "Please enter the verification code");
      return;
    }
    try {
      AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);

      UserCredential userCredential =
          await auth.signInWithCredential(credential);
      storeTokenAndData(userCredential);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (builder) => HomePage()),
          (route) => false);
      showSnackBar(context, "Successfully signed in");
    } catch (e) {
      showSnackBar(context, "The sms verification code is wrong");
    }
  }

  //============================================================================

  Future<void> signInWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      storeTokenAndData(userCredential);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (builder) => HomePage()),
          (route) => false);
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> signUpWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      storeTokenAndData(userCredential);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (builder) => HomePage()),
          (route) => false);
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> resetPassword(String email, BuildContext context) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      showSnackBar(context, "Reset password link has sent your mail");
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
  }

  Future<bool> isLoggedIn() async {
    User? user = await auth.currentUser;
    return user != null;
  }

  Future<User?> getUser() async {
    return await auth.currentUser;
  }

  Future<String?> getUserEmail() async {
    return (await auth.currentUser)!.email;
  }

  Future<String?> getUserUid() async {
    return (await auth.currentUser)!.uid;
  }

  Future<String?> getUserDisplayName() async {
    return (await auth.currentUser)!.displayName;
  }

  Future<String?> getUserPhotoUrl() async {
    return (await auth.currentUser)!.photoURL;
  }

  Future<String?> getUserPhoneNumber() async {
    return (await auth.currentUser)!.phoneNumber;
  }

  Future<bool> isEmailVerified() async {
    return (await auth.currentUser)!.emailVerified;
  }

  Future<void> sendEmailVerification() async {
    await (await auth.currentUser)!.sendEmailVerification();
  }

  Future<void> reloadUser() async {
    await (await auth.currentUser)!.reload();
  }

  Future<void> updateProfile(
      {String? displayName, String? photoUrl, BuildContext? context}) async {
    User? user = await auth.currentUser;
    if (displayName != null) {
      await user!.updateDisplayName(displayName);
    }
    if (photoUrl != null) {
      await user!.updatePhotoURL(photoUrl);
    }
    if (context != null) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (builder) => HomePage()),
          (route) => false);
    }
  }

  Future<void> updateEmail({String? email, BuildContext? context}) async {
    User? user = await auth.currentUser;
    if (email != null) {
      await user!.updateEmail(email);
    }
    if (context != null) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (builder) => HomePage()),
          (route) => false);
    }
  }

  Future<void> updatePassword({String? password, BuildContext? context}) async {
    User? user = await auth.currentUser;
    if (password != null) {
      await user!.updatePassword(password);
    }
    if (context != null) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (builder) => HomePage()),
          (route) => false);
    }
  }

  Future<void> deleteUser() async {
    User? user = await auth.currentUser;
    await user!.delete();
  }

  Future<void> reauthenticateWithCredential(AuthCredential credential) async {
    User? user = await auth.currentUser;
    await user!.reauthenticateWithCredential(credential);
  }

  Future<void> reauthenticateWithPhoneNumber(
      String verificationId, String smsCode) async {
    AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);
    await reauthenticateWithCredential(credential);
  }

  Future<void> reauthenticateWithEmailAndPassword(
      String email, String password) async {
    AuthCredential credential =
        EmailAuthProvider.credential(email: email, password: password);
    await reauthenticateWithCredential(credential);
  }

  Future<void> reauthenticateWithGoogle(BuildContext context) async {
    GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
    if (googleSignInAccount != null) {
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);
      await reauthenticateWithCredential(credential);
    } else {
      showSnackBar(context, "Not able to sign in");
    }
  }
}
