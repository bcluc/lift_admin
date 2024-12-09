import 'package:go_router/go_router.dart';
import 'package:lift_admin/base/singleton/user_info.dart';
import 'package:lift_admin/data/profile_data.dart';
import 'package:lift_admin/data/service.dart';
import 'package:lift_admin/screens/auth/sign_in.dart';
import 'package:lift_admin/screens/splash_screen.dart';

GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: 'splash',
      redirect: (context, state) async {
        //final session = supabase.auth.currentSession;
        // if (session != null) {
        //   return await getRole() == 'end-user' ? '/browse' : '/admin/dashboard';
        // }
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
          return UserInfo().role == 'coordinator'
              ? '/browse'
              : '/admin/dashboard';
        }
        return null;
      },
      builder: (ctx, state) => const SignInScreen(),
    ),
  ],
);
