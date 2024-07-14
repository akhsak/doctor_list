import 'package:doctor/controller/bottombar_controller.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:doctor/controller/doctor_provider.dart';
import 'package:doctor/model/Doctor_model.dart';
import 'package:doctor/views/add.dart';
import 'package:doctor/views/deatil.dart';
import 'package:doctor/views/widget/text_widget.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WidgetController(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: smallText(text: 'Doctors', color: Colors.black),
          elevation: 0,
          actions: [
            Consumer<WidgetController>(
              builder: (context, state, child) => DropdownButton<String>(
                hint: smallText(text: 'Gender'),
                value: state.selectedGender,
                icon: const Icon(Icons.arrow_drop_down),
                onChanged: (String? newValue) {
                  state.selectGender(newValue!);
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
            Consumer<WidgetController>(
              builder: (context, state, child) => DropdownButton<String>(
                hint: smallText(text: 'District'),
                value: state.selectedDistrict,
                icon: const Icon(Icons.arrow_drop_down),
                onChanged: (String? newValue) {
                  state.selectDistrict(newValue!);
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
          child: _HomeStateWidget(),
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
      ),
    );
  }
}

class _HomeStateWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<WidgetController, DoctorController>(
      builder: (context, state, doctorController, child) =>
          StreamBuilder<QuerySnapshot<DoctorModel>>(
        stream: (state.selectedGender != 'Gender' &&
                state.selectedDistrict != 'District')
            ? doctorController.getDataByGenderAndDistrict(
                gender: state.selectedGender, district: state.selectedDistrict)
            : (state.selectedGender != 'Gender')
                ? doctorController.getDataByGender(state.selectedGender)
                : (state.selectedDistrict != 'District')
                    ? doctorController.getDataByDistrict(state.selectedDistrict)
                    : doctorController.getData(),
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
            List<QueryDocumentSnapshot<DoctorModel>> doctorsDoc =
                snapshot.data?.docs ?? [];

            doctorsDoc = doctorsDoc.where((doc) {
              final data = doc.data();
              return data.name
                      ?.toLowerCase()
                      .contains(state.searchQuery.toLowerCase()) ??
                  false;
            }).toList();

            return ListView.builder(
              itemCount: doctorsDoc.length,
              itemBuilder: (context, index) {
                return _buildDoctorListItem(context, doctorsDoc[index]);
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildDoctorListItem(
      BuildContext context, QueryDocumentSnapshot<DoctorModel> doc) {
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
            "Dr.${data.name}",
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                " ${data.district}",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              Text(
                " ${data.gender}",
                style: TextStyle(color: Colors.grey, fontSize: 12),
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
