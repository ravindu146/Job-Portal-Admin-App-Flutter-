import 'package:flutter/material.dart';
import 'package:job_portal_admin_app/components/my_back_button.dart';
import 'package:job_portal_admin_app/helper/user_profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserProfile? userProfile;

  @override
  void initState() {
    super.initState();
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    UserProfile? profile = await getUserProfile();

    setState(() {
      userProfile = profile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          children: [
            MyBackButton(),
            Container(
              padding: EdgeInsets.all(25),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Theme.of(context).colorScheme.secondary),
              child: Icon(
                Icons.person,
                size: 80,
              ),
            ),

            SizedBox(
              height: 25,
            ),
            Text(
              userProfile!.username,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),

            SizedBox(
              height: 10,
            ),
            Text(
              userProfile!.email,
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(userProfile!.role),
            // Add more details as needed
          ],
        ),
      ),
    );
  }
}
