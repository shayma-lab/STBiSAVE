import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CachedImageWidget extends StatelessWidget {
  final String image;
  final double? width;
  final double? height;
  final BoxFit fit;
  const CachedImageWidget(this.image, this.width, this.height, this.fit,
      {super.key});

  @override
  Widget build(BuildContext context) {
    final url = dotenv.env['API_URL'];
    return CachedNetworkImage(
        imageUrl: "$url/${image.replaceAll('\'', '/')}",
        height: height,
        width: width,
        fit: BoxFit.cover,
        placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF3C8CE7),
              ),
            ),
        errorWidget: (context, url, error) => Image.asset(
            "assets/images/avatar.png",
            height: height,
            width: width,
            fit: fit));
  }
}
