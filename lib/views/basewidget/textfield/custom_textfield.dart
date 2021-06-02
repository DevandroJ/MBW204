import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mbw204_club_ina/utils/colorResources.dart';

import 'package:mbw204_club_ina/utils/custom_themes.dart';

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$').hasMatch(this);
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType textInputType;
  final int maxLine;
  final FocusNode focusNode;
  final FocusNode nextNode;
  final TextInputAction textInputAction;
  final bool isShortBio;
  final bool isAddress;
  final bool isPhoneNumber;
  final bool isValidator;
  final String validatorMessage;
  final Color fillColor;

  CustomTextField({this.controller,
    this.hintText,
    this.textInputType,
    this.maxLine,
    this.focusNode,
    this.nextNode,
    this.textInputAction,
    this.isShortBio = false,
    this.isAddress = false,
    this.isPhoneNumber = false,
    this.isValidator=false,
    this.validatorMessage,
    this.fillColor
  });

  @override
  Widget build(context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).accentColor,
        borderRadius: isPhoneNumber 
        ? BorderRadius.only(
            topRight: Radius.circular(6), 
            bottomRight: Radius.circular(6)
          ) 
        : BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1), 
            spreadRadius: 1.0, 
            blurRadius: 3.0, 
            offset: Offset(0.0, 1.0)
          ) // changes position of shadow
        ],
      ),
      child: TextFormField(
        cursorColor: ColorResources.getBlackToWhite(context),
        controller: controller,
        maxLines: maxLine ?? isAddress || isShortBio ? 3 : 1,
        maxLength: isPhoneNumber ? 15 : null,
        focusNode: focusNode,
        keyboardType: textInputType ?? TextInputType.text,
        initialValue: null,
        textInputAction: textInputAction ?? TextInputAction.next,
        onFieldSubmitted: (v) {
          FocusScope.of(context).requestFocus(nextNode);
        },
        inputFormatters: [isPhoneNumber ? FilteringTextInputFormatter.digitsOnly : FilteringTextInputFormatter.singleLineFormatter],
        validator: (input){
          if(input.isEmpty){
            if(isValidator){
              return validatorMessage?? "";
            }
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: hintText ?? '',
          filled: fillColor != null,
          fillColor: fillColor,
          contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
          isDense: true,
          counterText: '',
          hintStyle: titilliumRegular.copyWith(color: Theme.of(context).hintColor),
          errorStyle: TextStyle(height: 1.5),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
              width: 0.5
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
              width: 0.5
            ),
          ),
        ),
      ),
    );
  }
}
