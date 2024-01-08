import 'dart:io';

import 'package:final_project/db/database_helper.dart';
import 'package:final_project/model/student_model.dart';
import 'package:final_project/screens/add_student_page.dart';
import 'package:final_project/screens/student_details_page.dart';
import 'package:flutter/material.dart';

class StudentListPage extends StatefulWidget {
  const StudentListPage({super.key});

  @override
  State<StudentListPage> createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage> {
  late DataBaseHelper dataBaseHelper;
  List<Student> students = [];
  List<Student> filteredStudents = [];
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    dataBaseHelper = DataBaseHelper();
    refreshStudentList();
  }

  Future<void> refreshStudentList() async {
    final studentList = await dataBaseHelper.getStudents();
    setState(() {
      students = studentList;
      filteredStudents = studentList;
    });
  }

  void _fliterStudent(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredStudents = students;
      } else {
        filteredStudents = students
            .where((student) =>
                student.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !isSearching
            ? const Text("Student List")
            : TextField(
                style: const TextStyle(color: Colors.white),
                onChanged: (query) {
                  _fliterStudent(query);
                },
                decoration: const InputDecoration(
                    hintText: "Search",
                    hintStyle: TextStyle(color: Colors.white)),
              ),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  isSearching = !isSearching;
                  if (!isSearching) {
                    filteredStudents = students;
                  }
                });
              },
              icon: const Icon(Icons.search))
        ],
      ),
      body: filteredStudents.isEmpty
          ? const Center(
              child: Text("No students"),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: filteredStudents.length,
              itemBuilder: (context, index) {
                final student = filteredStudents[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                StudentDetailPage(student: student)));
                  },
                  child: Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 30.0,
                          backgroundImage: FileImage(File(student.picture)),
                        ),
                        const SizedBox(height: 8.0),
                        Text(student.name),
                      ],
                    ),
                  ),
                );
              }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    AddStudentPage(dataBaseHelper: dataBaseHelper)),
          ).then((value) => refreshStudentList());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
