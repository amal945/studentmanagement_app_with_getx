import 'dart:io';

import 'package:final_project/db/database_helper.dart';
import 'package:final_project/model/student_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddStudentPage extends StatefulWidget {
  final DataBaseHelper dataBaseHelper;

  const AddStudentPage({super.key, required this.dataBaseHelper});

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _parentnameController = TextEditingController();
  final _ageController = TextEditingController();
  final _genderController = TextEditingController();
  final _rollnumberController = TextEditingController();
  String? _profilePicture;
  XFile? image;
  bool isGenderSelected = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Add Student"),
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
                  XFile? img =
                      await ImagePicker().pickImage(source: ImageSource.gallery);
                  setState(() {
                    image = img;
                  });
                  _profilePicture = image!.path;
                },
                child: CircleAvatar(
                  radius: 50.0,
                  backgroundImage: _profilePicture != null
                      ? FileImage(File(_profilePicture!))
                      : null,
                  child: _profilePicture == null
                      ? const Icon(Icons.add_a_photo)
                      : null,
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please Enter Valid input";
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(
                height: 16.0,
              ),
              TextFormField(
                controller: _parentnameController,
                decoration: const InputDecoration(
                  labelText: "Parent Name",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please Enter Valid input";
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(
                height: 16.0,
              ),
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
                    selectedColor: Colors.blue,
                    label: const Text('Male'),
                    selected: _genderController.text == 'Male',
                    onSelected: (selected) {
                      setState(() {
                        _genderController.text = selected ? 'Male' : '';
                        isGenderSelected = selected;
                      });
                    },
                  ),
                  ChoiceChip(
                    selectedColor: Colors.blue,
                    label: const Text('Female'),
                    selected: _genderController.text == 'Female',
                    onSelected: (selected) {
                      setState(() {
                        _genderController.text = selected ? 'Female' : '';
                        isGenderSelected = selected;
                      });
                    },
                  ),
                  ChoiceChip(
                    selectedColor: Colors.blue,
                    label: const Text('Other'),
                    selected: _genderController.text == 'Other',
                    onSelected: (selected) {
                      setState(() {
                        _genderController.text = selected ? 'Other' : '';
                        isGenderSelected = selected;
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
                decoration: const InputDecoration(
                  labelText: 'Rollnumber',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your rollnumber';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
              ),
              const SizedBox(
                height: 16.0,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate() && isGenderSelected) {
                    final name = _nameController.text;
                    final gender = _genderController.text.toLowerCase();
                    final age = int.parse(_ageController.text);
                    final rollnumber = int.parse(_rollnumberController.text);
                    final student = Student(
                      id: 0,
                      name: name,
                      age: age,
                      gender: gender,
                      rollnumber: rollnumber,
                      picture: _profilePicture ?? '',
                    );
                    widget.dataBaseHelper.insertStudents(student).then((id) {
                      if (id > 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Student added successfully'),
                          ),
                        );
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Failed to add student'),
                          ),
                        );
                      }
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Please select a gender and fill in all fields.',
                        ),
                      ),
                    );
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
