import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:lift_admin/base/common_variables.dart';
import 'package:lift_admin/data/dto/delivery_dto.dart';
import 'package:lift_admin/data/dto/order_dto.dart';
import 'package:lift_admin/data/service.dart';
import 'package:lift_admin/screens/hub/components/assign_order_dialog.dart';
import 'package:lift_admin/screens/hub/components/detail_delivery_form.dart';
import 'package:lift_admin/screens/order_process/components/detail_order_form.dart';
import 'package:localstorage/localstorage.dart';

class HubDetail extends StatefulWidget {
  const HubDetail({super.key});

  @override
  State<HubDetail> createState() => _HubDetailState();
}

class _HubDetailState extends State<HubDetail> {
  //final _maxRow = 99;
  int _selectedOrderRow = -1;
  int _selectedDeliverRow = -1;
  // ignore: non_constant_identifier_names
  late List<OrderDto> _OrderRows;
  // ignore: non_constant_identifier_names
  late List<DeliveryDto> _DeliverRows;

  late final Future<void> _futurePendingOrdersDeliveries = _getPending();
  Future<void> _getPending() async {
    await Future.delayed(kTabScrollDuration);
    String hubId = localStorage.getItem('hubId')!;
    //_UserRows = await queryUser(numberRowIgnore: 0);
    await queryHubDetail(hubId: localStorage.getItem('hubId')!);
    _OrderRows =
        await queryOrderWithStatusByHubId(status: 'pending', hubId: hubId);
    print(_OrderRows.length);

    _DeliverRows =
        await queryDeliverWithStatusByHubId(status: 'pending', hubId: hubId);
    print(_DeliverRows.length);
  }

  Future<void> _assignOrder() async {
    final hubId = localStorage.getItem('hubId')!;
    String? message = await showDialog(
      context: context,
      builder: (ctx) => AssignOrderDialog(
        hubId: hubId,
      ),
    );

    // print(message);
    if (message == "success") {
      final newOrderRows =
          await queryOrderWithStatusByHubId(status: 'pending', hubId: hubId);

      final newDeliverRows =
          await queryDeliverWithStatusByHubId(status: 'pending', hubId: hubId);
      setState(() {
        _OrderRows = newOrderRows;
        _DeliverRows = newDeliverRows;
      });
    }
  }

  Future<void> _logicEditOrder() async {
    String? message = await showDialog(
      context: context,
      builder: (ctx) => DetailOrderForm(
        detailOrder: _OrderRows[_selectedOrderRow],
      ),
    );

    // print(message);
    if (message == "updated") {
      setState(() {});
    }
  }

