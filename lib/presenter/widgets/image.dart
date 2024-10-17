import 'package:flutter/cupertino.dart';

class CustomImage {
  String asset;
  Color? color;

  CustomImage({required this.asset, this.color});

  Widget fromAsset({double? width, double? height, BoxFit? fit}) =>
      asset.isEmpty
          ? const SizedBox()
          : Image.asset(
              asset,
              height: height,
              width: width,
              color: color,
              fit: fit ?? BoxFit.contain,
            );
}
