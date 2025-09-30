import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flux_ui/flux_ui.dart';
import 'package:provider/provider.dart';

import '../../../../common/constants.dart';
import '../../../../routes/flux_navigate.dart';
import '../../../../services/services.dart';
import '../../../../widgets/blog/blog_action_button_mixin.dart';
import '../../../models/index.dart';
import '../../../services/service_config.dart';
import '../config/blog_config.dart';

class BlogSliderWidget extends StatefulWidget {
  const BlogSliderWidget({
    required this.config,
    this.blogs,
    super.key,
  });

  final List<Blog>? blogs;
  final BlogConfig config;

  @override
  State<BlogSliderWidget> createState() => _BlogSliderWidgetState();
}

class _BlogSliderWidgetState extends State<BlogSliderWidget>
    with BlogActionButtonMixin {
  final Services _service = Services();
  List<Blog>? _blogs;

  bool get isWordPress => ServerConfig().isWordPress;

  BlogConfig get blogConfig => widget.config;
  Map get configJson => blogConfig.toJson();

  // For FluxNews
  CategoryModel get categoryModel => context.read<CategoryModel>();
  // For other platforms
  BlogModel get blogModel => context.read<BlogModel>();
  List<Category>? get _listCategory =>
      isWordPress ? categoryModel.categories : blogModel.categories;

  @override
  void initState() {
    super.initState();
    _blogs = widget.blogs;
    WidgetsBinding.instance.endOfFrame.then((_) async {
      if (mounted) {
        if (_blogs?.isEmpty ?? true) {
          final data = await _service.api.fetchBlogLayout(config: configJson);
          _blogs = data;
        }
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final sliderConfig =
        blogConfig.bannerSliderConfig ?? const SliderListConfig();
    final isSliderEnd = sliderConfig.type == SliderLayoutType.contentEndCard;

    return SliderListWidget(
      config: sliderConfig,
      enableBackground: blogConfig.enableBackground,
      headerText: blogConfig.name,
      isCirclePageIndicator: sliderConfig.pageIndicatorType.isCircle,
      onTapSeeAll: () => FluxNavigate.pushNamed(
        RouteList.backdrop,
        arguments: BackDropArguments(
          config: configJson,
          data: null,
        ),
        context: context,
      ),
      showSubtitleImage: true,
      onTapItem: (context, item) => onTapBlog(
        blog: item.data,
        blogs: _blogs,
        context: context,
      ),
      items: _blogs?.map(
        (e) {
          final subTitle = isSliderEnd ? e.author : '${e.author} • ${e.date}';
          final categoryName = _listCategory
              ?.firstWhereOrNull(
                (element) => element.id == e.categoryId.toString(),
              )
              ?.name;
          final isUseTag = (!sliderConfig.hideTag && categoryName != null);
          final imageSubTitle = isSliderEnd ? e.authorImage : null;

          return SliderItemList<Blog>(
            image: e.imageFeature,
            title: e.title,
            subTitle: subTitle,
            data: e,
            imageSubTitle: imageSubTitle,
            tags: isUseTag ? [categoryName] : null,
          );
        },
      ).toList(),
    );
  }
}
