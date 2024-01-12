import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:job_portal_admin_app/components/my_add_button.dart';
import 'package:job_portal_admin_app/helper/helper_functions.dart';

class CompanyPage extends StatefulWidget {
  CompanyPage({super.key});

  @override
  State<CompanyPage> createState() => _CompanyPageState();
}

class _CompanyPageState extends State<CompanyPage> {
  Future<List<Map<String, dynamic>>> getManagersForCompany(
      String companyId) async {
    List<Map<String, dynamic>> managersList = [];

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('topLevelUsers')
          .where('companyId', isEqualTo: companyId)
          .where('role', isEqualTo: 'manager')
          .get();

      managersList = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } on FirebaseException catch (e) {
      print(e.code);
    }

    return managersList;
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

    void redirectToNewPage(BuildContext context) {
      Navigator.pushNamed(context, '/add_new_manager',
          arguments: {'companyName': companyName, 'companyId': companyId});

      setState(() {});
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
            mainAxisSize: MainAxisSize.min, // Set this to MainAxisSize.min
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
                height: 20, // You can adjust the height as needed
                thickness: 1, // You can adjust the thickness as needed
              ),
              MyAddButon(
                onTap: () {
                  redirectToNewPage(context);
                },
                text: 'Add New Manager',
              ),

              SizedBox(height: 20),

              // Future builder to display managers
              FutureBuilder(
                future: getManagersForCompany(companyId),
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

                      return ListTile(
                        title: Text('Manager: $managerUsername'),
                      );
                    },
                  );
                },
              ),

              Divider(
                color: Theme.of(context).colorScheme.secondary,
                height: 20, // You can adjust the height as needed
                thickness: 1, // You can adjust the thickness as needed
              ),
              MyAddButon(
                onTap: () {
                  redirectToNewPage(
                    context,
                  );
                },
                text: 'Add New Job Vacancy',
              ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
