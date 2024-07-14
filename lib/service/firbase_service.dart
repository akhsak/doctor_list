// firebase_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor/model/Doctor_model.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  String collectionref = 'Donor';
  //instnce data aces cheyn
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  FirebaseStorage storage = FirebaseStorage.instance;
  late final CollectionReference<DoctorModel> doctorref;

  FirebaseService() {
    doctorref = firestore.collection(collectionref).withConverter<DoctorModel>(
          fromFirestore: (snapshot, options) =>
              DoctorModel.fromJson(snapshot.data()!),
          toFirestore: (value, options) => value.toJson(),
        );
  }
}
