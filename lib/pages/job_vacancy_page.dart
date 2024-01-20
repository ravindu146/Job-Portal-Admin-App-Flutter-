import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class JobVacancyPage extends StatelessWidget {
  const JobVacancyPage({super.key});

  Future<Map<String, dynamic>> getJobDetails(String jobVacancyId) async {
    DocumentSnapshot jobSnapshot = await FirebaseFirestore.instance
        .collection('JobVacancies')
        .doc(jobVacancyId)
        .get();

    return jobSnapshot.data() as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final String JobVacancyId = args!['JobVacancyId'];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Job Vacancy Page',
          style: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: getJobDetails(JobVacancyId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error loading job details: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Text('Job details not found'),
            );
          } else {
            // Access the job details from snapshot.data and display them
            Map<String, dynamic> jobDetails = snapshot.data!;

            String jobTitle = jobDetails['job_title'];
            String jobDescription = jobDetails['job_description'];
            String category = jobDetails['category'];
            String companyId = jobDetails['company_id'];
            String companyName = jobDetails['company_name'];

            // Display your job details widgets here using jobDetails

            return SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    Container(
                        padding: EdgeInsets.all(25),
                        margin: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        child: Icon(Icons.work)),

                    Text(
                      jobTitle,
                      style: TextStyle(fontSize: 20),
                    ),
                    Text('Job Description: $jobDescription'),
                    Text('Company Name: $companyName'),

                    // Add other job details widgets as needed
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
