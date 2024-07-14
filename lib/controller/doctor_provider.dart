import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor/model/Doctor_model.dart';
import 'package:doctor/service/firbase_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class DoctorController extends ChangeNotifier {
  FirebaseService firebaseService = FirebaseService();
  String uniquename = DateTime.now().microsecondsSinceEpoch.toString();
  String downloadurl = '';

  Stream<QuerySnapshot<DoctorModel>> getData() {
    return firebaseService.doctorref.snapshots();
  }

  Stream<QuerySnapshot<DoctorModel>> getDataByGender(String gender) {
    return firebaseService.doctorref
        .where('gender', isEqualTo: gender)
        .snapshots();
  }

  Stream<QuerySnapshot<DoctorModel>> getDataByDistrict(String district) {
    return firebaseService.doctorref
        .where('district', isEqualTo: district)
        .snapshots();
  }

  // New method to fetch students filtered by both gender and district
  Stream<QuerySnapshot<DoctorModel>> getDataByGenderAndDistrict({
    required String gender,
    required String district,
  }) {
    return firebaseService.doctorref
        .where('gender', isEqualTo: gender)
        .where('district', isEqualTo: district)
        .snapshots();
  }

  adddoctor(DoctorModel student) async {
    await firebaseService.doctorref.add(student);
    notifyListeners();
  }

  deleteDoctor(id) async {
    await firebaseService.doctorref.doc(id).delete();
    notifyListeners();
  }

  updateDoctor(id, DoctorModel student) async {
    await firebaseService.doctorref.doc(id).update(student.toJson());
    notifyListeners();
  }

  imageAdder(image) async {
    Reference folder = firebaseService.storage.ref().child('images');
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
