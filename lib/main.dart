import 'package:flutter/material.dart';
import 'package:to_do_list/src/utils/constants.dart';
import './src/ui/landing_list.dart';

void main() {
  runApp(MyApp());
}

//Starting of the widget tree

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'To Do List',
        home: LandingList(),
        theme: Constants.themePrimary);
  }
}
