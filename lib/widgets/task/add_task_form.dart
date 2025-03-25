import 'package:cmsc128_lab/utils/styles.dart';
import 'package:cmsc128_lab/utils/firestore_utils.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:cmsc128_lab/data/task_data.dart';
import 'package:google_fonts/google_fonts.dart';

class AddTaskForm extends StatefulWidget {
  const AddTaskForm({super.key});

  @override
  State<AddTaskForm> createState() => _AddTaskFormState();
}

class _AddTaskFormState extends State<AddTaskForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  String _selectedCategory = "Personal";

  Future<void> _selectDate() async {
    DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (selected != null) {
      setState(() {
        _dateController.text = selected.toString().split(" ")[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: [
            // Task Name
            TextFormField(
              controller: _taskNameController,
              decoration: InputDecoration(
                label: Text('Task Name',
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: GoogleFonts.lexendDeca().fontFamily,
                        color: Colors.black.withOpacity(0.5))),
                prefixIcon: const Icon(IconlyLight.edit_square,
                    color: StyleColor.primary),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter task name';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            // Input Date
            TextFormField(
              controller: _dateController,
              decoration: InputDecoration(
                  label: Text('Enter Date',
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: GoogleFonts.lexendDeca().fontFamily,
                          color: Colors.black.withOpacity(0.5))),
                  // filled: true,
                  prefixIcon: const Icon(IconlyLight.calendar,
                      color: StyleColor.primary),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: StyleColor.primary, width: 1.0),
                  )),
              readOnly: true,
              onTap: () {
                _selectDate();
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please input date';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            // Category
            DropdownButtonFormField(
                value: _selectedCategory,
                decoration: InputDecoration(
                  label: Text('Category',
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: GoogleFonts.lexendDeca().fontFamily,
                          color: Colors.black.withOpacity(0.5))),
                ),
                items: categories.map((c) {
                  return DropdownMenuItem(
                    value: c,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Text(c,
                            style: TextStyle(
                                fontSize: 15,
                                fontFamily: GoogleFonts.lexendDeca().fontFamily,
                                color: Colors.black.withOpacity(0.5)))),
                  );
                }).toList(),
                menuMaxHeight: 190,
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                }),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      String taskName = _taskNameController.text;
                      taskName =
                          taskName[0].toUpperCase() + taskName.substring(1);

                      // Add to database
                      final newTask = {
                        'name': taskName,
                        'category': _selectedCategory,
                        'date': _dateController.text,
                        'isDone': false,
                        'actID': null,
                      };

                      FirestoreUtils.addTask(newTask);

                      // Notify if added successfully
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Task Added Successfully')),
                      );

                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Add')),
            ),
          ],
        ),
      ),
    );
  }
}
