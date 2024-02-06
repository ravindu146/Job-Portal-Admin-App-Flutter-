import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_portal_admin_app/components/my_add_button.dart';
import 'package:job_portal_admin_app/components/my_list_tile.dart';
import 'package:job_portal_admin_app/components/my_list_tile_with_action.dart';
import 'package:job_portal_admin_app/components/my_list_tile_with_action_and_delete.dart';
import 'package:job_portal_admin_app/helper/helper_functions.dart';

class CompanyPage extends StatefulWidget {
  final String companyId;

  CompanyPage({super.key, required this.companyId});

  @override
  State<CompanyPage> createState() => _CompanyPageState();
}

class _CompanyPageState extends State<CompanyPage> {
  late String _userRole;

  @override
  void initState() {
    super.initState();
    _getUserRole();
  }

  Future<void> _getUserRole() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('topLevelUsers')
          .doc(user.uid)
          .get();
      setState(() {
        _userRole = userSnapshot['role'];
      });
    }
  }

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

  Future<Map<String, dynamic>> getCompanyDetails(String companyId) async {
    DocumentSnapshot companySnapshot = await FirebaseFirestore.instance
        .collection('companies')
        .doc(companyId)
        .get();

    return companySnapshot.data() as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    void redirectToNewPage(
        BuildContext context, String companyName, String routePath) {
      Navigator.pushNamed(context, routePath, arguments: {
        'companyName': companyName,
        'companyId': widget.companyId
      });
    }

    void logout() {
      FirebaseAuth.instance.signOut();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Company Page",
          style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
        ),
        centerTitle: true,
        actions: [GestureDetector(onTap: logout, child: Icon(Icons.logout))],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: getCompanyDetails(widget.companyId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error loading company details: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Text('Company details not found'),
            );
          } else {
            // Access the company details from snapshot.data and display them
            Map<String, dynamic> companyDetails = snapshot.data!;

            final String companyName = companyDetails['name'];
            final String companyAddress = companyDetails['address'];
            final String addedByUsername = companyDetails['added_by_username'];
            final String addedByRole = companyDetails['added_by_role'];
            final String addedBy = companyDetails['added_by'];
            final String email = companyDetails['email'];

            // Display your company details widgets here using companyDetails

            return SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Center(
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
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Address: $companyAddress'),
                        Text("Added By: ${addedByUsername} (${addedByRole})"),
                        Text("Email: ${email}"),

                        SizedBox(
                          height: 15,
                        ),
                        Visibility(
                          visible: _userRole != 'manager',
                          child: Divider(
                            color: Theme.of(context).colorScheme.secondary,
                            height: 20,
                            thickness: 1,
                          ),
                        ),

                        Visibility(
                          visible: _userRole != 'manager',
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              'Managers',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary),
                            ),
                          ),
                        ),

                        Visibility(
                          visible: _userRole != 'manager',
                          child: MyAddButon(
                            onTap: () {
                              redirectToNewPage(
                                  context, companyName, '/add_new_manager');
                            },
                            text: 'Add New Manager',
                          ),
                        ),

                        // SizedBox(height: 10),

                        // Stream builder to display managers
                        Visibility(
                          visible: _userRole != 'manager',
                          child: StreamBuilder(
                            stream:
                                getManagersForCompanyStream(widget.companyId),
                            builder: (context,
                                AsyncSnapshot<List<Map<String, dynamic>>>
                                    snapshot) {
                              // Show loading circle
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              // Error
                              if (snapshot.hasError) {
                                return Text(
                                    'Error loading Managers for the company');
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
                                  final String managerUsername =
                                      manager['username'];
                                  final String managerEmail = manager['email'];

                                  return MyListTile(
                                      title: managerUsername,
                                      subTitle: managerEmail);
                                },
                              );
                            },
                          ),
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
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary),
                          ),
                        ),

                        MyAddButon(
                          onTap: () {
                            Navigator.pushNamed(
                                context, '/add_new_job_vacancy_page',
                                arguments: {
                                  'companyId': widget.companyId,
                                  'companyName': companyName,
                                  'companyAddress': companyAddress,
                                  'addedBy': addedBy,
                                  'addedByUsername': addedByUsername,
                                  'addedByRole': addedByRole,
                                });
                          },
                          text: 'Add New Job Vacancy',
                        ),

                        // Stream builder to display managers
                        StreamBuilder(
                          stream:
                              getJobVacanciesForCompanyStream(widget.companyId),
                          builder: (context,
                              AsyncSnapshot<List<Map<String, dynamic>>>
                                  snapshot) {
                            // Show loading circle
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
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

                                final String JobVacancyId =
                                    jobVacancy['documentId'];

                                return MyListTileWithActionWithDelete(
                                  title: "${jobTitle} - ${category}",
                                  subTitle: companyName,
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, '/job_vacancy_page',
                                        arguments: {
                                          'JobVacancyId': JobVacancyId,
                                        });
                                  },
                                  onDelete: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => Center(
                                          child: CircularProgressIndicator()),
                                    );

                                    try {
                                      FirebaseFirestore.instance
                                          .collection('JobVacancies')
                                          .doc(JobVacancyId)
                                          .delete();
                                      Navigator.pop(context);
                                    } on FirebaseException catch (e) {
                                      Navigator.pop(context);
                                      displayMessageToUser(
                                          "Error deleting document: $e",
                                          context);
                                    }
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
