import 'dart:io';
import 'package:final_project/db/database_helper.dart';
import 'package:final_project/model/student_model.dart';
import 'package:final_project/screens/edit_student_page.dart';
import 'package:final_project/screens/student_list_page.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class StudentDetailPage extends StatelessWidget {
  final Student student;

  StudentDetailPage({required this.student});
  DataBaseHelper db = DataBaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Student'),
                  content: const Text(
                      'Are you sure you want to delete this student?'),
                  actions: [
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    TextButton(
                      child: const Text('Delete'),
                      onPressed: () {
                        db.deleteStudent(student.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Deleted successfully.")),
                        );
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => StudentListPage()),
                            (route) => false);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditStudentPage(student: student),
                ),
              ).then((_) => Navigator.pop(context));
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CircleAvatar(
              radius: 50.0,
              backgroundImage: FileImage(File(student.picture)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Name: ${student.name}',
              style: const TextStyle(fontSize: 18.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Age: ${student.age}',
              style: const TextStyle(fontSize: 18.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Gender: ${student.gender}',
              style: const TextStyle(fontSize: 18.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Rollnumber: ${student.rollnumber}',
              style: const TextStyle(fontSize: 18.0),
            ),
          )
        ],
      ),
    );
  }
}
