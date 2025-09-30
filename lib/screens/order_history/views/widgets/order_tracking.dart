import 'package:flutter/material.dart';
import 'package:flux_localization/flux_localization.dart';

import '../../../../common/config.dart';
import '../../../../models/entities/aftership.dart';
import '../../../../models/order/order.dart';
import '../../../../widgets/common/webview.dart';

enum _ReplacedParams {
  slug('{slug}'),
  trackingNumber('{trackingNumber}');

  final String param;
  const _ReplacedParams(this.param);
}

class OrderTracking extends StatelessWidget {
  const OrderTracking({super.key, required this.order});

  final Order order;

  String _buildUrl(AfterShipTracking afterShipTracking) {
    final customTrackingUrl =
        kAfterShip['custom_tracking_url']?.toString() ?? '';
    var newUrl = customTrackingUrl.isNotEmpty
        ? customTrackingUrl
        : '${kAfterShip['tracking_url']}/{slug}/{trackingNumber}';

    for (var element in _ReplacedParams.values) {
      switch (element) {
        case _ReplacedParams.slug:
          newUrl =
              newUrl.replaceAll(element.param, afterShipTracking.slug ?? '');
          break;
        case _ReplacedParams.trackingNumber:
          newUrl = newUrl.replaceAll(
              element.param, afterShipTracking.trackingNumber);
          break;
      }
    }

    return newUrl;
  }

  void _onTrackingNavigate(
    BuildContext context,
    AfterShipTracking afterShipTracking,
  ) {
    final url = _buildUrl(afterShipTracking);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebView(
          url,
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.surface,
            leading: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Icon(Icons.arrow_back_ios),
            ),
            title: Text(S.of(context).trackingPage),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // `enabled` is compatible with old version "null"
    if (order.aftershipTrackings.isNotEmpty && kAfterShip['enabled'] != false) {
      return Column(
        children: [
          Text(
            S.of(context).orderTracking,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...List.generate(
            order.aftershipTrackings.length,
            (index) {
              final afterShipTracking = order.aftershipTrackings[index];

              return Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: GestureDetector(
                  onTap: () => _onTrackingNavigate(context, afterShipTracking),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: <Widget>[
                        Text(
                            '${index + 1}. ${S.of(context).trackingNumberIs} '),
                        Text(
                          afterShipTracking.trackingNumber,
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            decoration: TextDecoration.underline,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      );
    }

    return const SizedBox();
  }
}
