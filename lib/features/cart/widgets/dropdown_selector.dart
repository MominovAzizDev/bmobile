import '../../../core/exports.dart';

class DropdownSelector<T> extends StatefulWidget {
  const DropdownSelector({
    super.key,
    required this.title,
    required this.menuEntries,
    required this.callback,
    required this.validator,
    this.initialSelection,
    required this.width,
    required this.height,
    this.minWidth = 250,
    this.maxWidth = 250,
    this.hintText,
    this.fillColor,
  });

  final String title;
  final Function(T?) callback;
  final String? Function(T?) validator;
  final List<DropdownMenuEntry<T>> menuEntries;
  final T? initialSelection;
  final double width, height, minWidth, maxWidth;
  final String? hintText;
  final Color? fillColor;

  @override
  State<DropdownSelector<T>> createState() => _DropdownSelectorState<T>();
}

class _DropdownSelectorState<T> extends State<DropdownSelector<T>>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isFullWidth = widget.width == double.infinity;

    return FormField<T>(
      validator: widget.validator,
      builder: (field) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: isFullWidth ? double.infinity : widget.width,
              height: widget.height,
              child: Theme(
                data: Theme.of(context).copyWith(
                  inputDecorationTheme: InputDecorationTheme(
                    
                    filled: true,
                    fillColor: widget.fillColor ?? Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 1.2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 1.2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                child: DropdownMenu<T>(
                  trailingIcon: AppImage(imageUrl: AppIcons.downArrow),
                  width: isFullWidth ? double.infinity : widget.width,
                  hintText: widget.hintText,
                  enableSearch: true,
                  enableFilter: true,
                  initialSelection: widget.initialSelection,
                  onSelected: (value) {
                    widget.callback(value);
                    field.didChange(value);
                  },
                  dropdownMenuEntries: widget.menuEntries,
                  menuStyle: MenuStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.white), // Orqa fon oq
                    surfaceTintColor: MaterialStateProperty.all<Color>(Colors.transparent), // Tint'ni olib tashlash
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    elevation: MaterialStateProperty.all(4),
                  ),
                )
                ,
              ),
            ),
            if (field.hasError)
              AnimatedBuilder(
                animation: Tween<double>(begin: 0, end: 1).animate(animationController),
                builder: (context, child) {
                  animationController.forward();
                  return FadeTransition(
                    opacity: animationController,
                    child: child,
                  );
                },
                child: Text(
                  field.errorText!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
