import 'dart:async';
import 'dart:convert';
import 'dart:io' as file;
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:inspireui/utils/logs.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../dependency_injection/dependency_injection.dart';
import '../../services/index.dart' show ServerConfig, ConfigType;
import '../config.dart' show kAdvanceConfig;
import '../config/models/optimize_image_config.dart';
import '../constants.dart' show NullableStringExtensions, kDefaultImage;
import 'image_resize.dart' show kSize;

export './image_resize.dart';

class ImageTools {
  static String prestashopImage(String url, [kSize? size = kSize.medium]) {
    if (url.contains('?')) {
      switch (size) {
        case kSize.large:
          return url.replaceFirst('?', '/large_default?');
        case kSize.small:
          return url.replaceFirst('?', '/small_default?');
        default: // kSize.medium
          return url.replaceFirst('?', '/medium_default?');
      }
    }
    switch (size) {
      case kSize.large:
        return '$url/large_default';
      case kSize.small:
        return '$url/small_default';
      default: // kSize.medium
        return '$url/medium_default';
    }
  }

  static final _regexImageShopify = RegExp('(?:[-_]?[0-9]+x[0-9]+)+');

  static String shopifyImage(String url, [kSize? size = kSize.medium]) {
    var lastIndex = url.lastIndexOf('_');
    lastIndex = lastIndex == -1 ? 0 : lastIndex;
    return url.replaceFirstMapped(_regexImageShopify, (match) {
      switch (size) {
        case kSize.large:
          return '_3500x3500';
        case kSize.small:
          return '_1000x1000';
        default: // kSize.medium
          return '_2000x2000';
      }
    }, lastIndex);
  }

  static String? formatImage(String? url, [kSize? size = kSize.medium]) {
    if (ServerConfig().type == ConfigType.presta) {
      return prestashopImage(url!, size);
    }

    if (ServerConfig().isShopify) {
      return shopifyImage(url!, size);
    }

    final enableResizeImage = kAdvanceConfig.optimizeImage.enable;

    if (ServerConfig().isMStoreApiPluginSupported) {
      switch (kAdvanceConfig.optimizeImage.plugin) {
        case OptimizeImagePlugin.regenerateImage:
          if (ServerConfig().isCacheImage ?? enableResizeImage) {
            var pathWithoutExt = p.withoutExtension(url!);
            var ext = p.extension(url);
            String? imageURL = url;

            if (ext == '.jpeg') {
              imageURL = url;
            } else {
              switch (size) {
                case kSize.large:
                  imageURL = '$pathWithoutExt-large$ext';
                  break;
                case kSize.small:
                  imageURL = '$pathWithoutExt-small$ext';
                  break;
                default: // kSize.medium:e
                  imageURL = '$pathWithoutExt-medium$ext';
                  break;
              }
            }

            printLog('[🏞Image Caching][Re-generateImage] $imageURL');
            return imageURL;
          }
        case OptimizeImagePlugin.optimole:
          if (enableResizeImage) {
            var imageURL = url;

            if (url?.contains('/w:auto/') ?? false) {
              switch (size) {
                case kSize.large:
                  imageURL = url?.replaceAll('/w:auto/', '/w:500/');
                  break;
                case kSize.small:
                  imageURL = url?.replaceAll('/w:auto/', '/w:150/');
                  break;
                default: // kSize.medium:e
                  imageURL = url?.replaceAll('/w:auto/', '/w:300/');
                  break;
              }
            }

            printLog('[🏞Image Caching][Optimole] $imageURL');
            return imageURL;
          }
      }
    }

    return url;
  }

  static NetworkImage networkImage(String? url, [kSize size = kSize.medium]) {
    return NetworkImage(formatImage(url, size) ?? kDefaultImage);
  }

