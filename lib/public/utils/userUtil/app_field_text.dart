import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.hint,
    this.initialValue,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onChanged,
    this.onTap,
    this.onFieldSubmitted,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.autofocus = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.inputFormatters,
    this.contentPadding,
    this.borderRadius = 14,
    this.fillColor,
    this.filled = true,
    this.textCapitalization = TextCapitalization.none,
    this.textAlign = TextAlign.start,
    this.style,
    this.hintStyle,
    this.labelStyle,
    this.autofillHints,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String? hint;
  final String? initialValue;

  final Widget? prefixIcon;
  final Widget? suffixIcon;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  final String? Function(String?)? validator;

  final void Function(String)? onChanged;
  final void Function()? onTap;
  final void Function(String)? onFieldSubmitted;

  final bool obscureText;
  final bool readOnly;
  final bool enabled;
  final bool autofocus;

  final int maxLines;
  final int? minLines;
  final int? maxLength;

  final List<TextInputFormatter>? inputFormatters;

  final EdgeInsetsGeometry? contentPadding;

  final double borderRadius;

  final Color? fillColor;
  final bool filled;

  final TextCapitalization textCapitalization;
  final TextAlign textAlign;

  final TextStyle? style;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;

  final Iterable<String>? autofillHints;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    OutlineInputBorder border(Color color) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(
          color: color,
          width: 1.2,
        ),
      );
    }

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      initialValue: initialValue,
      validator: validator,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      readOnly: readOnly,
      enabled: enabled,
      autofocus: autofocus,
      maxLines: obscureText ? 1 : maxLines,
      minLines: minLines,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      textCapitalization: textCapitalization,
      textAlign: textAlign,
      style: style,
      autofillHints: autofillHints,
      onChanged: onChanged,
      onTap: onTap,
      onFieldSubmitted: onFieldSubmitted,
      cursorColor: theme.primaryColor,

      decoration: InputDecoration(
        labelText: label,
        hintText: hint,

        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,

        filled: filled,
        fillColor:
            fillColor ?? theme.colorScheme.surfaceContainerHighest,

        contentPadding:
            contentPadding ??
            const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 18,
            ),

        hintStyle: hintStyle,
        labelStyle: labelStyle,

        border: border(Colors.grey.shade400),

        enabledBorder: border(Colors.grey.shade400),

        focusedBorder: border(theme.primaryColor),

        errorBorder: border(Colors.red),

        focusedErrorBorder: border(Colors.redAccent),

        disabledBorder: border(Colors.grey.shade300),

        errorStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}