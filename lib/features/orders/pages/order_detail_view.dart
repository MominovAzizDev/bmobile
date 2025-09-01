import '../../../core/exports.dart';

class OrderDetailView extends StatelessWidget {
  const OrderDetailView({super.key, });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppbar(
        title: "Ortga",
        centerTitle: false,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(text: "Buyurtma ID: ")
          ],
        ),
      ),
    );
  }
}
