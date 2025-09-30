import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flux_localization/flux_localization.dart';
import 'package:flux_ui/flux_ui.dart';
import 'package:inspireui/icons/icon_picker.dart' deferred as defer_icon;
import 'package:inspireui/inspireui.dart';
import 'package:provider/provider.dart';

import '../../common/config.dart';
import '../../common/tools.dart';
import '../../models/app_model.dart';
import '../../models/cart/cart_base.dart';
import '../../models/entities/address.dart';
import '../../models/entities/country.dart';
import '../../models/notification_model.dart';
import '../../models/user_model.dart';
import '../../modules/dynamic_layout/config/app_config.dart';
import '../../modules/dynamic_layout/helper/helper.dart';
import '../../services/index.dart';
import 'appbar_avatar_widget.dart';

class AppBarItemWidget extends StatefulWidget {
  const AppBarItemWidget({
    super.key,
    this.showBottom = true,
    required this.item,
  });

  final AppBarItemConfig item;
  final bool showBottom;

  @override
  State<AppBarItemWidget> createState() => _AppBarItemWidgetState();
}

class _AppBarItemWidgetState extends State<AppBarItemWidget> {
  double get appBarSize => kToolbarHeight;

  AppBarConfig? get appBar =>
      Provider.of<AppModel>(context, listen: false).appConfig!.appBar;

  Address? currentAddress;

  AppBarItemConfig get item => widget.item;

