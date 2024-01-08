import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_portal_admin_app/components/my_textfield.dart';
import 'package:job_portal_admin_app/helper/helper_functions.dart';

import '../components/my_button.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Text editing controllers
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  void userLogin() async {
    // Create the loading Circle
    showDialog(
        context: context,
        builder: (context) => Center(child: CircularProgressIndicator()));

    // Try to login
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      displayMessageToUser(e.code, context);
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
              // logo
              Icon(
                Icons.person,
                size: 80,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              SizedBox(
                height: 20,
              ),

              // app Name
              Text('A D M I N   J O B   P O R T A L',
                  style: TextStyle(fontSize: 20)),

              SizedBox(
                height: 25,
              ),
              // Email Text field
              MyTextField(
                  hintText: "Email",
                  obsecureText: false,
                  controller: emailController),

              SizedBox(
                height: 25,
              ),

              // password Textfield
              MyTextField(
                  hintText: "Password",
                  obsecureText: true,
                  controller: passwordController),

              SizedBox(
                height: 10,
              ),

              // forgot password?
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Forgot Password?',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                ],
              ),

              SizedBox(
                height: 25,
              ),

              //sign in button
              MyButton(text: 'Login', onTap: userLogin),
              SizedBox(
                height: 10,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  GestureDetector(
                    child: Text(
                      "Register here",
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
