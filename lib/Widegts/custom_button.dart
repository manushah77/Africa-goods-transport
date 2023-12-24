import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  String? title;
  Function? onTap;
  Color? txtclr;
  Color? btnclr;
   CustomButton({this.onTap,this.title,this.txtclr,this.btnclr});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 35.0,right: 35),
      child: MaterialButton(
        height: 56,
        minWidth: 260,
        color: btnclr,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        onPressed: () {
          onTap!();
        },
        child: Center(
          child: Text(
            title.toString(),
            style: TextStyle(
              color: txtclr,
            ),
          ),
        ),
      ),
    );
  }
}
