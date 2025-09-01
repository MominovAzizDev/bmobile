import '../../../core/exports.dart';

class CalculatorView extends StatefulWidget {
  const CalculatorView({super.key});

  @override
  State<CalculatorView> createState() => _CalculatorViewState();
}

class _CalculatorViewState extends State<CalculatorView> {
  final TextEditingController uzinlikController = TextEditingController();
  final TextEditingController balandController = TextEditingController();

  int? selectedThickness;
  bool showResult = false;
  int? resultCount;
  double? resultVolume;

  final List<DropdownMenuEntry<int>> thicknessOptions = [
    DropdownMenuEntry(value: 50, label: '50 mm'),
    DropdownMenuEntry(value: 100, label: '100 mm'),
    DropdownMenuEntry(value: 125, label: '125 mm'),
    DropdownMenuEntry(value: 200, label: '200 mm'),
    DropdownMenuEntry(value: 250, label: '250 mm'),
    DropdownMenuEntry(value: 300, label: '300 mm'),
    DropdownMenuEntry(value: 350, label: '350 mm'),
    DropdownMenuEntry(value: 400, label: '400 mm'),
  ];

  double? calculateVolume() {
    final double? uzunlik = double.tryParse(uzinlikController.text);
    final double? balandlik = double.tryParse(balandController.text);
    final int? qalinlik = selectedThickness;

    if (uzunlik == null || balandlik == null || qalinlik == null) return null;

    final wallVolume = uzunlik * balandlik * (qalinlik / 1000);
    return wallVolume;
  }

  int? calculateBlockCount(double volume) {
    const blockVolume = 0.03;
    return (volume / blockVolume).ceil();
  }

  void handleCalculate() {
    final volume = calculateVolume();
    if (volume != null) {
      final count = calculateBlockCount(volume);
      setState(() {
        resultVolume = volume;
        resultCount = count;
        showResult = true;
      });
    } else {
      setState(() {
        showResult = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Barcha maydonlarni to‘ldiring")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppbar(
        title: "Kalkulyator",
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CheckoutFormField(
                controller: uzinlikController,
                title: "Devor uzunligi (m)",
                hintText: "0 m",
                validator: (_) {},
                isValid: true,
                fontWeight: FontWeight.w600,
                color: AppColors.textBlackColor,
                size: 12,
              ),
              SizedBox(height: 24.h),
              CheckoutFormField(
                controller: balandController,
                title: "Devor balandligi (m)",
                hintText: "0 m",
                validator: (_) {},
                isValid: true,
                fontWeight: FontWeight.w600,
                color: AppColors.textBlackColor,
                size: 12,
              ),
              SizedBox(height: 24.h),
              DropdownSelector(
                title: "Devor qalinligi (mm)",
                hintText: "Tanlang...",
                menuEntries: thicknessOptions,
                callback: (value) {
                  selectedThickness = value;
                },
                validator: (value) {
                  if (value == null) return "Qalinlik tanlang";
                  return null;
                },
                width: double.infinity,
                height: 48,
              ),
              SizedBox(height: 32.h),
              AppElevatedButton(
                onPressed: handleCalculate,
                text: "Hisoblash",
                radius: 14,
              ),
              SizedBox(height: 32.h),
              if (showResult && resultCount != null && resultVolume != null)
                NatijaWidget(
                  dona: "${resultCount!} dona",
                  hajm: "${resultVolume!.toStringAsFixed(2)} m³",
                ),
            ],
          ),
        ),
      ),
    );
  }
}
