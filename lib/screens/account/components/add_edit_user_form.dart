import 'package:flutter/material.dart';
import 'package:lift_admin/base/component/label_text_form_field.dart';
import 'package:lift_admin/data/model/user.dart';
import 'package:lift_admin/data/service.dart';

class AddEditUserForm extends StatefulWidget {
  const AddEditUserForm({super.key, this.editUser});

  final User? editUser;

  @override
  State<AddEditUserForm> createState() => _AddEditUserFormState();
}

class _AddEditUserFormState extends State<AddEditUserForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isProcessing = false;

  final _userNameController = TextEditingController();

  String? _selectedRole;
  final List<String> _roles = const [
    'administrator',
    'coordinator',
    'shipper',
    'client'
  ]; // Add your roles here

  @override
  void initState() {
    super.initState();
    if (widget.editUser != null) {
      /*
      Nếu là chỉnh sửa độc giả
      thì phải fill thông tin vào của độc giả cần chỉnh sửa vào form
      */
      _userNameController.text = widget.editUser!.name;
      _selectedRole = widget.editUser!.role;
    }
  }

  void saveUser(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isProcessing = true;
      });

      if (widget.editUser == null) {
        // User newuser = User(
        //   name: _userNameController.text.toLowerCase(),
        //   role: _roleController.text,
        // );

        // String returningId = await insertUser(newuser.name, newuser.role);
        // newuser.id = returningId;

        if (mounted) {
          Navigator.of(context).pop();
        }
      } else {
        widget.editUser!.name = _userNameController.text.toLowerCase();
        widget.editUser!.role = _selectedRole!;

        await updateUser(widget.editUser!);

        if (mounted) {
          Navigator.of(context).pop('updated');
        }
      }

      setState(() {
        _isProcessing = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.editUser == null
                ? 'Add user successful.'
                : 'Update user successful.'),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
            width: 300,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      child: SizedBox(
        width: 400,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 30,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      widget.editUser == null ? 'ADD NEW USER' : 'EDIT USER',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                LabelTextFormField(
                  labelText: 'User Name',
                  controller: _userNameController,
                ),
                //
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _selectedRole,
                  items: _roles.map((String role) {
                    return DropdownMenuItem<String>(
                      value: role,
                      child: Text(role),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRole = newValue!;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Role',
                  ),
                ),
                //
                const SizedBox(height: 40),
                Align(
                  alignment: Alignment.center,
                  child: _isProcessing
                      ? const SizedBox(
                          height: 44,
                          width: 44,
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : FilledButton(
                          onPressed: () => saveUser(context),
                          style: FilledButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 30,
                            ),
                          ),
                          child: const Text(
                            'Save',
                            textAlign: TextAlign.center,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
