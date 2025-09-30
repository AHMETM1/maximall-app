import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flux_localization/flux_localization.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../common/constants.dart';
import '../../common/extensions/extensions.dart';
import '../../common/tools/flash.dart';
import '../../models/entities/user.dart';
import '../../routes/flux_navigate.dart';
import '../../screens/request/camera_permission.dart';
import '../../services/service_config.dart';
import 'scanner.dart';

class ScannerButton extends StatelessWidget {
  final User? user;
  final IconData? customIcon;
  final bool productType;

  const ScannerButton({
    super.key,
    this.user,
    this.customIcon,
    this.productType = true,
  });

  Future<void> _showUnsupportedDialog(BuildContext context) async {
    await context.showFluxDialogText(
      title: S.of(context).notice,
      body: S.of(context).scannerOnlyForProduct,
      primaryAction: S.of(context).ok,
    );
    return;
  }

  bool get _shouldShowScanner {
    final config = ServerConfig();
    if (config.isListingSingleApp) return false;
    if (!config.isListingType) return true;
    if (config.isListeoType && config.multiVendorType == 'dokan') {
      return productType;
    }
    return true;
  }

  bool get _shouldShowUnsupportedDialog {
    final config = ServerConfig();
    if (config.isListingSingleApp) return true;
    if (!config.isListingType) return false;
    if (config.isListeoType && config.multiVendorType == 'dokan') {
      return !productType;
    }
    return false;
  }

  Future<bool> _checkCameraPermission(BuildContext context) async {
    if (await Permission.camera.status == PermissionStatus.granted) {
      return true;
    }

    final result = await FluxNavigate.push(
      MaterialPageRoute(
        builder: (_) => CameraPermissionRequestScreen(
          onAppSettingsCallback: (hasPermission) {
            if (!hasPermission) {
              unawaited(
                FlashHelper.errorBar(
                  context,
                  message: S.of(context).noCameraPermissionIsGranted,
                ),
              );
            }
          },
        ),
      ),
      context: context,
    );

    return result == true;
  }

  Future<void> _handleScannerPress(BuildContext context) async {
    if (_shouldShowUnsupportedDialog) {
      await _showUnsupportedDialog(context);
      return;
    }

    if (!isIos && !isAndroid) {
      unawaited(_showFakeScanner(context));
      return;
    }

    if (!await _checkCameraPermission(context)) return;

    if (_shouldShowScanner) {
      return navigateToScanner(context);
    }
  }

  Future<void> _showFakeScanner(BuildContext context) {
    return FluxNavigate.push(
      MaterialPageRoute(builder: (_) => const FakeBarcodeScreen()),
      context: context,
    );
  }

  Future navigateToScanner(BuildContext context) {
    return FluxNavigate.push(
      MaterialPageRoute(
        builder: (_) => Scanner(
          key: UniqueKey(),
          user: user,
        ),
      ),
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!ServerConfig().isWooType ||

        /// Not supported in Listing single app
        ServerConfig().isListingSingleApp) {
      return const SizedBox();
    }
    return IconButton(
      onPressed: () => _handleScannerPress(context),
      icon: Icon(customIcon ?? CupertinoIcons.barcode_viewfinder),
    );
  }
}

class FakeBarcodeScreen extends StatelessWidget {
  const FakeBarcodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: const Center(
        child: Icon(
          CupertinoIcons.barcode_viewfinder,
          size: 200.0,
        ),
      ),
    );
  }
}
