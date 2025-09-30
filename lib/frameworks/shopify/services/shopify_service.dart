import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flux_localization/flux_localization.dart';
import 'package:flux_ui/flux_ui.dart' as store_model;
import 'package:flux_ui/flux_ui.dart';
import 'package:graphql/client.dart';
import 'package:intl/intl.dart';

import '../../../common/config.dart'
    show kAdvanceConfig, kShopifyPaymentConfig, shopifyCustomerAccountConfig;
import '../../../common/constants.dart';
import '../../../common/error_codes/error_codes.dart';
import '../../../data/boxes.dart';
import '../../../models/cart/cart_model_shopify.dart';
import '../../../models/entities/index.dart';
import '../../../models/index.dart'
    show
        CartModel,
        Category,
        Order,
        PaymentMethod,
        PaymentSettings,
        Product,
        ProductModel,
        ProductVariation,
        RatingCount,
        ShippingMethod,
        User;
import '../../../services/base_services.dart';
import '../../../widgets/common/index.dart';
import 'shopify_blog_service.dart';
import 'shopify_customer_account_service.dart';
import 'shopify_query.dart';
import 'shopify_storage.dart';

class ShopifyService extends BaseServices {
  ShopifyService({
    required super.domain,
    super.blogDomain,
    required String accessToken,
    required this.client,
  }) : super(
          blogService: (blogDomain?.isEmpty ?? true)
              ? ShopifyBlogService(client: client)
              : null,
        ) {
    // Initialize Customer Account API service if config is available
    if (shopifyCustomerAccountConfig.enabled) {
      customerAccountService = ShopifyCustomerAccountService(
        config: shopifyCustomerAccountConfig,
        shopDomain: domain,
      );
    }
  }

  Future<String?> get customerAccessToken async =>
      await customerAccountService?.getAccessToken() ??
      UserBox().userInfo?.cookie;

  bool get isCustomerAccountEnabled =>
      customerAccountService != null && (UserBox().userInfo?.isSocial == true);

  static const String apiVersion = '2025-04';

  final GraphQLClient client;

  ShopifyStorage shopifyStorage = ShopifyStorage();
  ShopifyCustomerAccountService? customerAccountService;

  @override
  String get languageCode => super.languageCode.toUpperCase();

  String? get countryCode => (SettingsBox().countryCode?.isEmpty ?? true)
      ? null
      : SettingsBox().countryCode?.toUpperCase();

  final cacheCursorWithCategories = <String, String?>{};
  final cacheCursorWithSearch = <String, String?>{};

  static GraphQLClient getClient({
    required String accessToken,
    required String domain,
    String? version,
  }) {
    var httpLink;
    httpGet(domain.toUri()!);
    if (version == null) {
      httpLink = HttpLink('$domain/api/graphql');
    } else {
      httpLink = HttpLink('$domain/api/$version/graphql.json');
    }
    final authLink = AuthLink(
      headerKey: 'X-Shopify-Storefront-Access-Token',
      getToken: () async => accessToken,
    );
    return GraphQLClient(
      cache: GraphQLCache(),
      link: authLink.concat(httpLink),
    );
  }

  // Future<void> getCookie() async {
  //   final storage = injector<LocalStorage>();
  //   try {
  //     final json = storage.getItem(LocalStorageKey.shopifyCookie);
  //     if (json != null) {
  //       cookie = json;
  //     } else {
  //       cookie = 'OCSESSID=' +
  //           randomNumeric(30) +
  //           '; PHPSESSID=' +
  //           randomNumeric(30);
  //       await storage.setItem(LocalStorageKey.shopifyCookie, cookie);
  //     }
  //     printLog('Cookie storage: $cookie');
  //   } catch (err) {
  //     printLog(err);
  //   }
  // }

