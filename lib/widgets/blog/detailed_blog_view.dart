import 'package:flutter/material.dart';
import 'package:flux_ui/flux_ui.dart';
import 'package:inspireui/extensions/color_extension.dart';

import '../../models/entities/blog.dart';
import 'detailed_blog_mixin.dart';

class BlogDetail extends StatefulWidget {
  final Blog item;

  const BlogDetail({super.key, required this.item});

  @override
  State<BlogDetail> createState() => _BlogCardState();
}

class _BlogCardState extends State<BlogDetail> with DetailedBlogMixin {
  Blog blogData = const Blog.empty();
  @override
  void initState() {
    blogData = widget.item;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant BlogDetail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.item != widget.item) {
      blogData = widget.item;
    }
  }

  @override
  Widget build(BuildContext context) {
    const bannerHigh = 180.0;
    final size = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: theme.colorScheme.surface,
            leading: IconButton(
              onPressed: () => {Navigator.pop(context)},
              icon: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withValueOpacity(0.8),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(48),
                  ),
                ),
                child: const Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                ),
              ),
            ),
            actions: [
              renderBlogFunctionButtons(blogData, context),
            ],
            expandedHeight: bannerHigh,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              background: FluxImage(
                imageUrl: blogData.imageFeature,
                fit: BoxFit.cover,
                width: size.width,
              ),
              stretchModes: const [
                StretchMode.zoomBackground,
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          blogData.title,
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 25,
                            color: theme.colorScheme.secondary
                                .withValueOpacity(0.8),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      renderAuthorInfo(blogData, context),
                      renderAudioWidget(blogData, context),
                      renderBlogContentWithTextEnhancement(blogData),
                      renderRelatedBlog(blogData.categoryId),
                      renderCommentLayout(blogData.id),
                      renderCommentInput(blogData.id),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
