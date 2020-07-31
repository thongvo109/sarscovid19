import 'package:countup/countup.dart';
import 'package:flutter/material.dart';

class ItemShow extends StatelessWidget {
  final String typeName;
  final int value;
  final String typeName1;
  final int value1;
  final Color color;
  final bool lineThree;
  final String typeName2;
  final int value2;
  ItemShow({
    this.typeName,
    this.value,
    this.typeName1,
    this.value1,
    this.color,
    this.lineThree = false,
    this.typeName2,
    this.value2,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                typeName,
                style: TextStyle(
                    color: color, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Countup(
                begin: 0,
                end: value.toDouble(),
                separator: ',',
                style: TextStyle(
                  color: color,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                typeName1,
                style: TextStyle(
                    color: color, fontSize: 20, fontWeight: FontWeight.w500),
              ),
              Countup(
                begin: 0,
                end: value1.toDouble(),
                separator: ',',
                style: TextStyle(
                  color: color,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          if (lineThree) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  typeName2,
                  style: TextStyle(
                      color: color, fontSize: 20, fontWeight: FontWeight.w500),
                ),
                Countup(
                  begin: 0,
                  end: value2.toDouble(),
                  separator: ',',
                  style: TextStyle(
                    color: color,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ]
        ],
      ),
    );
  }
}
