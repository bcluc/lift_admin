import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final vnDateFormat = DateFormat('dd/MM/yyyy');

const Color primaryColor = Color.fromARGB(255, 245, 192, 57);

const secondaryColor = Color.fromARGB(255, 255, 81, 81);

const secondaryColorBg = Color.fromARGB(255, 250, 250, 250);

const secondaryColorSideBorder = Color.fromARGB(255, 241, 241, 241);

const secondaryColorSubtitle = Color(0xFF686868);

const secondaryColorBorder = Color.fromARGB(255, 217, 217, 217);

const secondaryColorTitle = Color.fromARGB(255, 48, 48, 48);

const secondaryColorDisable = Color.fromARGB(255, 178, 178, 178);

const secondaryColorBaseBg = Color.fromARGB(255, 255, 239, 231);
TextStyle errorTextStyle(BuildContext context) {
  return TextStyle(color: Theme.of(context).colorScheme.error);
}

const defaultPadding = 16.0;
