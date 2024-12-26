import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:lift_admin/base/common_variables.dart';
import 'package:lift_admin/base/component/menu_item.dart';
import 'package:lift_admin/base/component/side_bar_header.dart';
import 'package:localstorage/localstorage.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  bool isCollapsed = false;
  List<Map<String, dynamic>> menuItems = [];
  @override
  void initState() {
    super.initState();
    _setMenuItems();
  }

  Future<void> _setMenuItems() async {
    final role = localStorage.getItem('role');

    if (role != null && role == 'administrator') {
      setState(() {
        menuItems = [
          {
            'path': '/admin/hub',
            'icon': Icons.house_rounded,
            'text': 'Hubs',
          },
          {
            'path': '/admin/account',
            'icon': Icons.person_3_rounded,
            'text': 'Accounts',
          },
          {
            'path': '/admin/process',
            'icon': Icons.monitor_heart_rounded,
            'text': 'Order processing',
          },
        ];
      });
    } else {
      setState(() {
        menuItems = [
          {
            'path': '/hub/detail',
            'icon': Icons.home_rounded,
            'text': 'Detail',
          },
          {
            'path': '/hub/order',
            'icon': Icons.delivery_dining_rounded,
            'text': 'Order',
          },
          {
            'path': '/hub/staff',
            'icon': Icons.people_rounded,
            'text': 'Staff',
          },
          // Add more items as needed
        ];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final fullPath = GoRouterState.of(context).fullPath;
    return AnimatedContainer(
      duration: Durations.medium3,
      width: isCollapsed ? 84 : 260,
      height: double.infinity,
      curve: Curves.fastOutSlowIn,
      child: Ink(
        color: sideBorderBgColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const Gap(10),
              SideBarHeader(
                onPress: () => setState(
                  () {
                    isCollapsed = !isCollapsed;
                  },
                ),
              ),
              const Gap(6),
              const Divider(
                color: Color.fromARGB(34, 255, 255, 255),
              ),
              const Gap(40),
              ...menuItems.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: MenuItem(
                    iconData: item['icon'],
                    text: item['text'],
                    onPress: () => context.go(item['path']),
                    isSelected: fullPath == item['path'],
                  ),
                ),
              ),
              const Spacer(),
              // MenuItem(
              //   iconData: Icons.logout_rounded,
              //   text: 'Đăng xuất',
              //   onPress: () async {
              //     // await supabase.auth.signOut();
              //     if (context.mounted) {
              //       context.go('/intro');
              //       ScaffoldMessenger.of(context).showSnackBar(
              //         const SnackBar(
              //           content: Center(
              //             child: Text(
              //               'Hẹn sớm gặp lại bạn.',
              //               style: TextStyle(
              //                   fontWeight: FontWeight.bold, fontSize: 20),
              //             ),
              //           ),
              //           behavior: SnackBarBehavior.floating,
              //           duration: Duration(seconds: 4),
              //           width: 300,
              //         ),
              //       );
              //     }
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
