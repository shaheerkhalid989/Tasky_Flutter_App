import "package:flutter/material.dart";
import "package:lottie/lottie.dart";

class IntroPage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width - 100,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xff1d1e26),
            Color(0xff252041),
          ],
        ),
      ),
      child: SingleChildScrollView(
        child: Column(children: [
          SizedBox(
            height: 30,
          ),
          Text(
            "Task Mangement!",
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(4.5),
            child: Text(
              "Experience the perfect blend of functionality and simplicity with Tasky, your go-to app for managing tasks seamlessly and staying organized.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          // Lottie.network(
          //     'https://lottie.host/54616f3a-a027-43ef-845b-b25a597cd61a/h874PqXwaM.json',
          //     height: 300,
          //     width: 300),
          Lottie.asset('assets/6.json', height: 300, width: 300),
          // Image.asset(
          //   'assets/Animation - 1.gif',
          //   width: 420, // Adjust the width as needed
          //   height: 420, // Adjust the height as needed
          //   fit: BoxFit.fill,
          // ),
        ]),
      ),
    );
  }
}
