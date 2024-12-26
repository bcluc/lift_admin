import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lift_admin/base/common_variables.dart';
import 'package:lift_admin/base/component/pagination.dart';
import 'package:lift_admin/base/component/search_field.dart';
import 'package:lift_admin/data/dto/order_dto.dart';
import 'package:lift_admin/data/service.dart';
import 'package:lift_admin/screens/order_process/components/detail_order_form.dart';

class OrderSection extends StatefulWidget {
  const OrderSection({super.key, required this.status});

  final String status;
  @override
  State<OrderSection> createState() => _OrderSectionState();
}

class _OrderSectionState extends State<OrderSection>
    with SingleTickerProviderStateMixin {
  bool isVisible = false;
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _sizeAnimation;
  final List<String> _colsName = [
    'Id',
    'Hub id',
    'Hub name',
    'Pay status',
    'Status',
    'Delivery type',
  ];
  final _searchController = TextEditingController();
  final _maxRow = 8;
  int _selectedRow = -1;
  bool _isLoading = false;
  late List<OrderDto> _orderRows;
  late int _orderCount;
  final _paginationController = TextEditingController(text: "1");
  Future<void> _loadOrdersOfPageIndex(int pageIndex) async {
    setState(() {
      _isLoading = true;
    });

    String searchText = _searchController.text.toLowerCase();

    List<OrderDto> newOrderRows = searchText.isEmpty
        ? await queryOrderWithStatus(
            numberRowIgnore: (pageIndex - 1) * _maxRow, status: widget.status)
        : await searchOrderWithNumberRowIgnoreWithStatus(
            str: searchText,
            numberRowIgnore: (pageIndex - 1) * _maxRow,
            status: widget.status);

    print(newOrderRows.length);
    setState(() {
      _isLoading = false;
      _orderRows = newOrderRows;
      _selectedRow = -1;
    });
  }

  late final Future<void> _futureRecentOrders = _getRecentOrders();
  Future<void> _getRecentOrders() async {
    /* 
    Delay 1 khoảng bằng thời gian animation của TabController 
    Tạo chuyển động mượt mà 
    */
    await Future.delayed(kTabScrollDuration);
    _orderRows =
        await queryOrderWithStatus(numberRowIgnore: 0, status: widget.status);
    _orderCount = await queryCountOrderWithStatus(status: widget.status);
  }

  Future<void> _logicDetailOrder() async {
    String? message = await showDialog(
      context: context,
      builder: (ctx) => DetailOrderForm(
        detailOrder: _orderRows[_selectedRow],
      ),
    );

    // print(message);
    if (message == "updated") {
      setState(() {});
    }
  }

  Future<void> _logicDeleteOrder(BuildContext ctx) async {
    var deleteOrderId = _orderRows[_selectedRow].id;

    /* Xóa dòng dữ liệu*/
    await deleteOrder(_orderRows[_selectedRow].id);

    int totalPages = _orderCount ~/ _maxRow + min(_orderCount % _maxRow, 1);
    int currentPage = int.parse(_paginationController.text);
    if (currentPage == 0) currentPage = 1;

    _orderCount--;
    // print('totalPage = $totalPages');

    if (currentPage == totalPages) {
      _orderRows.removeAt(_selectedRow);
      if (_orderRows.isEmpty && _orderCount > 0) {
        currentPage--;
        if (currentPage == 0) currentPage = 1;
        _paginationController.text = currentPage.toString();
        _loadOrdersOfPageIndex(currentPage);
      }
    } else {
      _loadOrdersOfPageIndex(currentPage);
    }

    setState(() {});

    if (mounted) {
      Navigator.of(ctx).pop();
      ScaffoldMessenger.of(ctx).clearSnackBars();
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(
            'Deleted order $deleteOrderId.',
            textAlign: TextAlign.center,
          ),
          behavior: SnackBarBehavior.floating,
          width: 400,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: const Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    _sizeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  void toggleVisibility() {
    setState(() {
      isVisible = !isVisible;
      if (isVisible) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _futureRecentOrders,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Error loading orders'),
            );
          }
          int totalPages =
              _orderCount ~/ _maxRow + min(_orderCount % _maxRow, 1);
          if (_orderCount == 0) {
            return Center(child: Text('There are no ${widget.status} orders'));
          } else {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    width: double.infinity,
                    constraints: const BoxConstraints(minHeight: 84),
                    child: FilledButton(
                      onPressed: toggleVisibility,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          direction: Axis.horizontal,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '${widget.status} Orders',
                                  style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w900),
                                ),
                                const Spacer(),
                                isVisible
                                    ? Row(
                                        children: [
                                          FilledButton.icon(
                                            onPressed: _selectedRow == -1
                                                ? null
                                                : _logicDetailOrder,
                                            style: FilledButton.styleFrom(
                                              padding: const EdgeInsets.all(20),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              backgroundColor:
                                                  _selectedRow == -1
                                                      ? baseBgColor
                                                      : primaryColor,
                                            ),
                                            icon: Icon(
                                              Icons.info,
                                              color: _selectedRow == -1
                                                  ? borderColor
                                                  : Colors.white,
                                            ),
                                            label: Text(
                                              'Detail',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: _selectedRow == -1
                                                      ? borderColor
                                                      : Colors.white),
                                            ),
                                          ),
                                          const Gap(20),
                                          FilledButton.icon(
                                            onPressed: _selectedRow == -1
                                                ? null
                                                : () async {
                                                    await showDialog(
                                                      context: context,
                                                      builder: (ctx) =>
                                                          AlertDialog(
                                                        title: const Text(
                                                            'Confirm'),
                                                        content: Text(
                                                            'Do you want to delete order ${_orderRows[_selectedRow].id}?'),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(ctx)
                                                                  .pop();
                                                            },
                                                            child: const Text(
                                                                'Cancel'),
                                                          ),
                                                          FilledButton(
                                                            onPressed: () =>
                                                                _logicDeleteOrder(
                                                                    ctx),
                                                            child: const Text(
                                                                'Yes'),
                                                          ),
                                                        ],
                                                      ),
                                                    );

                                                    if (_selectedRow >=
                                                        _orderRows.length) {
                                                      _selectedRow = -1;
                                                    }
                                                  },
                                            style: FilledButton.styleFrom(
                                              padding: const EdgeInsets.all(20),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              backgroundColor: baseBgColor,
                                            ),
                                            icon: Icon(
                                              Icons.delete,
                                              color: _selectedRow == -1
                                                  ? borderColor
                                                  : primaryColor,
                                            ),
                                            label: Text(
                                              'Delete',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: _selectedRow == -1
                                                      ? borderColor
                                                      : primaryColor),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Icon(
                                        color: Colors.black,
                                        size: 30,
                                        isVisible
                                            ? Icons.arrow_downward_outlined
                                            : Icons.arrow_forward_rounded,
                                      ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    width: double.infinity,
                    child: SizeTransition(
                      sizeFactor: _sizeAnimation,
                      child: SlideTransition(
                        position: _offsetAnimation,
                        child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: sectionColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                const Gap(20),
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF64748B)
                                            .withOpacity(0.06),
                                        spreadRadius: 1,
                                        blurRadius: 1,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  padding:
                                      const EdgeInsets.fromLTRB(24, 26, 24, 26),
                                  child: SearchField(
                                    controller: _searchController,
                                    onSearch: (value) async {
                                      if (_searchController.text == value) {
                                        _paginationController.text = '1';
                                        _orderCount =
                                            await queryCountOrderSearchWithStatus(
                                                _searchController.text,
                                                widget.status);
                                        _loadOrdersOfPageIndex(1);
                                      }
                                    },
                                  ),
                                ),
                                const Gap(30),
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF64748B)
                                            .withOpacity(0.06),
                                        spreadRadius: 1,
                                        blurRadius: 1,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.only(bottom: 30),
                                  child: Column(
                                    children: [
                                      _isLoading
                                          ? const Center(
                                              child:
                                                  CircularProgressIndicator())
                                          : SizedBox(
                                              width: double.infinity,
                                              child: DataTable(
                                                /* Set màu cho Heading */
                                                headingRowColor:
                                                    WidgetStateColor
                                                        .resolveWith(
                                                  (states) => neutralColor,
                                                ),
                                                /* The horizontal margin between the contents of each data column */
                                                columnSpacing: 20,
                                                dataRowColor:
                                                    WidgetStateProperty
                                                        .resolveWith(
                                                  (states) => getDataRowColor(
                                                      context, states),
                                                ),
                                                dataRowMaxHeight: 65,
                                                border: const TableBorder
                                                    .symmetric(),
                                                showCheckboxColumn: false,
                                                columns: List.generate(
                                                  _colsName.length,
                                                  (index) => DataColumn(
                                                    label: Text(
                                                      _colsName[index],
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                rows: List.generate(
                                                  _orderRows.length,
                                                  (index) {
                                                    OrderDto order =
                                                        _orderRows[index];
                                                    TextStyle cellTextStyle =
                                                        const TextStyle(
                                                            color:
                                                                Colors.black);
                                                    return DataRow(
                                                      selected:
                                                          _selectedRow == index,
                                                      onSelectChanged: (_) =>
                                                          setState(() {
                                                        _selectedRow = index;
                                                      }),
                                                      onLongPress: () {
                                                        setState(() {
                                                          _selectedRow = index;
                                                        });
                                                        _logicDetailOrder();
                                                      },
                                                      cells: [
                                                        DataCell(
                                                          ConstrainedBox(
                                                            constraints:
                                                                const BoxConstraints(
                                                                    maxWidth:
                                                                        150),
                                                            child: Text(
                                                              order.id,
                                                              style:
                                                                  cellTextStyle,
                                                            ),
                                                          ),
                                                        ),
                                                        DataCell(
                                                          ConstrainedBox(
                                                            constraints:
                                                                const BoxConstraints(
                                                                    maxWidth:
                                                                        150),
                                                            child: Text(
                                                              order.hubId!,
                                                              style:
                                                                  cellTextStyle,
                                                            ),
                                                          ),
                                                        ),
                                                        DataCell(
                                                          Text(
                                                            order.hubName!,
                                                            style:
                                                                cellTextStyle,
                                                          ),
                                                        ),
                                                        DataCell(
                                                          ConstrainedBox(
                                                            constraints:
                                                                const BoxConstraints(
                                                                    maxWidth:
                                                                        250),
                                                            child: Text(
                                                              order.payStatus!,
                                                              style:
                                                                  cellTextStyle,
                                                            ),
                                                          ),
                                                        ),
                                                        DataCell(
                                                          Text(
                                                            order.deliveryInfo!
                                                                .status!,
                                                            style:
                                                                cellTextStyle,
                                                          ),
                                                        ),
                                                        DataCell(
                                                          Text(
                                                            order.deliveryInfo!
                                                                .deliveryType!,
                                                            style:
                                                                cellTextStyle,
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                      if (_orderCount > 0) const Gap(20),
                                      _orderCount > 0
                                          ? Row(
                                              children: [
                                                const Spacer(),
                                                Pagination(
                                                  controller:
                                                      _paginationController,
                                                  maxPages: totalPages,
                                                  onChanged:
                                                      _loadOrdersOfPageIndex,
                                                ),
                                                const Gap(20),
                                              ],
                                            )
                                          : const Expanded(
                                              child: Center(
                                                child: Text(
                                                  'There are no orders',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black54),
                                                ),
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
