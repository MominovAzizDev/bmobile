
import '../../../core/exports.dart';

class DetailView extends StatelessWidget {
  const DetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: DetailAppBar(
          backgroundColor: Colors.white,
          backTap: () {},
          uploadTap: () async {
            await SharePlus.instance.share(ShareParams(text: "https://youtu.be/XQ1SIS8JSPI?si=AZ6ND922JiT28r_V"));
          },
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.h),
        children: [
          DetailItem(images: imageList),
          SizedBox(height: 16.h),
          ItemContainer(),
          SizedBox(height: 24.h),
          ProductAbout(),
        ],
      ),
      bottomNavigationBar: DetailBottomNavigationBar(callback: () {}, title: "Savatga qo'shish",),
    );
  }
}

final imageList = [
  AppImages.calculator,
  AppImages.blocsD300,
  AppImages.cley,
  AppImages.instruments,
];
