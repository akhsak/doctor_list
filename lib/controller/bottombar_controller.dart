// import 'package:doctor/views/screens/appoinment.dart';
// import 'package:doctor/views/screens/home.dart';
// import 'package:doctor/views/screens/prescrption.dart';
// import 'package:doctor/views/screens/profile.dart';
// import 'package:flutter/material.dart';

// class WidgetController extends ChangeNotifier {
//   int CurrentIndex = 0;

//   void onTap(int index) {
//     CurrentIndex = index;
//     notifyListeners();
//   }

//   List userScreens = [
//     HomePage(),
//     const AppoinmentPage(),
//     const PrescriptionPage(),
//     ProfilePage(),
//   ];

//   String selectedGender = 'Gender';
//   String selectedDistrict = 'District';
//   String searchQuery = '';

//   void selectGender(String value) {
//     selectedGender = value;
//     notifyListeners();
//   }

//   void selectDistrict(String value) {
//     selectedDistrict = value;
//     notifyListeners();
//   }

//   void search(String value) {
//     searchQuery = value;
//     notifyListeners();
//   }
// }
import 'package:flutter/material.dart';
import 'package:doctor/views/screens/appoinment.dart';
import 'package:doctor/views/screens/home.dart';
import 'package:doctor/views/screens/prescrption.dart';
import 'package:doctor/views/screens/profile.dart';

class WidgetController extends ChangeNotifier {
  int currentIndex = 0;

  String selectedGender = 'Gender';
  String selectedDistrict = 'District';
  String searchQuery = '';

  void onTap(int index) {
    currentIndex = index;
    notifyListeners();
  }

  void selectGender(String value) {
    selectedGender = value;
    notifyListeners();
  }

  void selectDistrict(String value) {
    selectedDistrict = value;
    notifyListeners();
  }

  void search(String value) {
    searchQuery = value;
    notifyListeners();
  }

  List<Widget> userScreens = [
    HomePage(),
    const AppoinmentPage(),
    const PrescriptionPage(),
    ProfilePage(),
  ];
}
