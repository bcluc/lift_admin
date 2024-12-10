import 'package:flutter/material.dart';
import 'package:lift_admin/base/common_variables.dart';
import 'package:lift_admin/base/component/header.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  @override
  Widget build(BuildContext context) {
    const List<Color> palette = [
      Color.fromARGB(255, 130, 2, 98),
      Color.fromARGB(255, 41, 23, 32),
      Color.fromARGB(255, 193, 42, 90),
      Color.fromARGB(255, 4, 167, 118),
      Color.fromARGB(255, 255, 209, 102),
      Color.fromARGB(255, 255, 81, 81),
    ];

    // print(topicsData.toList());
    // return FutureBuilder(
    //   future: fetchData(),
    //   builder: (context, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return const Center(child: CircularProgressIndicator());
    //     } else if (snapshot.hasError) {
    //       return const Center(child: Text('Error fetching data'));
    //     } else {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const Header(),
            const SizedBox(height: 6),
            const Divider(
              color: secondaryColorBorder,
              thickness: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Container(
                    height: 500,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: secondaryColorBorder,
                        width: 1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: defaultPadding),
                Text('Browse Screen'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
