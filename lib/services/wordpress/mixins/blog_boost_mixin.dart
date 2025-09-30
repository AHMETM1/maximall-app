import 'package:flutter/foundation.dart';

import '../../../common/constants.dart';
import '../../../data/boxes.dart';
import '../../../models/index.dart';
import '../../elastic/elastic_client.dart';
import '../../elastic/elastic_query.dart';
import '../../elastic/elastic_service.dart';

mixin BlogBoostMixin {
  String get domainBlog;

  String get languageCode => SettingsBox().languageCode ?? 'en';

  @nonVirtual
  Future<List<Blog>> boostBlogLayout({required Map config}) async {
    var includeValue = config['include'];
    String? include;
    if (includeValue is String) {
      include = includeValue;
    }
    if (includeValue is List) {
      include = includeValue.join(',');
    }
    return boostBlogs(
      category: config['category'],
      tag: config['tag'],
      limit: config['limit'],
      offset: config['page'],
      search: config['search'],
      order: config['order'],
      orderBy: config['orderby'],
      include: include,
      author: config['author'],
    );
  }

  @nonVirtual
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
  }) async {
    var list = <Blog>[];
    final mustList = ElasticActionList();
    final sortList = <Map<String, dynamic>>[];
    if (category != null && category != kEmptyCategoryID && category != '0') {
      final must = ElasticActionList();
      must.addFilter(
        keyFilter: 'terms',
        key: 'categories',
        value: category.split(','),
      );
      must.addFilter(
        keyFilter: 'terms',
        key: 'pure_taxonomies.categories.term_id',
        value: category.split(','),
      );
      mustList.addBool(should: must.actions);
    }

    if (tag?.isNotEmpty ?? false) {
      final must = ElasticActionList();
      must.addFilter(keyFilter: 'terms', key: 'tags', value: tag?.split(','));
      must.addFilter(
        keyFilter: 'terms',
        key: 'pure_taxonomies.tags.term_id',
        value: tag?.split(','),
      );
      mustList.addBool(must: must.actions);
    }
    if (search?.isNotEmpty ?? false) {
      mustList.addQuery(
        query: '$search'.splitMapJoin(
          RegExp(r' |-'),
          onNonMatch: (n) => '*$n*',
          onMatch: (m) => ' ',
        ),
        queryOperator: ElasticQueryOperator.and,
        fields: ['title.rendered'],
      );
    }
    if (orderBy?.isNotEmpty ?? false) {
      sortList
          .add({ElasticClient.convertBlogOrderBy('$orderBy'): order ?? 'desc'});
    }

    if (include?.isNotEmpty ?? false) {
      mustList.addFilter(
        keyFilter: 'terms',
        key: 'id',
        value: include?.split(','),
      );
    }

    if (author?.isNotEmpty ?? false) {
      mustList.addMatch(key: 'author', value: author);
    }

    final response = await ElasticService.search(
      uri: Uri.parse(domainBlog),
      indiesName: IndiesName.blog,
      languageCode: languageCode,
      limit: limit ?? apiPageSize,
      offset: offset,
      mustList: mustList,
      sortList: sortList,
    );

    if (response != null) {
      list = Blog.parseBlogList(response, {'include': include});
    }

    return list;
  }
}
