import '../../../core/exports.dart';
import '../widgets/detail_container.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {

  List<int> quantities = List.generate(5, (_) => 1);
  List<int> itemPrices = List.generate(5, (_) => 1000000);

  int get totalPrice => List.generate(quantities.length, (i) => quantities[i] * itemPrices[i]).fold(0, (a, b) => a + b);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: false,
              floating: true,
              backgroundColor: AppColors.backgroundColor,
              expandedHeight: 70.h,
              title: AppText(
                text: "Cart",
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: AppColors.textBlackColor,
              ),
            ),
            if (quantities.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: AppText(
                    text: "Cart bo'sh",
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textGrey,
                  ),
                ),
              )
            else ...[
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 8.h),
                        child: DetailContainer(
                          name: 'Gazabeton',
                          detail: '200 300 700',
                          kvPrice: '729991',
                          price: itemPrices[index].toString(),
                          quantity: quantities[index],
                          minus: () {
                            setState(() {
                              if (quantities[index] > 1) quantities[index]--;
                            });
                          },
                          plus: () {
                            setState(() {
                              quantities[index]++;
                            });
                          },
                          delete: () {
                            setState(() {
                              quantities.removeAt(index);
                              itemPrices.removeAt(index);
                            });
                          },
                        ),
                      );
                    },
                    childCount: quantities.length,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: AppText(
                      text: "Umumiy: ${totalPrice.toStringAsFixed(0)} UZS",
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: AppColors.textGrey,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 16.h)),
            ]
          ],
        ),
        bottomNavigationBar: quantities.isNotEmpty
            ? DetailBottomNavigationBar(
          callback: () {
            context.push(Routes.checkout);
          },
          title: "Buyurtmani rasmiylashtirish",
        )
            : null,
      ),
    );
  }
}