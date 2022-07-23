import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../Utils/app_colors.dart';
import '../../../Utils/dimensions.dart';

class ProfileTextInputFieldView extends StatefulWidget {
  final icon;
  final hintText;
  final onChanged;
  final controller;
  final hintColor;
  final keyboardType;
  final textCapitalization;
  final inputFormatters;
  final bool isPassword;
  final bool readOnly;

  const ProfileTextInputFieldView({
    Key? key,
    required this.icon,
    required this.hintText,
    this.onChanged,
    this.controller,
    this.hintColor,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.isPassword = false,
    this.readOnly = false,
  }) : super(key: key);

  @override
  State<ProfileTextInputFieldView> createState() => _ProfileTextInputFieldViewState();
}

class _ProfileTextInputFieldViewState extends State<ProfileTextInputFieldView> {
  bool isObscure = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isObscure = widget.isPassword == true;
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      width: Dimensions.screenWidth(context: context),
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(color: AppColors.grey, blurRadius: 1)]),
      child: TextFormField(
        inputFormatters: widget.inputFormatters,
        readOnly: widget.readOnly,
        textCapitalization: widget.textCapitalization,
        keyboardType: widget.keyboardType,
        obscureText: isObscure,
        onChanged: widget.onChanged,
        controller: widget.controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: widget.hintColor,
          ),
          prefixIcon: Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: AppColors.grey.withAlpha(15),
                borderRadius: BorderRadius.circular(10)),
            child: Icon(
              widget.icon,
              color: AppColors.black,
            ),
          ),
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    isObscure ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      isObscure = !isObscure;
                    });
                  },
                )
              : SizedBox(),
        ),
      ),
    );
  }
}
