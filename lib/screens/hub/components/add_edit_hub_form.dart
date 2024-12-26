import 'package:flutter/material.dart';
import 'package:lift_admin/base/component/label_text_form_field.dart';
import 'package:lift_admin/data/dto/hub_dto.dart';
import 'package:lift_admin/data/service.dart';

class AddEditHubForm extends StatefulWidget {
  const AddEditHubForm({super.key, this.editHub});

  final HubDto? editHub;

  @override
  State<AddEditHubForm> createState() => _AddEditHubFormState();
}

class _AddEditHubFormState extends State<AddEditHubForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isProcessing = false;

  final _hubNameController = TextEditingController();
  final _addressController = TextEditingController();
  List<String> _suggestions = [];

  void _getAddressSuggestions(String input) async {
    final suggestions = await fetchAddressSuggestions(input);
    setState(() {
      _suggestions = suggestions;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.editHub != null) {
      /*
      Nếu là chỉnh sửa độc giả
      thì phải fill thông tin vào của độc giả cần chỉnh sửa vào form
      */
      _hubNameController.text = widget.editHub!.name;
      _addressController.text = widget.editHub!.address;
    }
  }

  void saveHub(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isProcessing = true;
      });

      if (widget.editHub == null) {
        HubDto newHub = HubDto(
          name: _hubNameController.text.toLowerCase(),
          address: _addressController.text,
          canceledOrders: 0,
          failedOrders: 0,
          inProgressOrders: 0,
          pendingOrders: 0,
          successOrders: 0,
        );

        String returningId = await insertHub(newHub.name, newHub.address);
        newHub.hubId = returningId;

        if (mounted) {
          Navigator.of(context).pop(newHub);
        }
      } else {
        widget.editHub!.name = _hubNameController.text.toLowerCase();
        widget.editHub!.address = _addressController.text;

        await updateHub(widget.editHub!);

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
            content: Text(widget.editHub == null
                ? 'Add hub successful.'
                : 'Update hub successful.'),
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
                      widget.editHub == null ? 'ADD NEW HUB' : 'EDIT HUB',
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
                  labelText: 'Hub Name',
                  controller: _hubNameController,
                ),
                //
                const SizedBox(height: 20),
                TextField(
                  controller: _addressController,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      _getAddressSuggestions(value);
                    } else {
                      setState(() {
                        _suggestions = [];
                      });
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: 'Address',
                  ),
                ),
                if (_suggestions.isNotEmpty)
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      itemCount: _suggestions.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_suggestions[index]),
                          onTap: () {
                            _addressController.text = _suggestions[index];
                            setState(() {
                              _suggestions = [];
                            });
                          },
                        );
                      },
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
                          onPressed: () => saveHub(context),
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
