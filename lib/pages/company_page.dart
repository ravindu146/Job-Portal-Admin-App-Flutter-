import 'package:flutter/material.dart';

class CompanyPage extends StatelessWidget {
  CompanyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    // Extracting information
    final String companyName = args!['companyName'];
    final String companyAddress = args!['companyAddress'];
    final String addedByUsername = args!['addedByUsername'];
    final String addedByRole = args!['addedByRole'];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Company Page",
          style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
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
            // Text(
            //   'Company Details',
            //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            // ),
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
          ],
        ),
      ),
    );
  }
}
