import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:job_portal_admin_app/components/my_list_tile.dart';
import 'package:job_portal_admin_app/components/my_list_tile_with_action.dart';

import '../components/my_drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Stream<List<Map<String, dynamic>>> getAllJobVacanciesStream() {
  //   return FirebaseFirestore.instance
  //       .collection('JobVacancies')
  //       .orderBy('timestamp', descending: true)
  //       .snapshots()
  //       .map((querySnapshot) => querySnapshot.docs
  //           .map((doc) => {
  //                 ...doc.data() as Map<String, dynamic>,
  //                 'timestamp': doc['timestamp']?.millisecondsSinceEpoch,
  //               })
  //           .toList());
  // }

  Stream<List<Map<String, dynamic>>> getAllJobVacanciesStream() {
    return FirebaseFirestore.instance
        .collection('JobVacancies')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs.map((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              data['documentId'] = doc.id; // Add documentId to the map
              data['timestamp'] = doc['timestamp']?.millisecondsSinceEpoch;
              return data;
            }).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          'J O B   W A L L',
          style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
        ),
        centerTitle: true,
      ),
      drawer: MyDrawer(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              // Title
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Latest Jobs',
                  style: TextStyle(fontSize: 25),
                ),
              ),

              SizedBox(
                height: 20,
              ),

              // Stream builder to display Latest Jobs
              StreamBuilder(
                stream: getAllJobVacanciesStream(),
                builder: (context,
                    AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                  // Show loading circle
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  // Error
                  if (snapshot.hasError) {
                    return Text(
                        'Error loading Job Vacancies: ${snapshot.error}');
                  }

                  //If has no data
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('No Job vacancies Added');
                  }

                  // List of vacancies
                  final jobVacancies = snapshot.data!;

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: jobVacancies.length,
                    itemBuilder: (context, index) {
                      final jobVacancy = jobVacancies[index];
                      final String jobTitle = jobVacancy['job_title'];
                      final String jobDescription =
                          jobVacancy['job_description'];
                      final String category = jobVacancy['category'];
                      final String companyName = jobVacancy['company_name'];

                      // final String JobVacancyId = snapshot.data!.docs[index].id;
                      final String JobVacancyId = jobVacancy['documentId'];

                      return MyListTileWithAction(
                          title: "${jobTitle} - ${category}",
                          subTitle: companyName,
                          onTap: () {
                            Navigator.pushNamed(context, '/job_vacancy_page',
                                arguments: {
                                  'JobVacancyId': JobVacancyId,
                                });
                          });
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
