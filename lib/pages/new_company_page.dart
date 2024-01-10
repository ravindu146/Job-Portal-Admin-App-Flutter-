import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_portal_admin_app/components/my_button.dart';
import 'package:job_portal_admin_app/components/my_textfield.dart';
import 'package:job_portal_admin_app/helper/helper_functions.dart';
import 'package:job_portal_admin_app/helper/user_profile.dart';

class NewCompanyPage extends StatefulWidget {
  NewCompanyPage({super.key});

  @override
  State<NewCompanyPage> createState() => _NewCompanyPageState();
}

class _NewCompanyPageState extends State<NewCompanyPage> {
  // controllers
  final TextEditingController companyNameController = TextEditingController();

  final TextEditingController companyAddressController =
      TextEditingController();

  Future<void> AddNewCompanyDocument() async {
    // Loading circle
    showDialog(
      context: context,
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      },
    );

    // Try to Create the document
    try {
      // get the current user
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await FirebaseFirestore.instance.collection('companies').add({
          'name': companyNameController.text,
          'address': companyAddressController.text,
          'added_by': user!.uid
        });

        Navigator.pop(context);
      } else {
        displayMessageToUser('User is not Authenticaated!', context);
      }
    } catch (e) {
      Navigator.pop(context);
      displayMessageToUser(e.toString(), context);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add New Company',
          style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              // Logo
              Icon(
                Icons.business,
                size: 50,
              ),

              SizedBox(
                height: 20,
              ),

              // Company Name Text field
              MyTextField(
                  hintText: 'Company Name',
                  obsecureText: false,
                  controller: companyNameController),

              SizedBox(
                height: 20,
              ),

              // Address Text field
              MyTextField(
                  hintText: 'Comapany Address',
                  obsecureText: false,
                  controller: companyAddressController),

              SizedBox(
                height: 20,
              ),

              MyButton(text: "Add Company", onTap: AddNewCompanyDocument),
            ],
          ),
        ),
      ),
    );
  }
}
