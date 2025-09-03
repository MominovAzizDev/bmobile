import 'package:gazobeton/features/orders/blocs/orders_bloc.dart';
import 'package:gazobeton/features/orders/widgets/orders_active_widget.dart';
import '../../../core/exports.dart';

class OrdersView extends StatefulWidget {
  const OrdersView({super.key});

  @override
  State<OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onRefresh() {
    context.read<OrdersBloc>().add(OrdersRefresh());
  }

  void _onCreateOrder() {
    context.read<OrdersBloc>().add(OrdersCreate());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(
          text: "Orders",
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: InkWell(
              onTap: () {
                context.push(Routes.support);
              },
              child: SizedBox(
                child: Row(
                  children: [
                    AppImage(imageUrl: AppIcons.phone2),
                    SizedBox(width: 4.w),
                    AppText(
                      text: "Aloqa",
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.mainColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
        toolbarHeight: 96,
        bottom: PreferredSize(
          preferredSize: Size(343.w, 48.h),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.grey60Color.withOpacity(0.35), 
                borderRadius: BorderRadius.circular(14.r),
              ),
              padding: EdgeInsets.all(4), 
              child: TabBar(
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                controller: _tabController,
                labelColor: AppColors.textBlackColor,
                unselectedLabelColor: AppColors.textBlackColor,
                splashFactory: InkRipple.splashFactory,
                splashBorderRadius: BorderRadius.circular(12),
                indicator: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                indicatorColor: Colors.white,
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 15,
                ),
                tabs: const [
                  Tab(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: AppText(text: "Active"),
                    ),
                  ),
                  Tab(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: AppText(text: "Archive"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: BlocBuilder<OrdersBloc, OrdersState>(
        builder: (context, state) {
          return switch (state.status) {
            OrdersStatus.error => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    text: "Xatolik yuz berdi", 
                    color: Colors.red, 
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  if (state.errorMessage != null) ...[
                    SizedBox(height: 8),
                    AppText(
                      text: state.errorMessage!,
                      color: Colors.grey,
                      fontSize: 14,
                      textAlign: TextAlign.center,
                    ),
                  ],
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<OrdersBloc>().add(OrdersLoad());
                    },
                    child: AppText(text: "Qayta urinish"),
                  ),
                ],
              ),
            ),
            OrdersStatus.loading => Center(
              child: CircularProgressIndicator(
                color: AppColors.mainColor,
              ),
            ),
            OrdersStatus.idle => RefreshIndicator(
              onRefresh: () async {
                _onRefresh();
                await Future.delayed(Duration(milliseconds: 500));
              },
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOrdersList(
                    orders: state.model.where((model) => 
                      model.status != "bekor qilingan" && 
                      model.status != "yakunlangan"
                    ).toList(),
                    emptyMessage: "Hozirda faol buyurtmalar yo'q",
                  ),
                  _buildOrdersList(
                    orders: state.model.where((model) => 
                      model.status == "bekor qilingan" || 
                      model.status == "yakunlangan"
                    ).toList(),
                    emptyMessage: "Arxiv buyurtmalari yo'q",
                  ),
                ],
              ),
            ),
          };
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onCreateOrder,
        backgroundColor: AppColors.mainColor,
        icon: Icon(Icons.add, color: Colors.white),
        label: AppText(
          text: "Yangi buyurtma",
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildOrdersList({
    required List<OrdersModel> orders,
    required String emptyMessage,
  }) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: AppColors.grey60Color,
            ),
            SizedBox(height: 16),
            AppText(
              text: emptyMessage,
              color: AppColors.grey60Color,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final model = orders[index];
        return Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: OrdersActiveWidget(
            model: model,
            onTap: () {
              context.push('/orders/${model.orderId}');
            },
            onCancel: () {
              _showCancelDialog(context, model.orderId);
            },
          ),
        );
      },
    );
  }

  void _showCancelDialog(BuildContext context, String orderId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: AppText(text: "Buyurtmani bekor qilish"),
          content: AppText(text: "Rostdan ham bu buyurtmani bekor qilmoqchimisiz?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: AppText(text: "Yo'q"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<OrdersBloc>().add(OrdersCancel(orderId));
              },
              child: AppText(text: "Ha", color: Colors.red),
            ),
          ],
        );
      },
    );
  }
}