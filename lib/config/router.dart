import 'package:go_router/go_router.dart';
import 'package:lift_admin/base/singleton/user_info.dart';
import 'package:lift_admin/screens/account/account_screen.dart';
import 'package:lift_admin/screens/auth/sign_in.dart';
import 'package:lift_admin/screens/complaint/complaint_screen.dart';
import 'package:lift_admin/screens/hub/hub_detail.dart';
import 'package:lift_admin/screens/hub/hub_screen.dart';
import 'package:lift_admin/screens/layout.dart';
import 'package:lift_admin/screens/order_process/order_process.dart';
import 'package:lift_admin/screens/regulation/regulation_screen.dart';
import 'package:lift_admin/screens/splash_screen.dart';

GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: 'splash',
      redirect: (context, state) async {
        final token = UserInfo().token;
        if (token != null) {
          return UserInfo().role == 'coordinator' ? '/hub' : '/admin/hub';
        }
        return null;
      },
      builder: (ctx, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/sign-in',
      name: 'sign-in',
      redirect: (context, state) async {
        final token = UserInfo().token;
        if (token != null) {
          return UserInfo().role == 'coordinator' ? '/hub' : '/admin/hub';
        }
        return null;
      },
      builder: (ctx, state) => const SignInScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) {
        return Layout(child: child);
      },
      routes: [
        GoRoute(
          path: '/admin',
          name: 'admin',
          redirect: (context, state) async {
            final token = UserInfo().token;
            // print('Token role: ${UserInfo().role}');
            // print(token);
            if (token == null) {
              return '/sign-in';
            } else {
              if (UserInfo().role == 'coordinator') {
                return '/hub';
              }
            }
            return 'admin/hub';
          },
        ),
        GoRoute(
          path: '/admin/hub',
          name: 'admin-hub',
          builder: (context, state) => const HubScreen(),
        ),
        GoRoute(
          path: '/admin/account',
          name: 'admin-account',
          builder: (context, state) => const AccountScreen(),
        ),
        GoRoute(
          path: '/admin/process',
          name: 'admin-process',
          builder: (context, state) => const OrderProcessScreen(),
        ),
        GoRoute(
          path: '/admin/complaint',
          name: 'admin-complaint',
          builder: (context, state) => const ComplaintScreen(),
        ),
        GoRoute(
          path: '/admin/regulation',
          name: 'admin-regulation',
          builder: (context, state) => const RegulationScreen(),
        ),
      ],
    ),
    ShellRoute(
      builder: (context, state, child) {
        return Layout(child: child);
      },
      routes: [
        GoRoute(
          path: '/hub',
          name: 'hub',
          redirect: (context, state) async {
            final token = UserInfo().token;
            // print('Token role: ${UserInfo().role}');
            // print(token);
            if (token == null) {
              return '/sign-in';
            } else {
              if (UserInfo().role == 'administrator') {
                return '/admin/hub';
              }
            }
            return null;
          },
        ),
        GoRoute(
          path: '/hub/detail',
          name: 'detail',
          builder: (context, state) => const HubDetail(),
        ),
      ],
    ),
  ],
);
