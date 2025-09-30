import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flux_localization/flux_localization.dart';
import 'package:flux_ui/flux_ui.dart';
import 'package:inspireui/inspireui.dart';
import 'package:provider/provider.dart';

import '../../../common/config.dart';
import '../../../common/constants.dart';
import '../../../common/extensions/extensions.dart';
import '../../../models/index.dart';
import '../../../services/service_config.dart';
import '../../../widgets/asymmetric/asymmetric_view.dart';
import '../../../widgets/product/product_list.dart';
import '../filter_mixin/products_filter_mixin.dart';
import '../products_flatview.dart';
import '../widgets/category_menu.dart';
import 'products_layout.dart';

class ProductsFlatviewLayout extends ProductsLayout {
  const ProductsFlatviewLayout({
    super.key,
    super.products,
    super.config,
    super.countdownDuration,
    super.autoFocusSearch,
    this.allowFilterMultipleCategory = true,
    this.enableProductListCategoryMenu = true,
    this.categoryMenuStyle,
  });

  final bool allowFilterMultipleCategory;
  final bool enableProductListCategoryMenu;
  final ProductCategoryMenuStyle? categoryMenuStyle;

  @override
  StateProductsFlatviewLayout createState() => StateProductsFlatviewLayout();
}

class StateProductsFlatviewLayout<T extends ProductsFlatviewLayout>
    extends StateProductLayout<T> {
  final searchFieldController = TextEditingController();
  final categoryMenuDelegate = CategoryMenuDelegate();

  bool _isFirstLoad = true;

  bool get hasBackCategory =>
      categoryMenuDelegate.onGetIdCategoryParent != null &&
      stackSelectedCategory.isNotEmpty &&
      widget.allowFilterMultipleCategory == false &&
      widget.enableProductListCategoryMenu;

  bool get useCategoryTab => widget.categoryMenuStyle?.isTab ?? false;

  String _countItemText(int length) {
    if (length == 1) {
      return S.of(context).countItem(length);
    }
    return S.of(context).countItems(length);
  }

  // This value depends on the config in ServerConfig (check according to
  // framework) and can be turned on or off manually through the
  // variable allowFilterMultipleCategory
  @override
  bool get allowMultipleCategory =>
      ServerConfig().allowMultipleCategory &&
      widget.allowFilterMultipleCategory;

  @override
  bool get showTagCategoryImage =>
      widget.enableProductListCategoryMenu == false || allowMultipleCategory;

  @override
  void dispose() {
    searchFieldController.dispose();
    super.dispose();
  }

  @override
  void onClearTextSearch() {
    searchFieldController.clear();
  }

  void onSearch(String searchText) {
    onFilter(
      minPrice: minPrice,
      maxPrice: maxPrice,
      categoryId: categoryIds,
      tagId: tagIds,
      brandIds: brandIds,
      listingLocationId: listingLocationId,
      search: searchText,
      isSearch: true,
    );
  }

  Widget renderHeaderCategoryMenu() {
    final selectedCategories = categoryIds ?? <String>[];
    if (_isFirstLoad &&
        selectedCategories.length == 1 &&
        showCategory == false) {
      final ctgId = selectedCategories.first;

      onToogleCategory(
        categoryId: ctgId,
        parentCategoryId: categoryModel.getIdParentCategories(ctgId),
      );

      _isFirstLoad = false;
    }

    return ProductCategoryMenu(
      imageLayout: true,
      selectedCategories: categoryIds,
      onTap: onTapProductCategoryMenu,
      categoryMenuDelegate: categoryMenuDelegate,
      style: widget.categoryMenuStyle ?? ProductCategoryMenuStyle.menu,
      onPush: (
        String? categoryId,
        String? parentCategoryId,
        bool hasChild,
      ) {
        onToogleCategory(
          categoryId: categoryId,
          parentCategoryId: parentCategoryId,
          hasChild: hasChild,
        );
      },
    );
  }

  Widget renderProductsList({
    List<Product>? products,
    required bool isFetching,
    String? errMsg,
    bool? isEnd,
    double? width,
    required String layout,
  }) {
    final productLength = products?.length ?? 0;

    return layout.isListView
        ? ProductList(
            products: products,
            onRefresh: onRefresh,
            onLoadMore: onLoadMore,
            isFetching: isFetching,
            errMsg: errMsg,
            isEnd: isEnd,
            layout: layout,
            ratioProductImage: ratioProductImage,
            productListItemHeight: productListItemHeight,
            animationConfig: widget.config?.animationConfig,
            width: width,
            appbar: useCategoryTab ? null : renderFilters(context),
            header: [
              if (widget.allowFilterMultipleCategory == false &&
                  widget.enableProductListCategoryMenu)
                renderHeaderCategoryMenu(),
              if (useCategoryTab)
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16)
                        .copyWith(top: 16),
                    child: AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      alignment: AlignmentDirectional.centerStart,
                      child: renderFilterTitle(context),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, bottom: 10, top: 25),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            currentTitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                        const Spacer(),
                        if (productLength > 0) ...[
                          Text(
                            _countItemText(productLength),
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context).hintColor,
                                    ),
                          ),
                          const SizedBox(width: 5),
                        ]
                      ],
                    ),
                    if (productConfig.showCountDown) ...[
                      const SizedBox(height: 5),
                      CountDownTimer(
                        widget.countdownDuration,
                        builder: (context, countdownWidget, isEnd) {
                          if (isEnd) {
                            return const SizedBox();
                          }
                          return Row(
                            children: [
                              Text(
                                S.of(context).endsIn('').toUpperCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary
                                          .withValueOpacity(0.8),
                                    )
                                    .apply(fontSizeFactor: 0.6),
                              ),
                              countdownWidget
                            ],
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              renderHeaderCategoryMenu(),
              if (useCategoryTab) ...[
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: renderFilterTitle(context),
                ),
              ],
              Expanded(
                child: AsymmetricView(
                  products: products,
                  isFetching: isFetching,
                  isEnd: isEnd,
                  onLoadMore: onLoadMore,
                  width: width,
                ),
              ),
            ],
          );
  }

  Widget? renderTitleFilter(String layout) {
    return layout.isListView
        ? null
        : useCategoryTab
            ? null
            : renderFilters(context);
  }

  bool _onBackWithCategory() {
    final stackCategory = onToogleCategory();
    if (stackCategory?.isNotEmpty ?? false) {
      onFilter(categoryId: [stackCategory!]);
      return true;
    }

    return false;
  }

  void _onBack() {
    if (_onBackWithCategory() == false) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget renderProductsLayout({
    List<Product>? products,
    required bool isFetching,
    String? errMsg,
    bool? isEnd,
    double? width,
    required String layout,
  }) {
    return WillPopScopeWidget(
      onWillPop: () async {
        return _onBackWithCategory() == false;
      },
      child: renderScaffold(
        routeName: RouteList.backdrop,
        resizeToAvoidBottomInset: false,
        disableSafeArea: true,
        child: ProductFlatView(
          searchFieldController: searchFieldController,
          hasAppBar: hasAppBar,
          autoFocusSearch: widget.autoFocusSearch,
          onBack: hasBackCategory ? _onBack : null,
          builder: renderProductsList(
            products: products,
            isFetching: isFetching,
            errMsg: errMsg,
            isEnd: isEnd,
            width: width,
            layout: layout,
          ),
          titleFilter: renderTitleFilter(layout),
          onFilter: useCategoryTab ? showFilterBottomSheet : null,
          onSearch: onSearch,
          bottomSheet: renderBottomSheet(),
          categoriesOptionalBuilder: useCategoryTab
              ? (double width) {
                  return Selector<CategoryModel, List<Category>?>(
                    selector: (context, provider) => provider.rootCategories,
                    builder: (context, rootCategories, child) {
                      return rootCategories?.isNotEmpty ?? false
                          ? _buildCategorieOption(width, rootCategories!)
                          : const SizedBox();
                    },
                  );
                }
              : null,
        ),
      ),
    );
  }

  Widget _buildCategorieOption(double width, List<Category> rootCategories) {
    final selectedCategoryId =
        (categoryIds?.isNotEmpty ?? false) ? categoryIds?.first : null;

    var category = categoryModel.categories
        ?.findRootCategoryFromCategoryId(selectedCategoryId);

    if (category == null && kEnableLargeCategories) {
      for (var entry in categoryModel.subOfCategory.entries) {
        final isParent =
            entry.value.any((category) => category.id == selectedCategoryId);

        if (isParent) {
          category = rootCategories
              .firstWhereOrNull((element) => element.id == entry.key);
          break;
        }
      }
    }

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => renderBottomSheetListCategories(
            rootCategories,
            category,
          ),
        );
      },
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        child: Row(
          children: [
            Flexible(
              child: Text(
                category == null
                    ? S.of(context).categories
                    : category.name ?? '',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              CupertinoIcons.chevron_down,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  Widget renderBottomSheetListCategories(
    List<Category> listCategories,
    Category? categorySelected,
  ) {
    final maxWidth = MediaQuery.sizeOf(context).width / 4 - 25;
    final indexSelected = listCategories.indexWhere(
      (element) => element.id == categorySelected?.id,
    );

    return Material(
      color: Colors.transparent,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  fit: StackFit.loose,
                  children: [
                    Center(
                      child: Text(
                        S.of(context).categories,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const Icon(
                          CupertinoIcons.clear,
                          size: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(color: Theme.of(context).colorScheme.outline),
                const SizedBox(height: 16),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.sizeOf(context).height * 0.7,
                  ),
                  child: GridViewScrollToItem(
                    crossAxisCount: 4,
                    childAspectRatio: 0.7,
                    itemHeight: maxWidth / 0.65,
                    indexInitial: indexSelected,
                    itemCount: listCategories.length,
                    itemBuilder: (context, index) {
                      final isSelected = index == indexSelected;
                      final categoryId = listCategories[index].id!;

                      return GestureDetector(
                        onTap: () {
                          if (isSelected == false) {
                            onToogleCategory(
                                categoryId: categoryId, cleanStack: true);
                            onTapProductCategoryMenu(categoryId);
                          }
                          Navigator.of(context).pop();
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withValueOpacity(0.5)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FluxImage(
                                imageUrl: listCategories[index].image ?? '',
                                width: maxWidth,
                                height: maxWidth,
                                fit: BoxFit.cover,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              const SizedBox(height: 4),
                              Tooltip(
                                message: listCategories[index].name ?? '',
                                child: Text(
                                  listCategories[index].name ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: isSelected ? Colors.white : null,
                                        fontWeight:
                                            isSelected ? FontWeight.w600 : null,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
