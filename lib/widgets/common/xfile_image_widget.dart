import 'dart:typed_data';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flux_ui/flux_ui.dart';
import 'package:image_picker/image_picker.dart';

import '../../common/constants.dart';

class XFileImageWidget extends StatefulWidget {
  final XFile image;
  final double? width;
  final double? height;
  final BoxFit? fit;
  const XFileImageWidget({
    super.key,
    required this.image,
    this.width,
    this.height,
    this.fit,
  });

  @override
  StateXFileImageWidget createState() => StateXFileImageWidget();
}

class StateXFileImageWidget extends State<XFileImageWidget> {
  final ValueNotifier<Uint8List?> imageNotifier = ValueNotifier(null);
  CancelableCompleter<Uint8List>? completer;

  @override
  void initState() {
    super.initState();
    completer = CancelableCompleter<Uint8List>();
    completer?.complete(widget.image.readAsBytes());
    completer?.operation.valueOrCancellation().then((value) {
      if (mounted) {
        imageNotifier.value = value;
      }
    });
  }

  @override
  void dispose() {
    completer?.operation.cancel();
    imageNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Uint8List?>(
      valueListenable: imageNotifier,
      builder: (_, bytes, __) {
        if (bytes == null) {
          return FluxImage(
            imageUrl: kDefaultImage,
            width: widget.width,
            height: widget.height,
            fit: widget.fit,
          );
        }
        return Image.memory(
          bytes,
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
        );
      },
    );
  }
}
