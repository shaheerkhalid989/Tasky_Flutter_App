import "package:flutter/material.dart";
import "package:lottie/lottie.dart";

class IntroPage1 extends StatelessWidget {
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
            "Welcome to Tasky!",
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
              "Tasky is a task management app that helps you to manage your tasks and projects easily.",
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
          Lottie.asset('assets/8.json', height: 300, width: 300),
        ]),
      ),
    );
  }
}
