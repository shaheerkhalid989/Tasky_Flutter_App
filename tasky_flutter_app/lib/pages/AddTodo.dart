import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";

class AddTodo extends StatefulWidget {
  const AddTodo({Key? key}) : super(key: key);

  @override
  AddTodoState createState() => AddTodoState();
}

class AddTodoState extends State<AddTodo> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descrptionController = TextEditingController();
  String type = "";
  String category = "";

  String selectedType = "";
  String selectedCategory = "";

  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime selectedDate = DateTime.now();

  String dateString = DateFormat('yyyy-MM-dd').format(DateTime.now());

  Map<String, bool> chipSelectedState = {
    "Important": false,
    "Planned": false,
    "Work": false,
    "Home": false,
    "Personal": false,
    "Food": false,
    "Workout": false,
    "Game": false,
    "Other": false,
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Tasky"),
      //   backgroundColor: Colors.black,
      //   actions: [
      //     IconButton(
      //       onPressed: () {},
      //       icon: Icon(Icons.logout),
      //     )
      //   ],
      // ),
      body: Container(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
              ),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 28,
                  )),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Create",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 33,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Text(
                          "New Task",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 33,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 2,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.assignment_add,
                          size: 35,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    label("Task Title"),
                    SizedBox(
                      height: 10,
                    ),
                    title("Enter Title"),
                    SizedBox(
                      height: 25,
                    ),
                    label("Task Type"),
                    SizedBox(
                      height: 10,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          chipData("Important", Colors.cyan, "type"),
                          SizedBox(
                            width: 10,
                          ),
                          chipData("Planned", Colors.lime, "type"),
                          // SizedBox(
                          //   width: 10,
                          // ),
                          // chipData("Other", Colors.orange),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    label("Task Description"),
                    SizedBox(
                      height: 10,
                    ),
                    description("Enter Description"),
                    SizedBox(
                      height: 25,
                    ),
                    label("Task Category"),
                    SizedBox(
                      height: 0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(),
                      child: Container(
                        height: 70,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              chipData("Work", Colors.blue, "category"),
                              SizedBox(
                                width: 10,
                              ),
                              chipData("Home", Colors.red, "category"),
                              SizedBox(
                                width: 10,
                              ),
                              chipData("Personal", Colors.green, "category"),
                              SizedBox(
                                width: 10,
                              ),
                              chipData("Food", Colors.teal, "category"),
                              SizedBox(
                                width: 10,
                              ),
                              chipData("Workout", Colors.purple, "category"),
                              SizedBox(
                                width: 10,
                              ),
                              chipData(
                                  "Game",
                                  const Color.fromRGBO(63, 81, 181, 1),
                                  "category"),
                              SizedBox(
                                width: 10,
                              ),
                              chipData("Shopping", Colors.pink, "category"),
                              SizedBox(
                                width: 10,
                              ),
                              chipData(
                                  "Study", Colors.yellow.shade600, "category"),
                              SizedBox(
                                width: 10,
                              ),
                              chipData("Family", Colors.brown, "category"),
                              SizedBox(
                                width: 10,
                              ),
                              chipData("Other", Colors.orange, "category"),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    label("Task Date"),
                    SizedBox(
                      height: 10,
                    ),
                    selectDate(),
                    SizedBox(
                      height: 20,
                    ),
                    label("Notifying Time"),
                    SizedBox(
                      height: 15,
                    ),
                    timePicker(),
                    SizedBox(
                      height: 20,
                    ),
                    button(),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget button() {
    return InkWell(
      onTap: () {
        if (titleController.text.isEmpty ||
            type.isEmpty ||
            descrptionController.text.isEmpty ||
            category.isEmpty ||
            selectedTime.toString().isEmpty ||
            selectedDate.toString().isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Complete all fields.'),
            ),
          );
        } else {
          print(selectedDate);
          String? userId = FirebaseAuth.instance.currentUser?.uid;
          FirebaseFirestore.instance.collection("Task").add({
            "title": titleController.text,
            "type": type,
            "description": descrptionController.text,
            "category": category,
            "time": selectedTime.format(context),
            "date": dateString,
            "userId": userId,
            "done" : false, // Add the user ID to the document
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Task Added'),
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => AddTodo(),
            ),
          );
        }
      },
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Color(0xFF800080),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.task,
                  color: Colors.white), // Replace with your todo logo
              SizedBox(width: 10), // Add some spacing between the icon and text
              Text(
                "Add Task",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget chipData(String label, Color colr, String chipCategory) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (chipCategory == "type") {
            if (selectedType == label) {
              // If the currently selected type is this chip, unselect it
              selectedType = "";
              type = "";
              print(type);
            } else {
              // If the currently selected type is not this chip, select this chip and unselect the previous one
              selectedType = label;
              type = label;
              print(type);
            }
          } else {
            if (selectedCategory == label) {
              // If the currently selected category is this chip, unselect it
              selectedCategory = "";
              category = "";
              print(category);
            } else {
              // If the currently selected category is not this chip, select this chip and unselect the previous one
              selectedCategory = label;
              category = label;
              print(category);
            }
          }
        });
      },
      child: Chip(
        backgroundColor: colr,
        label: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
        elevation: 5,
        shadowColor: Color(0xFFDAA520),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        side: BorderSide(
          color: Colors.grey,
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        avatar: (chipCategory == "type" && selectedType == label) ||
                (chipCategory != "type" && selectedCategory == label)
            ? Icon(
                Icons.check,
                color: Colors.white,
              )
            : null,
      ),
    );
  }

  Widget title(String title) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Color(0xff2a2e3d),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: TextFormField(
          controller: titleController,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: title,
            hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }

  Widget description(String title) {
    return Container(
      height: 150,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Color(0xff2a2e3d),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: TextFormField(
          controller: descrptionController,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
          maxLines: null,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: title,
            hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }

  Widget label(String label) {
    return Text(
      label,
      style: TextStyle(
        color: Colors.white,
        fontSize: 17,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
      ),
    );
  }

  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay now = TimeOfDay.now();
    final TimeOfDay initialTime = now;

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (picked != null && picked != selectedTime) {
      final DateTime nowDateTime = DateTime.now();
      final DateTime selectedDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        picked.hour,
        picked.minute,
      );

      if (selectedDateTime.isBefore(nowDateTime)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please select a time in the future.'),
          ),
        );
      } else {
        setState(() {
          selectedTime = picked;
        });
      }
    }
  }

  Widget timePicker() {
    return Container(
      height: 120,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 100, // Set the height of the button
          //width: 200, // Set the width of the button
          child: OutlinedButton.icon(
            onPressed: () {
              selectTime(context);
            },
            icon: Icon(
              Icons.access_time,
              size: 60,
              color: Color(0xFFDAA520),
            ),
            label: RichText(
              text: TextSpan(
                text: selectedTime == TimeOfDay.now()
                    ? 'Pick Time'
                    : 'Picked Time: ',
                style: TextStyle(
                  color: Color(0xFFDAA520),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
                children: <TextSpan>[
                  if (selectedTime != TimeOfDay.now())
                    TextSpan(
                      text: '${selectedTime.format(context)}',
                      style: TextStyle(color: Colors.red),
                    ),
                ],
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: Color(0xFFDAA520),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget selectDate() {
    return TextButton(
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
            dateString = DateFormat('yyyy-MM-dd').format(selectedDate);
          });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today,
            color: Color(0xFFDAA520),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            DateFormat('EEEE, d MMMM yyyy').format(selectedDate),
            style: TextStyle(
              color: Color(0xFFDAA520),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
