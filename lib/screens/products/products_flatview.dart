import 'dart:async';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flux_localization/flux_localization.dart';
import 'package:flux_ui/flux_ui.dart';
import 'package:provider/provider.dart';

import '../../common/config.dart';
import '../../common/constants.dart';
import '../../common/tools/navigate_tools.dart';
import '../../models/index.dart';
import '../../services/service_config.dart';
import '../../services/services.dart';
import '../cart/cart_screen.dart';
import 'products_mixin.dart';

enum MenuType { cart, wishlist, share, login }

const kWidthCategoriesOptionalBuilder = 120.0;

class ProductFlatView extends StatefulWidget {
  final Widget builder;
  final Widget? bottomSheet;
  final Widget? titleFilter;
  final Function? onSort;
  final Function? onFilter;
  final Function onSearch;
  final bool autoFocusSearch;
  final bool hasAppBar;
  final TextEditingController searchFieldController;
  final void Function()? onBack;
  final Widget Function(double width)? categoriesOptionalBuilder;

  const ProductFlatView({
    required this.builder,
    required this.onSearch,
    this.bottomSheet,
    this.titleFilter,
    this.onSort,
    this.onFilter,
    this.autoFocusSearch = true,
    this.hasAppBar = false,
    super.key,
    required this.searchFieldController,
    this.onBack,
    this.categoriesOptionalBuilder,
  });

  @override
  State<ProductFlatView> createState() => _ProductFlatViewState();
}

