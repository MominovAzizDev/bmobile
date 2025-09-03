import 'package:gazobeton/features/orders/blocs/orders_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/exports.dart';

class OrderDetailView extends StatelessWidget {
  const OrderDetailView({
    super.key,
    required this.orderId,
  });

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppbar(
        title: "Buyurtma tafsilotlari",
        centerTitle: false,
      ),
      body: BlocBuilder<OrdersBloc, OrdersState>(
        builder: (context, state) {
          final order = state.model.where((o) => o.orderId == orderId).firstOrNull;

          if (state.status == OrdersStatus.loading) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.mainColor),
            );
          }

          if (order == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.grey60Color,
                  ),
                  SizedBox(height: 16),
                  AppText(
                    text: "Buyurtma topilmadi",
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.grey60Color,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.pop(),
                    child: AppText(text: "Ortga"),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderCard(order),
                SizedBox(height: 16),
                _buildCustomerInfoCard(order),
                SizedBox(height: 16),
                _buildDeliveryInfoCard(order),
                SizedBox(height: 16),
                _buildOrderTimelineCard(order),
                SizedBox(height: 24),
                _buildActionButtons(context, order),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderCard(OrdersModel order) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                text: "Buyurtma ID",
                fontSize: 14,
                color: AppColors.grey60Color,
                fontWeight: FontWeight.w500,
              ),
              _buildStatusChip(order.status),
            ],
          ),
          SizedBox(height: 4),
          AppText(
            text: order.orderId,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textBlackColor,
          ),
          if (order.orderDate != null) ...[
            SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.access_time_outlined,
                  size: 16,
                  color: AppColors.grey60Color,
                ),
                SizedBox(width: 4),
                AppText(
                  text: DateFormat('dd.MM.yyyy HH:mm').format(order.orderDate!),
                  fontSize: 14,
                  color: AppColors.grey60Color,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCustomerInfoCard(OrdersModel order) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: "Mijoz ma'lumotlari",
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textBlackColor,
          ),
          SizedBox(height: 12),
          _buildDetailRow(
            icon: Icons.person_outline,
            label: "To'liq ism",
            value: order.fullname ?? "Noma'lum",
          ),
          SizedBox(height: 8),
          _buildDetailRow(
            icon: Icons.phone_outlined,
            label: "Telefon raqam",
            value: order.phoneNumber ?? "Noma'lum",
          ),
          SizedBox(height: 8),
          _buildDetailRow(
            icon: Icons.email_outlined,
            label: "Email",
            value: order.email ?? "Noma'lum",
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryInfoCard(OrdersModel order) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: "Yetkazish ma'lumotlari",
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textBlackColor,
          ),
          SizedBox(height: 12),
          _buildDetailRow(
            icon: order.isDeliverable == true ? Icons.local_shipping_outlined : Icons.store_outlined,
            label: "Usul",
            value: order.isDeliverable == true ? "Yetkazib berish" : "Do'kondan olish",
          ),
          SizedBox(height: 8),
          _buildDetailRow(
            icon: Icons.location_on_outlined,
            label: "Manzil",
            value: order.address ?? "Noma'lum",
          ),
        ],
      ),
    );
  }

  Widget _buildOrderTimelineCard(OrdersModel order) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: "Buyurtma holati",
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textBlackColor,
          ),
          SizedBox(height: 12),
          _buildTimelineStep(
            title: "Buyurtma qabul qilindi",
            isCompleted: true,
            isActive: order.status == "pending" || order.status == "kutilmoqda",
          ),
          _buildTimelineStep(
            title: "Buyurtma tasdiqlandi",
            isCompleted: _isStatusCompleted(order.status ?? "", "confirmed"),
            isActive: order.status == "confirmed" || order.status == "tasdiqlangan",
          ),
          _buildTimelineStep(
            title: "Tayyorlanmoqda",
            isCompleted: _isStatusCompleted(order.status ?? "", "processing"),
            isActive: order.status == "processing" || order.status == "jarayonda",
          ),
          _buildTimelineStep(
            title: "Yuborildi",
            isCompleted: _isStatusCompleted(order.status ?? "", "shipped"),
            isActive: order.status == "shipped" || order.status == "yuborilgan",
          ),
          _buildTimelineStep(
            title: "Yetkazildi",
            isCompleted: _isStatusCompleted(order.status ?? "", "delivered"),
            isActive: order.status == "delivered" || order.status == "yetkazilgan" || order.status == "yakunlangan",
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineStep({
    required String title,
    required bool isCompleted,
    required bool isActive,
    bool isLast = false,
  }) {
    return Row(
      children: [
        Column(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted
                    ? AppColors.mainColor
                    : isActive
                    ? AppColors.mainColor.withOpacity(0.3)
                    : Colors.grey.withOpacity(0.3),
                border: Border.all(
                  color: isCompleted || isActive ? AppColors.mainColor : Colors.grey,
                  width: 2,
                ),
              ),
              child: isCompleted ? Icon(Icons.check, color: Colors.white, size: 12) : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 30,
                color: isCompleted ? AppColors.mainColor : Colors.grey.withOpacity(0.3),
              ),
          ],
        ),
        SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 30),
            child: AppText(
              text: title,
              fontSize: 14,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              color: isCompleted || isActive ? AppColors.textBlackColor : AppColors.grey60Color,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: AppColors.grey60Color,
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                text: label,
                fontSize: 12,
                color: AppColors.grey60Color,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(height: 2),
              AppText(
                text: value,
                fontSize: 14,
                color: AppColors.textBlackColor,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(String? status) {
    if (status == null) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
        ),
        child: AppText(
          text: "Noma'lum",
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    Color statusColor;
    Color backgroundColor;

    switch (status.toLowerCase()) {
      case 'pending':
      case 'kutilmoqda':
        statusColor = Colors.orange;
        backgroundColor = Colors.orange.withOpacity(0.1);
        break;
      case 'confirmed':
      case 'tasdiqlangan':
        statusColor = Colors.blue;
        backgroundColor = Colors.blue.withOpacity(0.1);
        break;
      case 'processing':
      case 'jarayonda':
        statusColor = Colors.purple;
        backgroundColor = Colors.purple.withOpacity(0.1);
        break;
      case 'shipped':
      case 'yuborilgan':
        statusColor = Colors.indigo;
        backgroundColor = Colors.indigo.withOpacity(0.1);
        break;
      case 'delivered':
      case 'yetkazilgan':
      case 'yakunlangan':
        statusColor = Colors.green;
        backgroundColor = Colors.green.withOpacity(0.1);
        break;
      case 'cancelled':
      case 'bekor qilingan':
        statusColor = Colors.red;
        backgroundColor = Colors.red.withOpacity(0.1);
        break;
      default:
        statusColor = Colors.grey;
        backgroundColor = Colors.grey.withOpacity(0.1);
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: AppText(
        text: _getStatusDisplayText(status),
        color: statusColor,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, OrdersModel order) {
    if (!_canCancelOrder(order.status ?? "")) {
      return SizedBox();
    }

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => _showCancelDialog(context, order.orderId),
            icon: Icon(Icons.cancel_outlined, color: Colors.red),
            label: AppText(
              text: "Buyurtmani bekor qilish",
              color: Colors.red,
              fontWeight: FontWeight.w600,
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.red),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              context.push(Routes.support);
            },
            icon: Icon(Icons.support_agent, color: Colors.white),
            label: AppText(
              text: "Qo'llab-quvvatlash bilan bog'lanish",
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.mainColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  void _showCancelDialog(BuildContext context, String orderId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: AppText(text: "Buyurtmani bekor qilish"),
          content: AppText(
            text: "Rostdan ham bu buyurtmani bekor qilmoqchimisiz? Bu amalni bekor qilib bo'lmaydi.",
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: AppText(text: "Yo'q"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<OrdersBloc>().add(OrdersCancel(orderId));
                context.pop();
              },
              child: AppText(text: "Ha, bekor qilish", color: Colors.red),
            ),
          ],
        );
      },
    );
  }

  String _getStatusDisplayText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Kutilmoqda';
      case 'confirmed':
        return 'Tasdiqlangan';
      case 'processing':
        return 'Jarayonda';
      case 'shipped':
        return 'Yuborilgan';
      case 'delivered':
        return 'Yetkazilgan';
      case 'cancelled':
        return 'Bekor qilingan';
      case 'yakunlangan':
        return 'Yakunlangan';
      case 'bekor qilingan':
        return 'Bekor qilingan';
      case 'kutilmoqda':
        return 'Kutilmoqda';
      case 'tasdiqlangan':
        return 'Tasdiqlangan';
      case 'jarayonda':
        return 'Jarayonda';
      case 'yuborilgan':
        return 'Yuborilgan';
      case 'yetkazilgan':
        return 'Yetkazilgan';
      default:
        return status;
    }
  }

  bool _canCancelOrder(String status) {
    final nonCancellableStatuses = ['bekor qilingan', 'yakunlangan', 'cancelled', 'delivered', 'shipped', 'yuborilgan', 'yetkazilgan'];

    return !nonCancellableStatuses.contains(status.toLowerCase());
  }

  bool _isStatusCompleted(String currentStatus, String checkStatus) {
    final statusOrder = [
      'pending',
      'kutilmoqda',
      'confirmed',
      'tasdiqlangan',
      'processing',
      'jarayonda',
      'shipped',
      'yuborilgan',
      'delivered',
      'yetkazilgan',
      'yakunlangan',
    ];

    final currentIndex = statusOrder.indexOf(currentStatus.toLowerCase());
    final checkIndex = statusOrder.indexOf(checkStatus.toLowerCase());

    return currentIndex >= checkIndex && checkIndex != -1;
  }
}
