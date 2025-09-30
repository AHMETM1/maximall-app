import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart' hide Category;
import 'package:flux_interface/flux_interface.dart';
import 'package:flux_ui/flux_ui.dart';
import 'package:http/http.dart' as http;
import 'package:http_auth/http_auth.dart';

import '../common/config.dart';
import '../common/constants.dart';
import '../data/boxes.dart';
import '../models/comment.dart';
import '../models/entities/branch.dart';
import '../models/entities/brand.dart';
import '../models/entities/order_delivery_date.dart';
import '../models/entities/paging_response.dart';
import '../models/entities/prediction.dart';
import '../models/entities/product_component.dart';
import '../models/entities/social_login_type.dart';
import '../models/entities/stripe_payment_intent.dart';
import '../models/index.dart';
import '../modules/dynamic_layout/config/app_config.dart';
import 'google_maps/google_maps_service.dart';
import 'google_maps/models/google_maps_models.dart';
import 'outside/index.dart';
import 'review_service.dart';
import 'service_config.dart';
import 'wordpress/wordpress_blog_service.dart';

export '../models/entities/paging_response.dart';

abstract class BaseServices {
  final BlogService _blogService;
  final ReviewService reviewService;
  final OutsideService outsideService;

  final String domain;

  BaseServices({
    required this.domain,
    String? blogDomain,
    BlogService? blogService,
    ReviewService? reviewService,
  })  : reviewService = reviewService ?? ReviewService.create(),
        outsideService = OutsideService.init(),
        _blogService = blogService ??
            (blogDomain != null
                ? WordpressBlogService(
                    domain: blogDomain,
                    useCrossBlog: blogDomain != domain,
                  )
                : const BlogService.base());

  String get currencyCode => SettingsBox().currencyCode ?? 'USD';

  String get languageCode => SettingsBox().languageCode ?? 'en';

  bool get useCrossBlog => _blogService.useCrossBlog;

  bool get useWordpressBlog => _blogService is WordpressBlogService;

  // get sort key to filter products
  String? getOrderByKey(orderBy) => null;

  dynamic getOrderDirection(order) => null;

  Future<List<Category>?>? getCategories() async => const <Category>[];

  Future<List<Product>>? getProducts({userId}) => null;

  Future<List<Product>?> fetchProductsLayout(
          {required config, userId, bool refreshCache = false}) async =>
      const <Product>[];

  Future<List<Product>?> fetchProductsByCategory({
    String? categoryId,
    String? tagId,
    required page,
    minPrice,
    maxPrice,
    orderBy,
    order,
    featured,
    onSale,
    listingLocation,
    userId,
    String? search,
    String? include,
    bool? productType,
    String? nextCursor,
    bool? boostEngine,
    List<String>? brandIds,
    Map? attributes,
    String? stockStatus,
    List<String>? exclude,
  }) async =>
      const <Product>[];

  Future<AppConfig?> getAppConfig({String lang = 'en'}) async => null;

  Future<User?>? loginFacebook({String? token}) => null;

  Future<User>? loginSMS({String? token}) => null;

  Future<bool> isUserExisted({String? phone, String? username}) async => true;

  Future<User?>? loginApple(
          {String? token, String? firstName, String? lastName}) =>
      null;

  Future<User?>? loginGoogle({String? token}) => null;

  Future<User?>? loginSocial(
    SocialLoginType type, {
    String? token,
    String? email,
    String? displayName,
    String? firstName,
    String? lastName,
    String? picture,
  }) =>
      null;

  Future<PagingResponse<Review>> getReviews(String productId,
          {int page = 1, int perPage = 10}) async =>
      const PagingResponse();

  Future<List<ProductVariation>?>? getProductVariations(Product product) =>
      null;

  Future<List<ShippingMethod>>? getShippingMethods({
    required CartModel cartModel,
    String? token,
    String? checkoutId,
    Store? store,
  }) =>
      null;

