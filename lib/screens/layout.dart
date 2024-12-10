import 'package:flutter/material.dart';
import 'package:lift_admin/base/component/side_bar.dart';

class Layout extends StatefulWidget {
  const Layout({
    super.key,
    required this.child,
  });
  final Widget child;

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  Future<void> fetchData() async {
    //await fetchTopicsData();
    await Future.delayed(const Duration(milliseconds: 3));
    setState(() {
      isFetchingData = false;
    });
  }

  bool isFetchingData = true;

  @override
  void initState() {
    super.initState();
    fetchData();
    WidgetsBinding.instance.addPostFrameCallback((_) async {});
    // Executes a function only one time after the layout is completed*/
  }

  @override
  Widget build(BuildContext context) {
    return isFetchingData
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            backgroundColor: Colors.white,
            body: Row(
              children: [
                const SideBar(),
                Expanded(
                  child: widget.child,
                ),
              ],
            ),
          );
  }
}
