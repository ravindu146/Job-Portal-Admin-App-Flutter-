import 'package:flutter/material.dart';

class MyBackButton extends StatelessWidget {
  const MyBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50, left: 25),
      child: GestureDetector(
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.secondary),
              padding: EdgeInsets.all(15),
              child: Icon(Icons.arrow_back),
            ),
          ],
        ),
        onTap: () => Navigator.pop(context),
      ),
    );
  }
}
