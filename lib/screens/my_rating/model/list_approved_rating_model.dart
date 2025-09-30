import '../../../models/entities/index.dart' show User;
import '../../../models/entities/paging_response.dart';
import '../../../models/entities/review.dart';
import '../../../models/paging_data_model.dart';
import '../../../services/review_manager.dart';

class ListApprovedRatingModel extends PagingDataModel<Review> {
  final User user;

  ListApprovedRatingModel({
    required this.user,
  });

  @override
  Future<PagingResponse<Review>> Function(dynamic cursor) get requestApi =>
      (cursor) => ReviewManager.instance.getListReviewByUserEmail(
            user.email ?? '',
            page: cursor,
            perPage: 10,
            status: 'approved',
          );
}
