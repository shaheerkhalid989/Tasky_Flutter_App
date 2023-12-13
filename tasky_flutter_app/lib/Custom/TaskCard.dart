import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String time;
  final IconData icon;
  final Color iconColor;
  final bool check;
  final Color iconBgColor;
  final Function onChange;
  final int index;
  final bool done;

  const TaskCard({
    Key? key,
    required this.title,
    required this.time,
    required this.icon,
    required this.iconColor,
    required this.check,
    required this.iconBgColor,
    required this.onChange,
    required this.index,
    required this.done,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10),
        Container(
          margin: EdgeInsets.only(right: 10.0),
          width: MediaQuery.of(context).size.width,
          child: Row(children: [
            Theme(
              child: Transform.scale(
                scale: 1.5,
                child: Checkbox(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  activeColor: Color(0xFF893999),
                  checkColor: Colors.purple.shade100,
                  value: check,
                  onChanged: (value) {
                    onChange(index);
                  },
                ),
              ),
              data: ThemeData(
                primarySwatch: Colors.blue,
                unselectedWidgetColor: Color(0xff5e616a),
              ),
            ),
            Expanded(
                child: Container(
              height: 75,
              decoration: BoxDecoration(
                color: done ? Colors.green.shade700 : Color(0xff2a2e3d),
                //color: Color(0xff2a2e3d),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFDAA520).withOpacity(0.5),
                    blurRadius: 5,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Row(children: [
                SizedBox(width: 10),
                Container(
                  height: 33,
                  width: 36,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w600,
                      )),
                ),
                Text(time,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      //letterSpacing: 1,
                      //fontWeight: FontWeight.w600,
                    )),
                SizedBox(width: 10),
              ]),
            ))
          ]),
        ),
      ],
    );
  }
}
