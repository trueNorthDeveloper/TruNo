class Expensesubmitrequest {
  dynamic categoryId;
  dynamic expenseDate;
  dynamic expenseAmount;
  List<DynamicFieldRequest>? dynamicField;
  //Expensesubmitrequest(this.categoryId, this.expenseDate, this.expenseAmount);
  Map<String, dynamic> toJson() => {
        "categoryId": categoryId,
        "expenseDate": expenseDate,
        "expenseAmount": expenseAmount,
        "dynamicField": dynamicField != null
            ? dynamicField!
                .map((item) => item.toJson())
                .toList() // Changed dynamicField.toJson to item.toJson()
            : null,
      };
}

class DynamicFieldRequest {
  dynamic filedId;
  dynamic value;
  Map<dynamic, dynamic> toJson() => {
        "filedId": filedId,
        "value": value,
      };
}