  Future<List<PaymentMethod>>? getPaymentMethods({
    CartModel? cartModel,
    ShippingMethod? shippingMethod,
    String? token,
  }) =>
      null;

  Future<Order>? createOrder({
    CartModel? cartModel,
    UserModel? user,
    bool? paid,
    AdditionalPaymentInfo? additionalPaymentInfo,
  }) =>
      null;

  Future<PagingResponse<Order>> getMyOrders({
    User? user,
    dynamic cursor,
    String? cartId,
    String? orderStatus,
  }) async =>
      const PagingResponse();

  Future? updateOrder(
    orderId, {
    status,
    required token,
    PaymentMethod? paymentMethod,
  }) =>
      null;

  Future? deleteOrder(orderId, {required token}) => null;

  Future<Order?>? cancelOrder({
    required Order? order,
    required String? userCookie,
  }) =>
      null;

  Future<User?>? getUserInfo(cookie) => null;

  Future<User?>? createUser({
    String? firstName,
    String? lastName,
    String? username,
    String? email,
    String? password,
    String? phoneNumber,
    bool isVendor = false,
    bool isDelivery = false,
    bool isOwner = false,
  }) =>
      null;

  Future<Map<String, dynamic>?>? updateUserInfo(
          Map<String, dynamic> json, String? token) =>
      null;

  Future<User?>? login({
    username,
    password,
  }) =>
      null;

  Future<Product?> getProduct(id) async => null;

  /// The `overrideGetProduct` function use same as [getProduct] function on all
  /// platforms. But this must be used because in case listing app loads of
  /// WooCommerce products. This function is overridden in the file
  /// `listing_service.dart`
  Future<Product?>? overrideGetProduct(id) => getProduct(id);

  Future<ProductVariation?> getVariationProduct(
    String productId,
    String? variationId,
  ) async =>
      null;

  Future<Coupons>? getCoupons({int page = 1, String search = ''}) => null;

  Future<List<OrderNote>>? getOrderNote({
    String? userId,
    String? orderId,
  }) =>
      null;

  Future? createReview(ReviewPayload payload) => null;

  Future<Map<String, dynamic>?>? getHomeCache(String? lang) => null;

  /// {@template fluxstore.blog_service.warning_override}
  /// ### Do not override this function.
  ///
  /// If you need to override blog-related functions, you need to create a separate blog service for the framework and override the features in it.
  /// {@endtemplate}
  @nonVirtual
  Future<List<Blog>?> fetchBlogLayout({required Map config}) =>
      _blogService.fetchBlogLayout(config: config);

