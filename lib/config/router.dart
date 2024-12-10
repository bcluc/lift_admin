import 'package:go_router/go_router.dart';
import 'package:lift_admin/base/singleton/user_info.dart';
import 'package:lift_admin/data/profile_data.dart';
import 'package:lift_admin/data/service.dart';
import 'package:lift_admin/screens/auth/sign_in.dart';
import 'package:lift_admin/screens/hub/hub_detail.dart';
import 'package:lift_admin/screens/hub/hub_screen.dart';
import 'package:lift_admin/screens/layout.dart';
import 'package:lift_admin/screens/splash_screen.dart';

GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: 'splash',
      redirect: (context, state) async {
        final session = UserInfo().token;
        if (session != null) {
          return UserInfo().role == 'coordinator' ? '/browse' : '/admin/hub';
        }
        return null;
      },
      builder: (ctx, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/sign-in',
      name: 'sign-in',
      redirect: (context, state) async {
        final session = UserInfo().token;
        if (session != null) {
          return UserInfo().role == 'coordinator' ? '/browse' : '/admin/hub';
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
          redirect: (context, state) {
            return '/admin/hub';
          },
        ),
        GoRoute(
          path: '/admin/hub',
          name: 'admin-hub',
          builder: (context, state) => const HubScreen(),
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
          redirect: (context, state) {
            return '/hub/detail';
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
