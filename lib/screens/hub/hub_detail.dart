import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:localstorage/localstorage.dart';

class HubDetail extends StatefulWidget {
  const HubDetail({super.key});

  @override
  State<HubDetail> createState() => _HubDetailState();
}

class _HubDetailState extends State<HubDetail> {
  @override
  Widget build(BuildContext context) {
    if (localStorage.getItem('token') == null) {
      context.go('/sign-in');
    }
    return const Placeholder();
  }
}
