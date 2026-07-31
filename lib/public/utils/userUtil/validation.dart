class Validation {
  final RegExp phoneRegex = RegExp(r'^[0-9]{10}$');

  //validate if does not contain number in field
  //-----------------------------start---------------------
  static String? validateNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Field cannot be empty';
    }
    final n = num.tryParse(value);
    if (n == null) {
      return 'Please enter a valid number';
    }
    if (n == 0) {
      return 'Please enter more than zero';
    }
    return null; // Valid number
  }
  //-----------------------------end----------
  //----------------------------------dynamic validation if any dynamic value has...............................

  static String? Function(String?) dynamicNumberValidation(
      {required num min, required num max}) {
    return (String? value) {
      if (value == null || value.trim().isEmpty) {
        return 'Field cannot be empty';
      }
      final n = num.tryParse(value);
      if (n == null) {
        return 'Please enter a valid number';
      }
      // Dynamic range checks
      if (n < min) {
        return 'Value must be at least $min';
      }
      if (n > max) {
        return 'Value cannot exceed $max';
      }
      return null;
    };
  }

  // Dynamic number validation with optional limits
  static String? validateDynamicNumber({
    required String? value,
    required String fieldLabel,
    required bool isRequired,
    num? maxLimit,
  }) {
    // 1. Check if required
    if (isRequired && (value == null || value.trim().isEmpty)) {
      return "$fieldLabel is required";
    }
    if (value == null || value.trim().isEmpty) return null;

    // 2. Check if valid number
    final amount = num.tryParse(value);
    if (amount == null) {
      return "Enter a valid amount";
    }

    // 3. Dynamic maximum amount check (if present)
    if (maxLimit != null && amount > maxLimit) {
      return "Maximum ₹$maxLimit allowed";
    }

    return null;
  }
}
