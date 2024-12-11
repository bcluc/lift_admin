import 'package:flutter/material.dart';
import 'package:lift_admin/base/common_variables.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
        decoration: InputDecoration(
      fillColor: secondaryColorBg,
      filled: true,
      hintText: 'Tìm kiếm',
      iconColor: subtitleColor,
      hintStyle: const TextStyle(color: subtitleColor),
      border: const OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      suffixIcon: InkWell(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.all(defaultPadding * 0.6),
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.search,
            color: Colors.white,
          ),
        ),
      ),
    ));
  }
}
