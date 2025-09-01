import '../../../core/exports.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(
        repo: context.read<HomeRepository>(),
      )..add(LoadHome(),),
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
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == HomeStatus.error) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Xatolik yuz berdi"),
                  ElevatedButton(
                    onPressed: () {
                      context.read<HomeBloc>().add(LoadHome());
                    },
                    child: Text("Qayta urinish"),
                  )
                ],
              ),
            );
          }
          else if (state.model.isEmpty) {
            return const Center(child: Text("Ma'lumotlar topilmadi"));
          }

          return ListView(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            children: [
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
                      return HomeDetail(
                        image: item.translations.imageUrl.uz_UZ,
                        text: item.translations.name.uz_UZ,
                        callback: () {
                          context.push(Routes.detail);
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
                  AppText(
                    text: "Kalkulyator",
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(height: 12),
                  CalculatorImage(
                    callback: () {
                      context.push(Routes.calculator);
                    },
                  ),
                ],
              ),
              50.verticalSpace,
            ],
          );
        },
      ),
    );
  }
}
