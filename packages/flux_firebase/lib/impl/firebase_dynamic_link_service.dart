// TODO(InspireUI Team): We will soon update a new alternative
// solution for FirebaseDynamicLinks as soon as possible
// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flux_interface/flux_interface.dart';
import 'package:fstore/common/constants.dart' show isAndroid, printLog;

import 'firebase_service.dart';

class FirebaseDynamicLinkServiceImpl extends FirebaseDynamicLinkService {
  FirebaseDynamicLinkServiceImpl({
    required super.config,
    required super.linkService,
  });

  FirebaseDynamicLinks get _firebaseDynamicLinks =>
      FirebaseServices().firebaseDynamicLinks;

  @override
  Future<void> initialize() async {
    _firebaseDynamicLinks.onLink.listen((dynamicLinkData) async {
      var uri = dynamicLinkData.link;
      final url = uri.toString();
      if (url.contains('page.link') || url.contains(config.uriPrefix)) {
        uri = (await _unShortenUrl(url)) ?? uri;
      }
      unawaited(linkService.handleWebLink(uri));
    }).onError((e) {
      printLog('[firebase-dynamic-link] error: ${e.message}');
    });

    // If run below code on ios, the app will open dynamic link twice
    if (isAndroid) {
      var initialLink = await _firebaseDynamicLinks.getInitialLink();
      if (initialLink != null) {
        final deepLink = initialLink.link;
        printLog('[firebase-dynamic-link] getInitialLink: $deepLink');
        await linkService.handleWebLink(deepLink);
      }
    }
  }

  /// share product link that contains Dynamic link
  @override
  Future<String?> createDynamicLink(String url) async {
    var productParams = _dynamicLinkParameters(url: url);
    var firebaseDynamicLink = await _generateFirebaseDynamicLink(productParams);
    printLog('[firebase-dynamic-link] $firebaseDynamicLink');
    return firebaseDynamicLink.toString();
  }

  DynamicLinkParameters _dynamicLinkParameters({required String url}) {
    return DynamicLinkParameters(
      uriPrefix: config.uriPrefix,
      link: Uri.parse(url),
      androidParameters: AndroidParameters(
        packageName: config.androidPackageName,
        minimumVersion: config.androidAppMinimumVersion,
      ),
      iosParameters: IOSParameters(
        bundleId: config.iOSBundleId,
        minimumVersion: config.iOSAppMinimumVersion,
        appStoreId: config.iOSAppStoreId,
      ),
    );
  }

  Future<Uri> _generateFirebaseDynamicLink(DynamicLinkParameters params) async {
    var dynamicLinks = _firebaseDynamicLinks;

    if (config.shortDynamicLinkEnable) {
      var shortDynamicLink = await dynamicLinks.buildShortLink(params);
      return shortDynamicLink.shortUrl;
    } else {
      return await dynamicLinks.buildLink(params);
    }
  }

  Future<Uri?> _unShortenUrl(String url) async {
    final uri = Uri.parse(url);
    final unShortenUrl = await _firebaseDynamicLinks.getDynamicLink(uri);
    return unShortenUrl?.link;
  }

  @override
  Future<void> handleLink(String url) async {
    final originalLink = await _unShortenUrl(url);
    if (originalLink != null) {
      unawaited(linkService.handleWebLink(originalLink));
    }
  }

  @override
  bool isSupportedLink(String url) {
    return url.contains(config.uriPrefix);
  }
}
