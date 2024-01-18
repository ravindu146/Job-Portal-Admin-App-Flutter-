import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/my_drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Stream<List<Map<String, dynamic>>> getAllJobVacanciesStream() {
    return FirebaseFirestore.instance
        .collection('JobVacancies')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((doc) => {
                  ...doc.data() as Map<String, dynamic>,
                  'timestamp': doc['timestamp']?.millisecondsSinceEpoch,
                })
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          'Home Page',
          style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
        ),
        centerTitle: true,
      ),
      drawer: MyDrawer(),
      body: Center(
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
                  return Text('Error loading Job Vacancies: ${snapshot.error}');
                }

                //If has no data
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No Job vacancies Added');
                }

                // List of Managers
                final jobVacancies = snapshot.data!;

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: jobVacancies.length,
                  itemBuilder: (context, index) {
                    final jobVacancy = jobVacancies[index];
                    final String jobTitle = jobVacancy['job_title'];
                    final String jobDescription = jobVacancy['job_description'];

                    return ListTile(
                      title: Text('Job title: $jobTitle'),
                      subtitle: Text('$jobDescription'),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
