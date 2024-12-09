import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lift_admin/base/assets.dart';
import 'package:lift_admin/base/common_variables.dart';
import 'package:lift_admin/base/singleton/user_info.dart';
import 'package:shimmer/shimmer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> _redirect() async {
    await Future.delayed(const Duration(seconds: 2));
    final session = UserInfo().token;
    if (mounted) {
      if (session != null) {
        context.go('/browse');
      } else {
        context.go('/sign-in');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // Executes a function only one time after the layout is completed
    WidgetsBinding.instance.addPostFrameCallback((_) => _redirect());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: Shimmer.fromColors(
        baseColor: primaryColor,
        highlightColor: const Color.fromARGB(255, 255, 232, 163),
        child: SvgPicture.asset(
          Assets.logo,
          width: 300,
        ),
      ),
    );
  }
}
