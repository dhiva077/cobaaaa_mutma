import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../viewmodel/pre_order_model.dart';

class FormPOViewModel extends ChangeNotifier {
  final List<POItem> _items = [];
  String _supplierName = '';
  DateTime _orderDate = DateTime.now();
  DateTime _deliveryDate = DateTime.now().add(const Duration(days: 7));
  bool _isLoading = false;

  List<POItem> get items => _items;
  String get supplierName => _supplierName;
  DateTime get orderDate => _orderDate;
  DateTime get deliveryDate => _deliveryDate;
  bool get isLoading => _isLoading;

  void setSupplierName(String value) {
    _supplierName = value;
    notifyListeners();
  }

  void setOrderDate(DateTime date) {
    _orderDate = date;
    notifyListeners();
  }

  void setDeliveryDate(DateTime date) {
    _deliveryDate = date;
    notifyListeners();
  }

  void addItem(POItem item) {
    _items.add(item);
    notifyListeners();
  }

  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  Future<bool> submitPO() async {
    if (_supplierName.isEmpty || _items.isEmpty) {
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 2));
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}

class FormPOView extends StatefulWidget {
  final PreOrderModel? poToEdit;

  const FormPOView({super.key, this.poToEdit});

  @override
  State<FormPOView> createState() => _FormPOViewState();
}

class _FormPOViewState extends State<FormPOView> {
  final FormPOViewModel _viewModel = FormPOViewModel();
  final _productNameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  final _unitController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(_onViewModelChanged);
    
    if (widget.poToEdit != null) {
      _initializeForm();
    }
  }

  void _initializeForm() {
    final po = widget.poToEdit!;
    _viewModel.setSupplierName(po.supplierName);
    _viewModel.setOrderDate(po.orderDate);
    _viewModel.setDeliveryDate(po.deliveryDate);
    
    for (var item in po.items) {
      _viewModel.addItem(item);
    }
  }

  void _onViewModelChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    _productNameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  void _showAddItemDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _productNameController,
                decoration: const InputDecoration(labelText: 'Nama Produk'),
              ),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Jumlah'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Harga'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _unitController,
                decoration: const InputDecoration(labelText: 'Satuan'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                final item = POItem(
                  productName: _productNameController.text,
                  quantity: int.parse(_quantityController.text),
                  price: double.parse(_priceController.text),
                  unit: _unitController.text,
                );
                _viewModel.addItem(item);
                _clearItemFields();
                Navigator.pop(context);
              },
              child: const Text('Tambah'),
            ),
          ],
        );
      },
    );
  }

  void _clearItemFields() {
    _productNameController.clear();
    _quantityController.clear();
    _priceController.clear();
    _unitController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.poToEdit == null ? 'Buat PO Baru' : 'Edit PO'),
        backgroundColor: AppColors.primary, // FIX: primary bukan primaryColor
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              initialValue: _viewModel.supplierName,
              decoration: InputDecoration(
                labelText: 'Nama Supplier',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: _viewModel.setSupplierName,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Masukkan nama supplier';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Tanggal Pesan'),
                      InkWell(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _viewModel.orderDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                          );
                          if (date != null) {
                            _viewModel.setOrderDate(date);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today,
                                  color: AppColors.primary), // FIX
                              const SizedBox(width: 8),
                              Text(_formatDate(_viewModel.orderDate)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Tanggal Kirim'),
                      InkWell(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _viewModel.deliveryDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                          );
                          if (date != null) {
                            _viewModel.setDeliveryDate(date);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today,
                                  color: AppColors.primary), // FIX
                              const SizedBox(width: 8),
                              Text(_formatDate(_viewModel.deliveryDate)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Daftar Item',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _showAddItemDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('Tambah Item'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary, // FIX
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildItemList(),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _viewModel.isLoading
                    ? null
                    : () async {
                        bool success;
                        if (widget.poToEdit == null) {
                          success = await _viewModel.submitPO();
                        } else {
                          success = await _viewModel.submitPO();
                        }

                        if (success && mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(widget.poToEdit == null
                                  ? 'PO berhasil dibuat'
                                  : 'PO berhasil diperbarui'),
                            ),
                          );
                          Navigator.pop(context);
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary, // FIX
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _viewModel.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(widget.poToEdit == null ? 'Simpan PO' : 'Update PO'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemList() {
    if (_viewModel.items.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Center(
            child: Text('Belum ada item ditambahkan'),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _viewModel.items.length,
      itemBuilder: (context, index) {
        final item = _viewModel.items[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            title: Text(item.productName),
            subtitle: Text('${item.quantity} ${item.unit} @ Rp ${item.price.toStringAsFixed(0)}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Rp ${(item.price * item.quantity).toStringAsFixed(0)}',
                  style: TextStyle(
                    color: AppColors.primary, // FIX
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _viewModel.removeItem(index);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}