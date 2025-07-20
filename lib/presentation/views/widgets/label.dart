import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Label extends StatelessWidget {
  final String text;
  final double fontSize;
  final double bottomPadding;
  final FontWeight fontWeight;
  final Color? color;

  const Label(
    this.text, {
    this.fontSize = 16,
    this.bottomPadding = 4,
    this.fontWeight = FontWeight.normal,
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: bottomPadding),
    child: Text(
      text,
      style: TextStyle(
        fontSize: fontSize.sp,
        fontWeight: fontWeight,
        color: color ?? Theme.of(context).textTheme.bodyMedium?.color,
      ),
    ),
  );
}
