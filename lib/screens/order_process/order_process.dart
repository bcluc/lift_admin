import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:lift_admin/base/common_variables.dart';
import 'package:lift_admin/base/component/pagination.dart';
import 'package:lift_admin/base/component/search_field.dart';
import 'package:lift_admin/data/dto/order_dto.dart';
import 'package:lift_admin/data/service.dart';
import 'package:lift_admin/screens/order_process/components/detail_order_form.dart';
import 'package:lift_admin/screens/order_process/components/order_section.dart';
import 'package:localstorage/localstorage.dart';

class OrderProcessScreen extends StatefulWidget {
  const OrderProcessScreen({super.key});

  @override
  State<OrderProcessScreen> createState() => _OrderProcessScreenState();
}

class _OrderProcessScreenState extends State<OrderProcessScreen> {
  final List<String> statuses = [
    "pending",
    "inProgress",
    "success",
    "failed",
    "canceled"
  ];

  @override
  Widget build(BuildContext context) {
    if (localStorage.getItem('token') == null) {
      context.go('/sign-in');
    }
// pending, inProgress, success, failed, canceled
    return Scaffold(
        backgroundColor: baseBgColor,
        body: Container(
          margin: const EdgeInsets.fromLTRB(20, 40, 20, 40),
          child: SingleChildScrollView(
            child: Column(
              children: [
                for (var status in statuses) ...[
                  OrderSection(status: status),
                  const Gap(10),
                ],
              ],
            ),
          ),
        ));
  }
}
