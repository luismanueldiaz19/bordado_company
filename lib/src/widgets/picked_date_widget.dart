import 'package:flutter/material.dart';

Future showDatePickerCustom({context}) async {
  DateTime selectedDate = DateTime.now();
  DateTime? picked = await showDatePicker(
    context: context,
    initialDate: selectedDate,
    firstDate: DateTime(1900),
    lastDate: DateTime(2100),
  );
  if (picked != null && picked != selectedDate) {
    selectedDate = picked;
    return picked.toString().substring(0, 10);
  } else {
    return null;
  }
}
