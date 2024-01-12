import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirestoreDatabase {
  // Get current User
  User? user = FirebaseAuth.instance.currentUser;

  // Get companies list

  Stream<QuerySnapshot> getCompaniesStream() {
    final companiesStream =
        FirebaseFirestore.instance.collection('companies').snapshots();

    return companiesStream;
  }

  // Getting list of Managers for a particular company
  Stream<QuerySnapshot> getManagersForCompany(String companyId) {
    final managersForCompanyStream = FirebaseFirestore.instance
        .collection('topLevelUsers')
        .where('companyId', isEqualTo: companyId)
        .where('role', isEqualTo: 'manager')
        .snapshots();

    return managersForCompanyStream;
  }
}
