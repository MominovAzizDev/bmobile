import '../../../core/exports.dart';

class ProfileImagePicker extends StatelessWidget {
  const ProfileImagePicker({super.key, required this.callback});

  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(60),
        child: SizedBox(
          width: 120,
          height: 120,
          child: Stack(
            children: [
              AppImage(
                imageUrl: AppImages.avatar,
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.cover,
              ),

              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: GestureDetector(
                  onTap: callback,
                  child: Container(
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      "Edit",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
