import 'package:flutter/material.dart';
import 'package:spacex_project/controller/index.dart';
import 'package:spacex_project/theme/colors.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primaryColor: primary,
    ),
    home: IndexPage(),
  ));
}
