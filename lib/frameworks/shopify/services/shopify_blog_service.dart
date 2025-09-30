import 'package:flux_interface/flux_interface.dart';
import 'package:graphql/client.dart';
import 'package:inspireui/utils/logs.dart';

import '../../../models/comment.dart';
import '../../../models/entities/blog.dart';
import '../../../models/entities/category.dart';
import '../../../models/entities/paging_response.dart';
import '../../../models/entities/tag.dart';
import '../../../services/wordpress/mixins/blog_boost_mixin.dart';
import 'shopify_query.dart';

class ShopifyBlogService with BlogBoostMixin implements BlogService {
  final GraphQLClient client;
  ShopifyBlogService({
    required this.client,
  });

  @override
  String get languageCode => super.languageCode.toUpperCase();

  @override
  String get domainBlog => client.link.toString();

  @override
  bool get useCrossBlog => false;

  @override
  Future<bool> createComment(
      {int? blogId, String? content, String? cookie}) async {
    return false;
  }

  @override
  Future<List<Blog>?> fetchBlogLayout({required Map config}) async {
    return <Blog>[];
  }

  @override
  Future<List<Blog>> fetchBlogsByCategory(
      {String? categoryId,
      String? tagId,
      int page = 1,
      String? order,
      String? orderBy,
      bool? boostEngine,
      String? search,
      String? author,
      List<String>? include}) async {
    return <Blog>[];
  }

  @override
  Future<Blog?> getBlogById(dynamic id) async {
    return null;
  }

  @override
  Future<Blog?> getBlogByPermalink(String blogPermaLink) async {
    final uri = Uri.parse(blogPermaLink);
    printLog('::::getArticle shopify link: $blogPermaLink');
    final articleHandle = uri.pathSegments.last;
    final blogHandle = uri.pathSegments[uri.pathSegments.length - 2];
    try {
      const nRepositories = 50;
      final options = QueryOptions(
        document: gql(ShopifyQuery.getArticleByHandle),
        variables: <String, dynamic>{
          'nRepositories': nRepositories,
          'blogHandle': blogHandle,
          'articleHandle': articleHandle,
        },
      );
      final result = await client.query(options);

      if (result.hasException) {
        printLog(result.exception.toString());
      }

      final blogData = result.data?['blog']?['articleByHandle'];
      final blog = Blog.fromShopifyJson(blogData);
      return blog;
    } catch (e) {
      printLog('::::getArticle shopify error');
      printLog(e.toString());
      return null;
    }
  }

  @override
  Future<List<Category>> getBlogCategories() async {
    return <Category>[];
  }

  @override
  Future<List<Tag>> getBlogTags() async {
    return <Tag>[];
  }

  @override
  Future<PagingResponse<Blog>>? getBlogs(dynamic cursor) async {
    try {
      printLog('::::request blogs');

      const nRepositories = 50;
      final options = QueryOptions(
        document: gql(ShopifyQuery.getArticle),
        fetchPolicy: FetchPolicy.networkOnly,
        variables: {
          'nRepositories': nRepositories,
          'pageSize': 12,
          'langCode': languageCode,
          if (cursor != null && cursor is! num) 'cursor': cursor,
        },
      );
      final response = await client.query(options);

      if (response.hasException) {
        printLog(response.exception.toString());
      }

      final data = <Blog>[];
      String? lastCursor;
      for (var item in response.data!['articles']['edges']) {
        final blog = item['node'];
        lastCursor = item['cursor'];
        data.add(Blog.fromShopifyJson(blog));
      }

      return PagingResponse(
        data: data,
        cursor: lastCursor,
      );

      // printLog(list);
    } catch (e) {
      printLog('::::fetchBlogLayout shopify error');
      printLog(e.toString());
      return const PagingResponse();
    }
  }

  @override
  Future<List<Blog>?> getBlogsByCategory(int? cateId) async {
    return <Blog>[];
  }

  @override
  Future<List<Comment>?> getCommentsByPostId({postId}) async {
    return <Comment>[];
  }

  @override
  Future<Blog?> getPageById(int? pageId) async {
    return null;
  }

  @override
  Future<List<Blog>> searchBlog(
      {required String name, bool? boostEngine}) async {
    return <Blog>[];
  }
}
