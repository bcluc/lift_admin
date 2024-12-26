import 'package:flutter/material.dart';
import 'package:lift_admin/base/common_variables.dart';
import 'package:lift_admin/data/dto/delivery_dto.dart';

class DetailDeliveryForm extends StatefulWidget {
  const DetailDeliveryForm({super.key, required this.detailDelivery});
  final DeliveryDto? detailDelivery;

  @override
  State<DetailDeliveryForm> createState() => _DetailDeliveryFormState();
}

class _DetailDeliveryFormState extends State<DetailDeliveryForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      child: SizedBox(
        width: 600,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 30,
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'DELIVERY DETAIL',
                        style: TextStyle(
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
                  const SizedBox(height: 20),
                  _buildReadOnlyField(
                      'Delivery Id', widget.detailDelivery?.id ?? ''),
                  _buildReadOnlyField(
                      'Date', widget.detailDelivery?.date ?? ''),
                  _buildReadOnlyField('Deliver Times',
                      widget.detailDelivery?.deliverTimes.toString() ?? ''),
                  _buildReadOnlyField(
                      'Hub Id', widget.detailDelivery?.hubId ?? ''),
                  _buildReadOnlyField(
                      'Order Id', widget.detailDelivery?.orderId ?? ''),
                  _buildReadOnlyField(
                      'Staff Id', widget.detailDelivery?.staffId! ?? ''),
                  _buildReadOnlyField(
                      'Staff Name', widget.detailDelivery?.staffName! ?? ''),
                  _buildReadOnlyField(
                      'Status', widget.detailDelivery?.status! ?? ''),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: value,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        style: const TextStyle(color: subtitleColor),
        enabled: false,
      ),
    );
  }
}
