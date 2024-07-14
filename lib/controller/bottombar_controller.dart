import 'package:doctor/views/screens/appoinment.dart';
import 'package:doctor/views/screens/home.dart';
import 'package:doctor/views/screens/prescrption.dart';
import 'package:doctor/views/screens/profile.dart';
import 'package:flutter/material.dart';

class BottomProvider extends ChangeNotifier {
  int CurrentIndex = 0;

  void onTap(int index) {
    CurrentIndex = index;
    notifyListeners();
  }

  List userScreens = [
    HomePage(),
    const AppoinmentPage(),
    const PrescriptionPage(),
    ProfilePage(),
  ];
}
