import 'package:flutter/material.dart';
import 'package:doctor/model/Doctor_model.dart';

class DetailPage extends StatelessWidget {
  final DoctorModel student;

  const DetailPage({required this.student, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(student.name ?? 'Student Detail'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[300],
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: student.image != null
                        ? NetworkImage(student.image!)
                        : AssetImage('assets/add-friend (1).png')
                            as ImageProvider,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildDetailCard("Name", student.name ?? ''),
            _buildDetailCard("District", student.district ?? ''),
            _buildDetailCard("Email", student.email ?? ''),
            _buildDetailCard("Number", student.number ?? ''),
            _buildDetailCard("Gender", student.gender ?? ''),
            // Additional details can be added here
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          title: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
