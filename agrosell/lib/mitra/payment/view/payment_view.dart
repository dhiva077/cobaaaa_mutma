import 'package:flutter/material.dart';

class PaymentView extends StatefulWidget {
  final bool isPreOrder;

  const PaymentView({
    super.key,
    this.isPreOrder = false,
  });

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  late String pageTitle;
  late String itemTitle;
  late String itemPrice;

  @override
  void initState() {
    super.initState();
    if (widget.isPreOrder) {
      pageTitle = "Status Pembayaran Pre Order";
      itemTitle = "Padi segar mayur";
      itemPrice = "Rp. 10.000.000.000";
    } else {
      pageTitle = "Status Pembayaran";
      itemTitle = "Beras Organik Premium";
      itemPrice = "Rp. 5.000.000.000";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F2D9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F2D9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF7A8C2E)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          pageTitle,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF49511B),
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ================= BADGE =================
              if (widget.isPreOrder)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7A8C2E).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Pre Order",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF7A8C2E),
                    ),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Siap Kirim",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
              const SizedBox(height: 16),

              // ================= PAYMENT ITEM CARD =================
              _paymentItemCard(
                imagePath: "assets/images/farmer.png",
                title: itemTitle,
                price: itemPrice,
              ),
              const SizedBox(height: 24),

              // ================= DETAIL PESANAN =================
              const Text(
                "Detail Pesanan",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF49511B),
                ),
              ),
              const SizedBox(height: 16),

              if (widget.isPreOrder) ...[
                _detailRow("Subtotal Pre Order", itemPrice),
                const SizedBox(height: 12),
                _detailRow("Biaya Admin", "Rp. 50.000"),
                const SizedBox(height: 12),
                _detailRow("Biaya Reservasi", "Rp. 100.000"),
                const SizedBox(height: 12),
                _detailRow("Ongkir Estimasi", "Rp. 20.000"),
              ] else ...[
                _detailRow("Subtotal", itemPrice),
                const SizedBox(height: 12),
                _detailRow("Biaya Admin", "Rp. 50.000"),
                const SizedBox(height: 12),
                _detailRow("Ongkir", "Rp. 10.000"),
              ],
              const SizedBox(height: 20),

              // ================= DIVIDER =================
              Container(
                height: 1,
                color: Colors.grey[300],
              ),
              const SizedBox(height: 20),

              // ================= TOTAL =================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF49511B),
                    ),
                  ),
                  Text(
                    widget.isPreOrder
                        ? "Rp. 10.000.170.000"
                        : "Rp. 5.000.060.000",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF7A8C2E),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // ================= PAYMENT METHOD =================
              const Text(
                "Pilih Metode Pembayaran",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF49511B),
                ),
              ),
              const SizedBox(height: 16),

              _paymentMethodCard("Bank Transfer", "BCA, Mandiri, BRI"),
              const SizedBox(height: 12),
              _paymentMethodCard("E-Wallet", "GoPay, OVO, Dana"),
              const SizedBox(height: 12),
              _paymentMethodCard("Cicilan", "Tenor 3, 6, 12 bulan"),
              const SizedBox(height: 40),

              // ================= BAYAR BUTTON =================
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Handle payment
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          widget.isPreOrder
                              ? "Proses pembayaran Pre Order dimulai"
                              : "Proses pembayaran dimulai",
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7A8C2E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Bayar Sekarang",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =====================================================
  // PAYMENT ITEM CARD
  // =====================================================
  Widget _paymentItemCard({
    required String imagePath,
    required String title,
    required String price,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage(imagePath),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF49511B),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF7A8C2E),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // DETAIL ROW
  // =====================================================
  Widget _detailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF49511B),
          ),
        ),
      ],
    );
  }

  // =====================================================
  // PAYMENT METHOD CARD
  // =====================================================
  Widget _paymentMethodCard(String method, String details) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey[400]!, width: 2),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                method,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF49511B),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                details,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}