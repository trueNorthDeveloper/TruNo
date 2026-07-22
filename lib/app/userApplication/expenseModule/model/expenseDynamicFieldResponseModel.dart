class ExpenseDynamicFieldResponseModel {
  final bool success;
  final String message;
  final List<DynamicField> data;
  ExpenseDynamicFieldResponseModel(
      {required this.success, required this.message, required this.data});
  factory ExpenseDynamicFieldResponseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseDynamicFieldResponseModel(
      success: json["success"] ?? false,
   message: json["message"] ?? "",
      data: json["data"] == null
          ? []
          : List<DynamicField>.from(
              json["data"].map((x) => DynamicField.fromJson(x))),
    );
  }
}

class DynamicField {
  final int id;
  final String fieldName;
  final String fieldType;
  final String fieldLabel;
  final bool isRequired;
  final bool isDropdown;
  final List<Options> optionss;
  DynamicField(
      {required this.id,
      required this.fieldLabel,
      required this.fieldName,
      required this.fieldType,
      required this.isRequired,
      required this.isDropdown,
      required this.optionss});
  factory DynamicField.fromJson(Map<String, dynamic> json) => DynamicField(
        id: json["id"] ?? 0,
        fieldName: json["fieldName"] ?? "",
        fieldType: json["fieldType"] ?? "",
        fieldLabel: json["fieldLabel"] ?? "",
        isRequired: json["isRequired"] ?? false,
        isDropdown: json["isDropdown"] ?? false,
        optionss: json["optionss"] == null
            ? []
            : List<Options>.from(
                json["optionss"].map((x) => Options.fromJson(x))),
      );
}

class Options {
  final String label;
  final double value;
  Options({required this.label, required this.value});
  factory Options.fromJson(Map<String, dynamic> json) => Options(
      label: json["label"] ?? "",
      value: (json["value"] as num?)?.toDouble() ?? 0,
    );
}
