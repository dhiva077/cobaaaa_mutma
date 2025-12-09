import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../viewmodel/pre_order_model.dart';

class DetailPOView extends StatefulWidget {
  final String poId;

  const DetailPOView({super.key, required this.poId});

  @override
  State<DetailPOView> createState() => _DetailPOViewState();
}

class _DetailPOViewState extends State<DetailPOView> {
  PreOrderModel? _poDetail;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchPODetail();
  }

  Future<void> _fetchPODetail() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _poDetail = PreOrderModel(
        id: widget.poId,
        supplierName: 'Supplier A',
        orderDate: DateTime(2024, 1, 15),
        deliveryDate: DateTime(2024, 1, 25),
        totalAmount: 5000000,
        status: 'approved',
        items: [
          POItem(productName: 'Product A', quantity: 100, price: 20000, unit: 'pcs'),
          POItem(productName: 'Product B', quantity: 50, price: 60000, unit: 'pcs'),
          POItem(productName: 'Product C', quantity: 75, price: 35000, unit: 'pcs'),
        ],
      );
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail PO: ${widget.poId}'),
        backgroundColor: AppColors.primary,
        actions: [
          if (_poDetail != null)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // Navigasi ke form edit
              },
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _poDetail == null
              ? const Center(child: Text('Data tidak ditemukan'))
              : _buildDetailContent(),
    );
  }

  Widget _buildDetailContent() {
    final po = _poDetail!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow('ID PO', po.id),
                  _buildDetailRow('Supplier', po.supplierName),
                  _buildDetailRow('Tanggal Pesan', _formatDate(po.orderDate)),
                  _buildDetailRow('Tanggal Kirim', _formatDate(po.deliveryDate)),
                  _buildDetailRow('Total', 'Rp ${po.totalAmount.toStringAsFixed(0)}'),
                  _buildStatusBadge(po.status),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Item Produk',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ...po.items.map((item) => _buildItemCard(item)),
          const SizedBox(height: 32),
          if (po.status == 'pending')
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  // Logic approve
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Setujui PO'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: _getStatusColor(status).withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _getStatusColor(status)),
        ),
        child: Text(
          status.toUpperCase(),
          style: TextStyle(
            color: _getStatusColor(status),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildItemCard(POItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(item.productName),
        subtitle: Text('${item.quantity} ${item.unit}'),
        trailing: Text(
          'Rp ${(item.price * item.quantity).toStringAsFixed(0)}',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'approved':
        return AppColors.success;
      case 'pending':
        return AppColors.warning;
      case 'rejected':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }
}