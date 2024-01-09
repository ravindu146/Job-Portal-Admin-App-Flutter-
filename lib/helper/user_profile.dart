import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:job_portal_admin_app/helper/helper_functions.dart';

class UserProfile {
  final String email;
  final String username;
  final String role;

  UserProfile(
      {required this.email, required this.username, required this.role});
}

Future<UserProfile?> getUserProfile() async {
  User? user = await FirebaseAuth.instance.currentUser;

  if (user != null) {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('topLevelUsers')
          .doc(user!.uid)
          .get();

      if (snapshot.exists) {
        return UserProfile(
            email: snapshot['email'],
            username: snapshot['username'],
            role: snapshot['role']);
      }
    } on FirebaseAuthException catch (e) {
      print("Error fetching user data from firestore : ${e.code}");
    }
  }
}
