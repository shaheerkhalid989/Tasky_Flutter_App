import "dart:ffi";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:tasky_flutter_app/pages/homepage.dart";
import 'package:intl/intl.dart';

class ViewData extends StatefulWidget {
  const ViewData({Key? key, required this.document, required this.id})
      : super(key: key);
  final Map<String, dynamic> document;
  final String id;

  @override
  ViewDataState createState() => ViewDataState();
}

class ViewDataState extends State<ViewData> {
  late TextEditingController titleController;
  late TextEditingController descrptionController;
  late String type;
  late String category;

  late String selectedType;
  late String selectedCategory;

  DateTime selectedDate = DateTime.now();

  late TimeOfDay selectedTime;

  bool edit = false;
  bool done = false;

  late final DateFormat _dateFormat;
  String? _dateString;

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

    _dateFormat = DateFormat('yyyy-MM-dd');
    _dateString = _dateFormat.format(selectedDate);

    String title = widget.document["title"] == null
        ? "TiTle Not Entered!"
        : widget.document["title"];
    titleController = TextEditingController(text: title);
    String descrition = widget.document["description"] == null
        ? "Description Not Entered!"
        : widget.document["description"];
    descrptionController = TextEditingController(text: descrition);
    type = widget.document["type"];
    selectedType = type;
    category = widget.document["category"];
    selectedCategory = category;
    String timeString = "1970-01-01 " + widget.document["time"];
    DateTime parsedTime = DateFormat("yyyy-MM-dd h:mm a").parse(timeString);
    selectedTime = TimeOfDay.fromDateTime(parsedTime);
    String dateString = widget.document["date"];
    // ignore: unnecessary_null_comparison
    if (dateString != null) {
      selectedDate = DateFormat('yyyy-MM-dd').parse(dateString);
    } else {
      // Handle the case where the date is not provided
      selectedDate = DateTime.now();
    }
    done = widget.document["done"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 28,
                      )),
                  Row(
                    children: [
                      !done
                          ? IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      backgroundColor: Colors.white
                                          .withOpacity(0.9), // Set the opacity
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            20), // Set the corner radius
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.all(20),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Text('Mark as Done',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            SizedBox(height: 20),
                                            Text(
                                                'Are you sure you want to mark this as done?'),
                                            SizedBox(height: 20),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: <Widget>[
                                                TextButton(
                                                  child: Text('No'),
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(); // Dismiss the dialog
                                                  },
                                                ),
                                                TextButton(
                                                  child: Text('Yes'),
                                                  onPressed: () {
                                                    done = true;
                                                    FirebaseFirestore.instance
                                                        .collection("Task")
                                                        .doc(widget.id)
                                                        .update({
                                                      "done": true,
                                                    }).then((value) {
                                                      Navigator.pop(
                                                          context); // Close the dialog
                                                      Navigator.pop(
                                                          context); // Navigate back to the previous screen
                                                    });
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
                              icon: Icon(
                                Icons.done,
                                color: Colors.white,
                                size: 28,
                              ),
                            )
                          : Container(),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                backgroundColor: Colors.white
                                    .withOpacity(0.9), // Set the opacity
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      20), // Set the corner radius
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text('Confirm Delete',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(height: 20),
                                      Text(
                                          'Are you sure you want to delete this item?'),
                                      SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
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
                                            onPressed: () {
                                              FirebaseFirestore.instance
                                                  .collection("Task")
                                                  .doc(widget.id)
                                                  .delete()
                                                  .then((value) {
                                                Navigator.pop(
                                                    context); // Close the dialog
                                                Navigator.pop(
                                                    context); // Navigate back to the previous screen
                                              });
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
                        icon: Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              edit = !edit; // Toggle the value of edit
                            });
                          },
                          icon: Icon(
                            Icons.edit,
                            color: edit ? Colors.red : Colors.white,
                            size: 28,
                          )),
                    ],
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "View",
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
                          "Your Task",
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
                          Icons.phone_iphone_rounded,
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
    return Visibility(
      visible: edit,
      child: InkWell(
        onTap: edit
            ? () {
                if (titleController.text.isEmpty ||
                    type.isEmpty ||
                    descrptionController.text.isEmpty ||
                    category.isEmpty ||
                    selectedTime.toString().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Complete all fields and select type and category.'),
                    ),
                  );
                } else {
                  FirebaseFirestore.instance
                      .collection("Task")
                      .doc(widget.id)
                      .update({
                    "title": titleController.text,
                    "type": type,
                    "description": descrptionController.text,
                    "category": category,
                    "time": selectedTime.format(context),
                    "date": _dateString,
                    //"choosenime": selectedTime,
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Task Updated'),
                    ),
                  );
                  Navigator.pop(context);
                }
              }
            : null,
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
                Icon(Icons.update,
                    color: Colors.white), // Replace with your todo logo
                SizedBox(
                    width: 10), // Add some spacing between the icon and text
                Text(
                  "Update Changes",
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
      ),
    );
  }

  Widget chipData(String label, Color colr, String chipCategory) {
    return GestureDetector(
      onTap: () {
        if (!edit) return;
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
          enabled: edit,
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
          enabled: edit,
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
            onPressed: edit ? () => selectTime(context) : null,
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
      onPressed: edit
          ? () async {
              final DateTime now = DateTime.now();
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: selectedDate.isBefore(now) ? now : selectedDate,
                firstDate: now,
                lastDate: DateTime(2025),
              );
              if (picked != null && picked != selectedDate)
                setState(() {
                  selectedDate = picked;
                  _dateString = DateFormat('yyyy-MM-dd').format(selectedDate);
                });
            }
          : null,
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
