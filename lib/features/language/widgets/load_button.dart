import '../../../core/exports.dart';

class LoadButton extends StatelessWidget {
  const LoadButton({
    super.key,
    required this.call,
  });

  final VoidCallback call;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: call,
      icon: Icon(Icons.file_upload_outlined),
    );
  }
}
