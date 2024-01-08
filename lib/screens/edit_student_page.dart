import 'dart:io';

import 'package:final_project/db/database_helper.dart';
import 'package:final_project/model/student_model.dart';
import 'package:final_project/screens/student_list_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditStudentPage extends StatefulWidget {
  final Student student;

  const EditStudentPage({required this.student});

  @override
  State<EditStudentPage> createState() => _EditStudentPageState();
}

class _EditStudentPageState extends State<EditStudentPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  String _selectedGender = '';
  final _rollnumberController = TextEditingController();
  final _profilePictureController = TextEditingController();
  XFile? image;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.student.name;
    _ageController.text = widget.student.age.toString();
    _selectedGender = widget.student.gender;
    _rollnumberController.text = widget.student.rollnumber.toString();
    _profilePictureController.text = widget.student.picture;
  }

  @override
  Widget build(BuildContext context) {
    DataBaseHelper databaseHelp = DataBaseHelper();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Edit Student"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () async {
                  XFile? img = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (img != null) {
                    setState(() {
                      image = img;
                      _profilePictureController.text = image!.path;
                    });
                  }
                },
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _profilePictureController.text.isNotEmpty
                      ? FileImage(File(_profilePictureController.text))
                      : FileImage(File(widget.student.picture)),
                  child: _profilePictureController.text.isEmpty
                      ? const Icon(Icons.add_a_photo)
                      : null,
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Name"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter valid name.";
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(
                  labelText: 'Age',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an age';
                  }
                  final age = int.tryParse(value);
                  if (age == null || age <= 0 || age > 100) {
                    return 'Invalid age. Age must be between 1 and 100.';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),
              Wrap(
                spacing: 8.0,
                children: <Widget>[
                  ChoiceChip(
                    label: const Text('Male'),
                    selected: _selectedGender == 'Male',
                    onSelected: (selected) {
                      setState(() {
                        _selectedGender = selected ? 'Male' : '';
                      });
                    },
                  ),
                  ChoiceChip(
                    label: const Text('Female'),
                    selected: _selectedGender == 'Female',
                    onSelected: (selected) {
                      setState(() {
                        _selectedGender = selected ? 'Female' : '';
                      });
                    },
                  ),
                  ChoiceChip(
                    label: const Text('Other'),
                    selected: _selectedGender == 'Other',
                    onSelected: (selected) {
                      setState(() {
                        _selectedGender = selected ? 'Other' : '';
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 16.0,
              ),
              TextFormField(
                controller: _rollnumberController,
                decoration: const InputDecoration(labelText: 'Rollnumber'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter rollnumber';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 16.0,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final name = _nameController.text;
                    final age = int.parse(_ageController.text);
                    final rollnumber = int.parse(_rollnumberController.text);

                    final updatedStudent = Student(
                      id: widget.student.id,
                      name: name,
                      age: age,
                      gender: _selectedGender,
                      rollnumber: rollnumber,
                      picture: _profilePictureController.text,
                    );

                    databaseHelp.updateStudent(updatedStudent).then((id) {
                      if (id > 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Updated successfully.")),
                        );
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StudentListPage()),
                            (route) => false);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Unsuccessful")),
                        );
                      }
                    });
                  }
                },
                child: const Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
