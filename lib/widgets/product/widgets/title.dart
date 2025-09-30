import 'dart:math';

import 'package:flutter/material.dart';
import 'package:html/parser.dart' as html;

import '../../../common/config.dart';
import '../../../common/constants.dart';
import '../../../models/entities/product.dart';

class ProductTitle extends StatelessWidget {
  final Product product;
  final bool hide;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final int? maxLines;
  final bool textCenter;
  final bool? resizeByMaxLines;

  const ProductTitle({
    super.key,
    required this.product,
    this.style,
    this.strutStyle,
    required this.hide,
    this.textCenter = false,
    this.maxLines,
    this.resizeByMaxLines = true,
  });

  int get _lineCount => maxLines ?? 2;
  bool get _isResizeByMaxLines => resizeByMaxLines ?? true;

  String _convertHtmlToText(String htmlString) {
    final document = html.parse(htmlString);
    return document.body?.text ?? '';
  }

  String _getPinnedTag() {
    var pinnedTag = '';
    if (kAdvanceConfig.pinnedProductTags.isNotEmpty) {
      for (var tag in product.tags) {
        final foundedTag = kAdvanceConfig.pinnedProductTags.any(
          (element) {
            final tagName = tag.name?.toLowerCase().trim();
            final hasTagName = tagName?.isNotEmpty ?? false;

            return hasTagName &&
                (element.toLowerCase().trim() == tagName ||
                    element == tag.id ||
                    element == tag.slug);
          },
        );
        if (foundedTag) {
          pinnedTag = tag.name ?? '';

          /// Only show first one tag.
          break;
        }
      }
    }
    return pinnedTag;
  }

  @override
  Widget build(BuildContext context) {
    if (hide) return const SizedBox();

    final productNameText = _convertHtmlToText(product.name ?? '');
    final pinnedTag = _getPinnedTag();
    final theme = Theme.of(context);

    final textScaler = MediaQuery.textScalerOf(context);

    final hasValidMaxScale = kMaxTextScale != null && kMaxTextScale! > 0;

    final textScale = hasValidMaxScale
        ? textScaler.clamp(
            minScaleFactor: 0.1,
            maxScaleFactor: min(2.0, max(0.1, kMaxTextScale!)),
          )
        : textScaler;

    final baseStyle =
        style ?? theme.textTheme.titleMedium!.apply(fontSizeFactor: 0.9);

    final fontSize =
        baseStyle.fontSize ?? theme.textTheme.titleMedium!.fontSize ?? 14.0;

    final scaleFactor = textScale.scale(1.0);

    final lineHeight = fontSize * (baseStyle.height ?? 1.6);

    final adjustedLineHeight =
        lineHeight * scaleFactor * (scaleFactor < 1.0 ? 1.2 : 1.0);

    final fixedHeight =
        _isResizeByMaxLines ? (adjustedLineHeight * _lineCount) : null;

    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: SizedBox(
              height: fixedHeight,
              child: Text.rich(
                textAlign: textCenter ? TextAlign.center : null,
                TextSpan(
                  children: [
                    if (pinnedTag.isNotEmpty) ...[
                      _buildPinnedTag(context, pinnedTag),
                      const WidgetSpan(child: SizedBox(width: 4.0)),
                    ],
                    TextSpan(text: productNameText),
                  ],
                ),
                maxLines: _isResizeByMaxLines ? _lineCount : null,
                overflow: _isResizeByMaxLines
                    ? TextOverflow.ellipsis
                    : TextOverflow.visible,
                style: baseStyle.copyWith(
                  fontSize:
                      _isResizeByMaxLines ? fontSize * scaleFactor : fontSize,
                ),
              ),
            ),
          ),
          if (product.verified ?? false)
            Icon(
              Icons.verified_user,
              size: 18,
              color: theme.colorScheme.secondary,
            ),
        ]);
  }

  WidgetSpan _buildPinnedTag(BuildContext context, String pinnedTag) {
    final theme = Theme.of(context);

    return WidgetSpan(
      alignment: PlaceholderAlignment.middle,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: style?.color ??
                theme.textTheme.titleMedium?.color ??
                theme.colorScheme.onSurface,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Text(
          pinnedTag.toTitleCase(),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