class _ProductFlatViewState extends State<ProductFlatView>
    with ProductsMixin, TickerProviderStateMixin {
  Color get labelColor => Colors.black;
  late AnimationController _animatedController;
  late Animation<double> _animation;
  bool get _isActiveAnimationUI => widget.categoriesOptionalBuilder != null;
  final FocusNode _focusNode = FocusNode();

  bool get isLoggedIn =>
      Provider.of<UserModel>(context, listen: false).loggedIn;

  PopupMenuItem<String> _buildMenuItem({
    required IconData icon,
    required String label,
    required String value,
    bool isSelect = false,
  }) {
    final menuItemStyle = TextStyle(
      fontSize: 13.0,
      color: isSelect
          ? Theme.of(context).primaryColor
          : Theme.of(context).colorScheme.secondary,
      height: 24.0 / 15.0,
    );
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 24.0),
            child: Icon(icon,
                color: isSelect
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).colorScheme.secondary,
                size: 17),
          ),
          Text(label, style: menuItemStyle),
        ],
      ),
    );
  }

  Future<void> _onSeeMore(MenuType type) async {
    switch (type) {
      case MenuType.cart:
        await Navigator.of(context).pushNamed(
          RouteList.cart,
          arguments: CartScreenArgument(isBuyNow: true, isModal: false),
        );
        break;
      case MenuType.share:
        await shareProductsLink(context);
        break;
      case MenuType.wishlist:
        await Navigator.of(context).pushNamed(RouteList.wishlist);
        break;
      case MenuType.login:
        await NavigateTools.navigateToLogin(context);
        break;
    }
  }

  Widget _buildMoreWidget(bool loggedIn) {
    final sortByData = [
      if (Services().widget.enableShoppingCart(null) &&
          ServerConfig().supportsShoppingCart)
        {
          'type': MenuType.cart.name,
          'title': S.of(context).myCart,
          'icon': CupertinoIcons.bag,
        },
      {
        'type': MenuType.wishlist.name,
        'title': S.of(context).myWishList,
        'icon': CupertinoIcons.heart,
      },
      if (dynamicLinkConfig.allowShareLink &&
          (ServerConfig().isWooType || ServerConfig().isShopify) &&
          !ServerConfig().isListingType)
        {
          'type': MenuType.share.name,
          'title': S.of(context).share,
          'icon': CupertinoIcons.share,
        },
      if (!loggedIn && kLoginSetting.enable)
        {
          'type': MenuType.login.name,
          'title': S.of(context).login,
          'icon': CupertinoIcons.person,
        },
    ];

    return PopupMenuButton<String>(
      onSelected: (value) => _onSeeMore(MenuType.values.byName(value)),
      itemBuilder: (BuildContext context) =>
          List<PopupMenuItem<String>>.generate(
        sortByData.length,
        (index) => _buildMenuItem(
          icon: sortByData[index]['icon'] as IconData,
          label: '${sortByData[index]['title']}',
          value: '${sortByData[index]['type']}',
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        child: Icon(
          CupertinoIcons.ellipsis,
          size: 20,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  void onSearch(String value) {
    final searchedString = value.trim();
    EasyDebounce.debounce('searchCategory', const Duration(milliseconds: 200),
        () => widget.onSearch(searchedString));
  }

  Widget _getStickyWidget() {
    if (widget.titleFilter == null) return const SizedBox();

    return Container(
      alignment: Alignment.center,
      height: 44,
      margin: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 1),
            blurRadius: 2,
          )
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: widget.titleFilter,
    );
  }

  void _onBack() {
    if (widget.onBack != null) {
      widget.onBack!();
    } else {
      Navigator.of(context).pop();
    }
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus == false) {
      _animatedController.reverse();
    }
  }

  @override
  void initState() {
    super.initState();
    _animatedController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation =
        CurvedAnimation(parent: _animatedController, curve: Curves.easeInOut);
    if (_isActiveAnimationUI) {
      _focusNode.addListener(_onFocusChange);
    }
  }

  @override
  void dispose() {
    _animatedController.dispose();

    if (_isActiveAnimationUI) {
      _focusNode.removeListener(_onFocusChange);
    }

    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          AppBar(
              primary: !widget.hasAppBar,
              titleSpacing: 0,
              backgroundColor: Theme.of(context).colorScheme.surface,
              leading: Navigator.of(context).canPop() || widget.onBack != null
                  ? CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: _onBack,
                      child: const Icon(CupertinoIcons.back),
                    )
                  : null,
              title: Padding(
                padding: EdgeInsets.only(
                    left: Navigator.of(context).canPop() ? 0 : 15),
                child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      final animatedValue = _animation.value;
                      final showSearch =
                          animatedValue == 1 || _isActiveAnimationUI == false;

                      return Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                if (widget.categoriesOptionalBuilder != null)
                                  SizedBox(
                                    width: (1 - animatedValue) *
                                        kWidthCategoriesOptionalBuilder,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      child: widget.categoriesOptionalBuilder!(
                                          kWidthCategoriesOptionalBuilder),
                                    ),
                                  ),
                                Flexible(
                                  child: Align(
                                    alignment: AlignmentDirectional.centerEnd,
                                    child: _renderSearch(showSearch),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (widget.onFilter != null) ...[
                            const SizedBox(width: 4),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 2),
                              child: IconButton(
                                onPressed: () => widget.onFilter!(),
                                icon: Icon(
                                  Icons.filter_alt_outlined,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ]
                        ],
                      );
                    }),
              ),
              actions: [
                Selector<UserModel, bool>(
                  selector: (context, provider) => provider.loggedIn,
                  builder: (context, loggedIn, child) {
                    return _buildMoreWidget(loggedIn);
                  },
                ),
                const SizedBox(width: 4),
              ]),
          Expanded(
            child: GestureDetector(
              onTap: () {
                _focusNode.unfocus();
                _animatedController.reverse();
              },
              behavior: HitTestBehavior.opaque,
              child: Stack(
                children: [
                  Column(
                    children: [
                      _getStickyWidget(),
                      Expanded(child: widget.builder),
                    ],
                  ),
                  Align(
                    alignment: Tools.isRTL(context)
                        ? Alignment.bottomLeft
                        : Alignment.bottomRight,
                    child: widget.bottomSheet,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  AnimatedSize _renderSearch(bool showSearch) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      alignment: Alignment.center,
      curve: Curves.easeInOut,
      child: SizedBox(
        width: showSearch ? double.infinity : 35,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: showSearch
              ? CupertinoSearchTextField(
                  controller: widget.searchFieldController,
                  autofocus: false,
                  focusNode: _focusNode,
                  onChanged: onSearch,
                  onSubmitted: onSearch,
                  onTap: _animatedController.forward,
                  placeholder: S.of(context).searchForItems,
                  style: Theme.of(context).textTheme.bodySmall,
                )
              : GestureDetector(
                  onTap: _animatedController.forward,
                  child: SizedBox(
                    height: 30,
                    width: 25,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Icon(
                            CupertinoIcons.search,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        if (widget.searchFieldController.text.isNotEmpty)
                          PositionedDirectional(
                            end: 0,
                            top: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.all(2),
                              child: const Icon(
                                Icons.edit_outlined,
                                size: 8,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
