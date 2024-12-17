import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:lift_admin/base/common_variables.dart';
import 'package:lift_admin/base/component/pagination.dart';
import 'package:lift_admin/base/component/search_field.dart';
// import 'package:lift_admin/base/singleton/user_info.dart';
import 'package:lift_admin/data/model/hub.dart';
import 'package:lift_admin/data/service.dart';
import 'package:lift_admin/screens/hub/add_edit_hub_form.dart';
import 'package:localstorage/localstorage.dart';

class HubScreen extends StatefulWidget {
  const HubScreen({super.key});

  @override
  State<HubScreen> createState() => _HubScreenState();
}

class _HubScreenState extends State<HubScreen> {
  final List<String> _colsName = [
    'Id',
    'Hub name',
    'Address',
  ];
  final _searchController = TextEditingController();
  final _maxRow = 5;
  int _selectedRow = -1;
  late List<Hub> _hubRows;
  late int _hubCount;
  final _paginationController = TextEditingController(text: "1");
  Future<void> _loadReadersOfPageIndex(int pageIndex) async {
    String searchText = _searchController.text.toLowerCase();

    List<Hub> newHubRows = searchText.isEmpty
        ? await queryHub(numberRowIgnore: (pageIndex - 1) * _maxRow)
        : await searchHubWithNumberRowIgnore(
            str: searchText, numberRowIgnore: (pageIndex - 1) * _maxRow);

    print(newHubRows.length);
    setState(() {
      _hubRows = newHubRows;
      _selectedRow = -1;
    });
  }

  late final Future<void> _futureRecentReaders = _getRecentHubs();
  Future<void> _getRecentHubs() async {
    /* 
    Delay 1 khoảng bằng thời gian animation của TabController 
    Tạo chuyển động mượt mà 
    */
    await Future.delayed(kTabScrollDuration);
    _hubRows = await queryHub(numberRowIgnore: 0);
    _hubCount = await queryCountHub();
  }

  Future<void> _logicAddReader() async {
    Hub? newReader = await showDialog(
      context: context,
      builder: (ctx) => const AddEditHubForm(),
    );

    if (newReader != null) {
      setState(() {
        if (_hubRows.length < _maxRow) {
          _hubRows.add(newReader);
        }
        _hubCount++;
      });
    }
  }

  Future<void> _logicEditReader() async {
    String? message = await showDialog(
      context: context,
      builder: (ctx) => AddEditHubForm(
        editHub: _hubRows[_selectedRow],
      ),
    );

    // print(message);
    if (message == "updated") {
      setState(() {});
    }
  }

