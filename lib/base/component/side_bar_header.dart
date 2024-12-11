import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lift_admin/base/assets.dart';
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
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: SvgPicture.asset(
              Assets.logo,
              height: 38,
              fit: BoxFit.contain,
              alignment: Alignment.centerLeft,
            ),
          ),
        ),
        IconButton(
          onPressed: onPress,
          icon: const Icon(Icons.menu_rounded),
          style: IconButton.styleFrom(
            foregroundColor: labelColor,
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            // side: const BorderSide(color: secondaryColorSubtitle, width: 1),
          ),
        ),
      ],
    );
  }
}
