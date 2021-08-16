import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'package:mbw204_club_ina/utils/colorResources.dart';
import 'package:mbw204_club_ina/utils/custom_themes.dart';

class CustomDropDownFormField extends FormField<dynamic> {
  final String titleText;
  final Color titleColor;
  final String hintText;
  final bool required;
  final String errorText;
  final dynamic value;
  final List dataSource;
  final String textField;
  final String valueField;
  final Function onChanged;
  final bool filled;
  final EdgeInsets contentPadding;

  CustomDropDownFormField(
      {FormFieldSetter<dynamic> onSaved,
      FormFieldValidator<dynamic> validator,
      bool autovalidate = false,
      this.titleText = '',
      this.titleColor = ColorResources.WHITE,
      this.hintText = 'Select one option',
      this.required = false,
      this.errorText = 'Please select one option',
      this.value,
      this.dataSource,
      this.textField,
      this.valueField,
      this.onChanged,
      this.filled = true,
      this.contentPadding = const EdgeInsets.fromLTRB(0, 0, 0, 0)})
      : super(
          onSaved: onSaved,
          validator: validator,
          autovalidateMode: AutovalidateMode.always,
          initialValue: value == '' ? null : value,
          builder: (FormFieldState<dynamic> state) {
            return Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InputDecorator(
                    decoration: InputDecoration(
                      contentPadding: contentPadding,
                      labelText: titleText,
                      labelStyle: poppinsRegular.copyWith(
                        color: titleColor,
                        fontSize: 12.0.sp
                      ),
                      filled: filled,
                      hintStyle: poppinsRegular.copyWith(
                        fontSize: 9.0.sp
                      )
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<dynamic>(
                        hint: Text(hintText,
                          style: poppinsRegular.copyWith(
                            color: Colors.grey,
                            fontSize: 9.0.sp
                          ),
                        ),
                        style: poppinsRegular.copyWith(
                          fontSize: 9.0.sp
                        ),
                        value: value == '' ? null : value,
                        onChanged: (dynamic newValue) {
                          state.didChange(newValue);
                          onChanged(newValue);
                        },
                        items: dataSource.map((item) {
                          return DropdownMenuItem<dynamic>(
                            value: item[valueField],
                            child: Text(item[textField],
                              overflow: TextOverflow.ellipsis,
                              style: poppinsRegular.copyWith(
                                color: ColorResources.BTN_PRIMARY_SECOND,
                                fontSize: 9.0.sp
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(height: state.hasError ? 5.0 : 0.0),
                  Text(
                    state.hasError ? state.errorText : '',
                    style: poppinsRegular.copyWith(
                      color: Colors.redAccent.shade700,
                      fontSize: state.hasError ? 12.0 : 0.0
                    ),
                  ),
                ],
              ),
            );
          },
        );
}