  Future<void> _logicDeleteReader(BuildContext ctx) async {
    var deleteReaderName = _hubRows[_selectedRow].name;

    /* Xóa dòng dữ liệu*/
    int res = await deleteHub(_hubRows[_selectedRow].id!);
    // print(res);
    int totalPages = _hubCount ~/ _maxRow + min(_hubCount % _maxRow, 1);
    print("totalPages = $totalPages");
    int currentPage = int.parse(_paginationController.text);
    print("currentPage = $currentPage");
    if (currentPage == 0) currentPage = 1;

    _hubCount--;
    print("hubCount = $_hubCount");
    // print('totalPage = $totalPages');

    if (currentPage == totalPages) {
      _hubRows.removeAt(_selectedRow);
      if (_hubRows.isEmpty && _hubCount > 0) {
        currentPage--;
        if (currentPage == 0) currentPage = 1;
        _paginationController.text = currentPage.toString();
        _loadReadersOfPageIndex(currentPage);
      }
    } else {
      _loadReadersOfPageIndex(currentPage);
    }

    setState(() {});

    if (mounted) {
      Navigator.of(ctx).pop();
      ScaffoldMessenger.of(ctx).clearSnackBars();
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(
            'Deleted $deleteReaderName.',
            textAlign: TextAlign.center,
          ),
          behavior: SnackBarBehavior.floating,
          width: 400,
        ),
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (localStorage.getItem('token') == null) {
      context.go('/sign-in');
    }

    return Scaffold(
      backgroundColor: baseBgColor,
      body: FutureBuilder(
          future: _futureRecentReaders,
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            int totalPages = _hubCount ~/ _maxRow + min(_hubCount % _maxRow, 1);

            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Gap(10),
                  Row(
                    children: [
                      const Text(
                        'Hub',
                        style: TextStyle(
                            fontSize: 36, fontWeight: FontWeight.w900),
                      ),
                      const Spacer(),
                      FilledButton(
                        onPressed: _logicAddReader,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: primaryColor,
                        ),
                        child: const Text(
                          'Add Hub',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      const Gap(20),
                      FilledButton.icon(
                        onPressed: _selectedRow == -1 ? null : _logicEditReader,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: baseBgColor,
                        ),
                        icon: Icon(
                          Icons.edit,
                          color:
                              _selectedRow == -1 ? borderColor : primaryColor,
                        ),
                        label: Text(
                          'Edit',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: _selectedRow == -1
                                  ? borderColor
                                  : primaryColor),
                        ),
                      ),
                      const Gap(20),
                      FilledButton.icon(
                        onPressed: _selectedRow == -1
                            ? null
                            : () async {
                                await showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('Confirm'),
                                    content: Text(
                                        'Do you want to delete hub ${_hubRows[_selectedRow].name}?'),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      FilledButton(
                                        onPressed: () =>
                                            _logicDeleteReader(ctx),
                                        child: const Text('Yes'),
                                      ),
                                    ],
                                  ),
                                );

                                if (_selectedRow >= _hubRows.length) {
                                  _selectedRow = -1;
                                }
                              },
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: baseBgColor,
                        ),
                        icon: Icon(
                          Icons.delete,
                          color:
                              _selectedRow == -1 ? borderColor : primaryColor,
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
                  ),
                  const Gap(20),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF64748B).withOpacity(0.06),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.fromLTRB(24, 26, 24, 26),
                    child: SearchField(
                      controller: _searchController,
                      onSearch: (value) async {
                        /* 
                          Phòng trường hợp gõ tiếng việt
                          VD: o -> (rỗng) -> ỏ
                          Lúc này, value sẽ bằng '' (rỗng) nhưng _searchController.text lại bằng "ỏ"
                          */
                        if (_searchController.text == value) {
                          _paginationController.text = '1';
                          _hubCount =
                              await queryCountHubSearch(_searchController.text);
                          _loadReadersOfPageIndex(1);
                        }
                      },
                    ),
                  ),
                  const Gap(30),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF64748B).withOpacity(0.06),
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
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            width: double.infinity,
                            child: const Text(
                              'Hubs list',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const Gap(20),
                          SizedBox(
                            width: double.infinity,
                            child: DataTable(
                              /* Set màu cho Heading */
                              headingRowColor: WidgetStateColor.resolveWith(
                                (states) => neutralColor,
                              ),
                              /* The horizontal margin between the contents of each data column */
                              columnSpacing: 20,
                              dataRowColor: WidgetStateProperty.resolveWith(
                                (states) => getDataRowColor(context, states),
                              ),
                              dataRowMaxHeight: 65,
                              border: const TableBorder.symmetric(),
                              showCheckboxColumn: false,
                              columns: List.generate(
                                _colsName.length,
                                (index) => DataColumn(
                                  label: Text(
                                    _colsName[index],
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              rows: List.generate(
                                _hubRows.length,
                                (index) {
                                  Hub hub = _hubRows[index];
                                  TextStyle cellTextStyle =
                                      const TextStyle(color: Colors.black);
                                  return DataRow(
                                    selected: _selectedRow == index,
                                    onSelectChanged: (_) => setState(() {
                                      _selectedRow = index;
                                    }),
                                    onLongPress: () {
                                      setState(() {
                                        _selectedRow = index;
                                      });
                                      _logicEditReader();
                                    },
                                    cells: [
                                      DataCell(
                                        ConstrainedBox(
                                          constraints: const BoxConstraints(
                                              maxWidth: 150),
                                          child: Text(
                                            hub.id!,
                                            style: cellTextStyle,
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          hub.name,
                                          style: cellTextStyle,
                                        ),
                                      ),
                                      DataCell(
                                        ConstrainedBox(
                                          constraints: const BoxConstraints(
                                              maxWidth: 250),
                                          child: Text(
                                            hub.address,
                                            style: cellTextStyle,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                          if (_hubCount > 0) const Spacer(),
                          _hubCount > 0
                              ? Row(
                                  children: [
                                    const Spacer(),
                                    Pagination(
                                      controller: _paginationController,
                                      maxPages: totalPages,
                                      onChanged: _loadReadersOfPageIndex,
                                    ),
                                    const Gap(20),
                                  ],
                                )
                              : const Expanded(
                                  child: Center(
                                    child: Text(
                                      'There are no hubs',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black54),
                                    ),
                                  ),
                                ),
                        ],
                      ),
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
