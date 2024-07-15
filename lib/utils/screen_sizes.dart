import 'package:flutter/material.dart';
import 'package:seller_app/utils/colors.dart';

const webScreenWidth = 600;

showSnackBar({required BuildContext context, required String message}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
    ));
}

showAlertDialog(BuildContext context, VoidCallback onPressed, String message) {
  // showDialog(
  //   context: context,
  //   builder: (context) {
  //     return AlertDialog(
  //       elevation: 2,
  //       actionsAlignment: MainAxisAlignment.center,
  //       title: Text(message),
  //       actions: [
  //         TextButton(
  //           onPressed: onPressed,
  //           child: const Text(
  //             'Yes',
  //             style: TextStyle(color: Colors.white),
  //           ),
  //         ),
  //         TextButton(
  //           onPressed: () {
  //             // do noting
  //             Navigator.of(context).pop(context);
  //           },
  //           child: const Text(
  //             'No',
  //             style: TextStyle(color: Colors.white),
  //           ),
  //         )
  //       ],
  //     );
  //   },
  // );

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? Colors.white // Light theme background color
            : Colors.grey[900], // Dark theme background color
        title: Text(
          message,
          style: TextStyle(
            fontSize: 18,
            color: Theme.of(context).brightness == Brightness.light ? Colors.grey[800] : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              onPressed();
            },
            child: Text(
              'Yes',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: primaryColor, // Use theme accent color
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'No',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red[300], // Use theme error color
              ),
            ),
          ),
        ],
      );
    },
  );
}

@immutable
// ignore: must_be_immutable
class EmptyAppbar extends StatelessWidget implements PreferredSizeWidget {
  EmptyAppbar({super.key});

  double height = 100.0;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height * 0.05;
    return SizedBox(
      height: height,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
