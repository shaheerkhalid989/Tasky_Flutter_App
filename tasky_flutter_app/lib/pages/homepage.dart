import 'dart:io';

import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tasky_flutter_app/Custom/TaskCard.dart';
import 'package:tasky_flutter_app/Service/Auth_service.dart';
import 'package:tasky_flutter_app/pages/AddTodo.dart';
//import 'package:tasky_flutter_app/pages/profile.dart';
import 'package:tasky_flutter_app/pages/prof.dart';
import 'package:tasky_flutter_app/pages/signin.dart';
import 'package:tasky_flutter_app/pages/view_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  AuthClass authClass = AuthClass();
  String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

  Stream<QuerySnapshot>? _stream;

  DateTime selectedDate = DateTime.now();
  String dateString = DateFormat('yyyy-MM-dd').format(DateTime.now());

  List<select> selected = [];
  bool isAnySelected = false;

  @override
  void initState() {
    super.initState();
    getTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            //SizedBox(width: 10), // Adjust the spacing as needed
            Text(
              "Your Schedule For",
              style: TextStyle(
                color: Colors.white,
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          // SizedBox(
          //   width: 15,
          // ),
          FutureBuilder<String>(
            future:
                loadImageFromDatabase(userId), // Load image path from database
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(); // Show loading indicator while waiting
              } else {
                return CircleAvatar(
                  backgroundColor: Colors.white,
                  child: ClipOval(
                    child: Image(
                      image: snapshot.data!.startsWith('http')
                          ? NetworkImage(snapshot.data!) // Load network image
                          : FileImage(File(snapshot.data! as String))
                              as ImageProvider<Object>,
                      fit: BoxFit
                          .contain, // Use this to control how the image fits
                      width: 35,
                      height: 50,
                    ),
                  ),
                );
              }
            },
          ),
          SizedBox(
            width: 15,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(35),
          child: Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TextButton(
                onPressed: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2025),
                  );
                  if (picked != null && picked != selectedDate)
                    setState(() {
                      selectedDate = picked;
                      dateString =
                          DateFormat('yyyy-MM-dd').format(selectedDate);
                      getTasks();
                      //print(selectedDate);
                    });
                },
                child: Text(
                  DateFormat('EEEE, d MMMM yyyy').format(selectedDate),
                  style: TextStyle(
                    color: Color(0xFFDAA520),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff1d1e26),
              Color(0xff252041),
            ],
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          unselectedItemColor: Colors.white,
          selectedItemColor: Colors.white,
          items: [
            BottomNavigationBarItem(
              icon: InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => HomePage(),
                    ),
                  );
                },
                child: Icon(
                  Icons.home,
                  size: 32,
                  color: Colors.white,
                ),
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (builder) => AddTodo()));
                },
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.teal,
                        Colors.amber,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.add,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
              ),
              label: "Add",
            ),
            BottomNavigationBarItem(
              icon: InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (builder) => Profile()));
                },
                child: Icon(
                  Icons.settings,
                  size: 32,
                  color: Colors.white,
                ),
              ),
              label: "Settings",
            ),
          ],
        ),
      ),
      body: mainBody(),
      floatingActionButton: isAnySelected
          ? FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      backgroundColor:
                          Colors.white.withOpacity(0.9), // Set the opacity
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(20), // Set the corner radius
                      ),
                      child: Container(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text('Confirm Delete',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            SizedBox(height: 20),
                            Text(
                                'Are you sure you want to delete selected item?'),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                TextButton(
                                  child: Text('Cancel'),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Dismiss the dialog
                                  },
                                ),
                                TextButton(
                                  child: Text('Delete'),
                                  onPressed: () async {
                                    var instance = FirebaseFirestore.instance
                                        .collection("Task");
                                    List<select> selectedCopy =
                                        List<select>.from(selected);
                                    Navigator.pop(context);
                                    for (int i = 0;
                                        i < selectedCopy.length;
                                        i++) {
                                      if (selectedCopy[i].checkValue) {
                                        await instance
                                            .doc(selectedCopy[i].id)
                                            .delete();
                                        selected.removeWhere((item) =>
                                            item.id == selectedCopy[i].id);
                                      }
                                    }
                                    setState(() {
                                      isAnySelected =
                                          false; // Hide the FloatingActionButton
                                    }); // Dismiss the dialog
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              child: Icon(Icons.delete),
            )
          : null,
    );
  }

  Widget mainBody() {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height - 130,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff1d1e26),
              Color(0xff252041),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            StreamBuilder(
              stream: _stream,
              builder: (context, snapshot) {
                if (_stream == null ||
                    snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      CircularProgressIndicator(
                        color: Colors.amber,
                      ),
                    ],
                  ));
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        Text(
                          "No Task Scheduled",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index) {
                        IconData iconData;
                        Color iconColor;

                        Map<String, dynamic> document =
                            snapshot.data!.docs[index].data()
                                as Map<String, dynamic>;
                        switch (document["category"]) {
                          case "Work":
                            iconData = Icons.work;
                            iconColor = Colors.blue;
                            break;
                          case "Home":
                            iconData = Icons.home;
                            iconColor = Colors.orange;
                            break;
                          case "Food":
                            iconData = Icons.fastfood;
                            iconColor = Colors.red;
                            break;
                          case "Study":
                            iconData = Icons.book;
                            iconColor = Colors.green;
                            break;
                          case "Workout":
                            iconData = Icons.fitness_center;
                            iconColor = Colors.blue;
                            break;
                          case "Game":
                            iconData = Icons.gamepad;
                            iconColor = Colors.orange;
                            break;
                          case "Family":
                            iconData = Icons.family_restroom;
                            iconColor = Colors.red.shade300;
                            break;
                          case "Personal":
                            iconData = Icons.person;
                            iconColor = Colors.red;
                            break;
                          case "Shopping":
                            iconData = Icons.shopping_cart;
                            iconColor = Colors.green;
                            break;
                          case "Others":
                            iconData = Icons.design_services;
                            iconColor = Colors.black;
                            break;
                          default:
                            iconData = Icons.design_services;
                            iconColor = Colors.black;
                            break;
                        }
                        selected.add(select(
                            id: snapshot.data!.docs[index].id,
                            checkValue: false));
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (builder) => ViewData(
                                  document: document,
                                  id: snapshot.data!.docs[index].id,
                                ),
                              ),
                            );
                          },
                          child: TaskCard(
                            title: document["title"],
                            time: document["time"],
                            icon: iconData,
                            iconColor: iconColor,
                            check: selected[index].checkValue,
                            iconBgColor: Colors.white,
                            index: index,
                            onChange: onChange,
                            done: document["done"] ?? false,
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
            // SizedBox(height: 0),
          ],
        ),
      ),
    );
  }

  void onChange(int index) {
    setState(() {
      selected[index].checkValue = !selected[index].checkValue;
      isAnySelected = selected.any((item) => item.checkValue);
    });
  }

  Stream<QuerySnapshot> getTaskStream(String userId, String dateString) {
    return FirebaseFirestore.instance
        .collection("Task")
        .where("userId", isEqualTo: userId)
        .where('date', isEqualTo: dateString)
        .snapshots();
  }

  void getTasks() {
    if (userId.isNotEmpty) {
      _stream = getTaskStream(userId, dateString);
      _stream?.listen((QuerySnapshot snapshot) {
        selected = snapshot.docs
            .map((doc) => select(id: doc.id, checkValue: false))
            .toList();
      });
    }
  }

  Future<String> loadImageFromDatabase(String userId) async {
    final Database db = await openDatabase('app.db', version: 1);
    final List<Map<String, dynamic>> maps =
        await db.query('images', where: 'userId = ?', whereArgs: [userId]);
    if (maps.isNotEmpty) {
      final File imageFile = File(maps.first['path']);
      final bool fileExists = await imageFile.exists();
      if (fileExists) {
        return maps.first['path'];
      }
    }
    // Return default network image URL if no image set in database or file does not exist
    return 'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_1280.png';
  }
}

class select {
  String id;
  bool checkValue = false;
  select({required this.id, required this.checkValue});
}

// for Future Use

