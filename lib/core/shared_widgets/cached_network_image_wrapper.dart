import 'package:cached_network_image/cached_network_image.dart';
import 'package:flower_driver/core/shared_widgets/shimmer_box.dart';
import 'package:flower_driver/core/utils/app_assets.dart';
import 'package:flutter/material.dart';

class CachedNetworkImageWrapper extends StatelessWidget {
  final String imagePath;
  final double? width;
  final double? height;
  final BoxFit? fit;

  const CachedNetworkImageWrapper({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imagePath,
      placeholder: (context, url) => ShimmerBox(
        height: height ?? double.infinity,
        width: width ?? double.infinity,
      ),
      errorWidget: (context, url, error) => Image.asset(
        AppAssets.userTestImage,
        width: width,
        height: height,
        fit: fit,
      ),
      width: width,
      height: height,
      fit: fit,
    );
  }
}
