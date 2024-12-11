import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final vnDateFormat = DateFormat('dd/MM/yyyy');

const Color primaryColor = Color.fromARGB(255, 245, 192, 57);

const secondaryColor = Color(0xFF2D4A79);

const secondaryColorBg = Color(0xFFF5EED8);

const sideBorderBgColor = Color(0xFF1C2536);

const subtitleColor = Color(0xFF686868);

const borderColor = Color(0xFF9CA3AF);

const labelColor = Color(0xFFD1D5DB);

const disabledColor = Color.fromARGB(255, 178, 178, 178);

const baseBgColor = Color(0xFFF9FAFC);

TextStyle errorTextStyle(BuildContext context) {
  return TextStyle(color: Theme.of(context).colorScheme.error);
}

const defaultPadding = 16.0;
