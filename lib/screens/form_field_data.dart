import 'package:flutter/material.dart';

class FormFieldData {
  final String label;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;

  FormFieldData({
    required this.label,
    this.validator,
    this.keyboardType = TextInputType.text,
  });
}