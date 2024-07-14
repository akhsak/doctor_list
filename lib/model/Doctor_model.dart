// student_model.dart

class DoctorModel {
  String? name;
  String? district;
  String? email;
  String? image;
  String? number;
  String? gender;

  DoctorModel(
      {this.name,
      this.district,
      this.email,
      required this.image,
      this.number,
      required this.gender});

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      image: json['image'],
      name: json['name'] as String?,
      district: json['district'] as String?,
      email: json['email'] as String?,
      number: json['number'] as String?,
      gender: json['gender'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'name': name,
      'district': district,
      'email': email,
      'number': number,
      'gender': gender,
    };
  }
}
