import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_portal_admin_app/components/my_button.dart';
import 'package:job_portal_admin_app/components/my_textfield.dart';
import 'package:job_portal_admin_app/helper/helper_functions.dart';

class NewManagerPage extends StatelessWidget {
  NewManagerPage({super.key});

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    //Extracting information
    final String companyName = args!['companyName'];
    final String companyId = args!['companyId'];

    void addManager() async {
      // Check if passwords match
      if (passwordController.text != confirmPasswordController.text) {
        displayMessageToUser("Passwords don't match", context);
      } else {
        // Loading Circle
        showDialog(
          context: context,
          builder: (context) => Center(child: CircularProgressIndicator()),
        );

        try {
          // Try to Register user to FirebaseAuth
          UserCredential? userCredential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: emailController.text,
                  password: passwordController.text);

          // Try adding the user information to Firestore Database collection name : topLevelUsers
          await FirebaseFirestore.instance
              .collection('topLevelUsers')
              .doc(userCredential.user!.uid)
              .set({
            'email': userCredential.user!.email,
            'username': usernameController.text,
            'role': 'manager',
            'companyId': companyId,
          });

          Navigator.pop(context);
        } on FirebaseException catch (e) {
          Navigator.pop(context);
          displayMessageToUser(e.code, context);
        }
        Navigator.pop(context);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New Manager Page',
          style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(25),
              child: Icon(
                Icons.person,
                size: 60,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("New Manager for "),
                Text(
                  "${companyName}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            MyTextField(
                hintText: 'Username',
                obsecureText: false,
                controller: usernameController),
            SizedBox(
              height: 20,
            ),
            MyTextField(
                hintText: 'Email',
                obsecureText: false,
                controller: emailController),
            SizedBox(
              height: 20,
            ),
            MyTextField(
                hintText: 'Password',
                obsecureText: true,
                controller: passwordController),
            SizedBox(
              height: 20,
            ),
            MyTextField(
                hintText: 'Confirm Password',
                obsecureText: true,
                controller: confirmPasswordController),
            SizedBox(
              height: 20,
            ),
            MyButton(text: 'Register Manager', onTap: addManager),
          ],
        ),
      ),
    );
  }
}
