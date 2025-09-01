

import '../../core/exports.dart';

class AppImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final BorderRadius? borderRadius;
  final Color? color;
  final BlendMode? colorBlendMode;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Alignment alignment;

  const AppImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.borderRadius,
    this.color,
    this.colorBlendMode,
    this.padding,
    this.margin,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: _buildImage(),
      ),
    );
  }

  Widget _buildImage() {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _buildErrorWidget();
    }

    // SVG formatini tekshirish
    if (_isSvg(imageUrl!)) {
      return _buildSvgImage();
    }

    // Network image (HTTP/HTTPS) formatini tekshirish
    if (_isNetworkImage(imageUrl!)) {
      return _buildNetworkImage();
    }

    // Asset image formatini tekshirish
    if (_isAssetImage(imageUrl!)) {
      return _buildAssetImage();
    }

    // File image formatini tekshirish
    return _buildFileImage();
  }

  // SVG rasmni ko'rsatish
  Widget _buildSvgImage() {
    if (_isNetworkImage(imageUrl!)) {
      return SvgPicture.network(
        imageUrl!,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        color: color,
        colorBlendMode: colorBlendMode ?? BlendMode.srcIn,
        placeholderBuilder: (context) => _buildPlaceholder(),
      );
    } else if (_isAssetImage(imageUrl!)) {
      return SvgPicture.asset(
        imageUrl!,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        color: color,
        colorBlendMode: colorBlendMode ?? BlendMode.srcIn,
      );
    } else {
      return SvgPicture.network(
        imageUrl!,
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        color: color,
        colorBlendMode: colorBlendMode ?? BlendMode.srcIn,
        placeholderBuilder: (context) => _buildPlaceholder(),
      );
    }
  }

  // Network rasmni ko'rsatish (caching bilan)
  Widget _buildNetworkImage() {
    return CachedNetworkImage(
      imageUrl: imageUrl!,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      color: color,
      colorBlendMode: colorBlendMode,
      placeholder: (context, url) => _buildPlaceholder(),
      errorWidget: (context, url, error) => _buildErrorWidget(),
      fadeInDuration: const Duration(milliseconds: 300),
      fadeOutDuration: const Duration(milliseconds: 300),
    );
  }

  // Asset rasmni ko'rsatish
  Widget _buildAssetImage() {
    return Image.asset(
      imageUrl!,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      color: color,
      colorBlendMode: colorBlendMode,
      errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
    );
  }

  // File rasmni ko'rsatish
  Widget _buildFileImage() {
    return Image.network(
      imageUrl!,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      color: color,
      colorBlendMode: colorBlendMode,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return _buildPlaceholder();
      },
      errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
    );
  }



  // Placeholder widget
  Widget _buildPlaceholder() {
    return placeholder ??
        Container(
          width: width,
          height: height,
          color: Colors.grey[200],
          child: const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
            ),
          ),
        );
  }

  // Error widget
  Widget _buildErrorWidget() {
    return errorWidget ??
        Container(
          width: width,
          height: height,
          color: Colors.grey[100],
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.broken_image_outlined,
                  size: (width != null && height != null)
                      ? (width! < height! ? width! * 0.3 : height! * 0.3)
                      : 30,
                  color: Colors.grey[400],
                ),
                if (width == null || width! > 60)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Rasm yuklanmadi',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
  }

  // SVG formatini aniqlash
  bool _isSvg(String url) {
    return url.toLowerCase().contains('.svg') ||
        url.toLowerCase().contains('svg');
  }

  // Network image formatini aniqlash
  bool _isNetworkImage(String url) {
    return url.startsWith('http://') || url.startsWith('https://');
  }

  // Asset image formatini aniqlash
  bool _isAssetImage(String url) {
    return url.startsWith('assets/') ||
        url.startsWith('images/') ||
        !url.contains('/') && !url.startsWith('http');
  }

  // Foydali static metodlar
  static Widget circle({
    required String? imageUrl,
    required double size,
    Color? backgroundColor,
    Widget? placeholder,
    Widget? errorWidget,
  }) {
    return AppImage(
      imageUrl: imageUrl,
      width: size,
      height: size,
      borderRadius: BorderRadius.circular(size / 2),
      placeholder: placeholder,
      errorWidget: errorWidget,
    );
  }

  static Widget rounded({
    required String? imageUrl,
    double? width,
    double? height,
    double radius = 8,
    BoxFit fit = BoxFit.cover,
    Widget? placeholder,
    Widget? errorWidget,
  }) {
    return AppImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      borderRadius: BorderRadius.circular(radius),
      fit: fit,
      placeholder: placeholder,
      errorWidget: errorWidget,
    );
  }
}

// Misol uchun ishlatish
class AppImageExample extends StatelessWidget {
  const AppImageExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('AppImage Misoli')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Network Image (HTTPS):'),
            SizedBox(height: 8),
            AppImage(
              imageUrl: 'https://via.placeholder.com/300x200.png',
              width: double.infinity,
              height: 200,
              borderRadius: BorderRadius.circular(12),
            ),

            SizedBox(height: 24),
            Text('SVG Image:'),
            SizedBox(height: 8),
            AppImage(
              imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/0/02/SVG_logo.svg',
              width: 100,
              height: 100,
            ),

            SizedBox(height: 24),
            Text('Asset Image:'),
            SizedBox(height: 8),
            AppImage(
              imageUrl: 'assets/images/my_image.png',
              width: 150,
              height: 150,
              borderRadius: BorderRadius.circular(8),
            ),

            SizedBox(height: 24),
            Text('Aylanma rasm:'),
            SizedBox(height: 8),
            AppImage.circle(
              imageUrl: 'https://via.placeholder.com/100x100.jpg',
              size: 80,
            ),

            SizedBox(height: 24),
            Text('Burchakli rasm:'),
            SizedBox(height: 8),
            AppImage.rounded(
              imageUrl: 'https://via.placeholder.com/200x150.jpg',
              width: 200,
              height: 150,
              radius: 16,
            ),
          ],
        ),
      ),
    );
  }
}