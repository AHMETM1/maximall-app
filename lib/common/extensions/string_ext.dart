import 'package:flutter/widgets.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import '../config.dart';
import '../constants.dart';
import '../enums/replaced_params.dart';

extension StringExtension on String {
  String? getPrivacyPolicies({bool isGetPageId = false}) {
    final value = this;

    if ((isGetPageId && int.tryParse(value) != null) || value.isURL) {
      return value.toString();
    }

    return null;
  }

  String addUrlQuery(String query) {
    if (query.isEmpty) {
      return this;
    }

    return contains('?') ? '$this&$query' : '$this?$query';
  }

  String addWooCookieToUrl(String? cookie) {
    if (cookie?.isNotEmpty ?? false) {
      final base64Str = EncodeUtils.encodeCookie(cookie!);
      return addUrlQuery('cookie=$base64Str');
    }

    return this;
  }

  String addWebProxy([String? webProxy]) {
    var url = this;

    if (kIsWeb) {
      var proxy = Configurations.webProxy;

      if (webProxy?.isNotEmpty ?? false) {
        proxy = webProxy!;
      }

      if (contains(proxy) == false) {
        url = replaceAll('https://', '').replaceAll('http://', '');
        final proxyURL = '$proxy$url';
        return proxyURL;
      }
    }
    return this;
  }

  String replaceHtmlTag() {
    return replaceAll('<p>', '')
        .replaceAll('</p>', '')
        .replaceAll('<a>', '')
        .replaceAll('</a>', '');
  }

  bool isYoutubeLink() {
    return contains('youtu.be') || contains('youtube');
  }
}

extension NullStringExtension on String? {
  String getReplacedParams(BuildContext context) {
    if (this == null) return '';

    var newText = '$this';

    for (var element in ReplacedParams.values) {
      switch (element) {
        case ReplacedParams.userName:

          // Using Provider.of and `listen = true` Because when logout/login
          // need to update the user name
          final userName = Provider.of<UserModel>(context).user?.name ?? '';

          newText = newText.replaceAll(element.param, userName);
          break;
      }
    }

    return newText;
  }

  String? unescape() {
    return this != null ? HtmlUnescape().convert(this!) : null;
  }
}

extension ServerConfigExt on String {
  bool get isTheSameServer {
    final url = Configurations.serverConfig['url'];
    if (url == null) return false;
    final serverConfigUri = Uri.tryParse('$url');
    if (serverConfigUri == null) return false;

    final uri = Uri.tryParse(this);
    if (uri == null) return false;

    if (uri.host != serverConfigUri.host) return false;

    return true;
  }
}