  Future<void> _logicEditDeliver() async {
    String? message = await showDialog(
      context: context,
      builder: (ctx) => DetailDeliveryForm(
        detailDelivery: _DeliverRows[_selectedDeliverRow],
      ),
    );

    // print(message);
    if (message == "updated") {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (localStorage.getItem('token') == null) {
      context.go('/sign-in');
    }
    TextStyle cellTextStyle = const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );

    return Scaffold(
      backgroundColor: baseBgColor,
      body: FutureBuilder(
          future: _futurePendingOrdersDeliveries,
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Gap(10),
                  Row(
                    children: [
                      const Text(
                        'Hub detail',
                        style: TextStyle(
                            fontSize: 36, fontWeight: FontWeight.w900),
                      ),
                      const Spacer(),
                      FilledButton.icon(
                        onPressed: _OrderRows.isEmpty ? null : _assignOrder,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor:
                              _OrderRows.isEmpty ? baseBgColor : primaryColor,
                        ),
                        icon: Icon(
                          Icons.power_settings_new_rounded,
                          color:
                              _OrderRows.isEmpty ? borderColor : Colors.white,
                        ),
                        label: Text(
                          'Assign to deliver',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: _OrderRows.isEmpty
                                  ? borderColor
                                  : Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const Gap(15),
                  Row(
                    children: [
                      Text('Hub name: ${localStorage.getItem('hubName')}',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.normal),
                          textAlign: TextAlign.left),
                      const Spacer(),
                    ],
                  ),
                  const Gap(8),
                  Row(
                    children: [
                      Text('Hub address: ${localStorage.getItem('hubAddress')}',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.normal),
                          textAlign: TextAlign.left),
                      const Spacer(),
                    ],
                  ),
                  const Gap(20),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color(0xFF64748B).withOpacity(0.06),
                                  spreadRadius: 1,
                                  blurRadius: 1,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 30),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24),
                                  width: double.infinity,
                                  child: const Text(
                                    'Pending orders list',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const Gap(30),
                                Container(
                                  color: neutralColor,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 15,
                                    horizontal: 30,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 15,
                                          ),
                                          child:
                                              Text('Id', style: cellTextStyle),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 15,
                                          ),
                                          child: Text('Receive address',
                                              style: cellTextStyle),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 15,
                                          ),
                                          child: Text('Pay with',
                                              style: cellTextStyle),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: _OrderRows.isNotEmpty
                                      ? ListView(
                                          children: List.generate(
                                            _OrderRows.length,
                                            (index) {
                                              return Column(
                                                children: [
                                                  Ink(
                                                    color: _selectedOrderRow ==
                                                            index
                                                        ? Theme.of(context)
                                                            .colorScheme
                                                            .primary
                                                            .withOpacity(0.1)
                                                        : null,
                                                    child: InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          _selectedOrderRow =
                                                              index;
                                                        });
                                                      },
                                                      onLongPress: () async {
                                                        setState(() {
                                                          _selectedOrderRow =
                                                              index;
                                                        });
                                                        _logicEditOrder();
                                                      },
                                                      child: Row(
                                                        children: [
                                                          const Gap(30),
                                                          Expanded(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                vertical: 15,
                                                                horizontal: 15,
                                                              ),
                                                              child: Text(
                                                                _OrderRows[
                                                                        index]
                                                                    .id,
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                horizontal: 15,
                                                              ),
                                                              child: Text(
                                                                _OrderRows[
                                                                        index]
                                                                    .receiverInfo!
                                                                    .address!,
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                horizontal: 15,
                                                              ),
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                    _OrderRows[
                                                                            index]
                                                                        .payWith!,
                                                                  ),
                                                                  const Spacer(),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          const Gap(30),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  if (index <
                                                      _OrderRows.length - 1)
                                                    const Divider(
                                                      height: 0,
                                                    ),
                                                ],
                                              );
                                            },
                                          ),
                                        )
                                      : const Center(
                                          child: Text(
                                            'No pending orders',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontStyle: FontStyle.italic),
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Gap(20),
                        Expanded(
                          flex: 1,
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color(0xFF64748B).withOpacity(0.06),
                                  spreadRadius: 1,
                                  blurRadius: 1,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 30),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24),
                                  width: double.infinity,
                                  child: const Text(
                                    'Pending deliveries list',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const Gap(30),
                                Container(
                                  color: neutralColor,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 15,
                                    horizontal: 30,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 15,
                                          ),
                                          child:
                                              Text('Id', style: cellTextStyle),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 15,
                                          ),
                                          child: Text('Staff Name',
                                              style: cellTextStyle),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 15,
                                          ),
                                          child: Text('Date',
                                              style: cellTextStyle),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: _DeliverRows.isNotEmpty
                                      ? ListView(
                                          children: List.generate(
                                            _DeliverRows.length,
                                            (index) {
                                              return Column(
                                                children: [
                                                  Ink(
                                                    color:
                                                        _selectedDeliverRow ==
                                                                index
                                                            ? Theme.of(context)
                                                                .colorScheme
                                                                .primary
                                                                .withOpacity(0)
                                                            : null,
                                                    child: InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          _selectedDeliverRow =
                                                              index;
                                                        });
                                                      },
                                                      onLongPress: () async {
                                                        setState(() {
                                                          _selectedDeliverRow =
                                                              index;
                                                        });
                                                        _logicEditDeliver();
                                                      },
                                                      child: Row(
                                                        children: [
                                                          const Gap(30),
                                                          Expanded(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                vertical: 15,
                                                                horizontal: 15,
                                                              ),
                                                              child: Text(
                                                                _DeliverRows[
                                                                        index]
                                                                    .id,
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                horizontal: 15,
                                                              ),
                                                              child: Text(
                                                                _DeliverRows[
                                                                        index]
                                                                    .staffName!,
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                horizontal: 15,
                                                              ),
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                    _DeliverRows[
                                                                            index]
                                                                        .date!,
                                                                  ),
                                                                  const Spacer(),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          const Gap(30),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  if (index <
                                                      _DeliverRows.length - 1)
                                                    const Divider(
                                                      height: 0,
                                                    ),
                                                ],
                                              );
                                            },
                                          ),
                                        )
                                      : const Center(
                                          child: Text(
                                            'No pending deliveries',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontStyle: FontStyle.italic),
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //
                ],
              ),
            );
          }),
    );
  }
}
