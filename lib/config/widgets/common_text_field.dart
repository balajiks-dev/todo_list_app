import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_list_app/config/colors.dart';
import 'package:todo_list_app/config/styles.dart';

import '../../utils/remove_emoji_input_formatter.dart';

class CommonTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String labelText;
  final bool isMandatory;
  final bool isPassword;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final Color? backgroundColor;
  final Color? labelColor;
  final Color? suffixIconColor;
  final int? maxLength;
  final Widget? prefixIcon;
  final GestureTapCallback? onTap;
  final bool? readOnly;

  const CommonTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.labelText,
    this.inputFormatters,
    this.isMandatory = false,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.backgroundColor,
    this.labelColor,
    this.suffixIconColor,
    this.maxLength,
    this.prefixIcon,
    this.onTap,
    this.readOnly = false,
  });

  @override
  State<CommonTextField> createState() => _RegistrationTextFieldState();
}

class _RegistrationTextFieldState extends State<CommonTextField> {
  bool _obscureText = false;
  bool _isFocused = false;
  late List<TextInputFormatter> _inputFormatters;

  @override
  void initState() {
    super.initState();
    (_inputFormatters = widget.inputFormatters ?? [])
        .add(RemoveEmojiInputFormatter());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0),
      child: Focus(
        onFocusChange: (focused) {
          setState(() {
            _isFocused = focused;
          });
        },
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 12, 10, 10),
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? Colors.white,
            borderRadius: BorderRadius.circular(10.0), // Border radius
            border: Border.all(
              color: AppColors.greyColor,
                width: 0.5,

          ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 5, left: 10, top: 5),
            child: TextFormField(
              onTap: widget.onTap,
              readOnly: widget.readOnly ?? false,
              obscuringCharacter: '*',
              maxLength: widget.maxLength,
              controller: widget.controller,
              cursorColor: widget.labelColor ?? Colors.black,
              keyboardType: widget.keyboardType,
              autocorrect: false,
              style: TextStyles.whiteMedium14.copyWith(
                color: widget.labelColor ?? Colors.black,
              ),
              obscureText: widget.isPassword ? !_obscureText : false,
              inputFormatters: _inputFormatters,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                suffixIconConstraints: const BoxConstraints(
                  maxHeight: 32,
                  minHeight: 20,
                ),
                prefixIcon: widget.prefixIcon,
                suffixIcon: widget.isPassword
                    ? IconButton(
                        onPressed: () {
                          _obscureText = !_obscureText;
                          setState(() {});
                        },
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: widget.suffixIconColor ?? Colors.white,
                          size: 18,
                        ),
                      )
                    : null,
                border: InputBorder.none,
                hintText: widget.hintText,
                hintStyle: TextStyles.whiteRegular14.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: widget.labelColor ?? Colors.black.withOpacity(0.6),
                ),
                label: Text(
                  widget.labelText,
                  style: TextStyles.whiteRegular14.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: widget.labelColor ?? Colors.black.withOpacity(0.6),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
