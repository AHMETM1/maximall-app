import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flux_localization/flux_localization.dart';
import 'package:provider/provider.dart';

import '../../../common/config.dart';
import '../../../common/config/configuration_utils.dart';
import '../../../common/constants.dart';
import '../../../common/extensions/translate_ext.dart';
import '../../../common/tools/biometrics_tools.dart';
import '../../../models/index.dart';
import '../../../routes/flux_navigate.dart';
import '../../../services/outside/index.dart';
import '../../../services/review_manager.dart';
import '../../../services/service_config.dart';
import '../../../widgets/animation/animated_fade_scale.dart';
import '../../../widgets/general/index.dart';
import '../../my_rating/index.dart';
import '../../users/user_point_screen.dart';
import '../layouts/mixins/setting_action_mixin.dart';
import '../rate_myapp_mixin.dart';
import 'setting_item/setting_item_notification_widget.dart';
import 'setting_item/setting_item_widget.dart';

const itemPadding = 15.0;

class DynamicSettingItemWidget extends StatefulWidget {
  const DynamicSettingItemWidget({
    super.key,
    required this.type,
    this.subGeneralSetting,
    this.user,
    required this.cardStyle,
  });

  final String type;
  final Map? subGeneralSetting;
  final User? user;
  final SettingItemStyle? cardStyle;

  @override
  State<DynamicSettingItemWidget> createState() =>
      _DynamicSettingItemWidgetState();
}

