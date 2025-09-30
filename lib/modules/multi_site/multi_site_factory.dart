import 'package:flutter/material.dart';
import 'package:flux_ui/flux_ui.dart';

mixin BaseMultiSiteFactoryMixin {
  Future startShowMultiSiteSelection(BuildContext context) async {}
  Widget multiSiteSelectionScreen(BuildContext context) => const SizedBox();
  MultiSiteArgument? createArgument(BuildContext context) => null;
}

class MultiSiteFactory with MultiSiteMixin, BaseMultiSiteFactoryMixin {
  MultiSiteFactory._privateConstructor();
  static final MultiSiteFactory instance =
      MultiSiteFactory._privateConstructor();
}
