import '../../../core/exports.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(
        repo: context.read<HomeRepository>(),
      )..add(LoadHome()),
      child: const _HomeBody(),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: HomeAppBar(
          callback: () {
            context.push(Routes.support);
          },
        ),
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state.status == HomeStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.mainColor,
              ),
            );
          } else if (state.status == HomeStatus.error) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red[400],
                  ),
                  SizedBox(height: 16.h),
                  AppText(
                    text: "Internet bilan bog'lanishda xatolik",
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textBlackColor,
                  ),
                  SizedBox(height: 8.h),
                  AppText(
                    text: "Internetni tekshirib qayta urinib ko'ring",
                    fontSize: 14,
                    color: AppColors.grey60Color,
                  ),
                  SizedBox(height: 24.h),
                  ElevatedButton(
                    onPressed: () {
                      context.read<HomeBloc>().add(LoadHome());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mainColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: AppText(
                      text: "Qayta urinish",
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          } else if (state.model.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 64,
                    color: AppColors.grey60Color,
                  ),
                  SizedBox(height: 16.h),
                  AppText(
                    text: "Mahsulotlar topilmadi",
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textBlackColor,
                  ),
                  SizedBox(height: 8.h),
                  AppText(
                    text: "Hozircha mahsulotlar mavjud emas",
                    fontSize: 14,
                    color: AppColors.grey60Color,
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<HomeBloc>().add(LoadHome());
            },
            color: AppColors.mainColor,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              children: [
                SizedBox(height: 16.h),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: "Mahsulotlar",
                      fontSize: 20,
                      color: AppColors.textBlackColor,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(height: 12.h),
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: state.model.length,
                      itemBuilder: (context, index) {
                        final item = state.model[index];
                        
                        // Image URL ni to'g'ri formatga keltirish
                        String imageUrl = item.translations.imageUrl.uz_UZ ?? '';
                        if (imageUrl.isNotEmpty && imageUrl.startsWith('/uploads/')) {
                          imageUrl = 'https://api.bsgazobeton.uz$imageUrl';
                        }
                        
                        return HomeDetail(
                          image: imageUrl.isNotEmpty ? imageUrl : AppImages.blocs,
                          text: item.translations.name.uz_UZ.isNotEmpty 
                              ? item.translations.name.uz_UZ 
                              : "Mahsulot nomi",
                          callback: () {
                            // Mahsulot ID ni ham o'tkazish kerak bo'lsa
                            context.push('${Routes.detail}?categoryId=${item.productCategoryId}');
                          },
                        );
                      },
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8.w,
                        mainAxisSpacing: 8.h,
                        childAspectRatio: 167.w / 186.h,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    AppText(
                      text: "Kalkulyator",
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textBlackColor,
                    ),
                    SizedBox(height: 12.h),
                    CalculatorImage(
                      callback: () {
                        context.push(Routes.calculator);
                      },
                    ),
                  ],
                ),
                SizedBox(height: 50.h),
              ],
            ),
          );
        },
      ),
    );
  }
}