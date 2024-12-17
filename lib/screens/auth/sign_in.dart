// import 'dart:convert';
// import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:gotrue/gotrue.dart';
import 'package:lift_admin/base/assets.dart';
import 'package:lift_admin/base/common_variables.dart';
import 'package:lift_admin/base/component/password_input.dart';
import 'package:lift_admin/data/service.dart';
import 'package:localstorage/localstorage.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isProcessing = false;

  String _errorText = '';

  void _submit() async {
    // check
    final enteredUserName = _userNameController.text;
    final enteredPassword = _passwordController.text;

    _errorText = '';
    if (enteredUserName.isEmpty) {
      _errorText = 'User name is missing';
    } else if (enteredPassword.isEmpty) {
      _errorText = 'Password is missing';
    }

    if (_errorText.isNotEmpty) {
      setState(() {});
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final authRes = await signIn(enteredUserName, enteredPassword);

      // final authRes = await supabase.auth.signInWithPassword(
      //   email: enteredUserName,
      //   password: enteredPassword,
      // );

      int count = await queryCountHub();
      print("COUNT NE");
      print(count);

      // UserInfo().token = authRes.token;
      // UserInfo().id = authRes.id;
      // UserInfo().role = authRes.role;
      // UserInfo().userName = authRes.userName;
      print(localStorage.getItem('token'));

      if (authRes.token != null) {
        // await fetchProfileData();
        // print(UserInfo().token);

        if (mounted) {
          // print(UserInfo().userName);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Center(
                child: Text(
                  'Sign in success.',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 4),
              width: 300,
            ),
          );
          //context.go('/admin/hub');
          if (authRes.role == 'administrator') {
            context.go('/admin/hub');
          } else if (authRes.role == 'coordinator') {
            context.go('/hub/detail');
          }
        }
      }
    } on AuthException catch (error) {
      if (mounted) {
        // print(error.message);
        if (error.message == "Invalid login credentials") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid login credentials'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.message),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        setState(() {
          _isProcessing = false;
        });
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('There is something wrong.'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (localStorage.getItem('token') == null) {
      context.go('/sign-in');
    } else {
      if (localStorage.getItem('role') == 'administrator') {
        context.go('/admin');
      } else if (localStorage.getItem('role') == 'coordinator') {
        context.go('/hub');
      }
    }
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        Assets.logoImg,
                        width: 50,
                        fit: BoxFit.cover,
                      ),
                      const Spacer(),
                    ],
                  ),
                  Expanded(
                    child: Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Sign in',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 28,
                              ),
                            ),
                            const SizedBox(height: 40),
                            Ink(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color.fromARGB(
                                      255, 209, 213, 219), // Màu sắc của border
                                  width: 1, // Độ rộng của border
                                ),
                                borderRadius: BorderRadius.circular(
                                    10), // Bán kính của border
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 12),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'User name',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextField(
                                    controller: _userNameController,
                                    autofocus: true,
                                    decoration: const InputDecoration(
                                      hintText: 'user name',
                                      hintStyle:
                                          TextStyle(color: Color(0xFFACACAC)),
                                      border: InputBorder.none,
                                      contentPadding:
                                          EdgeInsets.fromLTRB(0, 8, 0, 8),
                                      isCollapsed: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Gap(14),
                            PasswordTextField(
                              passwordController: _passwordController,
                              onEditingComplete: _submit,
                            ),
                            // const SizedBox(height: 10),
                            // InkWell(
                            //   onTap: () {},
                            //   child: const Text(
                            //     'Quên mật khẩu',
                            //     style: TextStyle(
                            //       color: Colors.black,
                            //       fontWeight: FontWeight.bold,
                            //     ),
                            //   ),
                            // ),
                            const SizedBox(height: 20),
                            // ignore: unnecessary_null_comparison
                            if (_errorText != null)
                              Align(
                                child: Text(
                                  _errorText,
                                  style: errorTextStyle(context),
                                ),
                              ),
                            const SizedBox(height: 12),
                            Align(
                              child: _isProcessing
                                  ? const SizedBox(
                                      height: 44,
                                      width: 44,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 3,
                                      ),
                                    )
                                  : FilledButton(
                                      onPressed: _submit,
                                      style: FilledButton.styleFrom(
                                        padding: const EdgeInsets.all(20),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        backgroundColor: primaryColor,
                                      ),
                                      child: const Text(
                                        'Sign in',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Color.fromARGB(255, 9, 14, 35),
                    Color.fromARGB(255, 18, 38, 71)
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(80),
                child: Image.asset(
                  Assets.authBanner, // Replace with your actual asset path
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
