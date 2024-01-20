import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:job_portal_admin_app/components/my_add_button.dart';
import 'package:job_portal_admin_app/components/my_list_tile.dart';
import 'package:job_portal_admin_app/components/my_list_tile_with_action.dart';
import 'package:job_portal_admin_app/helper/helper_functions.dart';

class CompanyPage extends StatefulWidget {
  CompanyPage({super.key});

  @override
  State<CompanyPage> createState() => _CompanyPageState();
}

class _CompanyPageState extends State<CompanyPage> {
  Stream<List<Map<String, dynamic>>> getManagersForCompanyStream(
      String companyId) {
    return FirebaseFirestore.instance
        .collection('topLevelUsers')
        .where('companyId', isEqualTo: companyId)
        .where('role', isEqualTo: 'manager')
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList());
  }

  Stream<List<Map<String, dynamic>>> getJobVacanciesForCompanyStream(
      String companyId) {
    return FirebaseFirestore.instance
        .collection('JobVacancies')
        .where('company_id', isEqualTo: companyId)
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
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    // Extracting information
    final String companyId = args!['companyId'];
    final String companyName = args!['companyName'];
    final String companyAddress = args!['companyAddress'];
    final String addedByUsername = args!['addedByUsername'];
    final String addedByRole = args!['addedByRole'];
    final String addedBy = args!['addedBy'];

    void redirectToNewPage(BuildContext context, String routePath) {
      Navigator.pushNamed(context, routePath,
          arguments: {'companyName': companyName, 'companyId': companyId});
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Company Page",
          style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            verticalDirection: VerticalDirection.down,
            children: [
              Container(
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(10)),
                child: Icon(
                  Icons.business,
                  size: 50,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '$companyName',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Text('Address: $companyAddress'),
              Text("Added By: ${addedByUsername} (${addedByRole})"),
              SizedBox(
                height: 15,
              ),
              Divider(
                color: Theme.of(context).colorScheme.secondary,
                height: 20,
                thickness: 1,
              ),

              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  'Managers',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.inversePrimary),
                ),
              ),

              MyAddButon(
                onTap: () {
                  redirectToNewPage(context, '/add_new_manager');
                },
                text: 'Add New Manager',
              ),

              // SizedBox(height: 10),

              // Stream builder to display managers
              StreamBuilder(
                stream: getManagersForCompanyStream(companyId),
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
                    return Text('Error loading Managers for the company');
                  }

                  //If has no data
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('No managers Added');
                  }

                  // List of Managers
                  final managers = snapshot.data!;

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: managers.length,
                    itemBuilder: (context, index) {
                      final manager = managers[index];
                      final String managerUsername = manager['username'];
                      final String managerEmail = manager['email'];

                      return MyListTile(
                          title: managerUsername, subTitle: managerEmail);
                    },
                  );
                },
              ),

              Divider(
                color: Theme.of(context).colorScheme.secondary,
                height: 20,
                thickness: 1,
              ),

              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  'Job Vacancies',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.inversePrimary),
                ),
              ),

              MyAddButon(
                onTap: () {
                  Navigator.pushNamed(context, '/add_new_job_vacancy_page',
                      arguments: {
                        'companyId': companyId,
                        'companyName': companyName,
                        'addedBy': addedBy,
                        'addedByUsername': addedByUsername,
                        'addedByRole': addedByRole,
                      });
                },
                text: 'Add New Job Vacancy',
              ),

              // Stream builder to display managers
              StreamBuilder(
                stream: getJobVacanciesForCompanyStream(companyId),
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
                        'Error loading Job Vacancies for the company: ${snapshot.error}');
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
                      final String jobDescription =
                          jobVacancy['job_description'];
                      final String category = jobVacancy['category'];

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
