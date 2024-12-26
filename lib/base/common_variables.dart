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

const sectionColor = Color(0xFFF0F0F1);

const neutralColor = Color(0xFFF3F4F6);

const disabledColor = Color.fromARGB(255, 178, 178, 178);

const baseBgColor = Color(0xFFF9FAFC);

const selectedColor = Color(0xFFE7EBEF);

TextStyle errorTextStyle(BuildContext context) {
  return TextStyle(color: Theme.of(context).colorScheme.error);
}

const defaultPadding = 16.0;

Color getDataRowColor(BuildContext context, Set<WidgetState> states) {
  if (states.contains(WidgetState.selected)) {
    return labelColor;
  }

  if (states.contains(WidgetState.pressed)) {
    return const Color.fromARGB(255, 200, 207, 218);
  }
  if (states.contains(WidgetState.hovered)) {
    return selectedColor;
  }

  return Colors.transparent;
}

final myIconButtonStyle = IconButton.styleFrom(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
  ),
  padding: const EdgeInsets.all(10),
);
