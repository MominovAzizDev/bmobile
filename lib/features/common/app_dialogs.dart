import 'package:gazobeton/core/exports.dart';

enum DialogType { success, error, warning, info }

class CustomDialog extends StatelessWidget {
  final String title;
  final String content;
  final DialogType type;
  final VoidCallback? onConfirm;

  const CustomDialog({
    super.key,
    required this.title,
    required this.content,
    this.type = DialogType.info,
    this.onConfirm,
  });

  IconData get _icon {
    switch (type) {
      case DialogType.success:
        return Icons.check_circle;
      case DialogType.error:
        return Icons.error;
      case DialogType.warning:
        return Icons.warning;
      case DialogType.info:
      return Icons.info;
    }
  }

  Color get _color {
    switch (type) {
      case DialogType.success:
        return Colors.green;
      case DialogType.error:
        return Colors.red;
      case DialogType.warning:
        return Colors.orange;
      case DialogType.info:
      return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(_icon, color: _color),
          const SizedBox(width: 8),
          AppText(text: title, color: _color),
        ],
      ),
      content: AppText(
        text: content,
        fontSize: 16,
        maxLines: 2,
      ),
      actions: [
        TextButton(
          onPressed: () {
            context.pop();
            if (onConfirm != null) onConfirm!();
          },
          child: const AppText(text: "OK"),
        ),
      ],
    );
  }
}

void showCustomDialog({
  required BuildContext context,
  required String title,
  required String content,
  DialogType type = DialogType.info,
  VoidCallback? onConfirm,
}) {
  showDialog(
    context: context,
    builder: (_) => CustomDialog(
      title: title,
      content: content,
      type: type,
      onConfirm: onConfirm,
    ),
  );
}