  /// {@macro fluxstore.blog_service.warning_override}
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
  }) =>
      _blogService.boostBlogs(
        category: category,
        tag: tag,
        limit: limit,
        offset: offset,
        search: search,
        order: order,
        orderBy: orderBy,
        include: include,
        author: author,
      );

  /// {@macro fluxstore.blog_service.warning_override}
  @nonVirtual
  Future<List<Blog>> boostBlogLayout({required Map config}) =>
      _blogService.boostBlogLayout(config: config);

  /// {@macro fluxstore.blog_service.warning_override}
  @nonVirtual
  Future<Blog?> getPageById(int? pageId) async =>
      _blogService.getPageById(pageId);

  Future? getCategoryWithCache() => null;

  Future<List<FilterAttribute>>? getFilterAttributes({
    String? categoryIds,
    String? tagIds,
    String? brandIds,
  }) =>
      null;

  Future<List<SubAttribute>>? getSubAttributes({
    required int id,
    int page = 1,
    int perPage = 10,
  }) =>
      null;

  Future<List<Tag>>? getFilterTags() => null;

  Future<String>? getCheckoutUrl(Map<String, dynamic> params, String? lang) =>
      null;

  Future<String?>? submitForgotPassword({
    String? forgotPwLink,
    Map<String, dynamic>? data,
  }) =>
      null;

  Future? logout(String? token) => null;

  @Deprecated('Shopify will deprecate its Checkout APIs in April 2025 '
      'and will instead use CartAPI.'
      '\n\nRelate to: https://shopify.dev/changelog/deprecation-of-checkout-apis')
  Future? checkoutWithCreditCard(String? vaultId, CartModel cartModel,
      Address address, PaymentSettingsModel paymentSettingsModel) {
    return null;
  }

  Future<PaymentSettings>? getPaymentSettings() {
    return null;
  }

  Future<Map<String, dynamic>?>? getCurrencyRate() => null;

  Future<List<dynamic>?>? getCartInfo(String? token) => null;

  Future? syncCartToWebsite(CartModel cartModel, User? user) => null;

  Future<Map<String, dynamic>>? getCustomerInfo(String? id) => null;

  Future<CartTax?>? getTaxes(CartModel cartModel, String? token) => null;

  Future<Tag?> getTagById({required String tagId}) async => null;

  Future<PagingResponse<Tag>> getTagsByPage({
    int? page,
    required int limit,
    String? categoryIds,
    String? brandIds,
  }) async =>
      const PagingResponse();

  Future<Tag?> getTagBySlug(String slug) async => null;

  Future? getCountries() => null;

  Future? getStatesByCountryId(countryId) => null;

  Future? getCitiesByStateId(countryId, stateId) => null;

  Future? getZipCodeByAddress(countryId, stateId, city) => null;

  Future<Point?>? getMyPoint(String? token) => null;

  Future? updatePoints(String? token, Order? order) => null;

  //For vendor
  Future<Store?>? getStoreInfo(storeId) => null;

  Future<bool>? pushNotification(
    cookie, {
    receiverEmail,
    senderName,
    message,
  }) =>
      null;

  Future<List<Review>>? getReviewsStore({storeId, page, perPage}) => null;

  Future<List<Product>>? getProductsByStore({
    storeId,
    int? page,
    int? perPage,
    int? catId,
    bool? onSale,
    String? order,
    String? orderBy,
    String? searchTerm,
  }) =>
      null;

  Future<List<Store>>? searchStores({
    String? keyword,
    int? page,
  }) =>
      null;

  Future<List<Store>>? getFeaturedStores({
    int? page,
    int? perPage,
  }) =>
      null;

  Future<PagingResponse<Order>> getVendorOrders({
    required User user,
    dynamic cursor,
  }) async =>
      const PagingResponse();

  Future<Product>? createProduct(String? cookie, Map<String, dynamic> data) =>
      null;

  Future<void>? deleteProduct(
          {required String? cookie, required String? productId}) =>
      null;

  Future<List<Product>>? getOwnProducts(
    String? cookie, {
    int? page,
    int? perPage,
  }) =>
      null;

  Future<dynamic>? uploadImage(dynamic data, String? token) => null;

  Future<List<Prediction>> getAutoCompletePlaces(
      String term, String? sessionToken) async {
    return GoogleMapsService().getAutoCompletePlaces(term, sessionToken);
  }

  Future<Prediction> getPlaceDetail(
      Prediction prediction, String? sessionToken) async {
    return GoogleMapsService().getPlaceDetail(prediction, sessionToken);
  }

  /// Get address from coordinates using reverse geocoding
  Future<String> getAddressFromLocation(double? lat, double? long) async {
    return GoogleMapsService().getAddressFromLocation(lat, long);
  }

  /// Get coordinates from country code
  Future<LocationResult?> getLocationFromCountryCode(String countryCode) async {
    return GoogleMapsService().getLocationFromCountryCode(countryCode);
  }

  Future<List<Store>>? getNearbyStores(
          {Prediction? prediction,
          int page = 1,
          int perPage = 10,
          int radius = 10,
          String? name}) =>
      null;

  Future<Product?> getProductByPermalink(String productPermalink) async {
    return null;
  }

  Future<Category?> getProductCategoryByPermalink(
      String productCategoryPermalink) async {
    return null;
  }

  Future<Store?> getStoreByPermalink(String storePermaLink) async {
    return null;
  }

  /// {@macro fluxstore.blog_service.warning_override}
  @nonVirtual
  Future<Blog?> getBlogByPermalink(String blogPermaLink) =>
      _blogService.getBlogByPermalink(blogPermaLink);

  Future<List<Brand>?> getBrands({
    int page = 1,
    int perPage = 10,
    List<String>? categoryIds,
  }) async =>
      null;

  Future<List<Product>?> fetchProductsByBrand(
          {dynamic page, String? brandId}) async =>
      null;

  ///----FLUXSTORE LISTING----///
  Future<({BookStatus status, String? messageError})>? bookService(
          {userId, value, message}) =>
      null;

  Future<List<Product>>? getProductNearest(location) => null;

  Future<List<ListingBooking>>? getBooking({userId, page, perPage}) => null;

  Future<Map<String, dynamic>?>? checkBookingAvailability({data}) => null;

  Future<List<dynamic>>? getLocations() => null;

  /// BOOKING FEATURE
  Future<bool>? createBooking(dynamic bookingInfo) => null;

  Future<List<dynamic>>? getListStaff(String? idProduct) => null;

  Future<List<String>>? getSlotBooking(
          String? idProduct, String idStaff, String date) =>
      null;

  /// {@macro fluxstore.blog_service.warning_override}
  @nonVirtual
  Future<PagingResponse<Blog>>? getBlogs(dynamic cursor) =>
      _blogService.getBlogs(cursor);

  /// RAZORPAY PAYMENT
  Future<String?> createRazorpayOrder(params) async {
    try {
      var client = BasicAuthClient(
          kRazorpayConfig['keyId'], kRazorpayConfig['keySecret']);
      final response = await client
          .post('https://api.razorpay.com/v1/orders'.toUri()!, body: params);
      final responseJson = jsonDecode(response.body);
      if (responseJson != null && responseJson['id'] != null) {
        return responseJson['id'];
      } else if (responseJson['message'] != null) {
        throw responseJson['message'];
      } else if (responseJson['error'] != null &&
          responseJson['error']['description'] != null) {
        throw responseJson['error']['description'];
      } else {
        throw "Can't create order for Razorpay";
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateOrderIdForRazorpay(paymentId, orderId) async {
    try {
      final token = base64.encode(latin1.encode(
          '${kRazorpayConfig['keyId']}:${kRazorpayConfig['keySecret']}'));

      var body = {};
      if (ServerConfig().isWooType) {
        body = {
          'notes': {'woocommerce_order_id': orderId}
        };
      }

      await http.patch(
          'https://api.razorpay.com/v1/payments/$paymentId'.toUri()!,
          headers: {
            'Authorization': 'Basic ${token.trim()}',
            'Content-Type': 'application/json'
          },
          body: json.encode(body));
    } catch (e) {
      return;
    }
  }

  /// {@macro fluxstore.blog_service.warning_override}
  @nonVirtual
  Future<List<Blog>> searchBlog({
    required String name,
    bool? boostEngine,
  }) =>
      _blogService.searchBlog(name: name, boostEngine: boostEngine);

  /// {@macro fluxstore.blog_service.warning_override}
  @nonVirtual
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
  }) =>
      _blogService.fetchBlogsByCategory(
        categoryId: categoryId,
        tagId: tagId,
        page: page,
        order: order,
        orderBy: orderBy,
        boostEngine: boostEngine,
        search: search,
        author: author,
        include: include,
      );

  /// {@macro fluxstore.blog_service.warning_override}
  @nonVirtual
  Future<List<Tag>> getBlogTags() => _blogService.getBlogTags();

  /// {@macro fluxstore.blog_service.warning_override}
  @nonVirtual
  Future<Blog?> getBlogById(dynamic id) => _blogService.getBlogById(id);

  Future<List<Category>> getCategoriesByPage({
    page,
    limit,
    storeId,
    String? searchTerm,
    int? parent,
    bool useCompute = true,
  }) async =>
      [];

  Future<PagingResponse<Category>> getSubCategories({
    dynamic page = 1,
    int limit = 25,
    required String? parentId,
  }) async =>
      const PagingResponse<Category>();

  Future<List<OrderDeliveryDate>> getListDeliveryDates({storeId}) async =>
      <OrderDeliveryDate>[];

  Future<Category?> getProductCategoryById(
          {required String categoryId}) async =>
      null;

  Future<VacationSettings?> getVacationSettings(String storeId) async => null;

  Future<bool?> setVacationSettings(
          String cookie, VacationSettings vacationSettings) async =>
      null;

  /// {@macro fluxstore.blog_service.warning_override}
  @nonVirtual
  Future<List<Comment>?> getCommentsByPostId({postId}) =>
      _blogService.getCommentsByPostId(postId: postId);

  /// {@macro fluxstore.blog_service.warning_override}
  @nonVirtual
  Future<bool> createComment({
    int? blogId,
    String? content,
    String? cookie,
  }) =>
      _blogService.createComment(
        blogId: blogId,
        content: content,
        cookie: cookie,
      );

  /// {@macro fluxstore.blog_service.warning_override}
  @nonVirtual
  Future<List<Blog>?> getBlogsByCategory(int? cateId) =>
      _blogService.getBlogsByCategory(cateId);

  /// {@macro fluxstore.blog_service.warning_override}
  @nonVirtual
  Future<List<Category>> getBlogCategories() =>
      _blogService.getBlogCategories();

  Future<dynamic>? getDataFromScanner(String data, {String? cookie}) => null;

  Future<String?> getBlogContent(dynamic id) async => null;

  Future<List<Order>> getVendorAdminOrders(
      {required String cookie,
      int page = 1,
      int perPage = 10,
      String? status,
      String? search,
      String? name}) async {
    var list = <Order>[];
    try {
      var base64Str = EncodeUtils.encodeCookie(cookie);
      var endpoint =
          '$domain/wp-json/vendor-admin/vendor-orders?page=$page&per_page=$perPage&token=$base64Str&platform=${ServerConfig().platform}';
      if (status != null) {
        if (status.toLowerCase() == 'onhold') {
          status = 'on-hold';
        }
        endpoint += '&status=$status';
      }
      if (search != null && search.trim().isNotEmpty) {
        endpoint += '&search=$search';
      }
      if (name != null && name.trim().isNotEmpty) {
        endpoint += '&name=$name';
      }
      printLog(endpoint);

      final response = await httpGet(
        endpoint.toUri()!,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'X-Requested-With': 'XMLHttpRequest',
        },
      );
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);

        for (var item in result['response']) {
          list.add(Order.fromJson(item));
        }
      }
    } catch (e) {
      printLog('vendor_admin.dart getVendorOrders: $e');
    }
    return list;
  }

  Future<String?> createPaymentIntentStripe(
      {required String totalPrice,
      String? currencyCode,
      String? emailAddress,
      String? name,
      required String paymentMethodId}) async {
    try {
      final urlReq = '${kStripeConfig["serverEndpoint"]}/payment-intent';
      final result = await http.post(
        urlReq.toUri()!,
        body: jsonEncode(
          {
            'payment_method_id': paymentMethodId,
            'email': emailAddress,
            'amount': totalPrice,
            'currencyCode': currencyCode,
            'returnUrl': kStripeConfig['returnUrl'],
            'captureMethod': (kStripeConfig['enableManualCapture'] ?? false)
                ? 'manual'
                : 'automatic',
          },
        ),
        headers: {'content-type': 'application/json'},
      );

      var response = json.decode(result.body);
      if (result.statusCode == 200) {
        final body = response is List ? response[0] : response;
        final success = body['success'];
        if (success) {
          return body['client_secret'];
        }
      } else if (response['message'] != null) {
        throw Exception(response['message']);
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  Future<StripePaymentIntent?> createPaymentIntentStripeV3({
    String? orderId,
    required String totalPrice,
    String? currencyCode,
    String? emailAddress,
    String? name,
    String? cookie,
  }) async {
    try {
      final version = kStripeConfig['stripeApiVersion'] ?? 3;
      final urlReq =
          '${kStripeConfig["serverEndpoint"]}/payment-intent-v$version';
      final result = await http.post(
        urlReq.toUri()!,
        body: jsonEncode(
          {
            'email': emailAddress,
            'amount': totalPrice,
            'cookieWoo': cookie,
            'currencyCode': currencyCode,
            'returnUrl': kStripeConfig['returnUrl'],
            'captureMethod': (kStripeConfig['enableManualCapture'] ?? false)
                ? 'manual'
                : 'automatic',
            'request3dSecure': 'any',
            'orderId': orderId,
          },
        ),
        headers: {'content-type': 'application/json'},
      );

      var response = json.decode(result.body);
      if (result.statusCode == 200) {
        final body = response is List ? response[0] : response;
        final success = body['success'];
        if (success == true) {
          return StripePaymentIntent(
            id: response['id'],
            clientSecret: response['client_secret'],
            status: response['status'],
            customerId: response['customer_id'],
            customerEphemeralKeySecret: response['ephemeral_key'],
            setupIntentClientSecret: response['setupIntent'],
          );
        }

        if (response['message'] != null) {
          throw Exception(response['message']);
        }
      }

      throw Exception('Unknown error. Please try again.');
    } catch (e, trace) {
      printError(e, trace);
      rethrow;
    }
  }

  Future<StripePaymentIntent?> getPaymentIntentStripeV3(String id) async {
    try {
      final urlReq = '${kStripeConfig["serverEndpoint"]}/payment-intent/$id';
      final result = await httpGet(urlReq.toUri()!);

      var response = json.decode(result.body);
      if (result.statusCode == 200) {
        if (response['message'] != null) {
          throw Exception(response['message']);
        }
        return StripePaymentIntent(
          id: response['id'],
          clientSecret: response['client_secret'],
          status: response['status'],
          customerId: response['customerId'],
          customerEphemeralKeySecret: response['ephemeralKey'],
          setupIntentClientSecret: response['setupIntent'],
        );
      }

      throw Exception('Unknown error. Please try again.');
    } catch (e, trace) {
      printError(e, trace);
      rethrow;
    }
  }

  Future<List<ProductItem>> getListProductItemByOrderId(String orderId) async {
    return const <ProductItem>[];
  }

  Future<List<String>> getImagesByProductId(String productId) async {
    return const <String>[];
  }

  Future<bool> checkProductPermission(String productId, String? cookie) async {
    return true;
  }

  Future<bool> deleteAccount(String token) async {
    /// If so fast, Apple will be suspect this action is ambiguous
    /// And has no effect on the account.
    /// So we need to wait for a while.
    /// This is a workaround.
    return Future.delayed(const Duration(seconds: 2), () => true);
  }

  Future<Brand?> getBrandById(brandId) async {
    return null;
  }

  Future<Brand?> getBrandBySlug(String slug) async {
    return null;
  }

  Future<PagingResponse<Product>> getProductsByCategoryId(
    String categoryId, {
    dynamic page = 1,
    int limit = 25,
    String? orderBy,
    String? order,
  }) async =>
      const PagingResponse<Product>();

  Future<int?> getProductCountOfCategory(String categoryId) async {
    return null;
  }

  Future<Order>? createIAPOrder(Map<String, dynamic> params, User? user) =>
      null;

  Future<RatingCount?>? getProductRatingCount(String productId) async {
    return null;
  }

  Future<CartDataShopify?> updateShippingRateWithCartId(
    String cartId, {
    required String deliveryGroupId,
    required String deliveryOptionHandle,
  }) async {
    return null;
  }

  Future<Order?> getLatestOrder({required String cookie}) async {
    return null;
  }

  Future<List<Product>> getVideoProducts({
    required int page,
    int perPage = 10,
  }) async {
    throw 'This feature supports only for FluxStore WooCommerce, FluxStore Shopify and FluxStore Multi Vendor now.';
  }

  @Deprecated('Shopify will deprecate its Checkout APIs in April 2025 '
      'and will instead use CartAPI.'
      '\n\nRelate to: https://shopify.dev/changelog/deprecation-of-checkout-apis')
  Future<void> updateCheckoutEmail({
    required String checkoutId,
    required String email,
  }) async {
    throw 'This feature supports only for FluxStore Shopify.';
  }

  Future<void> updateCartEmail({
    required String cartId,
    required String email,
  }) async {
    throw 'This feature supports only for FluxStore Shopify.';
  }

  Future<bool> enableNotification(
      {String? cookie, required bool enabled}) async {
    return enabled;
  }

  Future<List<Currency>?> getAvailableCurrencies() async {
    return <Currency>[];
  }

  Future<Order?> getOrderByOrderId({required String orderId}) async {
    return null;
  }

  Future<List<ListingType>> getListingTypes() async {
    return <ListingType>[];
  }

  Future<List<ProductComponent>?>? getProductComponents(String productId) =>
      null;

  List<Product>? productsFromJsonData(dynamic json) {
    return null;
  }

  Future<List<Branch>> getAllBranches() async {
    return <Branch>[];
  }

  /// Return min price and max price of all products
  Future<(double?, double?)> getMinMaxPrices() async {
    return (null, null);
  }

  /// Return size guide of product as HTML string
  Future<String?> getSizeGuide(String productId) async {
    return null;
  }

  Future<List<Product>?> fetchRelatedProduct(Product? product) {
    return fetchProductsByCategory(
      page: 1,
      categoryId: product?.categoryId,
      include: product?.relatedIds,
    );
  }

  Future<PagingResponse<PurchasedProduct>> getListPurchasedProduct({
    required String userCookie,
    int page = 1,
    int perPage = 10,
  }) async =>
      const PagingResponse();

  Future smartCodUpdateOrderSuccess(String orderId) async {}

  /// Prepares a cart for checkout completion
  /// Returns information about cart readiness for checkout
  /// Just for Shopify
  Future<CartDataShopify?> prepareCartForCompletion({
    required String cartId,
  }) async {
    return null;
  }

  /// Login with Customer Account API
  /// Just for Shopify
  Future<User?> loginWithCustomerAccount() async {
    return null;
  }

  /// Build static map URL
  Uri buildStaticMapUrl({
    required double lat,
    required double lng,
    String size = '800x600',
    String zoom = '13',
    String mapType = 'roadmap',
    String markerColor = 'red',
    String markerLabel = 'C',
    List<String>? styleParams,
  }) {
    return GoogleMapsService().buildStaticMapUrl(
      lat: lat,
      lng: lng,
      size: size,
      zoom: zoom,
      mapType: mapType,
      markerColor: markerColor,
      markerLabel: markerLabel,
      styleParams: styleParams,
    );
  }

  /// Search for places with autocomplete
  Future<List<PlaceSuggestion>> searchPlaces({
    required String query,
    String? sessionToken,
    double? latitude,
    double? longitude,
  }) async {
    return GoogleMapsService().searchPlaces(
      query: query,
      sessionToken: sessionToken,
      latitude: latitude,
      longitude: longitude,
    );
  }

  /// Get place details by place ID for place picker
  Future<PlaceDetail?> getPlaceDetailById(String placeId) async {
    return GoogleMapsService().getPlaceDetailById(placeId);
  }

  /// Search nearby places
  Future<List<NearbyPlaceResult>> getNearbyPlaces({
    required double latitude,
    required double longitude,
    int radius = 150,
  }) async {
    return GoogleMapsService().getNearbyPlaces(
      latitude: latitude,
      longitude: longitude,
      radius: radius,
    );
  }
}
