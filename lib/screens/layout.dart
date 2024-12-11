import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lift_admin/base/common_variables.dart';
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
            backgroundColor: baseBgColor,
            body: Row(
              children: [
                const SideBar(),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Spacer(),
                            IconButton(
                              iconSize: 32,
                              onPressed: () async {
                                if (context.mounted) {
                                  context.go('/sign-in');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Center(
                                        child: Text(
                                          'See you later.',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                      ),
                                      behavior: SnackBarBehavior.floating,
                                      duration: Duration(seconds: 4),
                                      width: 300,
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(Icons.exit_to_app_rounded),
                              color: borderColor,
                            ),
                          ],
                        ),
                      ),
                      Expanded(child: widget.child),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
