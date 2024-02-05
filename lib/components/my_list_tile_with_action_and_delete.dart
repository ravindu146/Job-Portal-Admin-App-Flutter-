import 'package:flutter/material.dart';

class MyListTileWithActionWithDelete extends StatelessWidget {
  final String title;
  final String subTitle;
  final void Function()? onTap;
  final void Function()? onDelete;

  MyListTileWithActionWithDelete({
    super.key,
    required this.title,
    required this.subTitle,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          title: Text(title),
          subtitle: Text(
            subTitle,
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
          onTap: onTap,
          trailing: IconButton(onPressed: onDelete, icon: Icon(Icons.delete)),
        ),
      ),
    );
  }
}




// import 'package:flutter/material.dart';

// class MyListTileWithActionAndDelete extends StatelessWidget {
//   final String title;
//   final String subTitle;
//   final void Function()? onTap;
//   final void Function()? onDelete;

//   MyListTileWithAction({
//     super.key,
//     required this.title,
//     required this.subTitle,
//     required this.onTap,
//     required this.onDelete,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Theme.of(context).colorScheme.primary,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: ListTile(
//           title: Text(title),
//           subtitle: Text(
//             subTitle,
//             style: TextStyle(color: Theme.of(context).colorScheme.secondary),
//           ),
//           onTap: onTap,
//           trailing: IconButton(
//             icon: Icon(Icons.delete),
//             onPressed: onDelete,
//           ),
//         ),
//       ),
//     );
//   }
// }
