import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flux_localization/flux_localization.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../../common/tools/image_tools.dart';
import '../../../models/entities/product.dart';

enum ShareProductDataType { images, desc, video }

class ShareProductDataWidget extends StatefulWidget {
  const ShareProductDataWidget({this.product});

  final Product? product;
  @override
  State<ShareProductDataWidget> createState() => _ShareProductDataWidgetState();
}

class _ShareProductDataWidgetState extends State<ShareProductDataWidget> {
  ShareProductDataType? _selectType = ShareProductDataType.images;
  bool _isDownloading = false;
  double? _progressValue;
  late final String? _productDesc =
      (widget.product?.shortDescription?.isNotEmpty ?? false)
          ? widget.product?.shortDescription
          : widget.product?.description;

  void _shareVideo() {
    Share.share(widget.product?.videoUrl ?? '',
        subject: widget.product?.name ?? '');
  }

  void _shareDesc() {
    Share.share(
        Bidi.stripHtmlIfNeeded(
          _productDesc ?? '',
        ),
        subject: widget.product?.name ?? '');
  }

  Future<void> _shareImages() async {
    setState(() {
      _isDownloading = true;
      _progressValue = 0;
    });
    var images = widget.product?.images ?? [];
    var count = 0;
    var files = <XFile>[];
    await Future.forEach<String>(images, (item) async {
      try {
        final url = Uri.parse(item);
        final response = await http.get(url);
        var fileName = url.path.split('/').last;
        var file = await ImageTools.writeToFile(response.bodyBytes,
            fileName: fileName);
        final image = XFile(file.path);
        files.add(image);
      } catch (_) {}
      count += 1;
      setState(() {
        _progressValue = count / images.length;
      });
    });
    setState(() {
      _isDownloading = false;
    });
    Navigator.pop(context);
    if (files.isNotEmpty) {
      try {
        await Share.shareXFiles(files);
      } catch (_) {}
      for (var value in files) {
        try {
          await File(value.path).delete();
        } catch (_) {}
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        S.of(context).shareProductData,
        textAlign: TextAlign.center,
      ),
      content: ShareProductDataContent(
        product: widget.product,
        productDesc: _productDesc,
        isDownloading: _isDownloading,
        progressValue: _progressValue,
        type: _selectType,
        onChanged: (type) {
          setState(() {
            _selectType = type;
          });
        },
      ),
      actions: <Widget>[
        TextButton(
          onPressed: _isDownloading ? null : () => Navigator.pop(context),
          child: Text(S.of(context).cancel),
        ),
        TextButton(
          onPressed: _isDownloading
              ? null
              : () {
                  if (_selectType == ShareProductDataType.desc) {
                    _shareDesc();
                    Navigator.pop(context);
                  } else if (_selectType == ShareProductDataType.video) {
                    _shareVideo();
                    Navigator.pop(context);
                  } else if (_selectType == ShareProductDataType.images) {
                    _shareImages();
                  }
                },
          child: Text(S.of(context).share),
        ),
      ],
    );
  }
}

class ShareProductDataContent extends StatelessWidget {
  const ShareProductDataContent(
      {super.key,
      this.product,
      this.productDesc,
      this.isDownloading,
      this.progressValue,
      this.type,
      required this.onChanged});
  final Product? product;
  final String? productDesc;
  final bool? isDownloading;
  final double? progressValue;
  final ShareProductDataType? type;
  final Function(ShareProductDataType?) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (product?.images.isNotEmpty ?? false)
          RadioListTile<ShareProductDataType>(
            title: Text(S.of(context).images),
            value: ShareProductDataType.images,
            groupValue: type,
            onChanged: onChanged,
          ),
        if (productDesc?.isNotEmpty ?? false)
          RadioListTile<ShareProductDataType>(
            title: Text(S.of(context).description),
            value: ShareProductDataType.desc,
            groupValue: type,
            onChanged: onChanged,
          ),
        if (product?.videoUrl?.isNotEmpty ?? false)
          RadioListTile<ShareProductDataType>(
            title: Text(S.of(context).video),
            value: ShareProductDataType.video,
            groupValue: type,
            onChanged: onChanged,
          ),
        if (isDownloading == true)
          Row(
            children: [
              const SizedBox(
                  height: 12, width: 12, child: CircularProgressIndicator()),
              const SizedBox(width: 10),
              Text(
                S.of(context).downloadingImages,
                style: Theme.of(context).textTheme.bodySmall,
              )
            ],
          ),
        if (isDownloading == true)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: LinearProgressIndicator(value: progressValue),
          ),
      ],
    );
  }
}
