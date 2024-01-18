import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:job_portal_admin_app/components/my_button.dart';
import 'package:job_portal_admin_app/components/my_textfield.dart';
import 'package:job_portal_admin_app/helper/helper_functions.dart';

class NewJobVacancyPage extends StatefulWidget {
  NewJobVacancyPage({super.key});

  @override
  State<NewJobVacancyPage> createState() => _NewJobVacancyPageState();
}

class _NewJobVacancyPageState extends State<NewJobVacancyPage> {
  // Text editing controllers
  TextEditingController jobTitleController = TextEditingController();
  TextEditingController jobDescriptionController = TextEditingController();

  String selectedJobCategory = 'Information Technology';

  // List of job categories
  List<String> jobCategories = [
    'Information Technology',
    'Healthcare',
    'Finance',
    'Marketing',
    'Sales',
    'Customer Service',
    'Education',
    'Engineering',
    'Human Resources',
    'Administrative',
    'Manufacturing',
    'Retail',
    'Hospitality',
    'Arts and Design',
    'Media and Communications',
    'Science',
    'Construction',
    'Social Services',
    'Legal',
    'Transportation',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    // Extracting information
    final String companyId = args!['companyId'];
    final String companyName = args!['companyName'];
    final String addedByUsername = args!['addedByUsername'];
    final String addedByRole = args!['addedByRole'];
    final String addedBy = args!['addedBy'];

    void addNewVacancyDocument() {
      // Loading circle
      showDialog(
        context: context,
        builder: (context) {
          return Center(child: CircularProgressIndicator());
        },
      );

      // Try saving the document

      try {
        FirebaseFirestore.instance.collection('JobVacancies').add({
          'job_title': jobTitleController.text,
          'job_description': jobDescriptionController.text,
          'category': selectedJobCategory,
          'added_by': addedBy, // added user's id
          'added_by_username': addedByUsername,
          'company_id': companyId,
          'company_name': companyName,
          'timestamp': Timestamp.now(),
        });

        Navigator.pop(context);
      } on FirebaseException catch (e) {
        Navigator.pop(context);
        displayMessageToUser(e.code, context);
      }
      Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New Job Vacancy',
          style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              //     // Logo
              Icon(
                Icons.work,
                size: 50,
              ),

              SizedBox(
                height: 20,
              ),

              // ADD SELECT CATRGORY HERE

              // Job Category Dropdown
              Text(
                'Select Job Category:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 12),

              DropdownButton<String>(
                value: selectedJobCategory,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedJobCategory = newValue!;
                  });
                },
                items:
                    jobCategories.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),

              SizedBox(height: 12),

              //     // Company Name Text field
              MyTextField(
                  hintText: 'Job Title',
                  obsecureText: false,
                  controller: jobTitleController),

              SizedBox(
                height: 20,
              ),

              //     // Address Text field
              MyTextField(
                  hintText: 'Job Description',
                  obsecureText: false,
                  controller: jobDescriptionController),

              SizedBox(
                height: 20,
              ),

              MyButton(text: "Add Job Vacancy", onTap: addNewVacancyDocument),
            ],
          ),
        ),
      ),
    );
  }
}
