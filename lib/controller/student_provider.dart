import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor/model/student_model.dart';
import 'package:doctor/service/firbase_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class StudentProvider extends ChangeNotifier {
  FirebaseService _firebaseService = FirebaseService();
  String uniquename = DateTime.now().microsecondsSinceEpoch.toString();
  String downloadurl = '';

  Stream<QuerySnapshot<StudentModel>> getData() {
    return _firebaseService.studentref.snapshots();
  }

  Stream<QuerySnapshot<StudentModel>> getDataByGender(String gender) {
    return _firebaseService.studentref
        .where('gender', isEqualTo: gender)
        .snapshots();
  }

  Stream<QuerySnapshot<StudentModel>> getDataByDistrict(String district) {
    return _firebaseService.studentref
        .where('district', isEqualTo: district)
        .snapshots();
  }

  // New method to fetch students filtered by both gender and district
  Stream<QuerySnapshot<StudentModel>> getDataByGenderAndDistrict({
    required String gender,
    required String district,
  }) {
    return _firebaseService.studentref
        .where('gender', isEqualTo: gender)
        .where('district', isEqualTo: district)
        .snapshots();
  }

  addStudent(StudentModel student) async {
    await _firebaseService.studentref.add(student);
    notifyListeners();
  }

  deleteStudent(id) async {
    await _firebaseService.studentref.doc(id).delete();
    notifyListeners();
  }

  updateStudent(id, StudentModel student) async {
    await _firebaseService.studentref.doc(id).update(student.toJson());
    notifyListeners();
  }

  imageAdder(image) async {
    Reference folder = _firebaseService.storage.ref().child('images');
    Reference images = folder.child("$uniquename.jpg");
    try {
      await images.putFile(image);
      downloadurl = await images.getDownloadURL();
      notifyListeners();
      print(downloadurl);
    } catch (e) {
      throw Exception(e);
    }
  }

  updateImage(imageurl, File? newimage) async {
    try {
      if (newimage != null && newimage.existsSync()) {
        Reference storedimage = FirebaseStorage.instance.refFromURL(imageurl);
        await storedimage.putFile(newimage);
        downloadurl = await storedimage.getDownloadURL();
        print("Image uploaded successfully. Download URL: $downloadurl");
      } else {
        // If no new image or new image is null or doesn't exist, keep the existing URL
        downloadurl = imageurl;
        print("No new image provided. Using existing URL: $downloadurl");
      }
    } catch (e) {
      print("Error updating image: $e");
    }
  }

  deleteImage(imageurl) async {
    Reference storedimage = FirebaseStorage.instance.refFromURL(imageurl);
    await storedimage.delete();
  }
}
