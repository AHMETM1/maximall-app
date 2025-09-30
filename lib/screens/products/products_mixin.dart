import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flux_localization/flux_localization.dart';
import 'package:flux_ui/flux_ui.dart';
import 'package:provider/provider.dart';

import '../../common/tools/flash.dart';
import '../../models/product_model.dart';
import '../../services/index.dart';

mixin ProductsMixin {
  Future<void> shareProductsLink(BuildContext context) async {
    unawaited(
      FlashHelper.message(
        context,
        message: S.of(context).generatingLink,
        duration: const Duration(seconds: 2),
      ),
    );
    var productModel = Provider.of<ProductModel>(context, listen: false);
    var currentCategoryId = productModel.categoryIds;
    var currentTagId = productModel.tagIds;
    String? url;
    if (currentCategoryId?.length == 1) {
      url = await Services()
          .linkService
          .generateProductCategoryUrl(currentCategoryId?.first);
    } else if (currentTagId?.length == 1) {
      url = await Services()
          .linkService
          .generateProductTagUrl(currentTagId?.first);
    } else {
      url = ServerConfig().url;
    }

    if (url != null && url.isNotEmpty) {
      final dynamicLink =
          await Services().dynamicLinkService.createDynamicLink(url);

      if (dynamicLink != null) {
        unawaited(Tools.share(dynamicLink));
        return;
      }
    }

    unawaited(
      FlashHelper.errorMessage(
        context,
        message: S.of(context).failedToGenerateLink,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
