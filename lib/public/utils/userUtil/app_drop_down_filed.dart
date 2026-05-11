import 'package:flutter/material.dart';

class AppDropdownField<T> extends StatelessWidget {
  const AppDropdownField({
    super.key,
    required this.items,
    required this.onChanged,
    this.value,
    this.label,
    this.hint,
    this.validator,
    this.prefixIcon,
    this.borderRadius = 14,
    this.fillColor,
    this.filled = true,
  });

  final List<DropdownMenuItem<T>> items;
  final T? value;
  final String? label;
  final String? hint;
  final Widget? prefixIcon;
  final double borderRadius;
  final Color? fillColor;
  final bool filled;

  final void Function(T?) onChanged;
  final String? Function(T?)? validator;

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

    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      validator: validator,
      onChanged: onChanged,

      decoration: InputDecoration(
        labelText: label,
        hintText: hint,

        prefixIcon: prefixIcon,

        filled: filled,
        fillColor:
            fillColor ?? theme.colorScheme.surfaceContainerHighest,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),

        border: border(Colors.grey.shade400),
        enabledBorder: border(Colors.grey.shade400),
        focusedBorder: border(theme.primaryColor),
        errorBorder: border(Colors.red),
        focusedErrorBorder: border(Colors.redAccent),
      ),
    );
  }
}