  Future<void> _onTapItem(AppBarItemConfig item) async {
    if (item.type == 'location') {
      final address = await item.onHandleItem<Address>(context);
      if (address != null && mounted) {
        setState(() {
          currentAddress = address;
        });
        Provider.of<CartModel>(context, listen: false).setAddress(address);
      }
    } else {
      await item.onHandleItem(context, item.toJson());
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.endOfFrame.then((_) {
      if (mounted) afterFirstLayout(context);
    });
  }

  void afterFirstLayout(BuildContext context) {
    if (!(appBar?.toJson().toString().contains('location') ?? false)) {
      return;
    }
    Future.microtask(
      () async {
        final addressValue =
            await Provider.of<CartModel>(context, listen: false).getAddress();

        Address? newAddress;
        if (addressValue != null) {
          newAddress = addressValue;
        } else {
          var user = Provider.of<UserModel>(context, listen: false).user;
          newAddress = Address(country: kPaymentConfig.defaultCountryISOCode);
          if (kPaymentConfig.defaultStateISOCode != null) {
            newAddress.state = kPaymentConfig.defaultStateISOCode;
          }
          if (user != null) {
            newAddress.firstName = user.firstName;
            newAddress.lastName = user.lastName;
            newAddress.email = user.email;
          }
        }

        if (newAddress.country != null) {
          final countryName = await Services()
              .widget
              .getCountryName(context, newAddress.country);

          if (countryName != null) {
            final country = Country(id: newAddress.country, name: countryName);

            final states = await Services().widget.loadStates(country);

            if (newAddress.state != null) {
              final state = states.firstWhereOrNull((element) =>
                  element.id == newAddress?.state ||
                  element.code == newAddress?.state);

              if (state != null) {
                newAddress.state = state.name;
              }
            }
          }
        }

        // Update state synchronously after all async work is done
        if (mounted) {
          setState(() {
            currentAddress = newAddress;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget widget;
    switch (item.type) {
      case 'avatar':
        widget = Padding(
          padding: EdgeInsets.only(
            left: item.paddingLeft.toDouble(),
            right: item.paddingRight.toDouble(),
            top: item.paddingTop.toDouble(),
            bottom: item.paddingBottom.toDouble(),
          ),
          child: AvatarWidget(
            radius: item.avatarRadius.toDouble(),
            defaultAvatar: item.defaultAvatar,
            imageUrl: context.select(
                (UserModel? userModel) => userModel?.user?.picture ?? ''),
            width: Helper.formatDouble(item.width),
            height: Helper.formatDouble(item.height),
            fit: ImageTools.boxFit(
              item.imageBoxFit,
              defaultValue: BoxFit.cover,
            ),
            imageColor:
                item.imageColor != null ? HexColor(item.imageColor) : null,
            iconColor: item.iconColor != null ? HexColor(item.iconColor) : null,
          ),
        );
        break;
      case 'welcome_text':
        var textColor = item.textColor != null
            ? HexColor(item.textColor)
            : Theme.of(context).colorScheme.secondary;
        var headerTextColor = item.headerTextColor != null
            ? HexColor(item.headerTextColor)
            : Theme.of(context).colorScheme.secondary;
        widget = SizedBox(
          height: item.height?.toDouble() ?? appBarSize,
          width: item.width?.toDouble(),
          child: FittedBox(
            alignment: Tools.getAlignment(
              item.alignment,
              defaultValue: Alignment.centerLeft,
            ),
            fit: BoxFit.fitHeight,
            child: Padding(
              padding: EdgeInsets.only(
                left: item.paddingLeft.toDouble(),
                right: item.paddingRight.toDouble(),
                top: item.paddingTop.toDouble(),
                bottom: item.paddingBottom.toDouble(),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  HtmlWidget(
                    item.title.getReplacedParams(context),
                    textStyle: TextStyle(
                      inherit: false,
                      fontSize: Helper.formatDouble(item.fontSize),
                      fontWeight: Tools.getFontWeight(
                        item.fontWeight,
                        defaultValue: FontWeight.w300,
                      ),
                      color: textColor.withValueOpacity(
                          Helper.formatDouble(item.textOpacity) ?? 0.5),
                    ),
                    maxLines: 1,
                  ),
                  SizedBox(height: item.spacingText.toDouble()),
                  HtmlWidget(
                    item.headerText.getReplacedParams(context),
                    textStyle: TextStyle(
                      inherit: false,
                      fontSize: Helper.formatDouble(item.headerFontSize),
                      fontWeight: Tools.getFontWeight(
                        item.headerFontWeight,
                        defaultValue: FontWeight.w600,
                      ),
                      color: headerTextColor.withValueOpacity(
                          Helper.formatDouble(item.headerTextOpacity) ?? 0.5),
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ),
        );
        break;
      case 'space':
        if (item.isCustomSpace) {
          widget = SizedBox(width: item.size.toDouble());
          break;
        }
        return const Spacer();
      case 'location':
        widget = Container(
          height: item.height?.toDouble() ?? appBarSize,
          width: item.width?.toDouble(),
          padding: EdgeInsets.only(
            left: item.paddingLeft.toDouble(),
            right: item.paddingRight.toDouble(),
            top: item.paddingTop.toDouble(),
            bottom: item.paddingBottom.toDouble(),
          ),
          child: Consumer<CartModel>(
            builder: (context, cartModel, child) {
              // Update currentAddress when address in cartModel changes
              if (cartModel.address != null) {
                currentAddress = cartModel.address;
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (!item.hideTitle)
                    Row(
                      children: [
                        const SizedBox(width: 4.0),
                        Text(
                          item.title ?? S.of(context).selectAddress,
                          style: const TextStyle(
                            fontSize: 10.0,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const Icon(
                          Icons.arrow_drop_down,
                          size: 16.0,
                        ),
                        const Spacer(),
                      ],
                    ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      DeferredWidget(
                        defer_icon.loadLibrary,
                        () => Icon(
                          defer_icon.iconPicker(
                            item.icon!,
                            item.fontFamily!,
                          ),
                          size: item.iconSize.toDouble(),
                          color: item.iconColor != null
                              ? HexColor(item.iconColor)
                              : Theme.of(context).primaryColor,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          currentAddress?.fullInfoAddress.toString() ?? '',
                          style: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        );
        break;
      case 'text':
        var textColor = item.textColor != null
            ? HexColor(item.textColor)
            : Theme.of(context).colorScheme.secondary;
        widget = Container(
          alignment: Tools.getAlignment(
            item.alignment,
            defaultValue: Alignment.center,
          ),
          height: item.height?.toDouble() ?? appBarSize,
          width: item.width?.toDouble(),
          padding: EdgeInsets.only(
            left: item.paddingLeft.toDouble(),
            right: item.paddingRight.toDouble(),
            top: item.paddingTop.toDouble(),
            bottom: item.paddingBottom.toDouble(),
          ),
          child: HtmlWidget(
            item.title.getReplacedParams(context),
            textStyle: TextStyle(
              fontSize: Helper.formatDouble(item.fontSize),
              fontWeight: Tools.getFontWeight(
                item.fontWeight,
                defaultValue: FontWeight.w300,
              ),
              color: textColor.withValueOpacity(
                  Helper.formatDouble(item.textOpacity) ?? 0.5),
            ),
          ),
        );
        break;
      case 'search':
        widget = Container(
          height: item.height?.toDouble() ?? appBarSize,
          width: item.width?.toDouble(),
          padding: EdgeInsets.only(
            left: item.paddingLeft.toDouble(),
            right: item.paddingRight.toDouble(),
            top: item.paddingTop.toDouble(),
            bottom: item.paddingBottom.toDouble(),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              DeferredWidget(
                defer_icon.loadLibrary,
                () => Icon(
                  defer_icon.iconPicker(
                    item.icon!,
                    item.fontFamily!,
                  ),
                  size: item.iconSize.toDouble(),
                  color: item.iconColor != null
                      ? HexColor(item.iconColor)
                      : Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(
                width: 4.0,
                height: appBarSize,
              ),
              if (!item.hideTitle)
                Expanded(
                  child: Text(
                    item.title ?? '',
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: Helper.formatDouble(item.fontSize),
                          fontWeight: Tools.getFontWeight(
                            item.fontWeight,
                            defaultValue: FontWeight.w300,
                          ),
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withValueOpacity(
                                  Helper.formatDouble(item.textOpacity) ?? 0.5),
                        ),
                  ),
                ),
            ],
          ),
        );
        break;
      case 'icon':
        widget = SizedBox(
          height: item.size.toDouble(),
          width: item.size.toDouble(),
          child: IconButton(
            color: item.iconColor != null
                ? HexColor(item.iconColor)
                : Theme.of(context).colorScheme.secondary.withValueOpacity(0.9),
            iconSize: item.iconSize.toDouble(),
            padding: EdgeInsets.only(
              left: item.paddingLeft.toDouble(),
              right: item.paddingRight.toDouble(),
              top: item.paddingTop.toDouble(),
              bottom: item.paddingBottom.toDouble(),
            ),
            icon: DeferredWidget(
              defer_icon.loadLibrary,
              () => Icon(
                defer_icon.iconPicker(
                  item.icon!,
                  item.fontFamily!,
                ),
              ),
            ),
            onPressed: () => _onTapItem(item),
          ),
        );
        break;
      case 'logo':
        widget = Padding(
          padding: EdgeInsets.only(
            left: item.paddingLeft.toDouble(),
            right: item.paddingRight.toDouble(),
            top: item.paddingTop.toDouble(),
            bottom: item.paddingBottom.toDouble(),
          ),
          child: InkWell(
            onTap: () => _onTapItem(item),
            child: FluxImage(
              imageUrl: context.select(
                (AppModel userModel) => userModel.themeConfig.logo,
              ),
              width: item.width?.toDouble(),
              height: item.height?.toDouble(),
              fit: ImageTools.boxFit(item.imageBoxFit),
              color: item.imageColor != null ? HexColor(item.imageColor) : null,
            ),
          ),
        );
        break;
      case 'image':
        final image = item.image;
        widget = Padding(
          padding: EdgeInsets.only(
            left: item.paddingLeft.toDouble(),
            right: item.paddingRight.toDouble(),
            top: item.paddingTop.toDouble(),
            bottom: item.paddingBottom.toDouble(),
          ),
          child: InkWell(
            onTap: () => _onTapItem(item),
            child: image == null
                ? SizedBox(
                    width: item.width?.toDouble(),
                    height: item.height?.toDouble(),
                  )
                : FluxImage(
                    imageUrl: item.image!,
                    width: item.width?.toDouble(),
                    height: item.height?.toDouble(),
                    fit: ImageTools.boxFit(item.imageBoxFit),
                    color: item.imageColor != null
                        ? HexColor(item.imageColor)
                        : null,
                  ),
          ),
        );
        break;
      default:
        return const SizedBox();
    }

    /// Add badge number.
    if (item.type == 'icon' && ['cart', 'notification'].contains(item.action)) {
      var badgeCount = 0;
      if (item.action == 'notification') {
        badgeCount = Provider.of<NotificationModel>(context).unreadCount;
      }
      if (item.action == 'cart') {
        badgeCount = Provider.of<CartModel>(context).totalCartQuantity;
      }

      widget = Stack(
        children: [
          widget,
          if (badgeCount > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(16),
                ),
                constraints: const BoxConstraints(
                  minWidth: 18,
                  minHeight: 18,
                ),
                child: Text(
                  '$badgeCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )
        ],
      );
    }

    if (item.onlyShowWhenAtTop && this.widget.showBottom) {
      widget = const SizedBox();
    }

    /// Add margin & background.
    widget = Container(
      decoration: BoxDecoration(
        color: item.backgroundColor != null
            ? HexColor(item.backgroundColor)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(item.radius.toDouble()),
      ),
      margin: EdgeInsets.only(
        left: item.marginLeft.toDouble(),
        right: item.marginRight.toDouble(),
        top: item.marginTop.toDouble(),
        bottom: item.marginBottom.toDouble(),
      ),
      child: widget,
    );

    /// Handle expanded widget if the width is not set
    if (['search', 'text', 'location', 'welcome_text'].contains(item.type)) {
      if (item.width == null) {
        widget = Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => _onTapItem(item),
            child: widget,
          ),
        );
      } else {
        widget = Flexible(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => _onTapItem(item),
            child: widget,
          ),
        );
      }
    }
    return widget;
  }
}
