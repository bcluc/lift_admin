import 'package:flutter/material.dart';
import 'package:lift_admin/base/component/label_text_form_field.dart';
import 'package:lift_admin/data/dto/staff_dto.dart';
import 'package:localstorage/localstorage.dart';

class AddEditStaffForm extends StatefulWidget {
  const AddEditStaffForm({super.key, this.editStaff});

  final StaffDto? editStaff;

  @override
  State<AddEditStaffForm> createState() => _AddEditStaffFormState();
}

class _AddEditStaffFormState extends State<AddEditStaffForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isProcessing = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _hubIdController = TextEditingController();
  final TextEditingController _motorcycleCapacityController =
      TextEditingController();
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _hubIdController.text = localStorage.getItem('hubId')!;

    if (widget.editStaff != null) {
      _nameController.text = widget.editStaff!.name ?? '';
      _ageController.text = widget.editStaff!.age?.toString() ?? '';
      _genderController.text = widget.editStaff!.gender ?? '';
      _motorcycleCapacityController.text =
          widget.editStaff!.motorcycleCapacity?.toString() ?? '';
      _userIdController.text = widget.editStaff!.userId ?? '';
      _weightController.text = widget.editStaff!.weight?.toString() ?? '';
    }
  }

  Future<void> insertStaff(StaffDto staff) async {
    // Implement your logic to insert staff
  }

  Future<void> updateStaff(StaffDto staff) async {
    // Implement your logic to update staff
  }
  void saveStaff(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isProcessing = true;
      });
      StaffDto staff = StaffDto(
        id: widget.editStaff?.id ?? '',
        name: _nameController.text,
        age: int.tryParse(_ageController.text),
        gender: _genderController.text,
        hubId: _hubIdController.text,
        motorcycleCapacity: int.tryParse(_motorcycleCapacityController.text),
        userId: _userIdController.text,
        weight: int.tryParse(_weightController.text),
      );

      if (widget.editStaff == null) {
        // User newuser = User(
        //   name: _userNameController.text.toLowerCase(),
        //   role: _roleController.text,
        // );

        // String returningId = await insertUser(newuser.name, newuser.role);
        // newuser.id = returningId;
        await insertStaff(staff);

        if (mounted) {
          Navigator.of(context).pop();
        }
      } else {
        widget.editStaff!.name = _nameController.text.toLowerCase();
        widget.editStaff!.age = int.parse(_ageController.value.text);
        widget.editStaff!.gender = _genderController.text.toLowerCase();
        widget.editStaff!.hubId = _hubIdController.text.toLowerCase();
        widget.editStaff!.motorcycleCapacity =
            int.parse(_motorcycleCapacityController.text);
        widget.editStaff!.userId = _userIdController.text.toLowerCase();
        widget.editStaff!.weight = int.parse(_weightController.text);

        await updateStaff(staff);

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
            content: Text(widget.editStaff == null
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
                      widget.editStaff == null ? 'ADD NEW STAFF' : 'EDIT STAFF',
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
                LabelTextFormField(
                  labelText: 'Name',
                  controller: _nameController,
                  customValidator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                LabelTextFormField(
                  labelText: 'Age',
                  controller: _ageController,
                  customValidator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an age';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                LabelTextFormField(
                  labelText: 'Gender',
                  controller: _genderController,
                  customValidator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a gender';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                LabelTextFormField(
                  labelText: 'Hub ID',
                  controller: _hubIdController,
                  isEnable: false,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _motorcycleCapacityController,
                  decoration:
                      const InputDecoration(labelText: 'Motorcycle Capacity'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a motorcycle capacity';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                LabelTextFormField(
                  labelText: 'User ID',
                  controller: _userIdController,
                  customValidator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a user ID';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _weightController,
                  decoration: const InputDecoration(labelText: 'Weight'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a weight';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
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
                          onPressed: () => saveStaff(context),
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
