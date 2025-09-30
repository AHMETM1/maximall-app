import 'package:flutter/material.dart';
import 'package:flux_localization/flux_localization.dart';
import 'package:inspireui/widgets/keep_alive_widget.dart';
import 'package:provider/provider.dart';

import '../../../widgets/animation/animated_fade_scale.dart';
import '../model/list_purchased_product_model.dart';
import 'pages/list_approved_rating.dart';
import 'pages/list_hold_rating.dart';
import 'pages/list_purchased_product.dart';

class MyRatingScreen extends StatefulWidget {
  const MyRatingScreen({super.key});

  @override
  State<MyRatingScreen> createState() => _MyRatingScreenState();
}

class _MyRatingScreenState extends State<MyRatingScreen> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).myRating),
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            ColoredBox(
              color: colorScheme.surface,
              child: TabBar(
                indicatorColor: colorScheme.secondary,
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(S.of(context).toRate),
                        Selector<ListPurchasedProductModel, int>(
                          selector: (context, value) => value.data.length,
                          builder: (context, value, child) {
                            if (value == 0) {
                              return const SizedBox.shrink();
                            }

                            return Padding(
                              padding: const EdgeInsetsDirectional.only(
                                start: 4.0,
                              ),
                              child: AnimatedFadeScale(
                                child: Badge(
                                  label: Text(value.toString()),
                                  largeSize: 20,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Tab(
                    text: S.of(context).myReviews,
                  ),
                  Tab(
                    text: S.of(context).pendingReviews,
                  )
                ],
              ),
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  KeepAliveWidget(child: ListPurchaseProduct()),
                  KeepAliveWidget(child: ListApprovedRating()),
                  KeepAliveWidget(child: ListHoldRating()),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
