import 'package:flutter/material.dart';
import 'package:lift_admin/base/common_variables.dart';

class SideBarHeader extends StatelessWidget {
  const SideBarHeader({
    super.key,
    required this.onPress,
  });

  final void Function() onPress;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onPress,
          icon: const Icon(Icons.menu_rounded),
          style: IconButton.styleFrom(
            foregroundColor: secondaryColorSubtitle,
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            // side: const BorderSide(color: secondaryColorSubtitle, width: 1),
          ),
        ),
        const Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'System Admin',
                  style: TextStyle(color: secondaryColorTitle),
                  maxLines: 1,
                ),
                Text('admin@viovid.com',
                    maxLines: 1, style: TextStyle(color: secondaryColorTitle))
              ],
            ),
          ),
        ),
      ],
    );
  }
}
