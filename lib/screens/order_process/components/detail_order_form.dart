import 'package:flutter/material.dart';
import 'package:lift_admin/base/common_variables.dart';
import 'package:lift_admin/data/dto/order_dto.dart';

class DetailOrderForm extends StatefulWidget {
  const DetailOrderForm({super.key, required this.detailOrder});
  final OrderDto? detailOrder;

  @override
  State<DetailOrderForm> createState() => _DetailOrderFormState();
}

class _DetailOrderFormState extends State<DetailOrderForm> {
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
                        'ORDER DETAIL',
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
                  _buildReadOnlyField('Order ID', widget.detailOrder?.id ?? ''),
                  _buildReadOnlyField(
                      'Hub Name', widget.detailOrder?.hubName ?? ''),
                  _buildReadOnlyField(
                      'Message', widget.detailOrder?.message ?? ''),
                  _buildReadOnlyField(
                      'Pay Status', widget.detailOrder?.payStatus ?? ''),
                  _buildReadOnlyField(
                      'Pay With', widget.detailOrder?.payWith ?? ''),
                  const SizedBox(height: 20),
                  const Text(
                    'Delivery Info',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  _buildReadOnlyField('Delivery Type',
                      widget.detailOrder?.deliveryInfo!.deliveryType ?? ''),
                  _buildReadOnlyField(
                      'Package Size',
                      widget.detailOrder?.deliveryInfo!.packageSize
                              .toString() ??
                          ''),
                  _buildReadOnlyField('Pickup Date',
                      widget.detailOrder?.deliveryInfo!.pickupDate ?? ''),
                  _buildReadOnlyField('Pickup Time',
                      widget.detailOrder?.deliveryInfo!.pickupTime ?? ''),
                  _buildReadOnlyField('Shipment Type',
                      widget.detailOrder?.deliveryInfo!.shipmentType ?? ''),
                  _buildReadOnlyField(
                      'Status', widget.detailOrder?.deliveryInfo!.status ?? ''),
                  _buildReadOnlyField('Value',
                      widget.detailOrder?.deliveryInfo!.value.toString() ?? ''),
                  const SizedBox(height: 20),
                  const Text(
                    'Receiver Info',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  _buildReadOnlyField('Receiver Name',
                      widget.detailOrder?.receiverInfo!.name ?? ''),
                  _buildReadOnlyField('Receiver Address',
                      widget.detailOrder?.receiverInfo!.address ?? ''),
                  _buildReadOnlyField('Receiver Phone',
                      widget.detailOrder?.receiverInfo!.phoneNumber ?? ''),
                  const SizedBox(height: 20),
                  const Text(
                    'Sender Info',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  _buildReadOnlyField('Sender Name',
                      widget.detailOrder?.senderInfo!.name ?? ''),
                  _buildReadOnlyField('Sender Address',
                      widget.detailOrder?.senderInfo!.address ?? ''),
                  _buildReadOnlyField('Sender Phone',
                      widget.detailOrder?.senderInfo!.phoneNumber ?? ''),
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
