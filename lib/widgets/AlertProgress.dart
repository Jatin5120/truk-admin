import 'package:flutter/material.dart';
class ProgressAlert extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Row(
        children: [
          Text("Downloading......"),
          CircularProgressIndicator()
        ],
      ),
    );
  }
}
