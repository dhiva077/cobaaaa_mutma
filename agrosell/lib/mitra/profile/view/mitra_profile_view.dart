import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../viewmodel/mitra_profile_viewmodel.dart';

class MitraProfileView extends StatefulWidget {
  const MitraProfileView({super.key});

  @override
  State<MitraProfileView> createState() => _MitraProfileViewState();
}

class _MitraProfileViewState extends State<MitraProfileView> {
  final MitraProfileViewModel _viewModel = MitraProfileViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(_onViewModelChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.fetchProfileData();
    });
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _viewModel.isLoading
          ? Center(child: CircularProgressIndicator(color: AppColors.primary))
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: false, 
                  backgroundColor: AppColors.background,
                  elevation: 0,
                  pinned: false,
                  toolbarHeight: 0,
                  flexibleSpace: _buildHeaderTitle(),
                ),

                // Bagian Profile Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 15),
                    child: _buildProfileHeaderCard(),
                  ),
                ),

                // Section: Pesanan Saya
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 5),
                    child: Text(
                      'Pesanan Saya',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 8.0),
                        child: _buildOrderItem(_viewModel.orders[index]),
                      );
                    },
                    childCount: _viewModel.orders.length,
                  ),
                ),

                // Section: List & Detail Pre-Order
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 15, bottom: 5),
                    child: Text(
                      'List & Detail Pre-Order',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 8.0),
                        child: _buildPreOrderItem(_viewModel.preOrders[index]),
                      );
                    },
                    childCount: _viewModel.preOrders.length,
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 30)),
              ],
            ),
    );
  }

  // --- WIDGET HELPER ---

  Widget _buildHeaderTitle() {
    return Container(
      padding: const EdgeInsets.only(left: 20, top: 40, bottom: 5),
      alignment: Alignment.bottomLeft,
      child: Text(
        'Profile',
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildProfileHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          // Gambar/Avatar
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('assets/images/dummy_avatar.png'),
                fit: BoxFit.cover,
              ),
              color: AppColors.primaryLight,
            ),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _viewModel.mitraName,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                _viewModel.mitraType,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.divider),
            ),
            child: Icon(Icons.edit, color: AppColors.primary, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(OrderItem order) {
    final bool isPreOrder = order.type == 'Pre-Order';
    final bool isExpanded = _viewModel.isExpanded(order.id);

    return GestureDetector(
      onTap: () => _viewModel.toggleOrderExpand(order.id),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border.withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Pesanan (Selalu Terlihat)
            Row(
              children: [
                Text(
                  order.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: isPreOrder
                        ? AppColors.secondaryLight
                        : AppColors.primaryLight.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    isPreOrder ? 'Pre-Order' : 'Non Pre-Order',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isPreOrder ? AppColors.accent : AppColors.primaryDark,
                    ),
                  ),
                ),
                const Spacer(),
                // Icon panah yang berputar
                Icon(
                  isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: AppColors.textPrimary,
                ),
              ],
            ),
            
            // Konten Detail (Hanya Muncul saat isExpanded true)
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              crossFadeState: isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: const SizedBox.shrink(), // Widget kosong saat tertutup
              secondChild: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  Divider(height: 1, color: AppColors.divider),
                  const SizedBox(height: 15),
                  // Timeline Status Pengiriman
                  _DeliveryStatusTimeline(currentStatus: order.currentStatus),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreOrderItem(PreOrderItem preOrder) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          // Gambar produk kecil
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryLight,
              image: const DecorationImage(
                image: AssetImage('assets/images/dummy_product_icon.png'),
                fit: BoxFit.cover,
              ),
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(Icons.eco, color: AppColors.textLight, size: 24),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                preOrder.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                preOrder.harvestTime,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DeliveryStatusTimeline extends StatelessWidget {
  final OrderStatus currentStatus;
  const _DeliveryStatusTimeline({required this.currentStatus});

  @override
  Widget build(BuildContext context) {
    final Color activeColor = AppColors.primary;
    final Color inactiveColor = AppColors.divider;

    bool isPaymentActive = currentStatus.index >= OrderStatus.paymentStatus.index;
    bool isInProcessActive = currentStatus.index >= OrderStatus.inProcess.index;
    bool isShippedActive = currentStatus.index >= OrderStatus.shipped.index;

    // Garis yang menghubungkan
    Widget line(bool isActive) => Expanded(
          child: Container(
            height: 2,
            color: isActive ? activeColor : inactiveColor,
          ),
        );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Status Pembayaran (KLIK -> /payment-status)
        GestureDetector(
          onTap: () {
            // Navigasi ke halaman status pembayaran
            Navigator.pushNamed(context, '/payment-status');
          },
          child: _StatusStep(
            label: 'Status Pembayaran',
            iconWidget: Icon(
              Icons.payments_outlined,
              size: 20, 
              color: isPaymentActive ? activeColor : inactiveColor,
            ),
            isActive: isPaymentActive,
            activeColor: activeColor,
            inactiveColor: inactiveColor,
          ),
        ),

        // Garis 1 -> 2
        line(isInProcessActive),

        // 2. Sedang Diproses (KLIK -> /process-status)
        GestureDetector(
          onTap: () {
            // Navigasi ke halaman detail pemrosesan
            Navigator.pushNamed(context, '/process-status');
          },
          child: _StatusStep(
            label: 'Sedang Diproses',
            iconWidget: Icon(
              Icons.all_inbox_outlined,
              size: 20, 
              color: isInProcessActive ? activeColor : inactiveColor,
            ),
            isActive: isInProcessActive,
            activeColor: activeColor,
            inactiveColor: inactiveColor,
          ),
        ),

        // Garis 2 -> 3
        line(isShippedActive),

        // 3. Dikirim (KLIK -> /delivery-status)
        GestureDetector(
          onTap: () {
            // Navigasi ke halaman status pengiriman
            Navigator.pushNamed(context, '/delivery-status');
          },
          child: _StatusStep(
            label: 'Dikirim',
            iconWidget: Icon(
              Icons.local_shipping_outlined,
              size: 20, 
              color: isShippedActive ? activeColor : inactiveColor,
            ),
            isActive: isShippedActive,
            activeColor: activeColor,
            inactiveColor: inactiveColor,
          ),
        ),
      ],
    );
  }
}


class _StatusStep extends StatelessWidget {
  final String label;
  final Widget iconWidget;
  final bool isActive;
  final Color activeColor;
  final Color inactiveColor;

  const _StatusStep({
    required this.label,
    required this.iconWidget,
    required this.isActive,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = isActive ? activeColor : inactiveColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Ikon Status
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border.all(color: color, width: 2),
            borderRadius: BorderRadius.circular(15),
          ),
          child: iconWidget,
        ),
        const SizedBox(height: 5),
        // Teks Status
        Container(
           constraints: const BoxConstraints(maxWidth: 80),
           child: Text(
             label,
             textAlign: TextAlign.center,
             style: TextStyle(
               fontSize: 10,
               color: color,
               fontWeight: FontWeight.w500,
             ),
           ),
        ),
      ],
    );
  }
}