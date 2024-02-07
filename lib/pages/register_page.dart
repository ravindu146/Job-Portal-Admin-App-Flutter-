import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_portal_admin_app/components/my_textfield.dart';

import '../components/my_button.dart';
import '../helper/helper_functions.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Text editing controllers
  final TextEditingController usernameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  // Register Function
  void RegisterUser() async {
    // Show loading circle
    showDialog(
      context: context,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    // Make sure passwords match
    if (passwordController.text != confirmPasswordController.text) {
      Navigator.pop(context);

      displayMessageToUser("Passwords don't match!", context);
    } else {
      // try Creating the User

      try {
        UserCredential? UserCredential1 = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);

        // Create a user document and add to the firestore
        createUserDocument(UserCredential1);

        if (context.mounted) Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        // pop loading circle
        Navigator.pop(context);
        displayMessageToUser(e.code, context);
      } on FirebaseException catch (e1) {
        displayMessageToUser(e1.code, context);
      }
    }
  }

  Future<void> createUserDocument(UserCredential? userCredential) async {
    if (userCredential != null && userCredential.user != null) {
      await FirebaseFirestore.instance
          .collection('topLevelUsers')
          .doc(userCredential.user!.uid)
          .set({
        'email': userCredential.user!.email,
        'username': usernameController.text,
        'role': 'admin'
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(left: 25, right: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),

              Image(image: AssetImage("assets/images/JobPortalIcon.PNG")),

              SizedBox(
                height: 25,
              ),
              // Username Text field
              MyTextField(
                  hintText: "Username",
                  obsecureText: false,
                  controller: usernameController),

              SizedBox(
                height: 10,
              ),

              // Email Text field
              MyTextField(
                  hintText: "Email",
                  obsecureText: false,
                  controller: emailController),

              SizedBox(
                height: 10,
              ),

              // password Textfield
              MyTextField(
                  hintText: "Password",
                  obsecureText: true,
                  controller: passwordController),

              SizedBox(
                height: 10,
              ),

              // Confirm Password Textfield
              MyTextField(
                  hintText: "Confirm Password",
                  obsecureText: true,
                  controller: confirmPasswordController),

              SizedBox(
                height: 10,
              ),

              SizedBox(
                height: 10,
              ),

              //sign in button
              MyButton(text: 'Register User', onTap: RegisterUser),

              SizedBox(
                height: 10,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account? "),
                  GestureDetector(
                    child: Text(
                      "Login Here",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: widget.onTap,
                  ),
                ],
              )

              // don't have an account? Resgister Here
            ],
          ),
        ),
      ),
    );
  }
}
