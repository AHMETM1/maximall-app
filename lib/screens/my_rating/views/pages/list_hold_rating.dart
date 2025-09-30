import 'package:flutter/material.dart';

import '../../../../models/entities/index.dart';
import '../../../../widgets/common/paging_list.dart';
import '../../model/list_hold_rating_model.dart';
import '../widgets/my_rating_item.dart';

class ListHoldRating extends StatefulWidget {
  const ListHoldRating({super.key});

  @override
  State<ListHoldRating> createState() => _ListHoldRatingState();
}

class _ListHoldRatingState extends State<ListHoldRating> {
  @override
  Widget build(BuildContext context) {
    return PagingList<ListHoldRatingModel, Review>(
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, review, index) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 12,
          ),
          color: Theme.of(context).cardColor,
          child: MyRatingItem(review: review),
        );
      },
      lengthLoadingWidget: 4,
      loadingWidget: const MyRatingItemSkeleton(),
    );
  }
}
