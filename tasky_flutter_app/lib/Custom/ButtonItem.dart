import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget buttonItem(BuildContext context, String btnSVG, String btnText,
    double size, Function onTap) {
  return InkWell(
    onTap: onTap as void Function()?,
    child: Container(
      width: MediaQuery.of(context).size.width - 60,
      height: 60,
      child: Card(
        color: Colors.black,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(width: 1, color: Colors.grey),
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              colors: [
                Color(0xFF123456),
                Color(0xFF789abc)
              ], // Replace with your gradient colors
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                btnSVG,
                height: size,
                width: size,
              ),
              SizedBox(
                width: 15,
              ),
              Text(
                btnText,
                style: TextStyle(color: Colors.grey.shade300, fontSize: 18),
              )
            ],
          ),
        ),
      ),
    ),
  );
}
