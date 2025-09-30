import 'package:flutter/material.dart';
import 'package:flux_localization/flux_localization.dart';
import 'package:flux_ui/flux_ui.dart';
import 'package:inspireui/inspireui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../common/config.dart';
import '../../../../common/theme/colors.dart';
import '../../../../models/order/order.dart';
import '../../../../services/services.dart';

class ProductDownloadButton extends StatefulWidget {
  final String? productId;
  final OrderStatus orderStatus;

  const ProductDownloadButton({
    required this.productId,
    required this.orderStatus,
  });

  @override
  State<ProductDownloadButton> createState() => _ProductDownloadButtonState();
}

class _ProductDownloadButtonState extends State<ProductDownloadButton> {
  bool isLoading = false;
  bool get _shouldShow =>
      widget.orderStatus == OrderStatus.completed &&
      (!kPaymentConfig.enableShipping || !kPaymentConfig.enableAddress) &&
      kPaymentConfig.enableDownloadProduct;

  void _handleDownloadAction(String file) async {
    try {
      Navigator.pop(context);
      setState(() => isLoading = true);

      await Tools.launchURL(
        file,
        mode: LaunchMode.externalApplication,
      );

      await Future.delayed(const Duration(milliseconds: 200));

      setState(() => isLoading = false);
    } catch (err) {
      Tools.showSnackBar(ScaffoldMessenger.of(context), '$err');
    }
  }

  void _showDownloadableFiles(BuildContext context) async {
    try {
      setState(() => isLoading = true);

      var product = await Services().api.overrideGetProduct(widget.productId);

      setState(() => isLoading = false);

      if (product?.files?.isEmpty ?? true) {
        throw (S.of(context).noFileToDownload);
      }

      var files = product!.files!;

      if (files.length == 1) {
        final file = files[0];
        if (file != null) {
          _handleDownloadAction(file);
        }
      } else {
        await showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: ListView.separated(
                    itemCount: files.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final file = files[index];
                      final fileNames =
                          product.fileNames?[index] ?? S.of(context).files;

                      return ListTile(
                        title: Text(fileNames),
                        trailing: ElevatedButton(
                          onPressed: () async {
                            if (file != null) {
                              _handleDownloadAction(file);
                            }
                          },
                          child: Text(
                            S.of(context).download,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  height: 1,
                  decoration: const BoxDecoration(color: kGrey200),
                ),
                ListTile(
                  title: Text(
                    S.of(context).selectTheFile,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            );
          },
        );
      }
    } catch (err) {
      Tools.showSnackBar(ScaffoldMessenger.of(context), '$err');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_shouldShow) return const SizedBox();

    return TextButton.icon(
      style: TextButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor.withValueOpacity(0.2),
      ),
      onPressed: isLoading ? null : () => _showDownloadableFiles(context),
      icon: isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
              ),
            )
          : Icon(
              Icons.file_download,
              color: Theme.of(context).primaryColor,
            ),
      label: Text(
        S.of(context).download,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
