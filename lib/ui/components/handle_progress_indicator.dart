import 'package:flutter/material.dart';

void handleProgressIndicator(BuildContext context, bool? isLoading) {
  if (isLoading == true) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const SimpleDialog(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(height: 10),
                Text('Aguarde...', textAlign: TextAlign.center),
              ],
            ),
          ],
        );
      },
    );
  } else {
    if (context.mounted) {
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
    }
  }
}
