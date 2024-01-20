import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:job_portal_admin_app/components/my_add_button.dart';
import 'package:job_portal_admin_app/database/firestore.dart';

class CompaniesPage extends StatelessWidget {
  CompaniesPage({Key? key}) : super(key: key);

  final FirestoreDatabase database = FirestoreDatabase();

  void redirectToNewPage(BuildContext context) {
    Navigator.pushNamed(context, '/add_new_company');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Companies Page',
          style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Add new company button
          MyAddButon(
              onTap: () {
                redirectToNewPage(context);
              },
              text: 'Add New Company'),

          // List of Companies

          Expanded(
            child: StreamBuilder(
              stream: database.getCompaniesStream(),
              builder: (context, snapshot) {
                // Show loading Circle
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                // Handle the error (e.g., display an error message)
                if (snapshot.hasError) {
                  return Center(child: Text('Error loading companies.'));
                }

                // Get All companies
                final companies = snapshot.data!.docs;

                // no Data?
                if (snapshot.data == null || companies.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Center(
                          child: Padding(
                        padding: const EdgeInsets.all(25),
                        child: Text('No Companies added..'),
                      )),
                    ],
                  );
                }

                // return as a list
                return ListView.builder(
                    itemCount: companies.length,
                    itemBuilder: (context, index) {
                      // Get individual Company
                      final company = companies[index];

                      // Get data from each company
                      final String name = company['name'];
                      final String address = company['address'];
                      final String addedBy = company['added_by'];
                      final String addedByUsername =
                          company['added_by_username'];
                      final String addedByRole = company['added_by_role'];

                      // Get company document ID
                      final String companyId = snapshot.data!.docs[index].id;

                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                              title: Text("${name} - ${address}"),
                              subtitle: Text(
                                "Added by : ${addedByUsername} (${addedByRole})",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                              ),
                              onTap: () {
                                Navigator.pushNamed(context, '/company_page',
                                    arguments: {
                                      'companyId': companyId,
                                      'companyName': name,
                                      'companyAddress': address,
                                      'addedByUsername': addedByUsername,
                                      'addedByRole': addedByRole,
                                      'addedBy': addedBy
                                    });
                              }),
                        ),
                      );
                    });
              },
            ),
          )
        ],
      ),
    );
  }
}
