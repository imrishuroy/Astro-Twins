// import 'dart:async';
// import 'dart:ui' as ui;

import '/widgets/display_image.dart';
import 'package:flutter/material.dart';

class ShowChatImage extends StatelessWidget {
  final String imageUrl;
  final bool isCurrentUser;
  const ShowChatImage({
    Key? key,
    required this.imageUrl,
    this.isCurrentUser = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //  Image image = Image.network(imageUrl);
    //Completer<ui.Image> completer = Completer<ui.Image>();

    // int height = 0;
    // int width = 0;

    // image.image
    //     .resolve(const ImageConfiguration())
    //     .addListener(ImageStreamListener((ImageInfo info, bool _) {
    //   print('Image scale - ${info.image.height}');
    //   height = info.image.height;
    //   width = info.image.width;
    //   completer.complete(info.image);
    // }));

    // final a = completer.future;

    // final imageHeight = (image.height ?? 50.0) * 0.5;
    // final imageWidth = (image.width ?? 50.0) * 0.5;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: isCurrentUser ? const Color(0xffF8EBFF) : Colors.grey[300],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(1.2),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: DisplayImage(
            imageUrl: imageUrl,
            // height: height * 0.4,
            // width: width * 0.4,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
