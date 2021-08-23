import 'package:admin/constants.dart';
import 'package:flutter/material.dart';

class statisticalData {
  final String? svgSrc, title;
  final int? numOfFiles, percentage;
  final Color? color;

  statisticalData({
    this.svgSrc,
    this.title,
    this.numOfFiles,
    this.percentage,
    this.color,
  });
}
