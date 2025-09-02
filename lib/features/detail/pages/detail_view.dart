import 'package:gazobeton/features/detail/bloc/product_bloc.dart';
import 'package:gazobeton/features/detail/bloc/product_event.dart';
import 'package:gazobeton/features/detail/bloc/product_state.dart';

import '../../../core/exports.dart';
import '../../../data/models/auth_models/product_model.dart';

class DetailView extends StatefulWidget {
  final String? categoryId; // Kategoriya ID si (productId emas!)

  const DetailView({super.key, this.categoryId});

  @override
  State<DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  @override
  void initState() {
    super.initState();
    // Sahifa ochilganda kategoriya bo'yicha mahsulotlarni yuklash
    if (widget.categoryId != null && widget.categoryId!.isNotEmpty) {
      print('Loading products for category: ${widget.categoryId}'); // Debug uchun
      context.read<ProductBloc>().add(LoadProductsByCategoryEvent(widget.categoryId!));
    } else {
      // ID bo'lmasa, barcha mahsulotlarni yuklash
      context.read<ProductBloc>().add(LoadProductsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: DetailAppBar(
          backgroundColor: Colors.white,
          backTap: () {
            Navigator.pop(context);
          },
          uploadTap: () async {
            await SharePlus.instance.share(ShareParams(text: "https://youtu.be/XQ1SIS8JSPI?si=AZ6ND922JiT28r_V"));
          },
        ),
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.mainColor,
              ),
            );
          }

          if (state is ProductError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  SizedBox(height: 16),
                  AppText(
                    text: state.message,
                    fontSize: 16,
                    color: Colors.red,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (widget.categoryId != null && widget.categoryId!.isNotEmpty) {
                        context.read<ProductBloc>().add(LoadProductsByCategoryEvent(widget.categoryId!));
                      } else {
                        context.read<ProductBloc>().add(LoadProductsEvent());
                      }
                    },
                    child: Text('Qayta urinish'),
                  ),
                ],
              ),
            );
          }

          List<ProductModel> products = [];
          
          if (state is ProductLoaded) {
            products = state.products;
          } else if (state is ProductDetailLoaded) {
            products = [state.product];
          }

          if (products.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 64,
                    color: AppColors.grey60Color,
                  ),
                  SizedBox(height: 16),
                  AppText(
                    text: "Bu kategoriyada mahsulotlar topilmadi",
                    fontSize: 16,
                    color: AppColors.textGrey,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ProductBloc>().add(LoadProductsEvent());
                    },
                    child: Text('Barcha mahsulotlarni ko\'rish'),
                  ),
                ],
              ),
            );
          }

          // Agar bir nechta mahsulot bo'lsa, birinchisini ko'rsatish yoki listini ko'rsatish
          final currentProduct = products.first;

          // Rasmlar ro'yxatini yaratish (safe conversion)
          List<String> productImages = [];
          try {
            if (currentProduct.translations.imageUrl.isNotEmpty) {
              // API dan kelgan rasmlarni ishlatish
              productImages = currentProduct.translations.imageUrl.values
                  .where((img) => img != null && img.isNotEmpty)
                  .map((img) => img.toString())
                  .toList();
            }
          } catch (e) {
            productImages = [];
          }
          
          // Agar rasmlar bo'lmasa, default rasmlarni ishlatish
          if (productImages.isEmpty) {
            productImages = imageList;
          }

          return Column(
            children: [
              // Agar bir nechta mahsulot bo'lsa, ularni tanlash uchun horizontal scroll
              if (products.length > 1) ...[
                Container(
                  height: 60.h,
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      final isSelected = index == 0; // Default birinchisini tanlangan deb hisoblaymiz
                      
                      String productName = '';
                      try {
                        final nameMap = product.translations.name;
                        if (nameMap.containsKey('uz') && nameMap['uz'] != null) {
                          productName = nameMap['uz'].toString();
                        } else if (nameMap.values.isNotEmpty && nameMap.values.first != null) {
                          productName = nameMap.values.first.toString();
                        }
                      } catch (e) {
                        productName = 'Mahsulot ${index + 1}';
                      }
                      
                      if (productName.isEmpty) {
                        productName = 'Mahsulot ${index + 1}';
                      }

                      return GestureDetector(
                        onTap: () {
                          // Tanlangan mahsulotni ko'rsatish logikasi
                          // Bu yerda state management qo'shishingiz mumkin
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 12.w),
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.mainColor : Colors.grey[200],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: AppText(
                              text: productName,
                              fontSize: 12,
                              color: isSelected ? Colors.white : AppColors.textGrey,
                              fontWeight: FontWeight.w600,
                              maxLines: 1,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Divider(color: Colors.grey[300]),
              ],
              
              // Asosiy mahsulot ma'lumoti
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 16.h),
                  children: [
                    DetailItem(images: productImages),
                    SizedBox(height: 16.h),
                    ItemContainer(product: currentProduct),
                    SizedBox(height: 24.h),
                    ProductAbout(product: currentProduct),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          return DetailBottomNavigationBar(
            callback: () {
              // Savatga qo'shish logikasi
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Mahsulot savatga qo'shildi"),
                  backgroundColor: AppColors.mainColor,
                ),
              );
            },
            title: "Savatga qo'shish",
          );
        },
      ),
    );
  }
}

// Default rasmlar (agar API dan rasm kelmasa)
final imageList = [
  AppImages.calculator,
  AppImages.blocsD300,
  AppImages.cley,
  AppImages.instruments,
];