  Future<List<Category>> getCategoriesByCursor({
    List<Category>? categories,
    String? cursor,
  }) async {
    try {
      const nRepositories = 50;
      var variables = <String, dynamic>{'nRepositories': nRepositories};
      if (cursor != null) {
        variables['cursor'] = cursor;
      }
      variables['pageSize'] = 250;
      variables['langCode'] = languageCode;
      final options = QueryOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        document: gql(ShopifyQuery.getCollections),
        variables: variables,
      );
      final result = await client.query(options);

      if (result.hasException) {
        printLog(result.exception.toString());
      }

      var list = categories ?? <Category>[];

      for (var item in result.data!['collections']['edges']) {
        var category = item['node'];

        list.add(Category.fromJsonShopify(category));
      }
      if (result.data?['collections']?['pageInfo']?['hasNextPage'] ?? false) {
        var lastCategory = result.data!['collections']['edges'].last;
        String? cursor = lastCategory['cursor'];
        if (cursor != null) {
          printLog('::::getCategories shopify by cursor $cursor');
          return await getCategoriesByCursor(
            categories: list,
            cursor: cursor,
          );
        }
      }
      return list;
    } catch (e) {
      return categories ?? [];
    }
  }

  @override
  Future<List<Category>> getCategories() async {
    try {
      printLog('::::request category');
      var categories = await getCategoriesByCursor();
      return categories;
    } catch (e) {
      printLog('::::getCategories shopify error');
      printLog(e.toString());
      rethrow;
    }
  }

  @override
  Future<PagingResponse<Category>> getSubCategories({
    dynamic page,
    int limit = 25,
    required String? parentId,
  }) async {
    final cursor = page;
    try {
      const nRepositories = 50;
      var variables = <String, dynamic>{'nRepositories': nRepositories};
      if (cursor != null) {
        variables['cursor'] = cursor;
      }
      variables['pageSize'] = limit;
      final options = QueryOptions(
        document: gql(ShopifyQuery.getCollections),
        variables: variables,
      );
      final result = await client.query(options);

      if (result.hasException) {
        printLog(result.exception.toString());
      }

      var list = <Category>[];

      String? lastCursor;
      for (var item in result.data!['collections']['edges']) {
        var category = item['node'];
        lastCursor = item['cursor'];
        list.add(Category.fromJsonShopify(category));
      }

      return PagingResponse(data: list, cursor: lastCursor);
    } catch (e) {
      return const PagingResponse(data: <Category>[]);
    }
  }

  Future<List<Product>?> fetchProducts({
    int page = 1,
    int? limit,
    String? order,
    String? orderBy,
  }) async {
    String? currentCursor;
    final sortKey = getProductSortKey(orderBy);
    final reverse = getOrderDirection(order);
    try {
      var list = <Product>[];
      const nRepositories = 50;
      var variables = <String, dynamic>{
        'nRepositories': nRepositories,
        'pageSize': limit ?? apiPageSize,
        'sortKey': sortKey,
        'reverse': reverse,
        'langCode': languageCode,
        'countryCode': countryCode,
      };
      final markCategory = variables.toString();
      if (page == 1) {
        cacheCursorWithCategories[markCategory] = null;
      }

      currentCursor = cacheCursorWithCategories[markCategory];
      if (currentCursor?.isNotEmpty ?? false) {
        variables['cursor'] = currentCursor;
      }
      printLog('::::request fetchProducts');
      final options = QueryOptions(
        document: gql(ShopifyQuery.getProducts),
        fetchPolicy: FetchPolicy.networkOnly,
        variables: variables,
      );
      final result = await client.query(options);
      if (result.hasException) {
        throw (result.exception.toString());
      }

      var productResp = result.data?['products'];

      if (productResp != null) {
        var edges = productResp['edges'];
        if (edges is List && edges.isNotEmpty) {
          printLog('fetchProducts with products length ${edges.length}');
          var lastItem = edges.last;
          var lastCursor = lastItem['cursor'];
          cacheCursorWithCategories[markCategory] = lastCursor;
          for (var item in edges) {
            var product = item['node'];

            /// Hide out of stock.
            if ((kAdvanceConfig.hideOutOfStock) &&
                product['availableForSale'] == false) {
              continue;
            }
            list.add(Product.fromShopify(product));
          }
        }
      }
      return list;
    } catch (e) {
      printError('::::fetchProducts shopify error $e');
      printError(e.toString());
      rethrow;
    }
  }

  @override
  Future<PagingResponse<Product>> getProductsByCategoryId(
    String categoryId, {
    dynamic page,
    int limit = 25,
    String? orderBy,
    String? order,
  }) async {
    try {
      final currentCursor = page;
      printLog(
          '::::request fetchProductsByCategory with cursor $currentCursor');
      const nRepositories = 50;

      final sortKey = getProductCollectionSortKey(orderBy);
      final reverse = getOrderDirection(order);

      var variables = <String, dynamic>{
        'nRepositories': nRepositories,
        'categoryId': categoryId.toString(),
        'pageSize': limit,
        'query': '',
        'sortKey': sortKey,
        'reverse': reverse,
        'cursor': currentCursor != '' ? currentCursor : null,
        'langCode': languageCode,
        'countryCode': countryCode,
      };
      final options = QueryOptions(
        document: gql(ShopifyQuery.getProductByCollection),
        fetchPolicy: FetchPolicy.networkOnly,
        variables: variables,
      );
      final result = await client.query(options);
      var list = <Product>[];
      var lastCursor = '';

      if (result.hasException) {
        printLog(result.exception.toString());
      }

      var node = result.data?['node'];

      if (node != null) {
        var productResp = node['products'];
        var edges = productResp['edges'];

        printLog(
            'fetchProductsByCategory with products length ${edges.length}');

        if (edges.length != 0) {
          var lastItem = edges.last;
          lastCursor = lastItem['cursor'];
        }

        for (var item in result.data!['node']['products']['edges']) {
          var product = item['node'];
          product['categoryId'] = categoryId;

          /// Hide out of stock.
          if ((kAdvanceConfig.hideOutOfStock) &&
              product['availableForSale'] == false) {
            continue;
          }
          list.add(Product.fromShopify(product));
        }
      }

      return PagingResponse(data: list, cursor: lastCursor);
    } catch (e) {
      return const PagingResponse(data: []);
    }
  }

  @override
  Future<List<Product>?> fetchProductsLayout({
    required config,
    ProductModel? productModel,
    userId,
    bool refreshCache = false,
  }) async {
    try {
      var list = <Product>[];
      if (config['layout'] == 'imageBanner' ||
          config['layout'] == 'circleCategory') {
        return list;
      }

      return await fetchProductsByCategory(
        categoryId: config['category'],
        orderBy: config['orderby'].toString(),
        order: config['order'].toString(),
        productModel: productModel,
        page: config.containsKey('page') ? config['page'] : 1,
        limit: config['limit'],
      );
    } catch (e) {
      printLog('::::fetchProductsLayout shopify error');
      printLog(e.toString());
      return null;
    }
  }

  String getProductCollectionSortKey(orderBy) {
    // if (onSale == true) return 'BEST_SELLING';

    if (orderBy == 'price') return 'PRICE';

    if (orderBy == 'date') return 'CREATED';

    if (orderBy == 'title') return 'TITLE';

    return 'COLLECTION_DEFAULT';
  }

  String getProductSortKey(orderBy) {
    // if (onSale == true) return 'BEST_SELLING';

    if (orderBy == 'price') return 'PRICE';

    if (orderBy == 'date') return 'UPDATED_AT';

    if (orderBy == 'title') return 'TITLE';

    return 'RELEVANCE';
  }

  @override
  bool getOrderDirection(order) {
    if (order == 'desc') return true;
    return false;
  }

  @override
  Future<List<Product>?> fetchProductsByCategory({
    String? categoryId,
    String? tagId,
    page = 1,
    minPrice,
    maxPrice,
    orderBy,
    order,
    featured,
    onSale,
    ProductModel? productModel,
    listingLocation,
    userId,
    nextCursor,
    String? include,
    String? search,
    bool? productType,
    bool? boostEngine,
    limit,
    List<String>? brandIds,
    Map? attributes,
    String? stockStatus,
    List<String>? exclude,
  }) async {
    if ((categoryId?.isEmpty ?? true) &&
        (tagId?.isEmpty ?? true) &&
        (search == null || search.isEmpty)) {
      return await fetchProducts(
        orderBy: orderBy,
        page: page,
        limit: limit,
        order: order,
      );
    }
    if (search != null && search.isNotEmpty) {
      search = 'title:$search OR $search';
    }
    String? currentCursor;
    if (tagId != null) {
      search = (search?.isNotEmpty ?? false)
          ? '$search AND tag:$tagId'
          : 'tag:$tagId';
    }

    if (search == null && categoryId == null) {
      return <Product>[];
    }

    final sortKey = getProductCollectionSortKey(orderBy);
    final reverse = getOrderDirection(order);

    try {
      var list = <Product>[];

      /// change category id
      if (page == 1) {
        cacheCursorWithCategories['$categoryId'] = null;
        cacheCursorWithSearch['$search'] = null;
      }

      currentCursor = cacheCursorWithCategories['$categoryId'];
      const nRepositories = 50;
      var variables = <String, dynamic>{
        'nRepositories': nRepositories,
        'categoryId': categoryId,
        'pageSize': limit ?? apiPageSize,
        'query': search,
        'sortKey': sortKey,
        'reverse': reverse,
        'langCode': languageCode,
        'countryCode': countryCode,
        'cursor': currentCursor != '' ? currentCursor : null,
      };
      printLog(
          '::::request fetchProductsByCategory with category id $categoryId --- search $search');

      if (search != null && search.isNotEmpty ||
          (categoryId?.isEmpty ?? true) ||
          categoryId == kEmptyCategoryID) {
        currentCursor = cacheCursorWithSearch['$search'];
        printLog(
            '::::request fetchProductsByCategory with cursor $currentCursor');

        final result = await _searchProducts(
          name: search,
          cursor: currentCursor,
          sortKey: orderBy,
          reverse: reverse,
        );
        cacheCursorWithSearch['$search'] = result.cursor;
        return result.data;
      }

      printLog(
          '::::request fetchProductsByCategory with cursor $currentCursor');
      final options = QueryOptions(
        document: gql(ShopifyQuery.getProductByCollection),
        fetchPolicy: FetchPolicy.networkOnly,
        variables: variables,
      );
      final result = await client.query(options);

      if (result.hasException) {
        throw (result.exception.toString());
      }

      var node = result.data?['node'];

      if (node != null) {
        var productResp = node['products'];
        var edges = productResp['edges'];

        printLog(
            'fetchProductsByCategory with products length ${edges.length}');

        if (edges.length != 0) {
          var lastItem = edges.last;
          var lastCursor = lastItem['cursor'];
          cacheCursorWithCategories['$categoryId'] = lastCursor;
        }

        for (var item in result.data!['node']['products']['edges']) {
          var product = item['node'];
          product['categoryId'] = categoryId;

          /// Hide out of stock.
          if ((kAdvanceConfig.hideOutOfStock) &&
              product['availableForSale'] == false) {
            continue;
          }
          list.add(Product.fromShopify(product));
        }
      }
      return list;
    } catch (e) {
      printError('::::fetchProductsByCategory shopify error $e');
      printError(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<PaymentMethod>> getPaymentMethods({
    CartModel? cartModel,
    ShippingMethod? shippingMethod,
    String? token,
  }) async {
    try {
      var list = <PaymentMethod>[];

      list.add(PaymentMethod.fromJson({
        'id': '0',
        'title': 'Checkout Free',
        'description': '',
        'enabled': true,
      }));

      if (kShopifyPaymentConfig.paymentCardConfig.enable) {
        list.add(PaymentMethod.fromJson({
          'id': PaymentMethod.stripeCard,
          'title': 'Checkout Credit card',
          'description': '',
          'enabled': true,
        }));
      }

      if (kShopifyPaymentConfig.applePayConfig.enable && isIos) {
        list.add(PaymentMethod.fromJson({
          'id': PaymentMethod.stripeApplePay,
          'title': 'Checkout with ApplePay',
          'description': '',
          'enabled': true,
        }));
      }

      if (kShopifyPaymentConfig.googlePayConfig.enable && isAndroid) {
        list.add(PaymentMethod.fromJson({
          'id': PaymentMethod.stripeGooglePay,
          'title': 'Checkout with GooglePay',
          'description': '',
          'enabled': true,
        }));
      }

      return list;
    } catch (e) {
      rethrow;
    }
  }

  Future<PagingResponse<Product>> _searchProducts({
    String? name,
    int? page,
    String? cursor,
    String? sortKey,
    bool reverse = false,
  }) async {
    try {
      printLog('::::request searchProducts');
      const pageSize = 25;
      const nRepositories = 50;
      final options = QueryOptions(
        document: gql(ShopifyQuery.getProductByName),
        fetchPolicy: FetchPolicy.networkOnly,
        variables: <String, dynamic>{
          'nRepositories': nRepositories,
          'query': '$name',
          if (cursor != null)
            'cursor': cursor
          else if (page != null)
            'cursor': page,
          'pageSize': pageSize,
          'sortKey': getProductSortKey(sortKey),
          'reverse': reverse,
          'langCode': languageCode,
          'countryCode': countryCode,
        },
      );
      final result = await client.query(options);

      if (result.hasException) {
        throw (result.exception.toString());
      }

      var list = <Product>[];
      String? lastCursor;
      for (var item in result.data?['products']['edges']) {
        lastCursor = item['cursor'];

        /// Hide out of stock.
        if ((kAdvanceConfig.hideOutOfStock) &&
            item['node']?['availableForSale'] == false) {
          continue;
        }
        list.add(Product.fromShopify(item['node']));
      }

      printLog(list);

      return PagingResponse(data: list, cursor: lastCursor);
    } catch (e) {
      printLog('::::searchProducts shopify error');
      printLog(e.toString());
      rethrow;
    }
  }

  @override
  Future<User> createUser({
    String? firstName,
    String? lastName,
    String? username,
    String? email,
    String? password,
    String? phoneNumber,
    bool isVendor = false,
    bool isDelivery = false,
    bool isOwner = false,
  }) async {
    try {
      printLog('::::request createUser');

      const nRepositories = 50;
      final options = QueryOptions(
          document: gql(ShopifyQuery.createCustomer),
          variables: <String, dynamic>{
            'nRepositories': nRepositories,
            'input': {
              'firstName': firstName,
              'lastName': lastName,
              'email': email,
              'password': password,
              'phone': phoneNumber,
            }
          });

      final result = await client.query(options);

      final exception = result.exception;
      if (exception != null) {
        printLog(result.exception.toString());
        throw (exception.graphqlErrors.first.message);
      }

      final listError =
          List.from(result.data?['customerCreate']?['userErrors'] ?? []);
      if (listError.isNotEmpty) {
        final message = listError.map((e) => e['message']).join(', ');
        throw ('$message!');
      }

      printLog('createUser ${result.data}');

      var userInfo = result.data!['customerCreate']['customer'];
      final tokenResult =
          await createAccessToken(email: email, password: password);
      var user = User.fromShopifyJson(userInfo, tokenResult.token,
          tokenExpiresAt: tokenResult.expiresAt);

      return user;
    } catch (e) {
      printLog('::::createUser shopify error');
      printLog(e.toString());
      rethrow;
    }
  }

  @override
  Future<User?> getUserInfo(cookie, {DateTime? tokenExpiresAt}) async {
    try {
      printLog('::::request getUserInfo');

      if (cookie == null || cookie.isEmpty) {
        return null;
      }

      if (isCustomerAccountEnabled) {
        return await customerAccountService!
            .getUserInfo(await customerAccessToken);
      }

      const nRepositories = 50;
      final options = QueryOptions(
          document: gql(ShopifyQuery.getCustomerInfo),
          fetchPolicy: FetchPolicy.networkOnly,
          variables: <String, dynamic>{
            'nRepositories': nRepositories,
            'accessToken': cookie
          });

      final result = await client.query(options);

      printLog('result ${result.data}');

      if (result.hasException) {
        printLog(result.exception.toString());
        throw Exception(result.exception.toString());
      }

      var user = User.fromShopifyJson(result.data?['customer'] ?? {}, cookie,
          tokenExpiresAt: tokenExpiresAt);
      if (user.cookie == null) return null;
      return user;
    } catch (e) {
      printLog('::::getUserInfo shopify error');
      printLog(e.toString());
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> updateUserInfo(
      Map<String, dynamic> json, String? token) async {
    if (isCustomerAccountEnabled) {
      return customerAccountService!.updateUserInfo(json, token);
    }

    try {
      printLog('::::request updateUser');

      const nRepositories = 50;
      json.removeWhere((key, value) => key == 'deviceToken');
      // Shopify does not accept an empty string value when update
      if (json['phone'] == '') {
        json['phone'] = null;
      }
      if (json['password'] == '') {
        json.remove('password');
      }
      final options = QueryOptions(
          document: gql(ShopifyQuery.customerUpdate),
          fetchPolicy: FetchPolicy.networkOnly,
          variables: <String, dynamic>{
            'nRepositories': nRepositories,
            'customerAccessToken': token,
            'customer': json,
          });

      final result = await client.query(options);

      if (result.hasException) {
        printLog(result.exception.toString());
        throw Exception(result.exception.toString());
      }
      final List? errors = result.data!['customerUpdate']['customerUserErrors'];
      final error =
          errors?.firstWhereOrNull((element) => element['message'] != null);
      if (error != null) {
        throw Exception(error['message']);
      }

      // When update password, full user info will get null
      final userData = result.data?['customerUpdate']['customer'];
      // final user = User.fromShopifyJson(userData, newToken);
      return userData;
    } catch (e) {
      printLog('::::updateUser shopify error');
      printLog(e.toString());
      rethrow;
    }
  }

  Future<({String? token, DateTime? expiresAt})> createAccessToken(
      {email, password}) async {
    try {
      printLog('::::request createAccessToken');

      const nRepositories = 50;
      final options = QueryOptions(
          document: gql(ShopifyQuery.createCustomerToken),
          fetchPolicy: FetchPolicy.networkOnly,
          variables: <String, dynamic>{
            'nRepositories': nRepositories,
            'input': {'email': email, 'password': password}
          });

      final result = await client.query(options);

      if (result.hasException) {
        printLog(result.exception.toString());
        throw Exception(result.exception.toString());
      }
      final json = result.data?['customerAccessTokenCreate']
              ?['customerAccessToken'] ??
          {};

      final String? token = json['accessToken'];
      DateTime? expiresAt;

      if (json['expiresAt'] != null) {
        try {
          expiresAt = DateTime.parse(json['expiresAt']);
          printLog('Token expires at: $expiresAt');
          printLog(
              'Token expireds after ${expiresAt.difference(DateTime.now()).inDays} days');
        } catch (e) {
          printLog('Error parsing expiresAt: ${e.toString()}');
        }
      }

      return (token: token, expiresAt: expiresAt);
    } catch (e) {
      printLog('::::createAccessToken shopify error');
      printLog(e.toString());
      rethrow;
    }
  }

  @override
  Future<User?> login({username, password}) async {
    try {
      printLog('::::request login');

      final result =
          await createAccessToken(email: username, password: password);
      final accessToken = result.token;
      final expiresAt = result.expiresAt;

      if (accessToken == null) {
        throw Exception('Failed to get access token');
      }

      var userInfo = await getUserInfo(accessToken, tokenExpiresAt: expiresAt);

      printLog('login $userInfo');

      return userInfo;
    } catch (e) {
      printLog('::::login shopify error');
      printLog(e.toString());
      throw Exception(
          'Please check your username or password and try again. If the problem persists, please contact support!');
    }
  }

  @override
  Future<Product> getProduct(id) async {
    printLog('::::request getProduct $id');

    const nRepositories = 50;
    final options = QueryOptions(
      document: gql(ShopifyQuery.getProductById),
      fetchPolicy: FetchPolicy.noCache,
      variables: <String, dynamic>{
        'nRepositories': nRepositories,
        'id': id,
        'langCode': languageCode,
        'countryCode': countryCode,
      },
    );
    final result = await client.query(options);

    if (result.hasException) {
      printLog(result.exception.toString());
    }
    final product = Product.fromShopify(result.data!['node']);
    return product;
  }

  // payment settings from shop
  @override
  Future<PaymentSettings> getPaymentSettings() async {
    try {
      printLog('::::request paymentSettings');

      const nRepositories = 50;
      final options = QueryOptions(
          document: gql(ShopifyQuery.getPaymentSettings),
          variables: const <String, dynamic>{
            'nRepositories': nRepositories,
          });

      final result = await client.query(options);

      printLog('result ${result.data}');

      if (result.hasException) {
        printLog(result.exception.toString());
        throw Exception(result.exception.toString());
      }
      var json = result.data!['shop']['paymentSettings'];

      printLog('paymentSettings $json');

      return PaymentSettings.fromShopifyJson(json);
    } catch (e) {
      printLog('::::paymentSettings shopify error');
      printLog(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<ProductVariation>?> getProductVariations(Product product) async {
    try {
      return product.variations;
    } catch (e) {
      printLog('::::getProductVariations shopify error');
      rethrow;
    }
  }

  @override
  Future<PagingResponse<Order>> getMyOrders({
    User? user,
    dynamic cursor,
    String? cartId,
    String? orderStatus,
  }) async {
    if (isCustomerAccountEnabled) {
      return await customerAccountService!.getMyOrders(cursor: cursor);
    }
    try {
      const nRepositories = 50;
      final options = QueryOptions(
        document: gql(ShopifyQuery.getOrder),
        fetchPolicy: FetchPolicy.noCache,
        variables: <String, dynamic>{
          'nRepositories': nRepositories,
          'customerAccessToken': user!.cookie,
          if (cursor != null) 'cursor': cursor,
          'pageSize': 50
        },
      );
      final result = await client.query(options);

      if (result.hasException) {
        printLog(result.exception.toString());
      }

      var list = <Order>[];
      String? lastCursor;

      for (var item in result.data!['customer']['orders']['edges']) {
        lastCursor = item['cursor'];
        var order = item['node'];
        list.add(Order.fromJson(order));
      }
      return PagingResponse(
        cursor: lastCursor,
        data: list,
      );
    } catch (e) {
      printLog('::::getMyOrders shopify error');
      printLog(e.toString());
      return const PagingResponse();
    }
  }

  @override
  Future<String> submitForgotPassword({
    String? forgotPwLink,
    Map<String, dynamic>? data,
  }) async {
    final options = MutationOptions(
      document: gql(ShopifyQuery.resetPassword),
      variables: {
        'email': data!['email'],
      },
    );

    final result = await client.mutate(options);

    if (result.hasException) {
      printLog(result.exception.toString());
      throw (result.exception?.graphqlErrors.firstOrNull?.message ??
          S.current.somethingWrong);
    }

    final List? errors = result.data!['customerRecover']['customerUserErrors'];
    const errorCode = 'UNIDENTIFIED_CUSTOMER';
    if (errors?.isNotEmpty ?? false) {
      if (errors!.any((element) => element['code'] == errorCode)) {
        throw Exception(errorCode);
      }
    }

    return '';
  }

  @override
  Future<Product?> getProductByPermalink(String productPermalink) async {
    final handle =
        productPermalink.substring(productPermalink.lastIndexOf('/') + 1);
    printLog('::::request getProduct $productPermalink');

    const nRepositories = 50;
    final options = QueryOptions(
      document: gql(ShopifyQuery.getProductByHandle),
      variables: <String, dynamic>{
        'nRepositories': nRepositories,
        'handle': handle
      },
    );
    final result = await client.query(options);

    if (result.hasException) {
      printLog(result.exception.toString());
    }

    final productData = result.data?['productByHandle'];
    return Product.fromShopify(productData);
  }

  @override
  Future<Category?> getProductCategoryByPermalink(
      String productCategoryPermalink) async {
    final uri = Uri.parse(productCategoryPermalink);
    printLog(
        '::::getProductCategoryByPermalink shopify link: $productCategoryPermalink');
    final collectionHandle = uri.pathSegments.last;
    try {
      const nRepositories = 50;
      final options = QueryOptions(
        document: gql(ShopifyQuery.getCollectionByHandle),
        variables: <String, dynamic>{
          'nRepositories': nRepositories,
          'handle': collectionHandle,
          'langCode': languageCode,
        },
      );
      final result = await client.query(options);

      if (result.hasException) {
        printLog(result.exception.toString());
      }

      final collectionData = result.data?['collection'];
      final collection = Category.fromJsonShopify(collectionData);
      return collection;
    } catch (e) {
      printLog('::::getProductCategoryByPermalink shopify error');
      printLog(e.toString());
      return null;
    }
  }

  @override
  Future<Category?> getProductCategoryById({
    required String categoryId,
  }) async {
    printLog('::::getCollection shopify id: $categoryId');
    try {
      const nRepositories = 50;
      final options = QueryOptions(
        document: gql(ShopifyQuery.getCollectionById),
        variables: <String, dynamic>{
          'nRepositories': nRepositories,
          'id': categoryId,
          'langCode': languageCode,
        },
      );
      final result = await client.query(options);

      if (result.hasException) {
        printLog(result.exception.toString());
      }

      final collectionData = result.data?['collection'];
      final collection = Category.fromJsonShopify(collectionData);
      return collection;
    } catch (e) {
      printLog('::::getCollection shopify error');
      printLog(e.toString());
      return null;
    }
  }

  @override
  Future<Order?> getLatestOrder({required String cookie}) async {
    if (isCustomerAccountEnabled) {
      return await customerAccountService!.getLatestOrder();
    }
    try {
      const nRepositories = 50;
      final options = QueryOptions(
        document: gql(ShopifyQuery.getOrder),
        fetchPolicy: FetchPolicy.noCache,
        variables: <String, dynamic>{
          'nRepositories': nRepositories,
          'customerAccessToken': cookie,
          'pageSize': 1
        },
      );
      final result = await client.query(options);

      if (result.hasException) {
        printLog(result.exception.toString());
      }

      for (var item in result.data!['customer']['orders']['edges']) {
        var order = item['node'];
        return Order.fromJson(order);
      }
    } catch (e) {
      printLog('::::getLatestOrder shopify error');
      printLog(e.toString());
      return null;
    }
    return null;
  }

  Future<CartDataShopify?> cartPaymentUpdate({
    required String cartId,
    required Map paymentData,
  }) async {
    printLog('::::cartPaymentUpdate CartId: $cartId PaymentData: $paymentData');
    try {
      final options = MutationOptions(
        document: gql(ShopifyQuery.cartPaymentUpdate),
        variables: <String, dynamic>{
          'id': cartId,
          'payment': paymentData,
        },
      );
      final result = await client.mutate(options);

      if (result.hasException) {
        printLog(result.exception.toString());
        throw (result.exception.toString());
      }

      final data = result.data!['cartPaymentUpdate']['cart'];
      return CartDataShopify.fromJson(data);
    } catch (e, trace) {
      printLog('::::cartPaymentUpdate shopify error $e');
      printError(e, trace);
      return null;
    }
  }

  @override
  Future<List<Product>> getVideoProducts({
    required int page,
    int perPage = 10,
  }) async {
    try {
      var list = <Product>[];
      final options = QueryOptions(
        document: gql(ShopifyQuery.getProductsByTag),
        fetchPolicy: FetchPolicy.networkOnly,
        variables: <String, dynamic>{
          'pageSize': perPage,
          'query': 'tag:video',
          'cursor': null,
          'langCode': languageCode,
          'countryCode': countryCode,
        },
      );
      final result = await client.query(options);

      if (result.hasException) {
        throw (result.exception.toString());
      }
      for (var item in result.data?['products']['edges']) {
        list.add(Product.fromShopify(item['node']));
      }
      return list;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PagingResponse<Review>> getReviews(String productId,
          {int page = 1, int perPage = 10}) =>
      reviewService.getReviews(
        productId,
        page: page,
        perPage: perPage,
      );

  @override
  Future<RatingCount?>? getProductRatingCount(String productId) async {
    return reviewService.getProductRatingCount(productId);
  }

  @override
  Future? createReview(ReviewPayload payload) {
    return reviewService.createReview(payload);
  }

  @override
  Future<List<Currency>?> getAvailableCurrencies() async {
    try {
      var list = <Currency>[];
      final options = QueryOptions(
        document: gql(ShopifyQuery.getAvailableCurrency),
        fetchPolicy: FetchPolicy.networkOnly,
      );
      final result = await client.query(options);

      if (result.hasException) {
        throw (result.exception.toString());
      }

      final availableCountries =
          List.from(result.data?['localization']?['availableCountries'] ?? []);
      if (availableCountries.isEmpty) return null;

      for (var item in availableCountries) {
        list.add(Currency.fromShopify(item));
      }
      return list;
    } catch (e) {
      return null;
    }
  }

  @override
  Future logout(String? token) async {
    return logoutFromCustomerAccount();
    // printLog('::::deleteToken shopify');
    // try {
    //   const nRepositories = 50;
    //   final options = QueryOptions(
    //     document: gql(ShopifyQuery.deleteToken),
    //     variables: <String, dynamic>{
    //       'nRepositories': nRepositories,
    //       'customerAccessToken': token,
    //     },
    //   );
    //   final result = await client.query(options);
    //
    //   if (result.hasException) {
    //     throw Exception(result.exception.toString());
    //   }
    // } catch (e) {
    //   printLog('::::deleteToken shopify error');
    //   printLog(e.toString());
    //   return null;
    // }
    // return null;
  }

  @override
  Future<ProductVariation?> getVariationProduct(
    String productId,
    String? variationId,
  ) async {
    if (variationId == null) return null;

    try {
      final options = MutationOptions(
        document: gql(ShopifyQuery.getProductVariant),
        fetchPolicy: FetchPolicy.noCache,
        variables: <String, dynamic>{
          'id': variationId,
          'langCode': languageCode,
          'countryCode': countryCode,
        },
      );
      final result = await client.mutate(options);

      if (result.hasException) {
        printLog(result.exception.toString());
      }

      final data = result.data!['node'];
      return ProductVariation.fromShopifyJson(data);
    } catch (e) {
      printLog('::::getVariationProduct shopify error');
      printLog(e.toString());
      return null;
    }
  }

  @override
  Future<List<ShippingMethod>> getShippingMethods({
    required CartModel cartModel,
    String? token,
    String? checkoutId,
    store_model.Store? store,
  }) async {
    try {
      if (checkoutId == null) {
        throw 'Please create a cart first.';
      }
      var list = <ShippingMethod>[];
      var newAddress = cartModel.address?.toShopifyJson();

      printLog('getShippingMethods with cartId $checkoutId');

      final options = MutationOptions(
        document: gql(ShopifyQuery.cartBuyerIdentifyUpdate),
        fetchPolicy: FetchPolicy.noCache,
        variables: {
          'cartId': checkoutId,
          'buyerIdentity': {
            'email': cartModel.address!.email,
            'countryCode': countryCode,
            'customerAccessToken': await customerAccessToken,
            'deliveryAddressPreferences': [
              {
                'deliveryAddress': newAddress,
              }
            ]
          },
        },
      );

      final result = await client.mutate(options);

      if (result.hasException) {
        printLog(result.exception.toString());
        throw ('So sorry, We do not support shipping to your address.');
      }

      final cart = await getCart(cartId: checkoutId);

      final deliveryGroups = cart.deliverGroups;

      if (deliveryGroups.isEmpty) {
        throw ('So sorry, We do not support shipping to your address.');
      }

      for (final group in deliveryGroups) {
        for (final option in group.deliveryOptions) {
          final optionWithGroupId = option.toJson()
            ..addAll({
              'deliveryGroupId': group.id,
            });
          list.add(ShippingMethod.fromShopifyJsonV2(optionWithGroupId));
        }
      }

      return list;
    } catch (e, trace) {
      printLog('::::getShippingMethods shopify error');
      printError(e, trace);
      throw ('So sorry, We do not support shipping to your address.');
    }
  }

  Future<CartDataShopify> getCart({required String cartId}) async {
    try {
      final options = QueryOptions(
        document: gql(ShopifyQuery.fetchCart),
        fetchPolicy: FetchPolicy.noCache,
        variables: {'id': cartId},
      );

      final result = await client.query(options);

      if (result.hasException) {
        printLog(result.exception.toString());
        throw Exception(result.exception.toString());
      }

      printLog('getCart $result');

      return CartDataShopify.fromJson(result.data?['cart']);
    } catch (e, trace) {
      printLog('::::getCheckout shopify error');
      printError(e, trace);
      rethrow;
    }
  }

  Future<CartDataShopify?> createCart(
      {required CartModelShopify cartModel}) async {
    try {
      var lineItems = [];

      final productVariationInCart = cartModel.cartItemMetaDataInCart.keys
          .where((e) => cartModel.cartItemMetaDataInCart[e]?.variation != null)
          .toList();
      for (var productId in productVariationInCart) {
        var variant = cartModel.cartItemMetaDataInCart[productId]!.variation!;
        var productCart = cartModel.productsInCart[productId];

        printLog('::::::::createCart $variant');

        lineItems.add({'merchandiseId': variant.id, 'quantity': productCart});
      }

      printLog('::::::::createCart lineItems $lineItems');
      final options = MutationOptions(
        document: gql(ShopifyQuery.cartCreate),
        variables: {
          'input': {
            'lines': lineItems,
            'buyerIdentity': {
              'countryCode': countryCode,
              // if (email != null) 'email': email,
              // if (cookie != null) 'customerAccessToken': cookie,
              // Use Customer Account API token if available
              'customerAccessToken': await customerAccessToken,
            }
          },
          'langCode': cartModel.langCode?.toUpperCase(),
          'countryCode': countryCode,
        },
      );

      final result = await client.mutate(options);

      if (result.hasException) {
        throw Exception(result.exception.toString());
      }

      final cart = result.data!['cartCreate']['cart'];

      printLog('addItemsToCart cart $cart');

      // start link checkout with user
      // final newCheckout = await (checkoutLinkUser(checkout['id'], cookie));

      final cartData = CartDataShopify.fromJson(cart ?? {});
      return cartData;
    } catch (e, trace) {
      printError('::::addItemsToCart shopify error', trace);
      rethrow;
    }
  }

  Future<CartDataShopify?> applyCouponWithCartId({
    required String cartId,
    required String discountCode,
  }) async {
    try {
      printLog('::::::::::applyCoupon $discountCode for $cartId');

      final options = MutationOptions(
        document: gql(ShopifyQuery.cartDiscountCodesUpdate),
        variables: {
          'cartId': cartId,
          'discountCodes': [discountCode],
        },
      );

      final result = await client.mutate(options);

      if (result.hasException) {
        printLog(result.exception.toString());
        throw Exception(result.exception.toString());
      }

      final cartData = result.data!['cartDiscountCodesUpdate']['cart'];

      return CartDataShopify.fromJson(cartData);
    } catch (e, trace) {
      printLog('::::applyCoupon shopify error');
      printError(e, trace);
      rethrow;
    }
  }

  Future<CartDataShopify?> removeCouponWithCartId(String cartId) async {
    try {
      printLog('::::::::::removeCoupon for $cartId::::::::::::::::');

      final options = MutationOptions(
        document: gql(ShopifyQuery.cartDiscountCodesUpdate),
        variables: {
          'cartId': cartId,
          'discountCodes': const [],
        },
      );

      final result = await client.mutate(options);

      if (result.hasException) {
        printLog(result.exception.toString());
        throw Exception(result.exception.toString());
      }

      final cartData = result.data!['cartDiscountCodesUpdate']['cart'];

      return CartDataShopify.fromJson(cartData);
    } catch (e, trace) {
      printLog('::::::::::::::::::: removeCoupon error ::::::::::::::::::::::');
      printError(e, trace);
      rethrow;
    }
  }

  Future<CartDataShopify> updateCartAttributes({
    required String cartId,
    required DateTime deliveryDate,
  }) async {
    var deliveryInfo = [];
    final dateFormat = DateFormat(DateTimeFormatConstants.ddMMMMyyyy);
    final dayFormat = DateFormat(DateTimeFormatConstants.weekday);
    final timeFormat = DateFormat(DateTimeFormatConstants.timeHHmmFormatEN);
    deliveryInfo = [
      {
        'key': 'Delivery Date',
        'value': dateFormat.format(deliveryDate),
      },
      {
        'key': 'Delivery Day',
        'value': dayFormat.format(deliveryDate),
      },
      {
        'key': 'Delivery Time',
        'value': timeFormat.format(deliveryDate),
      },
      // {
      //   'key': 'Date create',
      //   'value': timeFormat.format(DateTime.now()),
      // },
    ];
    final options = MutationOptions(
      document: gql(ShopifyQuery.cartAttributesUpdate),
      variables: <String, dynamic>{
        'cartId': cartId,
        'attributes': deliveryInfo,
      },
    );

    final result = await client.mutate(options);

    if (result.hasException) {
      printLog(result.exception.toString());
      throw Exception(result.exception.toString());
    }

    return CartDataShopify.fromJson(
        result.data!['cartAttributesUpdate']['cart']);
  }

  Future<CartDataShopify> updateCartNote({
    required String cartId,
    required String note,
  }) async {
    final options = MutationOptions(
      document: gql(ShopifyQuery.cartNoteUpdate),
      variables: <String, dynamic>{
        'cartId': cartId,
        'note': note,
      },
    );

    final result = await client.mutate(options);

    if (result.hasException) {
      printLog(result.exception.toString());
      throw Exception(result.exception.toString());
    }

    return CartDataShopify.fromJson(result.data!['cartNoteUpdate']['cart']);
  }

  @override
  Future<void> updateCartEmail({
    required String cartId,
    required String email,
  }) async {
    final options = MutationOptions(
      document: gql(ShopifyQuery.cartBuyerIdentifyUpdate),
      variables: <String, dynamic>{
        'cartId': cartId,
        'buyerIdentity': {
          'email': email,
        }
      },
    );

    final result = await client.mutate(options);

    if (result.hasException) {
      printLog(result.exception.toString());
      throw (result.exception.toString());
    }
  }

  /// Updates the buyer identity for a cart
  /// This can include email, phone, country code, and delivery address preferences
  /// Returns the updated cart data if successful, otherwise returns null and throws an ErrorKey
  Future<CartDataShopify?> updateCartBuyerIdentity({
    required String cartId,
    required Map<String, dynamic> buyerIdentity,
  }) async {
    try {
      final options = MutationOptions(
        document: gql(ShopifyQuery.cartBuyerIdentifyUpdate),
        fetchPolicy: FetchPolicy.noCache,
        variables: <String, dynamic>{
          'cartId': cartId,
          'buyerIdentity': {
            ...buyerIdentity,
            'customerAccessToken': await customerAccessToken,
          },
        },
      );

      final result = await client.mutate(options);

      if (result.hasException) {
        printLog('GraphQL exception: ${result.exception.toString()}');

        // Check for network errors first
        if (result.exception?.linkException != null) {
          printLog('Network error detected');
          throw ErrorType.networkError;
        }

        // Check for GraphQL errors
        if (result.exception?.graphqlErrors.isNotEmpty ?? false) {
          final firstError = result.exception?.graphqlErrors.first;
          final errorMessage = firstError?.message ?? 'Unknown GraphQL error';
          printLog('GraphQL error: $errorMessage');

          // Default GraphQL error
          throw ErrorType.graphqlError;
        }

        // Generic exception if we can't categorize
        throw ErrorType.unknownError;
      }

      // Check for user errors in the response
      final userErrors = result.data?['cartBuyerIdentityUpdate']?['userErrors'];
      if (userErrors != null && userErrors is List && userErrors.isNotEmpty) {
        final firstError = userErrors.first;
        final errorMessage = firstError['message'] ?? 'Unknown error';
        final errorFields = firstError['field'];

        printLog('User error: $errorMessage, fields: $errorFields');

        // Map specific user errors to ErrorKeys based on field and message
        if (errorFields is List && errorFields.isNotEmpty) {
          final fieldPath = errorFields.join('.');

          if (fieldPath.contains('email')) {
            throw ErrorType.invalidEmail;
          }
          if (fieldPath.contains('phone')) {
            throw ErrorType.invalidPhone;
          }

          // Kiểm tra chi tiết hơn cho lỗi địa chỉ
          if (fieldPath.contains('deliveryAddress')) {
            // Lỗi cụ thể về country trong địa chỉ
            if (fieldPath.contains('country')) {
              throw ErrorType.invalidCountry;
            }
            // Lỗi cụ thể về zip/postal code
            if (fieldPath.contains('zip')) {
              throw ErrorType.invalidPostalCode;
            }
            // Lỗi cụ thể về province/state
            if (fieldPath.contains('province')) {
              throw ErrorType.invalidProvince;
            }
            // Lỗi cụ thể về thành phố
            if (fieldPath.contains('city')) {
              throw ErrorType.invalidCity;
            }
            // Lỗi chung về địa chỉ
            throw ErrorType.invalidAddress;
          }
        }

        // Default user error
        throw ErrorType.unknownError;
      }

      return CartDataShopify.fromJson(
          result.data!['cartBuyerIdentityUpdate']['cart']);
    } catch (e, trace) {
      printLog('::::updateCartBuyerIdentity shopify error');
      printError(e, trace);
      rethrow;
    }
  }

  @override
  Future<CartDataShopify?> updateShippingRateWithCartId(
    String cartId, {
    required String deliveryGroupId,
    required String deliveryOptionHandle,
  }) async {
    try {
      final options = MutationOptions(
        document: gql(ShopifyQuery.cartSelectedDeliveryOptionsUpdate),
        variables: <String, dynamic>{
          'cartId': cartId,
          'selectedDeliveryOptions': [
            {
              'deliveryGroupId': deliveryGroupId,
              'deliveryOptionHandle': deliveryOptionHandle,
            }
          ]
        },
      );
      final result = await client.mutate(options);

      if (result.hasException) {
        printLog(result.exception.toString());
      }

      final data = result.data!['cartSelectedDeliveryOptionsUpdate']['cart'];
      return CartDataShopify.fromJson(data);
    } catch (e, trace) {
      printLog('::::updateShippingRate shopify error');
      printError(e, trace);
      return null;
    }
  }

  /// Prepares a cart for checkout completion  by calling the Shopify API
  /// Returns a map with status information about the cart readiness
  @override
  Future<CartDataShopify?> prepareCartForCompletion({
    required String cartId,
  }) async {
    try {
      printLog(':::::prepareCartForCompletion $cartId');
      final options = MutationOptions(
        document: gql(ShopifyQuery.cartPrepareForCompletion),
        fetchPolicy: FetchPolicy.noCache,
        variables: {'cartId': cartId},
      );

      final result = await client.mutate(options);

      if (result.hasException) {
        throw Exception(result.exception.toString());
      }

      printLog(':::::prepareCartForCompletion');
      final resultData =
          result.data?['cartPrepareForCompletion']?['result'] ?? {};
      final cartDataReady = resultData['cartReady'] ?? {};
      final cartDataNotReady = resultData['cartNotReady'] ?? {};
      final cartDataThrottled = resultData['pollAfter'] ?? {};

      if (cartDataReady.isNotEmpty) {
        return CartDataShopify.fromJson(cartDataReady)
            .copyWith(status: CartStatus.ready);
      }

      if (cartDataNotReady.isNotEmpty) {
        return CartDataShopify.fromJson(cartDataNotReady)
            .copyWith(status: CartStatus.notReady);
      }

      return CartDataShopify.fromJson(cartDataThrottled)
          .copyWith(status: CartStatus.throttled);
    } catch (e, trace) {
      printLog(':::::prepareCartForCompletion error');
      printError(e, trace);
      rethrow;
    }
  }

  /// Submits a cart for checkout completion
  /// This is the final step in the checkout process after the cart has been prepared
  Future<CartSubmitResult> cartSubmitForCompletion({
    required String cartId,
  }) async {
    try {
      printLog(':::::cartSubmitForCompletion $cartId');
      final options = MutationOptions(
        document: gql(ShopifyQuery.cartSubmitForCompletion),
        fetchPolicy: FetchPolicy.noCache,
        variables: {
          'cartId': cartId,
          'attemptToken': Uuid().generateV4(),
        },
      );

      final result = await client.mutate(options);

      if (result.hasException) {
        printLog(result.exception.toString());
        return CartSubmitResult(
          status: CartSubmitStatus.error,
          errors: [
            CartSubmitError(
              code: 'GRAPHQL_ERROR',
              message: result.exception.toString(),
            )
          ],
        );
      }

      printLog(':::::cartSubmitForCompletion success');
      final submitData = result.data?['cartSubmitForCompletion'];
      return CartSubmitResult.fromJson(submitData);
    } catch (e, trace) {
      printLog(':::::cartSubmitForCompletion error');
      printError(e, trace);
      return CartSubmitResult(
        status: CartSubmitStatus.error,
        errors: [
          CartSubmitError(
            code: 'UNKNOWN_ERROR',
            message: e.toString(),
          )
        ],
      );
    }
  }

  @override
  Future<CartTax?>? getTaxes(CartModel cartModel, String? token) async {
    final taxes = cartModel.getTax();
    if (taxes == 0 || taxes == null) {
      return null;
    }
    return CartTax(
      items: [
        Tax(
          title: 'Tax',
          amount: taxes,
        ),
      ],
      total: taxes,
      isIncludingTax: false,
    );
  }

  /// Login with Customer Account API
  @override
  Future<User?> loginWithCustomerAccount() async {
    if (customerAccountService == null) {
      throw Exception('Customer Account API is not configured');
    }

    try {
      final user = await customerAccountService!.login();
      return user;
    } catch (e) {
      printLog('Error logging in with Customer Account API: $e');
      rethrow;
    }
  }

  /// Logout from Customer Account API
  Future<bool> logoutFromCustomerAccount() async {
    if (customerAccountService == null) {
      return false;
    }

    try {
      return await customerAccountService!.logout();
    } catch (e) {
      printLog('Error logging out from Customer Account API: $e');
      return false;
    }
  }
}
