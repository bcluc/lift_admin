import 'package:flutter/material.dart';
import 'package:lift_admin/base/common_variables.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    required this.controller,
    required this.onSearch,
    this.hintText,
  });

  final TextEditingController controller;
  final String? hintText;
  final void Function(String) onSearch;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            onEditingComplete: () => onSearch(controller.text),
            onChanged: (value) async {
              if (value.isEmpty) {
                await Future.delayed(
                  const Duration(milliseconds: 50),
                );
                onSearch("");
              }
            },
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              hintText: 'Search',
              iconColor: subtitleColor,
              hintStyle: const TextStyle(color: subtitleColor),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(color: labelColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(color: subtitleColor.withOpacity(0.5)),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        FilledButton(
          onPressed: () => onSearch(controller.text),
          style: FilledButton.styleFrom(
            iconColor: Colors.white,
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 38),
          ),
          child: const Icon(Icons.search),
        )
      ],
    );
  }
}
