import 'package:gazobeton/core/exports.dart';

class AddressView extends StatelessWidget {
  const AddressView({super.key});

  void _showErrorBanner(String message) {
    final messenger = ScaffoldMessenger.of(navigatorKey.currentContext!);
    messenger.clearMaterialBanners();
    messenger.showMaterialBanner(
      MaterialBanner(
        content: AppText(
          text: message,
          color: Colors.white,
          maxLines: 2,
        ),
        backgroundColor: AppColors.mainColor,
        leading: const Icon(Icons.error, color: Colors.white),
        actions: [
          TextButton(
            onPressed: messenger.hideCurrentMaterialBanner,
            child: const Text(
              'YOPISH',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
    Future.delayed(const Duration(seconds: 3), () {
      messenger.hideCurrentMaterialBanner();
    });
  }

  Future<void> openInMaps(double lat, double lng) async {
    final Uri googleMapsUri = Uri.parse("comgooglemaps://?q=$lat,$lng");
    final Uri yandexMapsUri = Uri.parse("yandexmaps://maps.yandex.com/?pt=$lng,$lat&z=16");
    final Uri fallbackUri = Uri.parse("https://www.google.com/maps/search/?api=1&query=$lat,$lng");

    try {
      // Google Maps ilovasi orqali ochishga harakat qilamiz
      if (await canLaunchUrl(googleMapsUri)) {
        final launched = await launchUrl(
          googleMapsUri,
          mode: LaunchMode.externalApplication,
        );
        if (launched) return;
      }

      // Yandex Maps ilovasi orqali harakat qilamiz
      if (await canLaunchUrl(yandexMapsUri)) {
        final launched = await launchUrl(
          yandexMapsUri,
          mode: LaunchMode.externalApplication,
        );
        if (launched) return;
      }

      // Agar hech biri ilova ochmasa — browserga fallback
      if (await canLaunchUrl(fallbackUri)) {
        await launchUrl(
          fallbackUri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        throw Exception("Hech bir xarita ilovasini ochib bo‘lmadi.");
      }
    } catch (e) {
      debugPrint('Xarita ochishda xatolik: $e');
      _showErrorBanner("Manzilni xaritada ochib bo‘lmadi.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppbar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView(
                children: [
                  AppText(
                    text: "Manzillar",
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textBlackColor,
                  ),
                  SizedBox(height: 32.h),
                  AddressContainer(
                    callback: () {
                      // openInMaps(41.311081, 69.240562); // bu toshkeniki
                      openInMaps(41.27109374040265, 69.22949968510633);
                    },
                    title: '1. Bosh ofis',
                    address: "Toshkent, Yakkasaroy tumani, Cho'ponota ko'chasi, 17",
                  ),
                  SizedBox(height: 12.h),
                  AddressContainer(
                    callback: () {
                      openInMaps(40.797671, 68.684073);
                    },
                    title: '2. Ishlab chiqarish zavodi',
                    address: "Sirdaryo viloyati, Sirdaryo tumani, Sobir Rahimov SIU, Chibantay qo'rg'oni",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
