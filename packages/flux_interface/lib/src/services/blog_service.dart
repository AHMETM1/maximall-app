import 'package:fstore/models/comment.dart';
import 'package:fstore/models/entities/paging_response.dart';
import 'package:fstore/models/index.dart';

abstract class BlogService {
  const factory BlogService.base() = _BlogServiceImpl;
  bool get useCrossBlog;

  Future<List<Blog>?> fetchBlogLayout({required Map config});
  Future<Blog?> getPageById(int? pageId);
  Future<List<Blog>> boostBlogs({
    String? category,
    String? tag,
    int? limit,
    int? offset,
    String? search,
    String? order,
    String? orderBy,
    String? include,
    String? author,
  });
  Future<PagingResponse<Blog>>? getBlogs(dynamic cursor);
  Future<List<Blog>> fetchBlogsByCategory({
    String? categoryId,
    String? tagId,
    int page = 1,
    String? order,
    String? orderBy,
    bool? boostEngine,
    String? search,
    String? author,
    List<String>? include,
  });
  Future<List<Tag>> getBlogTags();
  Future<Blog?> getBlogById(dynamic id);
  Future<List<Comment>?> getCommentsByPostId({postId});
  Future<bool> createComment({
    int? blogId,
    String? content,
    String? cookie,
  });
  Future<List<Blog>?> getBlogsByCategory(int? cateId);
  Future<List<Category>> getBlogCategories();
  Future<List<Blog>> boostBlogLayout({required Map config});
  Future<List<Blog>> searchBlog({
    required String name,
    bool? boostEngine,
  });

  Future<Blog?> getBlogByPermalink(String blogPermaLink);
}

class _BlogServiceImpl implements BlogService {
  const _BlogServiceImpl();

  @override
  bool get useCrossBlog => true;

  @override
  Future<List<Blog>> boostBlogs(
      {String? category,
      String? tag,
      int? limit,
      int? offset,
      String? search,
      String? order,
      String? orderBy,
      String? include,
      String? author}) {
    return Future.value([]);
  }

  @override
  Future<bool> createComment({int? blogId, String? content, String? cookie}) {
    return Future.value(false);
  }

  @override
  Future<List<Blog>?> fetchBlogLayout({required Map config}) {
    return Future.value([]);
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
      List<String>? include}) {
    return Future.value([]);
  }

  @override
  Future<Blog?> getBlogById(dynamic id) {
    return Future.value(null);
  }

  @override
  Future<List<Category>> getBlogCategories() {
    return Future.value([]);
  }

  @override
  Future<List<Tag>> getBlogTags() {
    return Future.value([]);
  }

  @override
  Future<PagingResponse<Blog>>? getBlogs(cursor) {
    return Future.value(const PagingResponse());
  }

  @override
  Future<List<Blog>?> getBlogsByCategory(int? cateId) {
    return Future.value([]);
  }

  @override
  Future<List<Comment>?> getCommentsByPostId({postId}) {
    return Future.value([]);
  }

  @override
  Future<Blog?> getPageById(int? pageId) {
    return Future.value(null);
  }

  @override
  Future<List<Blog>> boostBlogLayout({required Map config}) {
    return Future.value([]);
  }

  @override
  Future<List<Blog>> searchBlog({
    required String name,
    bool? boostEngine,
  }) {
    return Future.value([]);
  }

  @override
  Future<Blog?> getBlogByPermalink(String blogPermaLink) {
    return Future.value(null);
  }
}
