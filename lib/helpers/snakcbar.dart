import 'package:flutter/material.dart';

class SnackBarHelper extends StatelessWidget {
  BuildContext scaffoldContext;

  SnackBar snackBar;

  SnackBarHelper(this.snackBar);

  @override
  Widget build(BuildContext context) {
    scaffoldContext = context;
    showSnackBar(snackBar);
    return Container();
  }

  showSnackBar(SnackBar snackBar) async {
    Scaffold.of(scaffoldContext).showSnackBar(snackBar);
  }
}
