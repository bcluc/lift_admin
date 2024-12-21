import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:lift_admin/base/common_variables.dart';
import 'package:lift_admin/base/component/search_field.dart';
import 'package:lift_admin/data/model/user.dart';
import 'package:lift_admin/data/service.dart';
import 'package:lift_admin/screens/account/add_edit_user_form.dart';
import 'package:localstorage/localstorage.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final List<String> _colsName = const [
    'Id',
    'User name',
    'Role',
  ];
  final _searchController = TextEditingController();
  //final _maxRow = 99;
  int _selectedRow = -1;
  late List<User> _UserRows;
  late int _UserCount;
  //final _paginationController = TextEditingController(text: "1");
  // Future<void> _loadUsersOfPageIndex(int pageIndex) async {
  //   String searchText = _searchController.text.toLowerCase();

  //   List<User> newUserRows = searchText.isEmpty
  //       ? await queryUser(numberRowIgnore: (pageIndex - 1) * _maxRow)
  //       : await searchUserWithNumberRowIgnore(
  //           str: searchText, numberRowIgnore: (pageIndex - 1) * _maxRow);

  //   print(newUserRows.length);
  //   setState(() {
  //     _UserRows = newUserRows;
  //     _selectedRow = -1;
  //   });
  // }

  late final Future<void> _futureRecentUsers = _getRecentUsers();
  Future<void> _getRecentUsers() async {
    /* 
    Delay 1 khoảng bằng thời gian animation của TabController 
    Tạo chuyển động mượt mà 
    */
    await Future.delayed(kTabScrollDuration);
    //_UserRows = await queryUser(numberRowIgnore: 0);
    _UserRows = await queryAllUser();
    _UserCount = await queryCountUser();
  }

  Future<void> _logicAddUser() async {
    User? newUser = await showDialog(
      context: context,
      builder: (ctx) => const AddEditUserForm(),
    );

    if (newUser != null) {
      setState(() {
        _UserRows.add(newUser);
        _UserCount++;
      });
    }
  }

  Future<void> _logicEditUser() async {
    String? message = await showDialog(
      context: context,
      builder: (ctx) => AddEditUserForm(
        editUser: _UserRows[_selectedRow],
      ),
    );

    // print(message);
    if (message == "updated") {
      setState(() {});
    }
  }

  Future<void> _logicDeleteUser(BuildContext ctx) async {
    var deleteUserName = _UserRows[_selectedRow].name;

    /* Xóa dòng dữ liệu*/
    await deleteUser(_UserRows[_selectedRow].id!);

    _UserCount--;
    // print('totalPage = $totalPages');

    _UserRows.removeAt(_selectedRow);
    _selectedRow = -1;
    setState(() {});

    if (mounted) {
      Navigator.of(ctx).pop();
      ScaffoldMessenger.of(ctx).clearSnackBars();
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(
            'Deleted $deleteUserName.',
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
    TextStyle cellTextStyle = const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );

    return Scaffold(
      backgroundColor: baseBgColor,
      body: FutureBuilder(
          future: _futureRecentUsers,
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
                        'User',
                        style: TextStyle(
                            fontSize: 36, fontWeight: FontWeight.w900),
                      ),
                      const Spacer(),
                      // FilledButton(
                      //   onPressed: _logicAddUser,
                      //   style: FilledButton.styleFrom(
                      //     padding: const EdgeInsets.all(20),
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(8),
                      //     ),
                      //     backgroundColor: primaryColor,
                      //   ),
                      //   child: const Text(
                      //     'Add User',
                      //     style: TextStyle(
                      //         fontSize: 14,
                      //         fontWeight: FontWeight.bold,
                      //         color: Colors.white),
                      //   ),
                      // ),
                      // const Gap(20),
                      FilledButton.icon(
                        onPressed: _selectedRow == -1 ? null : _logicEditUser,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor:
                              _selectedRow == -1 ? baseBgColor : primaryColor,
                        ),
                        icon: Icon(
                          Icons.edit,
                          color:
                              _selectedRow == -1 ? borderColor : Colors.white,
                        ),
                        label: Text(
                          'Edit',
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
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('Confirm'),
                                    content: Text(
                                        'Do you want to delete User ${_UserRows[_selectedRow].name}?'),
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
                                        onPressed: () => _logicDeleteUser(ctx),
                                        child: const Text('Yes'),
                                      ),
                                    ],
                                  ),
                                );

                                if (_selectedRow >= _UserRows.length) {
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
                          _UserCount = await queryCountUserSearch(
                              _searchController.text);
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
                              'Accounts list',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
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
                                SizedBox(
                                  width: 80,
                                  child: Text('No', style: cellTextStyle),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15,
                                    ),
                                    child: Text('Id', style: cellTextStyle),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15,
                                    ),
                                    child:
                                        Text('User name', style: cellTextStyle),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15,
                                    ),
                                    child: Text('Role', style: cellTextStyle),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: ListView(
                              children: List.generate(
                                _UserRows.length,
                                (index) {
                                  return Column(
                                    children: [
                                      Ink(
                                        color: _selectedRow == index
                                            ? Theme.of(context)
                                                .colorScheme
                                                .primary
                                                .withOpacity(0.1)
                                            : null,
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              _selectedRow = index;
                                            });
                                          },
                                          onLongPress: () async {
                                            setState(() {
                                              _selectedRow = index;
                                            });
                                            _logicEditUser();
                                          },
                                          child: Row(
                                            children: [
                                              const Gap(30),
                                              SizedBox(
                                                width: 80,
                                                child: Text(
                                                  (index + 1).toString(),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    vertical: 15,
                                                    horizontal: 15,
                                                  ),
                                                  child: Text(
                                                    _UserRows[index].id!,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 15,
                                                  ),
                                                  child: Text(
                                                    _UserRows[index].name,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 15,
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        _UserRows[index].role,
                                                      ),
                                                      const Spacer(),
                                                      if (_selectedRow == index)
                                                        Icon(
                                                          Icons.check,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary,
                                                        )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const Gap(30),
                                            ],
                                          ),
                                        ),
                                      ),
                                      if (index < _UserRows.length - 1)
                                        const Divider(
                                          height: 0,
                                        ),
                                    ],
                                  );
                                },
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
