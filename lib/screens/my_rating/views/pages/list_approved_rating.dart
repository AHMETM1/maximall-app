import 'package:flutter/material.dart';

import '../../../../models/entities/index.dart';
import '../../../../widgets/common/paging_list.dart';
import '../../model/list_approved_rating_model.dart';
import '../widgets/my_rating_item.dart';

class ListApprovedRating extends StatefulWidget {
  const ListApprovedRating({super.key});

  @override
  State<ListApprovedRating> createState() => _ListApprovedRatingState();
}

class _ListApprovedRatingState extends State<ListApprovedRating> {
  @override
  Widget build(BuildContext context) {
    return PagingList<ListApprovedRatingModel, Review>(
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
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      lengthLoadingWidget: 4,
      loadingWidget: const MyRatingItemSkeleton(),
    );
  }
}
