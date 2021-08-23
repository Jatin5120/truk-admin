import 'package:flutter/material.dart';
class Alert extends StatelessWidget {
  const Alert({
    required this.msg
});
  final msg;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Text(msg),
    );
  }
}
