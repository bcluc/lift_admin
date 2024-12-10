import 'package:flutter/material.dart';
import 'package:lift_admin/base/common_variables.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Dashboard',
          style: Theme.of(context)
              .textTheme
              .headlineLarge
              ?.copyWith(color: secondaryColorTitle),
        ),
        const Spacer(),
      ],
    );
  }
}
