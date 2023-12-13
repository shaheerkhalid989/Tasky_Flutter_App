// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:tasky_flutter_app/Service/Auth_service.dart';
// import 'package:tasky_flutter_app/pages/AddTodo.dart';
// import 'package:tasky_flutter_app/pages/homepage.dart';
// import 'package:tasky_flutter_app/pages/onBoardingScreens.dart';
// import 'package:tasky_flutter_app/pages/signin.dart';
// import 'package:tasky_flutter_app/pages/signup.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }

// class MyApp extends StatefulWidget {
//   MyApp({Key? key}) : super(key: key);

//   // This widget is the root of your application.
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   Widget currentPage = SignInPage();
//   AuthClass authClass = AuthClass();

//   @override
//   void initState() {
//     super.initState();
//     checkLogin();
//   }

//   void checkLogin() async {
//     String? token = await authClass.getToken();
//     if (token != null) {
//       setState(() {
//         currentPage = HomePage();
//       });
//     }
//   }

//   // @override
//   // Widget build(BuildContext context) {
//   //   return MaterialApp(
//   //     debugShowCheckedModeBanner: false,
//   //     home: currentPage,
//   //   );
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: OnBoardingScreens(),
//     );
//   }
// }

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tasky_flutter_app/Service/Auth_service.dart';
import 'package:tasky_flutter_app/pages/AddTodo.dart';
import 'package:tasky_flutter_app/pages/homepage.dart';
import 'package:tasky_flutter_app/pages/onBoardingScreens.dart';
import 'package:tasky_flutter_app/pages/signin.dart';
import 'package:tasky_flutter_app/pages/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget currentPage = SignInPage();
  AuthClass authClass = AuthClass();

  @override
  void initState() {
    super.initState();
    checkLogin();
    initDatabase();
  }

  void checkLogin() async {
    String? token = await authClass.getToken();
    if (token != null) {
      setState(() {
        currentPage = HomePage();
      });
    }
  }

  Future<bool> isFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('first_time') ?? true;
    if (isFirstTime) {
      prefs.setBool('first_time', false);
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: isFirstTime(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          if (snapshot.data == true) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: OnBoardingScreens(),
            );
          } else {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: currentPage,
            );
          }
        }
      },
    );
  }

  Future<void> initDatabase() async {
    final Database db = await openDatabase('app.db', version: 2,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE images (id INTEGER PRIMARY KEY, path TEXT, userId TEXT)');
    }, onUpgrade: (Database db, int oldVersion, int newVersion) async {
      if (oldVersion < 2) {
        await db.execute('ALTER TABLE images ADD COLUMN userId TEXT');
      }
    });
    //loadImageFromDatabase(userId);
  }
}
