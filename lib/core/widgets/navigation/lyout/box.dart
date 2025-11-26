import 'package:flutter/widgets.dart';

class Box extends StatelessWidget{
  final Widget? child;
  final Color? color;
  
  const Box({super.key, this.child, this.color});


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),      
      ),
      child: child,
    );
  }
}
