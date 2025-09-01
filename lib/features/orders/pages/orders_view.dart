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
                color: AppColors.grey60Color.withValues(alpha: 0.35),
                borderRadius: BorderRadiusGeometry.circular(14.r),
              ),
              padding: EdgeInsetsGeometry.all(4),
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
              child: AppText(text: "Xatolik bor", color: Colors.black, fontSize: 33),
            ),
            OrdersStatus.loading => Center(child: CircularProgressIndicator()),
            OrdersStatus.idle => TabBarView(
              controller: _tabController,
              children: [
                // ACTIVE ORDERS
                (() {
                  final activeOrders = state.model.where((model) => model.status != "bekor qilingan" && model.status != "yakunlangan").toList();

                  return activeOrders.isEmpty
                      ? Center(
                          child: AppText(
                            text: "No Orders",
                            color: AppColors.grey60Color,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      : ListView.builder(
                          itemCount: activeOrders.length,
                          itemBuilder: (context, index) {
                            final model = activeOrders[index];
                            return OrdersActiveWidget(
                              id: model.orderId,
                              date: model.orderDate.toString(),
                              price: model.orderId.toString(),
                              status: model.status,
                            );
                          },
                        );
                })(),

                // ARCHIVE ORDERS
                (() {
                  final archiveOrders = state.model.where((model) => model.status == "bekor qilingan" || model.status == "yakunlangan").toList();

                  return archiveOrders.isEmpty
                      ? Center(
                          child: AppText(
                            text: "No Orders",
                            color: AppColors.grey60Color,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      : ListView.builder(
                          itemCount: archiveOrders.length,
                          itemBuilder: (context, index) {
                            final model = archiveOrders[index];
                            return OrdersActiveWidget(
                              id: model.orderId,
                              date: model.orderDate.toString(),
                              price: model.orderId.toString(),
                              status: model.status,
                            );
                          },
                        );
                })(),
              ],
            ),
          };
        },
      ),
    );
  }
}
