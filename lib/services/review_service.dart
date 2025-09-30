import '../common/config/models/review/review_config.dart';
import '../common/config/models/review/review_service_type.dart';
import '../models/entities/paging_response.dart';
import '../models/entities/rating_count.dart';
import '../models/entities/review.dart';
import '../models/entities/review_payload.dart';
import '../modules/judge_me/judge_review_service.dart';
import 'review_manager.dart';

abstract class ReviewService {
  const factory ReviewService.base() = _ReviewServiceImpl;

  factory ReviewService.create({
    ReviewConfig? reviewConfig,
    ReviewService Function()? factoryReviewServiceNative,
  }) {
    // Use provided config or fallback to global config
    final config = reviewConfig ?? ReviewManager.instance.config;
    return switch (config.service) {
      ReviewServiceType.native =>
        factoryReviewServiceNative?.call() ?? const _ReviewServiceImpl(),
      ReviewServiceType.judge => JudgeReviewService(
          apiKey: config.judgeConfig.apiKey,
          domain: config.judgeConfig.domain,
        ),
    };
  }

  const ReviewService();

  Future<PagingResponse<Review>> getReviews(
    String productId, {
    int page = 1,
    int perPage = 20,
  });

  Future<PagingResponse<Review>> getListReviewByUserEmail(
    String email, {
    int page = 1,
    int perPage = 20,
    String? status,
  });

  Future<void> createReview(ReviewPayload payload);

  Future<RatingCount?> getProductRatingCount(String productId);
}

class _ReviewServiceImpl implements ReviewService {
  const _ReviewServiceImpl();

  @override
  Future<void> createReview(ReviewPayload payload) async {
    return;
  }

  @override
  Future<PagingResponse<Review>> getReviews(String productId,
      {int page = 1, int perPage = 20}) async {
    return const PagingResponse();
  }

  @override
  Future<RatingCount?> getProductRatingCount(String productId) async {
    return null;
  }

  @override
  Future<PagingResponse<Review>> getListReviewByUserEmail(
    String email, {
    int page = 1,
    int perPage = 20,
    String? status,
  }) async {
    return const PagingResponse();
  }
}
