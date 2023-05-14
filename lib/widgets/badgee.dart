import 'package:flutter/material.dart';

class Badgee extends StatelessWidget {
  final Widget child;
  final String value;
  final Color? color;

  const Badgee({
    Key? key,
    required this.child,
    required this.value,
    this.color = Colors.deepOrange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int valueAsInt = int.parse(value);
    //widget de empilhamento de itens
    return Stack(
      //alinhamento central dos itens
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            height: 12,
            alignment: Alignment.center,
            width: (valueAsInt > 99) ? 25 : 15,
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(10)),
            child: Text(
              value,
              style: TextStyle(fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ),
        )
      ],
    );
  }
}
