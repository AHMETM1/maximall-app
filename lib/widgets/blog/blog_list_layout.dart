import 'package:flutter/material.dart';
import 'package:flux_ui/flux_ui.dart';

import '../../common/constants.dart';
import '../../frameworks/wordpress/presentation/widgets/blog_staggered.dart';
import '../../models/index.dart';
import '../../modules/dynamic_layout/blog/blog_slider.dart';
import '../../modules/dynamic_layout/helper/helper.dart';
import '../../modules/dynamic_layout/index.dart';
import '../../routes/flux_navigate.dart';
import '../../services/services.dart';
import 'blog_action_button_mixin.dart';
import 'blog_card_view.dart';

const _leftPadding = 12.0;

class BlogListLayout extends StatefulWidget {
  final BlogConfig config;

  const BlogListLayout({required this.config, super.key});

  @override
  State<BlogListLayout> createState() => _BlogListLayoutState();
}

class _BlogListLayoutState extends State<BlogListLayout>
    with BlogActionButtonMixin {
  final Services _service = Services();

  final _listBlogNotifier = ValueNotifier<List<Blog>?>(null);

  late final isCarouselView;
  late final scrollController;

  final blogEmptyList = const [Blog.empty(1), Blog.empty(2), Blog.empty(3)];

  BlogConfig get blogConfig => widget.config;
  Map get configJson => blogConfig.toJson();

  @override
  void initState() {
    super.initState();
    isCarouselView = blogConfig.layout == Layout.carousel;
    scrollController =
        isCarouselView ? CarouselController() : ScrollController();
    WidgetsBinding.instance.endOfFrame.then((_) async {
      if (mounted) {
        final data = await _service.api.fetchBlogLayout(config: configJson);
        _listBlogNotifier.value = data ?? [];
      }
    });
  }

  @override
  void dispose() {
    _listBlogNotifier.dispose();
    super.dispose();
  }

  double _buildBlogWidth(double screenWidth) {
    switch (blogConfig.layout) {
      case Layout.twoColumn:
      case Layout.carousel:
        return screenWidth * 0.5;
      case Layout.threeColumn:
        return screenWidth / 3;
      case Layout.fourColumn:
        return screenWidth / 4;
      case Layout.recentView:
        return screenWidth * 0.35;
      case Layout.saleOff:
        return screenWidth * 0.35;
      case Layout.card:
      default:
        return screenWidth - 10;
    }
  }

  Widget renderBlogListWidget(List<Blog>? blogs,
      {ScrollPhysics? physics, required double width, double? height}) {
    var blogCard = List.generate(
      blogs?.length ?? 0,
      (index) {
        return BlogCard(
          item: blogs?[index],
          width: _buildBlogWidth(width),
          config: blogConfig,
          onTap: () => onTapBlog(
            blog: blogs?[index],
            blogs: blogs,
            context: context,
          ),
        );
      },
    );

    switch (blogConfig.layout) {
      case Layout.carousel:
        final isMobileDisplay = Tools.isPhone(MediaQuery.of(context)) ||
            Tools.isBuilder; //check is in FluxBuilder or not
        final maxHeight =
            blogConfig.cardDesign == BlogCardType.background || isMobileDisplay
                ? 200.0
                : 360.0; // magic number

        return ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: CarouselView(
            controller: scrollController is CarouselController
                ? scrollController
                : null,
            itemExtent: _buildBlogWidth(width),
            itemSnapping: blogConfig.isSnapping,
            shape:
                const RoundedRectangleBorder(borderRadius: BorderRadius.zero),

            enableSplash:
                false, // disable splash effect to active action of child
            children: blogCard,
          ),
        );
      default:
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: scrollController,
          physics: physics,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: _leftPadding),
              ...blogCard,
            ],
          ),
        );
    }
  }

  Widget getBlogsListWidgets(List<Blog>? blogs, double width, context) {
    final physics = blogConfig.isSnapping
        ? CustomScrollPhysic(width: _buildBlogWidth(width))
        : const ScrollPhysics();

    final body = BackgroundColorWidget(
      enable: blogConfig.enableBackground,
      child: renderBlogListWidget(
        blogs,
        width: width,
        height: _buildBlogWidth(width),
        physics: physics,
      ),
    );

    return HandleAutoSlide.list(
      enable: blogConfig.enableAutoSliding,
      durationAutoSliding: blogConfig.durationAutoSliding,
      controller: scrollController,
      numberOfItems: blogs?.length ?? 0,
      child: body,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (blogConfig.layout == Layout.bannerSlider) {
      return ValueListenableBuilder<List<Blog>?>(
        valueListenable: _listBlogNotifier,
        builder: (context, value, child) {
          return BlogSliderWidget(
            config: blogConfig,
            blogs: value,
          );
        },
      );
    }

    final showSeeAll = blogConfig.layout != Layout.recentView;

    return LayoutBuilder(
      builder: (context, constraints) {
        var maxWidth = constraints.maxWidth - _leftPadding;
        return ValueListenableBuilder<List<Blog>?>(
          valueListenable: _listBlogNotifier,
          builder: (context, value, child) {
            if (value == null) {
              return Column(
                children: <Widget>[
                  HeaderView(
                    headerText: blogConfig.name ?? ' ',
                    showSeeAll: showSeeAll,
                    callback: () => FluxNavigate.pushNamed(
                      RouteList.backdrop,
                      arguments: BackDropArguments(
                        config: configJson,
                        data: [],
                      ),
                      context: context,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: _leftPadding),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          const SizedBox(width: 10.0),
                          for (var i = 0; i < 4; i++)
                            BlogCard(
                              item: Blog.empty(i),
                              width: _buildBlogWidth(
                                maxWidth,
                              ),
                              config: blogConfig,
                              onTap: () {},
                            )
                        ],
                      ),
                    ),
                  )
                ],
              );
            }

            return Column(
              children: <Widget>[
                HeaderView(
                  headerText: blogConfig.name ?? ' ',
                  showSeeAll: showSeeAll,
                  callback: () {
                    // if (Config().isUseWordPressBlog) {
                    //   Navigator.of(context).pushNamed(RouteList.listBlog);
                    //   return;
                    // }
                    FluxNavigate.pushNamed(
                      RouteList.backdrop,
                      arguments: BackDropArguments(
                        config: configJson,
                        data: value,
                      ),
                      context: context,
                    );
                  },
                ),
                value.isEmpty
                    ? const SizedBox(height: 200)
                    : (blogConfig.layout == 'staggered'
                        ? BlogStaggered(value, widget.config)
                        : getBlogsListWidgets(
                            value,
                            maxWidth,
                            context,
                          )),
              ],
            );
          },
        );
      },
    );
  }
}
