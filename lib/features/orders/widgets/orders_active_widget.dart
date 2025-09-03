import '../../../core/exports.dart';
import 'package:intl/intl.dart';

class OrdersActiveWidget extends StatelessWidget {
  const OrdersActiveWidget({
    super.key,
    required this.model,
    this.onTap,
    this.onCancel,
  });

  final OrdersModel model;
  final VoidCallback? onTap;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header - ID va Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: AppText(
                    text: "ID: ${model.orderId}",
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textBlackColor,
                  ),
                ),
                _buildStatusChip(model.status),
              ],
            ),

            const SizedBox(height: 12),

            // Customer info
            _buildInfoRow(
              icon: Icons.person_outline,
              label: "Mijoz",
              value: model.fullname,
            ),

            const SizedBox(height: 8),

            _buildInfoRow(
              icon: Icons.phone_outlined,
              label: "Telefon",
              value: model.phoneNumber,
            ),

            const SizedBox(height: 8),

            _buildInfoRow(
              icon: Icons.location_on_outlined,
              label: "Manzil",
              value: model.address,
            ),

            const SizedBox(height: 8),

            _buildInfoRow(
              icon: Icons.email_outlined,
              label: "Email",
              value: model.email,
            ),

            const SizedBox(height: 8),

            _buildInfoRow(
              icon: model.isDeliverable ? Icons.local_shipping_outlined : Icons.store_outlined,
              label: "Yetkazish",
              value: model.isDeliverable ? "Yetkazib berish" : "Do'kondan olish",
            ),

            if (model.orderDate != null) ...[
              const SizedBox(height: 8),
              _buildInfoRow(
                icon: Icons.access_time_outlined,
                label: "Sana",
                value: DateFormat('dd.MM.yyyy HH:mm').format(model.orderDate!),
              ),
            ],

            // Actions
            if (_canCancelOrder(model.status)) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onCancel,
                      icon: Icon(Icons.cancel_outlined, color: Colors.red),
                      label: AppText(
                        text: "Bekor qilish",
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onTap,
                      icon: Icon(Icons.visibility_outlined, color: Colors.white),
                      label: AppText(
                        text: "Ko'rish",
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.mainColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
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
        const SizedBox(width: 8),
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

  Widget _buildStatusChip(String status) {
    Color statusColor;
    Color backgroundColor;

    switch (status.toLowerCase()) {
      case 'pending':
      case 'kutilmoqda':
        statusColor = Colors.orange;
        backgroundColor = Colors.orange.withValues(alpha: 0.1);
        break;
      case 'confirmed':
      case 'tasdiqlangan':
        statusColor = Colors.blue;
        backgroundColor = Colors.blue.withValues(alpha: 0.1);
        break;
      case 'processing':
      case 'jarayonda':
        statusColor = Colors.purple;
        backgroundColor = Colors.purple.withValues(alpha: 0.1);
        break;
      case 'shipped':
      case 'yuborilgan':
        statusColor = Colors.indigo;
        backgroundColor = Colors.indigo.withValues(alpha: 0.1);
        break;
      case 'delivered':
      case 'yetkazilgan':
      case 'yakunlangan':
        statusColor = Colors.green;
        backgroundColor = Colors.green.withValues(alpha: 0.1);
        break;
      case 'cancelled':
      case 'bekor qilingan':
        statusColor = Colors.red;
        backgroundColor = Colors.red.withValues(alpha: 0.1);
        break;
      default:
        statusColor = Colors.grey;
        backgroundColor = Colors.grey.withValues(alpha: 0.1);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor.withValues(alpha: 0.3)),
      ),
      child: AppText(
        text: _getStatusDisplayText(status),
        color: statusColor,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
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
}