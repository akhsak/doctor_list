import 'dart:convert';
import 'dart:io';

import 'package:doctor/controller/baseprovider.dart';
import 'package:doctor/controller/doctor_provider.dart';
import 'package:doctor/model/Doctor_model.dart';
import 'package:doctor/views/widget/bottombar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart'; // for kIsWeb

class AddEditPage extends StatefulWidget {
  final DoctorModel? student;
  final String? id;

  AddEditPage({Key? key, this.student, this.id}) : super(key: key);

  @override
  _AddEditPageState createState() => _AddEditPageState();
}

class _AddEditPageState extends State<AddEditPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController genderController = TextEditingController();

  String? selectedDistrict;
  String? selectedGender;
  File? selectedImage;

  @override
  void initState() {
    super.initState();
    if (widget.student != null) {
      nameController.text = widget.student!.name ?? '';
      districtController.text = widget.student!.district ?? '';
      emailController.text = widget.student!.email ?? '';
      numberController.text = widget.student!.number ?? '';
      genderController.text = widget.student!.gender ?? '';
      selectedDistrict = widget.student!.district;
      selectedGender = widget.student!.gender;
      selectedImage =
          widget.student!.image != null ? File(widget.student!.image!) : null;
    } else {
      emailController.text = '@gmail.com';
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final pro = Provider.of<BaseProvider>(context);
    final isEdit = widget.student != null;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
          ),
        ),
        title: Text(
          isEdit ? 'Edit Doctor' : 'Add Doctor',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        actions: [
          if (isEdit)
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                deleteStudent(context);
              },
            ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Consumer<BaseProvider>(
                  builder: (context, provider, child) {
                    final image = kIsWeb
                        ? provider.selectedImageWeb
                        : provider.selectedImage?.path ?? selectedImage?.path;
                    return Stack(
                      children: [
                        image != null
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                child: CircleAvatar(
                                  radius: size.height * 0.1,
                                  backgroundImage: kIsWeb
                                      ? NetworkImage(image as String)
                                      : FileImage(File(image)) as ImageProvider,
                                ),
                              )
                            : widget.student != null &&
                                    widget.student!.image != null
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0),
                                    child: CircleAvatar(
                                      radius: size.height * 0.1,
                                      backgroundImage:
                                          NetworkImage(widget.student!.image!),
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: size.height * 0.1,
                                    backgroundColor: Colors.grey[300],
                                    child: Center(
                                      child: Text(
                                        'No Image',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ),
                                  ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 10, 156, 66),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                pro.setImage(ImageSource.gallery);
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  DropdownButtonFormField<String>(
                    value: selectedDistrict,
                    decoration: InputDecoration(
                      labelText: 'District',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    onChanged: (value) {
                      setState(() {
                        selectedDistrict = value;
                        districtController.text = value!;
                      });
                    },
                    items: [
                      'Alappuzha',
                      'Ernakulam',
                      'Idukki',
                      'Kannur',
                      'Kasaragod',
                      'Kollam',
                      'Kottayam',
                      'Kozhikode',
                      'Malappuram',
                      'Palakkad',
                      'Pathanamthitta',
                      'Thrissur',
                      'Thiruvananthapuram',
                      'Wayanad'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: size.height * 0.02),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  TextFormField(
                    controller: numberController,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    decoration: InputDecoration(
                      labelText: 'Number',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  DropdownButtonFormField<String>(
                    value: selectedGender,
                    decoration: InputDecoration(
                      labelText: 'Gender',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value;
                        genderController.text = value!;
                      });
                    },
                    items: ['Male', 'Female']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: size.height * 0.02),
                  SizedBox(
                    height: size.height * 0.06,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_validateFields()) {
                          if (isEdit) {
                            editStudent(context);
                          } else {
                            addStudent(context);
                          }
                        } else {
                          _showAlert(context, 'Please fill in all fields.');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 10, 156, 66),
                      ),
                      child: Text(
                        isEdit ? 'Save' : 'Add',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _validateFields() {
    return nameController.text.isNotEmpty &&
        districtController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        numberController.text.isNotEmpty &&
        genderController.text.isNotEmpty;
  }

  void _showAlert(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void addStudent(BuildContext context) async {
    final provider = Provider.of<DoctorController>(context, listen: false);
    final pro = Provider.of<BaseProvider>(context, listen: false);
    final name = nameController.text;
    final district = districtController.text;
    final email = emailController.text;
    final number = numberController.text;
    final gender = genderController.text;

    String imageUrl;
    if (kIsWeb && pro.selectedImageWeb != null) {
      imageUrl = pro.selectedImageWeb!;
    } else if (pro.selectedImage != null) {
      await provider.imageAdder(pro.selectedImage!);
      imageUrl = provider.downloadurl;
    } else {
      imageUrl =
          'https://example.com/default_image.png'; // Replace with your default image URL
    }

    final student = DoctorModel(
      name: name,
      district: district,
      email: email,
      image: imageUrl,
      number: number,
      gender: gender,
    );

    provider.adddoctor(student);

    // Clear fields after adding student
    _clearFields();

    // Navigate to next screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const BottomBar(),
      ),
    );
  }

  void editStudent(BuildContext context) async {
    final provider = Provider.of<DoctorController>(context, listen: false);
    final pro = Provider.of<BaseProvider>(context, listen: false);

    try {
      final editedName = nameController.text;
      final editedDistrict = districtController.text;
      final editedEmail = emailController.text;
      final editedNumber = numberController.text;
      final editedGender = genderController.text;

      String imageUrl;
      if (kIsWeb && pro.selectedImageWeb != null) {
        imageUrl = pro.selectedImageWeb!;
      } else if (pro.selectedImage != null) {
        await provider.imageAdder(pro.selectedImage!);
        imageUrl = provider.downloadurl;
      } else {
        imageUrl = widget
            .student!.image!; // Use existing image if no new image selected
      }

      final updatedStudent = DoctorModel(
        name: editedName,
        district: editedDistrict,
        email: editedEmail,
        image: imageUrl,
        number: editedNumber,
        gender: editedGender,
      );

      provider.updateDoctor(widget.id!, updatedStudent);

      Navigator.pop(context);
    } catch (e) {
      print("Error updating student: $e");
    }
  }

  void deleteStudent(BuildContext context) {
    final provider = Provider.of<DoctorController>(context, listen: false);
    provider.deleteDoctor(widget.id!);

    Navigator.pop(context);
  }

  void _clearFields() {
    nameController.clear();
    districtController.clear();
    emailController.clear();
    numberController.clear();
    genderController.clear();
    setState(() {
      selectedImage = null;
      selectedDistrict = null;
      selectedGender = null;
    });
  }
}
