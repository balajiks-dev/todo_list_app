import 'package:todo_list_app/config/styles.dart';
import 'package:flutter/material.dart';

SnackBar snackBarWidget(
  String error, {
  int seconds = 3,
  bool isError = false,
  bool isBottom = false,
}) {
  return SnackBar(
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    margin: EdgeInsets.zero,
    duration: Duration(seconds: seconds),
    backgroundColor: isError ? Colors.red : Colors.green,
    behavior: SnackBarBehavior.floating,
    content: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Text(
          error,
          style: TextStyles.whiteRegular14,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
      ),
    ),
  );
}

class CustomSnackBar {
  static void show(
    BuildContext context,
    String error, {
    int seconds = 3,
    bool isError = false,
    bool isBottom = false,
  }) {
    OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (BuildContext context) => Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Material(
          elevation: 5,
          child: Container(
            decoration: BoxDecoration(
              color: isError ? Colors.red : Colors.green,
            ),
            padding: const EdgeInsets.symmetric(vertical: 22.0),
            child: Center(
              child: Text(
                error,
                style: TextStyles.whiteRegular14,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);

    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }
}
