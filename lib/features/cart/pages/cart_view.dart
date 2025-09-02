import 'package:gazobeton/features/cart/bloc/cart_bloc.dart';
import 'package:gazobeton/features/cart/bloc/cart_event.dart';
import 'package:gazobeton/features/cart/bloc/cart_state.dart';

import '../../../core/exports.dart';
import '../widgets/detail_container.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  @override
  void initState() {
    super.initState();
    // Cart ma'lumotlarini yuklash
    context.read<CartBloc>().add(CartLoaded());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            return CustomScrollView(
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
                
                // Loading holatda
                if (state.status == CartStatus.loading)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.mainColor,
                      ),
                    ),
                  )
                
                // Error holatda  
                else if (state.status == CartStatus.error)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppText(
                            text: "Xatolik yuz berdi",
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textGrey,
                          ),
                          SizedBox(height: 16.h),
                          GestureDetector(
                            onTap: () {
                              context.read<CartBloc>().add(CartLoaded());
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                              decoration: BoxDecoration(
                                color: AppColors.mainColor,
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: AppText(
                                text: "Qayta urinish",
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                
                // Cart bo'sh
                else if (state.items.isEmpty)
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
                
                // Cart ma'lumotlari
                else ...[
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final item = state.items[index];
                          return Padding(
                            padding: EdgeInsets.only(bottom: 8.h),
                            child: DetailContainer(
                              name: item.productName,
                              detail: item.productDetail,
                              kvPrice: item.kvPrice,
                              price: "${item.price.toStringAsFixed(0)} UZS",
                              quantity: item.quantity,
                              minus: () {
                                if (item.quantity > 1) {
                                  context.read<CartBloc>().add(
                                    CartItemQuantityUpdated(
                                      productId: item.productId,
                                      quantity: item.quantity - 1,
                                    ),
                                  );
                                }
                              },
                              plus: () {
                                context.read<CartBloc>().add(
                                  CartItemQuantityUpdated(
                                    productId: item.productId,
                                    quantity: item.quantity + 1,
                                  ),
                                );
                              },
                              delete: () {
                                context.read<CartBloc>().add(
                                  CartItemRemoved(productId: item.productId),
                                );
                              },
                            ),
                          );
                        },
                        childCount: state.items.length,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: AppText(
                          text: "Umumiy: ${state.totalPrice.toStringAsFixed(0)} UZS",
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
            );
          },
        ),
        bottomNavigationBar: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            return state.items.isNotEmpty
                ? DetailBottomNavigationBar(
                    callback: () {
                      context.push(Routes.checkout);
                    },
                    title: "Buyurtmani rasmiylashtirish",
                  )
                : null;
          },
        ),
      ),
    );
  }
}