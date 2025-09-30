import 'package:flutter/material.dart';

import '../../../../../common/config.dart';
import '../../../../../common/config/models/product_detail_config.dart';
import '../../../../../common/tools.dart';
import '../../../widgets/size_guide_button.dart';

class ImageSelection extends StatelessWidget {
  final Map<String?, String?>? imageUrls;
  final List<String?> options;
  final String? value;
  final String? title;
  final Function? onChanged;
  final ProductDetailAttributeLayout? layout;
  final String? productId;

  const ImageSelection({
    required this.options,
    required this.value,
    this.title,
    this.layout,
    this.onChanged,
    this.imageUrls,
    this.productId,
  });

  @override
  Widget build(BuildContext context) {
    final size = kProductDetail.attributeImagesSize;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                title?.capitalize() ?? '',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SideGuideButtonWidget(
              attribute: title,
              productId: productId,
            ),
          ],
        ),
        const SizedBox(height: 4.0),
        Wrap(
          spacing: 0.0,
          children: <Widget>[
            for (var item in options)
              GestureDetector(
                onTap: () => onChanged!(item),
                child: Tooltip(
                  message: item?.toString().unescape(),
                  preferBelow: false,
                  verticalOffset: 32,
                  child: Container(
                    margin: const EdgeInsets.all(8.0),
                    child: Container(
                      width: size + 2,
                      height: size + 2,
                      padding: const EdgeInsets.all(2.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(
                          width: 1.0,
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withValueOpacity(
                                  item?.toUpperCase() == value?.toUpperCase()
                                      ? 0.6
                                      : 0.3),
                        ),
                      ),
                      child: Stack(
                        children: [
                          if (imageUrls?[item]?.isNotEmpty ?? false)
                            Positioned.fill(
                              child: ImageResize(
                                url: imageUrls![item],
                                height: size,
                                width: size,
                              ),
                            )
                          else
                            Positioned.fill(
                              child: Center(
                                child: Text(item?.toString().unescape() ?? ''),
                              ),
                            ),
                          if (item?.toUpperCase() == value?.toUpperCase())
                            Positioned.fill(
                              child: Container(
                                color: Theme.of(context)
                                    .colorScheme
                                    .surface
                                    .withValueOpacity(0.6),
                                child: const Icon(
                                  Icons.check_circle_rounded,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
          ],
        ),
      ],
    );
  }
}