  /// cache avatar for the chat
  static CachedNetworkImage getCachedAvatar(String avatarUrl) {
    return CachedNetworkImage(
      imageUrl: avatarUrl,
      imageBuilder: (context, imageProvider) => CircleAvatar(
        backgroundImage: imageProvider,
      ),
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }

  static BoxFit boxFit(
    String? fit, {
    BoxFit? defaultValue,
  }) {
    switch (fit) {
      case 'contain':
        return BoxFit.contain;
      case 'fill':
        return BoxFit.fill;
      case 'fitHeight':
        return BoxFit.fitHeight;
      case 'fitWidth':
        return BoxFit.fitWidth;
      case 'scaleDown':
        return BoxFit.scaleDown;
      case 'cover':
        return BoxFit.cover;
      case 'none':
        return BoxFit.none;
      default:
        return defaultValue ?? BoxFit.cover;
    }
  }

  static Future<file.File> writeToFile(Uint8List? data,
      {String? fileName}) async {
    final tempDir = await getTemporaryDirectory();
    final tempPath = tempDir.path;
    var filePath = '$tempPath/${fileName ?? 'file_01'}.jpeg';
    var f = file.File(filePath);
    if (data != null) {
      await f.writeAsBytes(data);
    }
    return f;
  }

  static Future<String?> getImagePath(dynamic image) async {
    try {
      if (image is file.File) {
        if (image.existsSync()) {
          return image.path;
        } else {
          final tmpFile = await writeToFile(image.readAsBytesSync());
          return tmpFile.path;
        }
      }

      if (image is XFile) {
        return image.path;
      }

      if (image is String && image.isURL) {
        return image;
      }
      return null;
    } catch (e) {
      printError(e);
      return null;
    }
  }

  static Future<XFile?> pickImage({
    ImageSource source = ImageSource.gallery,
    double? maxHeight,
    double? maxWidth,
    int? imageQuality,
  }) {
    final imagePicker = injector<ImagePicker>();
    return imagePicker.pickImage(
      source: source,
      maxHeight: maxHeight,
      maxWidth: maxHeight,
      imageQuality: imageQuality,
    );
  }

  static Future<List<XFile>> pickMultiImage({int? limit}) async {
    final imagePicker = injector<ImagePicker>();
    if (limit != null && limit < 2) {
      final image = await pickImage();
      if (image != null) {
        return [image];
      }
      return [];
    }
    return imagePicker.pickMultiImage(
      limit: limit,
    );
  }

  static Future<String> compressImage(
    dynamic image, {
    int percentage = 70,
    int quality = 70,
  }) async {
    var base64 = '';

    if (image is file.File) {
      try {
        file.File? tmpFile;
        if (image.existsSync()) {
          tmpFile = image;
        } else {
          tmpFile = await writeToFile(image.readAsBytesSync());
        }
        final compressedFile = await FlutterNativeImage.compressImage(
          tmpFile.path,
          percentage: percentage,
          quality: quality,
        );
        final bytes = compressedFile.readAsBytesSync();
        base64 += base64Encode(bytes);
      } catch (e) {
        printError(e);
      }
    }

    if (image is XFile) {
      final compressedFile = await FlutterNativeImage.compressImage(
        image.path,
        percentage: percentage,
        quality: quality,
      );
      final bytes = compressedFile.readAsBytesSync();
      base64 += base64Encode(bytes);
    }

    if (image is String) {
      if (image.contains('http')) {
        base64 += image;
      }
    }
    return base64;
  }

  static Future<String> compressAndConvertImagesForUploading(
      List<dynamic> images) async {
    var base64 = StringBuffer();
    for (final image in images) {
      base64
        ..write(await compressImage(image))
        ..write(',');
    }
    return base64.toString();
  }

  static Future<Uint8List?> getThumbnailFromVideo(
    String videoPath, {
    double? maxWidth,
    double? maxHeight,
    int quality = 75,
  }) async {
    try {
      final thumbnailPath = await VideoThumbnail.thumbnailData(
        video: videoPath,
        imageFormat: ImageFormat.WEBP,
        maxWidth: maxWidth?.round() ?? 64,
        maxHeight: maxHeight?.round() ?? 64,
        quality: quality,
      );
      return thumbnailPath;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> checkImageLive(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      try {
        final contentType = response.headers['content-type'];
        final isImage = contentType != null && contentType.startsWith('image/');

        return isImage && response.bodyBytes.isNotEmpty;
      } catch (e) {
        return false;
      }
    } else {
      return false;
    }
  }

  static Future<void> preLoadingImage(String imageUrl, BuildContext context,
      [bool useExtendedImage = true]) async {
    final imageProvider;

    if (imageUrl.isURL) {
      if (useExtendedImage) {
        imageProvider = ExtendedNetworkImageProvider(imageUrl, cache: true);
      } else {
        imageProvider = NetworkImage(imageUrl);
      }
    } else {
      imageProvider = AssetImage(imageUrl);
    }
    await precacheImage(imageProvider, context);
  }

  static Future<void> preLoadingListImages(
      List<String> url, BuildContext context,
      [bool useExtendedImage = true]) async {
    var futures = <Future>[];
    for (var e in url) {
      futures.add(ImageTools.preLoadingImage(e, context, useExtendedImage));
    }
    await Future.wait<void>(futures);
  }

  static void preLoadingListImagesInitState(
      List<String> url, BuildContext context,
      [bool useExtendedImage = true]) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ImageTools.preLoadingListImages(url, context);
    });
  }
}