class _DynamicSettingItemWidgetState extends State<DynamicSettingItemWidget>
    with RateMyAppMixin, SettingActionMixin {
  SettingItemStyle? get _cardStyle => widget.cardStyle;

  @override
  Widget build(BuildContext context) {
    IconData icon;
    String title;
    Widget? trailing;
    Function() onTap;
    var isMultiVendor = ServerConfig().isVendorType();
    var subGeneralSetting = widget.subGeneralSetting != null
        ? ConfigurationUtils.loadSubGeneralSetting(widget.subGeneralSetting!)
        : kSubGeneralSetting;
    final isVendorAndDeliverySupported = ServerConfig().isVendorType() ||
        (ServerConfig().typeName == 'woo' && ServerConfig().platform == 'woo');
    final isVender = widget.user?.isVender ?? false;

    var item = subGeneralSetting[widget.type];

    if (widget.type.contains('web')) {
      return GeneralWebWidget(item: item, cardStyle: _cardStyle);
    }

    if (widget.type.contains('post-')) {
      return GeneralPostWidget(item: item, cardStyle: _cardStyle);
    }

    if (widget.type.contains('title')) {
      return GeneralTitleWidget(item: item, itemPadding: itemPadding);
    }

    if (widget.type.contains('button')) {
      return GeneralButtonWidget(item: item);
    }

    if (widget.type.contains('product-')) {
      return GeneralProductWidget(item: item, cardStyle: _cardStyle);
    }

    if (widget.type.contains('category-')) {
      return GeneralCategoryWidget(item: item, cardStyle: _cardStyle);
    }

    if (widget.type.contains('banner-')) {
      return GeneralBannerWidget(item: item);
    }

    if (widget.type.contains('blog-')) {
      return GeneralBlogWidget(item: item, cardStyle: _cardStyle);
    }

    if (widget.type.contains('blogCategory-')) {
      return GeneralBlogCategoryWidget(item: item, cardStyle: _cardStyle);
    }

    if (widget.type.contains('screen-')) {
      return GeneralScreenWidget(item: item, cardStyle: _cardStyle);
    }

    switch (widget.type) {
      case 'vendorAdmin':
        {
          if (!isVender || !isVendorAndDeliverySupported) {
            return const SizedBox();
          }
          title = S.of(context).vendorAdmin;
          icon = Icons.dashboard;
          onTap = () => FluxNavigate.pushNamed(
                RouteList.vendorAdmin,
                arguments: widget.user,
                forceRootNavigator: true,
                context: context,
              );
          break;
        }
      case 'delivery':
        final isDeliveryBoy = widget.user?.isDeliveryBoy ?? false;
        {
          if (!isDeliveryBoy || !isVendorAndDeliverySupported) {
            return const SizedBox();
          }
          title = S.of(context).deliveryManagement;
          icon = CupertinoIcons.cube_box;
          onTap = () => FluxNavigate.pushNamed(
                RouteList.delivery,
                arguments: widget.user,
                forceRootNavigator: true,
                context: context,
              );
          break;
        }
      case 'products':
        {
          if (!isVender || !isMultiVendor) {
            return const SizedBox();
          }
          title = S.of(context).myProducts;
          icon = CupertinoIcons.cube_box;
          onTap = () => FluxNavigate.pushNamed(
                RouteList.productSell,
                context: context,
              );
          break;
        }

      case 'chat':
        {
          if (widget.user == null || !isMultiVendor) {
            return const SizedBox();
          }
          title = S.of(context).conversations;
          icon = CupertinoIcons.chat_bubble_2;
          onTap = () {
            FluxNavigate.pushNamed(
              RouteList.listChat,
              arguments: isMultiVendor && isVender,
              forceRootNavigator: true,
              context: context,
            );
          };
          break;
        }
      case 'wallet':
        {
          var walletDisabled = Provider.of<AppModel>(context, listen: false)
                  .multiSiteConfig
                  ?.walletEnabled ==
              false;
          if (widget.user == null ||
              !ServerConfig().isWooType ||
              walletDisabled) {
            return const SizedBox();
          }
          title = S.of(context).myWallet;
          icon = CupertinoIcons.square_favorites_alt;
          onTap = () async {
            if (BiometricsTools.instance.isWalletSupported) {
              var didAuth = await BiometricsTools.instance.localAuth(context);
              if (!didAuth) {
                return;
              }
            }

            await FluxNavigate.pushNamed(
              RouteList.myWallet,
              forceRootNavigator: true,
              context: context,
            );
          };
          break;
        }
      case 'wishlist':
        {
          trailing = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Consumer<ProductWishListModel>(
                builder: (context, model, child) {
                  if (model.products.isNotEmpty) {
                    return Text(
                      context.transCountProduct(model.products.length),
                      style: TextStyle(
                          fontSize: 14, color: Theme.of(context).primaryColor),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
              const SizedBox(width: 5),
              const Icon(Icons.arrow_forward_ios, size: 18, color: kGrey600)
            ],
          );

          title = S.of(context).myWishList;
          icon = CupertinoIcons.heart;
          onTap = () => Navigator.of(context).pushNamed(RouteList.wishlist);
          break;
        }
      case 'notifications':
        {
          return SettingNotificationWidget(cardStyle: _cardStyle);
        }
      case 'language':
        {
          return Selector<AppModel, String?>(
            selector: (context, model) => model.langCode,
            builder: (context, langCode, _) {
              final languages = getLanguages();
              return SettingItemWidget(
                cardStyle: _cardStyle,
                icon: CupertinoIcons.globe,
                title: S.of(context).language,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      languages.firstWhere(
                        (element) => langCode == element['code'],
                        orElse: () => {'text': ''},
                      )['text'],
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                      color: kGrey600,
                    )
                  ],
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(RouteList.language);
                },
              );
            },
          );
        }
      case 'currencies':
        {
          if (ServerConfig().isListingSingleApp) {
            return const SizedBox();
          }
          return Selector<AppModel, String?>(
            selector: (context, model) => model.currency,
            builder: (context, currency, _) {
              return SettingItemWidget(
                cardStyle: _cardStyle,
                icon: CupertinoIcons.money_dollar_circle,
                title: S.of(context).currencies,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$currency',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                      color: kGrey600,
                    )
                  ],
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(RouteList.currencies);
                },
              );
            },
          );
        }
      case 'darkTheme':
        {
          return Selector<AppModel, bool>(
            selector: (context, model) => model.darkTheme,
            builder: (context, darkTheme, _) {
              return SettingItemWidget(
                cardStyle: _cardStyle,
                icon: darkTheme ? CupertinoIcons.moon : CupertinoIcons.sun_min,
                title: S.of(context).appearance,
                trailing: Text(
                  darkTheme
                      ? S.of(context).darkTheme
                      : S.of(context).lightTheme,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                onTap: () {
                  context.read<AppModel>().updateTheme(!darkTheme);
                },
              );
            },
          );
        }
      case 'order':
        {
          final userModel = Provider.of<UserModel>(context, listen: false);
          final loggedIn = userModel.loggedIn;
          final user = (ServerConfig().isHaravan && loggedIn == false)
              ? null
              : userModel.user;
          if (user == null || ServerConfig().isListingSingleApp) {
            return const SizedBox();
          }
          icon = CupertinoIcons.time;
          title = S.of(context).orderHistory;
          onTap = () => openMyOrder(context, widget.user!);
          break;
        }
      case 'point':
        {
          if (!(kAdvanceConfig.enablePointReward && widget.user != null)) {
            return const SizedBox();
          }
          if (ServerConfig().isListingSingleApp) {
            return const SizedBox();
          }
          icon = CupertinoIcons.bag_badge_plus;
          title = S.of(context).myPoints;
          onTap = () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserPointScreen(),
                ),
              );
          break;
        }
      case 'rating':
        {
          icon = CupertinoIcons.star;
          title = S.of(context).rateTheApp;
          onTap = showRateMyApp;
          break;
        }
      case 'privacy':
        {
          icon = CupertinoIcons.doc_text;
          title = S.of(context).privacyAndTerm;
          onTap = () => onTapOpenPrivacy(context, privacy: item);
          break;
        }
      case 'about':
        {
          icon = CupertinoIcons.info;
          title = S.of(context).aboutUs;
          onTap = () => openAboutUS(context, about: item);
          break;
        }

      case 'post':
        {
          if (widget.user != null) {
            trailing = const Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: kGrey600,
            );
            title = S.of(context).postManagement;
            icon = CupertinoIcons.chat_bubble_2;
            onTap = () {
              Navigator.of(context).pushNamed(RouteList.postManagement);
            };
          } else {
            return const SizedBox();
          }

          break;
        }
      case 'biometrics':
        {
          if (!BiometricsTools.instance.isSupported) {
            return const SizedBox();
          }

          return SettingItemWidget(
            cardStyle: _cardStyle,
            icon: CupertinoIcons.lock,
            titleWidget: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).lockScreenAndSecurity,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 5),
                Text(
                  S.of(context).fingerprintsTouchID,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: kGrey600,
            ),
            onTap: () {
              Navigator.of(context).pushNamed(RouteList.biometrics);
            },
          );
        }
      case 'my-rating':
        final user = widget.user;
        if (user == null ||
            !ServerConfig().isSupportMyRating ||
            !ReviewManager.instance.enableReview) {
          return const SizedBox();
        }
        return Selector<ListPurchasedProductModel, int>(
          selector: (_, model) => model.data.length,
          builder: (_, value, __) {
            return SettingItemWidget(
              cardStyle: _cardStyle,
              icon: Icons.rate_review_outlined,
              title: S.of(context).myRating,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (value > 0)
                    AnimatedFadeScale(
                      child: Badge(
                        label: Text(value.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: Colors.white)),
                        largeSize: 24,
                      ),
                    ),
                  const SizedBox(width: 16.0),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                    color: kGrey600,
                  )
                ],
              ),
              onTap: () {
                openMyRating(context, user: user);
              },
            );
          },
        );

      default:
        {
          final outsideWidget = OutsideService.settingItemWidget(
            widget.type,
            cardStyle: widget.cardStyle,
          );
          if (outsideWidget != null) {
            return outsideWidget;
          }
          trailing =
              const Icon(Icons.arrow_forward_ios, size: 18, color: kGrey600);
          icon = Icons.error;
          title = S.of(context).dataEmpty;
          onTap = () {};
        }
    }

    return SettingItemWidget(
      icon: icon,
      title: title,
      trailing: trailing,
      onTap: onTap,
      cardStyle: widget.cardStyle,
    );
  }
}
