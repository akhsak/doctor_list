import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor/controller/student_provider.dart';
import 'package:doctor/model/student_model.dart';
import 'package:doctor/views/add.dart';
import 'package:doctor/views/deatil.dart';
import 'package:doctor/views/widget/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? selectedGender = 'Gender';
  String? selectedDistrict = 'District';
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: smallText(text: 'Doctors', color: Colors.black),
        elevation: 0,
        actions: [
          SizedBox(
            // width: size.width * 0.01,
            child: DropdownButton<String>(
              hint: smallText(text: 'Gender'),
              value: selectedGender,
              icon: const Icon(Icons.arrow_drop_down),
              onChanged: (String? newValue) {
                setState(() {
                  selectedGender = newValue;
                });
              },
              items: <String>['Gender', 'Male', 'Female']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          SizedBox(
            child: DropdownButton<String>(
              hint: smallText(text: 'District'),
              value: selectedDistrict,
              icon: const Icon(Icons.arrow_drop_down),
              onChanged: (String? newValue) {
                setState(() {
                  selectedDistrict = newValue;
                });
              },
              items: <String>[
                'District',
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
                'Wayanad',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Consumer<StudentProvider>(
          builder: (context, value, child) =>
              StreamBuilder<QuerySnapshot<StudentModel>>(
            stream: (selectedGender != null &&
                    selectedGender != 'Gender' &&
                    selectedDistrict != null &&
                    selectedDistrict != 'District')
                ? value.getDataByGenderAndDistrict(
                    gender: selectedGender!, district: selectedDistrict!)
                : (selectedGender != null && selectedGender != 'Gender')
                    ? value.getDataByGender(selectedGender!)
                    : (selectedDistrict != null &&
                            selectedDistrict != 'District')
                        ? value.getDataByDistrict(selectedDistrict!)
                        : value.getData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Snapshot has error'),
                );
              } else {
                List<QueryDocumentSnapshot<StudentModel>> studentsDoc =
                    snapshot.data?.docs ?? [];

                studentsDoc = studentsDoc.where((doc) {
                  final data = doc.data();
                  return data.name
                          ?.toLowerCase()
                          .contains(searchQuery.toLowerCase()) ??
                      false;
                }).toList();

                return ListView.builder(
                  itemCount: studentsDoc.length,
                  itemBuilder: (context, index) {
                    return _buildDoctorListItem(studentsDoc[index], value);
                  },
                );
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEditPage(),
            ),
          );
        },
        backgroundColor: Color.fromARGB(255, 10, 156, 66),
        shape: CircleBorder(),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildDoctorListItem(
      QueryDocumentSnapshot<StudentModel> doc, StudentProvider value) {
    final size = MediaQuery.of(context).size;
    final data = doc.data();
    final id = doc.id;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(
              student: data,
            ),
          ),
        );
      },
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.all(8),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: data.image != null
                ? NetworkImage(data.image!)
                : AssetImage('assets/add-friend (1).png') as ImageProvider,
          ),
          title: Text(
            data.name ?? '',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                " ${data.district}",
                style: TextStyle(color: Colors.grey),
              ),
              Text(
                " ${data.gender}",
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          trailing: SizedBox(
            height: size.height * 0.03,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddEditPage(
                      id: id,
                      student: data,
                    ),
                  ),
                );
              },
              child: smallText(
                text: 'Edit Profile',
                fontSize: 10,
                color: Colors.white,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 10, 156, 66),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
