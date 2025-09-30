import 'package:flutter/material.dart';
import 'package:flux_ui/flux_ui.dart';
import 'package:inspireui/widgets/skeleton_widget/skeleton_widget.dart';

const _kProductSimpleItemHeight = 65.0;
const _kProductSimpleItemWidth = 65.0;

class ProductSimpleItem extends StatelessWidget {
  const ProductSimpleItem({
    super.key,
    this.imageUrl,
    required this.name,
  });

  /// If [imageUrl] is null, it will show a skeleton
  final String? imageUrl;
  final String name;

  @override
  Widget build(BuildContext context) {
    final imageUrl = this.imageUrl;
    return Row(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          child: Builder(
            builder: (context) {
              // show loading
              if (imageUrl == null) {
                return const Skeleton(
                  height: _kProductSimpleItemHeight,
                  width: _kProductSimpleItemWidth,
                );
              }

              return FluxImage(
                imageUrl: imageUrl,
                width: _kProductSimpleItemWidth,
                height: _kProductSimpleItemHeight,
                fit: BoxFit.cover,
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: HtmlWidget(
            name,
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class ProductSimpleItemSkeleton extends StatelessWidget {
  const ProductSimpleItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Skeleton(
          height: _kProductSimpleItemHeight,
          width: _kProductSimpleItemWidth,
        ),
        SizedBox(width: 16),
        Skeleton(
          height: 20,
          width: 280,
        ),
      ],
    );
  }
}
