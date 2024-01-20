import 'package:flutter/material.dart';

class MyAddButon extends StatelessWidget {
  final void Function()? onTap;
  final String text;

  const MyAddButon({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Container(
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).colorScheme.secondary,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add),
              SizedBox(width: 10),
              Text(text),
            ],
          ),
        ),
        onTap: onTap // Use a lambda function or a separate method
        );
  }
}
