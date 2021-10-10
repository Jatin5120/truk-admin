import 'package:flutter/material.dart';

class ProgressAlert extends StatelessWidget {
  final String text;

  const ProgressAlert({
    Key? key,
    this.text = "Downloading ...",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Row(
        children: [Text(text), CircularProgressIndicator()],
      ),
    );
  }
}
