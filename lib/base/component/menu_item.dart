import 'package:flutter/material.dart';
import 'package:lift_admin/base/common_variables.dart';

class MenuItem extends StatelessWidget {
  const MenuItem({
    super.key,
    required this.iconData,
    required this.text,
    this.isSelected = false,
    required this.onPress,
  });

  final IconData iconData;
  final String text;
  final bool isSelected;
  final void Function() onPress;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      highlightColor: Colors.white.withOpacity(0.02),
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.hovered)) {
          return Colors.white.withOpacity(0.06);
        }
        return null;
      }),
      borderRadius: BorderRadius.circular(8),
      child: Ink(
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withOpacity(0.08) : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: Icon(
                iconData,
                color: isSelected ? primaryColor : labelColor,
              ),
            ),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : labelColor,
                ),
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
