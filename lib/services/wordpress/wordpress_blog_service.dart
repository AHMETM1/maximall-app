import 'dart:convert';

import 'package:flux_interface/flux_interface.dart';
import 'package:http/http.dart' as http;

import '../../common/config.dart';
import '../../common/constants.dart';
import '../../common/tools.dart';
import '../../models/comment.dart';
import '../../models/entities/paging_response.dart';
import '../../models/index.dart';
import 'mixins/blog_boost_mixin.dart';
import 'wordpress_api.dart';

class WordpressBlogService with BlogBoostMixin implements BlogService {
  late final WordpressApi _wordpressApi;
  final bool _useCrossBlog;
  final String _domain;

  WordpressBlogService({
    required String domain,
    bool isRoot = true,
    required bool useCrossBlog,
  })  : _domain = domain,
        _wordpressApi = WordpressApi(domain, isRoot: isRoot),
        _useCrossBlog = useCrossBlog;

  @override
  String get domainBlog => _domain;

  @override
  bool get useCrossBlog => _useCrossBlog;

  @override
  Future<List<Blog>?> fetchBlogLayout({required Map config}) async {
    try {
      final dataConfig = Map<String, dynamic>.from(config);
      final enableBoostEngine = bool.tryParse('${dataConfig['boostEngine']}') ??
          kBoostEngineConfig.isOptimizeEnable && _wordpressApi.isRoot;
      if (enableBoostEngine) {
        try {
          return await boostBlogLayout(config: dataConfig);
        } catch (e, trace) {
          printError(e, trace);
        }
      }
      var list = <Blog>[];
      var endPoint = 'posts?_embed';
      if (kAdvanceConfig.isMultiLanguages) {
        endPoint += '&lang=$languageCode';
      }
      if (dataConfig['category'] != null &&
          dataConfig['category'].toString().isNotEmpty &&
          dataConfig['category'] != kEmptyCategoryID) {
        endPoint += "&categories=${dataConfig["category"]}";
      }
      if (dataConfig['tag'] != null &&
          dataConfig['tag'].toString().isNotEmpty) {
        endPoint += "&tags=${dataConfig["tag"]}";
      }

      endPoint += "&per_page=${config["limit"] ?? kLimitFetchPageBlog}";

      if (config.containsKey('page')) {
        endPoint += "&page=${config["page"]}";
      }

      if (config.containsKey('orderby')) {
        endPoint += "&orderby=${config["orderby"]}";
      }

      if (config.containsKey('order')) {
        endPoint += "&order=${config["order"]}";
      }

      if (config.containsKey('author')) {
        endPoint += "&author=${config["author"]}";
      }

      if (config.containsKey('search')) {
        endPoint += "&search=${config["search"]}";
      }

      final include = config['include'];
      if (include != null) {
        if (include is List && include.isNotEmpty) {
          endPoint += "&include=${include.join(',')}";
        } else if (include is String && include.isNotEmpty) {
          endPoint += '&include=$include';
        }
      }

      var response = await _wordpressApi.getAsync(endPoint);

      if (response is List) {
        list = Blog.parseBlogList(response, config);
      }

      return list;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Blog?> getPageById(int? pageId) async {
    try {
      var response = await _wordpressApi.getAsync('pages/$pageId?_embed');
      if (response['code'] != null) return null;
      return Blog.fromWordpressJson(response);
    } catch (e, trace) {
      printError(e, trace);
      return null;
    }
  }

  @override
  Future<PagingResponse<Blog>>? getBlogs(dynamic cursor) async {
    try {
      final page = cursor ?? 1;
      if (kBoostEngineConfig.isOptimizeEnable && _wordpressApi.isRoot) {
        try {
          final blogs = await boostBlogs(offset: cursor);
          return PagingResponse(data: blogs);
        } catch (e, trace) {
          printError(e, trace);
        }
      }
      var endPoint = 'posts?_embed&page=$page';
      if (kAdvanceConfig.isMultiLanguages) {
        endPoint += '&lang=$languageCode';
      }
      if (kAdvanceConfig.alwaysRefreshBlog) {
        endPoint += '&dummy=${DateTime.now().millisecondsSinceEpoch}';
      }

      final response = await _wordpressApi.getAsync(endPoint);

      var list = <Blog>[];
      if (response is List) {
        list = Blog.parseBlogList(response);
      }

      return PagingResponse(data: list);
    } on Exception catch (_) {
      return const PagingResponse();
    }
  }

  @override
  Future<List<Blog>> searchBlog({
    required String name,
    bool? boostEngine,
  }) async {
    final enableBoostEngine = boostEngine ??
        kBoostEngineConfig.isOptimizeEnable && _wordpressApi.isRoot;
    if (enableBoostEngine) {
      try {
        return await boostBlogs(search: name);
      } catch (e, trace) {
        printError(e, trace);
      }
    }
    try {
      var response = await _wordpressApi.getAsync('posts?_embed&search=$name');

      var list = <Blog>[];
      for (var item in response) {
        list.add(Blog.fromWordpressJson(item));
      }
      return list;
    } catch (e) {
      rethrow;
    }
  }

  @override
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
  }) async {
    try {
      final enableBoostEngine = boostEngine ??
          kBoostEngineConfig.isOptimizeEnable && _wordpressApi.isRoot;
      if (enableBoostEngine) {
        try {
          final boostValues = await boostBlogs(
            category: categoryId,
            tag: tagId,
            offset: page,
            limit: kLimitFetchPageBlog,
            order: order,
            orderBy: orderBy,
            search: search,
            include: include?.join(','),
            author: author,
          );
          if (boostValues.isNotEmpty) {
            return boostValues;
          }
        } catch (e, trace) {
          printError(e, trace);
        }
      }
      var list = <Blog>[];

      var endPoint = 'posts?_embed&per_page=$kLimitFetchPageBlog&page=$page';
      if (kAdvanceConfig.isMultiLanguages) {
        endPoint += '&lang=$languageCode';
      }
      if ((categoryId?.isNotEmpty ?? false) && categoryId != kEmptyCategoryID) {
        endPoint += '&categories=$categoryId';
      }
      if (tagId?.isNotEmpty ?? false) {
        endPoint += '&tags=$tagId';
      }
      if (orderBy?.isNotEmpty ?? false) {
        endPoint += '&orderby=$orderBy';
      }
      if (order?.isNotEmpty ?? false) {
        endPoint += '&order=$order';
      }

      if (author?.isNotEmpty ?? false) {
        endPoint += '&author=$author}';
      }

      if (search?.isNotEmpty ?? false) {
        endPoint += '&search=$search';
      }

      if (include?.isNotEmpty ?? false) {
        endPoint += '&include=${include?.join(',')}';
      }

      var response = await _wordpressApi.getAsync(endPoint);

      if (response is List) {
        list = Blog.parseBlogList(response);
      }

      return list;
    } catch (e, trace) {
      printError(e, trace);
      return [];
    }
  }

