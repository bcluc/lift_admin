import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:lift_admin/base/component/menu_item.dart';
import 'package:lift_admin/base/component/side_bar_header.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  bool isCollapsed = false;

  @override
  Widget build(BuildContext context) {
    final fullPath = GoRouterState.of(context).fullPath;
    return AnimatedContainer(
      duration: Durations.medium3,
      width: isCollapsed ? 84 : 320,
      height: double.infinity,
      curve: Curves.fastOutSlowIn,
      child: Ink(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SideBarHeader(
                onPress: () => setState(
                  () {
                    isCollapsed = !isCollapsed;
                  },
                ),
              ),
              const Gap(40),
              ...menuItems.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: MenuItem(
                    iconData: item['icon'],
                    text: item['text'],
                    onPress: () => context.go(item['path']),
                    isSelected: fullPath == item['path'],
                  ),
                ),
              ),
              const Spacer(),
              const Divider(),
              MenuItem(
                iconData: Icons.logout_rounded,
                text: 'Đăng xuất',
                onPress: () async {
                  // await supabase.auth.signOut();
                  if (context.mounted) {
                    context.go('/intro');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Center(
                          child: Text(
                            'Hẹn sớm gặp lại bạn.',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 4),
                        width: 300,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final List<Map<String, dynamic>> menuItems = [
  {
    'path': '/admin/dashboard',
    'icon': Icons.auto_awesome_mosaic_rounded,
    'text': 'Dashboard',
  },
  {
    'path': '/admin/plan-management',
    'icon': Icons.auto_awesome,
    'text': 'Quản lý Gói',
  },
  {
    'path': '/admin/film-management',
    'icon': Icons.filter_b_and_w_rounded,
    'text': 'Quản lý Phim',
  },
  {
    'path': '/admin/topic-management',
    'icon': Icons.topic_rounded,
    'text': 'Quản lý Topic',
  },
  {
    'path': '/admin/account-management',
    'icon': Icons.person_3_rounded,
    'text': 'Quản lý Tài khoản',
  },
];
