import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatefulWidget {
  String? hintText;
  final prefixIcon;
  final suffixIcon;
  final bool? obsecureText;
  TextEditingController? controller;
  String? errorTxt;
  String? errorHint;
  bool? validate;
  final maxlines;
  final minlines;
  final onchange;
  final keyboradType;

  CustomTextField({
    Key? key,
    this.hintText,
    this.errorHint,
    this.prefixIcon,
    this.suffixIcon,
    this.obsecureText,
    this.controller,
    this.maxlines,
    this.minlines,
    this.validate,
    this.onchange,
    this.keyboradType,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Colors.black,
      style: GoogleFonts.montserrat(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Colors.black,
      ),
      obscureText: widget.obsecureText ?? false,
      keyboardType: widget.keyboradType ?? TextInputType.multiline, // Use provided keyboardType or default to TextInputType.multiline
      controller: widget.controller,
      validator: (value) {
        // Use widget.validate to determine whether validation is required
        if (widget.validate != null && widget.validate!) {
          if (value == null || value.isEmpty) {
            return widget.errorTxt ?? '${widget.errorHint}';
          }
        }
        return null; // Return null when validation passes
      },
      onChanged: widget.onchange,
      decoration: InputDecoration(
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
        suffixIconColor: Colors.black,
        contentPadding: EdgeInsets.only(top: 2, left: 15, right: 15),
        border: InputBorder.none,
        hintText: widget.hintText,
        hintStyle: GoogleFonts.openSans(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.black38,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.4), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.black54, width: 1),
        ),
        errorBorder:  OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.black54, width: 1),
        ),
        focusedErrorBorder:  OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.black54, width: 1),
        ),
      ),
    );
  }
}
