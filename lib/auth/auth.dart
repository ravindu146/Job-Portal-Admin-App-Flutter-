import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_portal_admin_app/auth/login_or_register.dart';
import '../pages/company_page.dart';
import '../pages/home_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return LoginOrRegister();
          } else {
            User user = snapshot.data as User;
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('topLevelUsers')
                  .doc(user.uid)
                  .get(),
              builder: (context, userDocSnapshot) {
                if (!userDocSnapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  String role = userDocSnapshot.data!['role'];
                  if (role == 'admin') {
                    return HomePage();
                  } else if (role == 'manager') {
                    String companyId = userDocSnapshot.data!['companyId'];
                    return CompanyPage(companyId: companyId);
                  } else {
                    return Center(child: Text('Invalid user role'));
                  }
                }
              },
            );
          }
        },
      ),
    );
  }
}
