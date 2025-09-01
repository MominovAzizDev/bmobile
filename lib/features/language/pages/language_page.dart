import '../../../core/exports.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  final List<Map<String, String>> languages = [
    {'name': 'O‘zbek'},
    {'name': 'English'},
    {'name': 'Русский'},
  ];
  final List<String> icons = [
    AppIcons.uzbek,
    AppIcons.english,
    AppIcons.russian,
  ];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppbar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              text: "Language",
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
            32.verticalSpace,
            Expanded(
              child: ListView.separated(
                itemCount: languages.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final lang = languages[index];
                  final icon = icons[index];
                  final isSelected = index == selectedIndex;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Container(
                      width: 343.w,
                      height: 56.h,
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.mainColor.withValues(alpha: 0.2) : Colors.white,
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(
                          color: isSelected ? AppColors.mainColor.withValues(alpha: 0.3) : Colors.grey.shade300,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          AppImage(
                            imageUrl: icon,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: AppText(
                              text: lang['name']!,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Icon(
                            isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                            color: isSelected ? AppColors.mainColor : Colors.black12,
                            size: 24,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