  @override
  Future<List<Tag>> getBlogTags() async {
    try {
      var list = <Tag>[];
      var endPoint =
          'tags?per_page=100&page=1&hide_empty=${kAdvanceConfig.hideEmptyTags}';
      if (kAdvanceConfig.isMultiLanguages) {
        endPoint += '&lang=$languageCode';
      }
      var response = await _wordpressApi.getAsync(endPoint);

      if (response is List) {
        for (var item in response) {
          list.add(Tag.fromJson(item));
        }
      }

      return list;
    } catch (e, trace) {
      printError(e, trace);
      return [];
    }
  }

  @override
  Future<Blog?> getBlogById(dynamic id) async {
    try {
      var endPoint = 'posts/$id?_embed';
      if (kAdvanceConfig.isMultiLanguages) {
        endPoint += '&lang=$languageCode';
      }
      if (kAdvanceConfig.alwaysRefreshBlog) {
        endPoint += '&dummy=${DateTime.now().millisecondsSinceEpoch}';
      }

      final response = await _wordpressApi.getAsync(endPoint);

      return Blog.fromWordpressJson(response);
    } catch (err, trace) {
      printError(err, trace);
    }
    return null;
  }

  @override
  Future<List<Comment>?> getCommentsByPostId({postId}) async {
    try {
      var list = <Comment>[];

      var endPoint = 'comments?';
      if (postId != null) {
        endPoint += 'post=$postId';
      }

      var response = await _wordpressApi.getAsync(endPoint);

      for (var item in response) {
        list.add(Comment.fromJson(item));
      }
      return list;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> createComment({
    int? blogId,
    String? content,
    String? cookie,
  }) async {
    try {
      //return true if comment created successful, false if otherwise
      if (cookie == null) {
        return false;
      }
      final token = EncodeUtils.encodeCookie(cookie);
      var data = {
        'content': content,
        'post_id': blogId.toString(),
        'token': token,
      };
      final dataResponse = await http.post(
          '${_wordpressApi.url}/wp-json/api/flutter_blog/blog/comment'.toUri()!,
          body: data);
      final body = jsonDecode(dataResponse.body);
      if (body is Map && body['message'] != null) {
        throw body['message'];
      } else {
        return body == true;
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Blog>?> getBlogsByCategory(int? cateId) async {
    try {
      final enableBoostEngine =
          kBoostEngineConfig.isOptimizeEnable && _wordpressApi.isRoot;
      if (enableBoostEngine) {
        try {
          return await boostBlogs(category: cateId?.toString());
        } catch (e, trace) {
          printError(e, trace);
        }
      }
      var url = 'posts?_embed';
      if (cateId != null) {
        url = url.addUrlQuery('categories=$cateId');
      }

      if (kAdvanceConfig.isMultiLanguages) {
        url += '&lang=$languageCode';
      }
      var response = await _wordpressApi.getAsync(url);
      var list = <Blog>[];
      if (response is List) {
        list = Blog.parseBlogList(response);
      }

      return list;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Category>> getBlogCategories() async {
    try {
      var response = await _wordpressApi.getAsync(
          'categories?per_page=20&hide_empty=${kAdvanceConfig.hideEmptyCategories}');
      var list = <Category>[];

      if (response is List) {
        for (var item in response) {
          if (item['slug'] == 'uncategorized') {
            continue;
          }
          list.add(Category.fromWordPress(item));
        }
      }
      return list;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Blog?> getBlogByPermalink(String blogPermaLink) async {
    try {
      final response = await httpGet(
          '$_domain/wp-json/api/flutter_blog/blog/dynamic?url=$blogPermaLink'
              .toUri()!);
      final body = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return Blog.fromWordpressJson(body);
      } else if (body['message'] != null) {
        throw Exception(body['message']);
      }
      return null;
    } catch (e) {
      //This error exception is about your Rest API is not config correctly so that not return the correct JSON format, please double check the document from this link https://support.inspireui.com/help-center/
      return null;
    }
  }
}
