import "package:flutter/material.dart";

class Done extends StatelessWidget {
  const Done({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.maxFinite,
        height: double.maxFinite,
        color: Colors.white,
        child: Image.asset("assets/images/done.png"));
  }
}
