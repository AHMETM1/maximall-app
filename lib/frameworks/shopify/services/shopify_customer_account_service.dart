import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:graphql/client.dart';
import 'package:http/http.dart' as http;

import '../../../common/config/models/index.dart';
import '../../../common/constants.dart';
import '../../../common/error_codes/error_codes.dart';
import '../../../data/boxes.dart';
import '../../../models/entities/paging_response.dart';
import '../../../models/entities/user.dart';
import '../../../models/order/order.dart';
import 'customer_account_graphql.dart';

class ShopifyCustomerAccountService {
  final String shopDomain;
  final ShopifyCustomerAccountConfig config;

  // final GraphQLClient _client;
  final HttpLink _httpLink;

  static const String apiVersion = '2025-04';
  static const Duration _timeOut = Duration(seconds: 20);

  ShopifyCustomerAccountService({
    required this.config,
    required this.shopDomain,
  }) : _httpLink = HttpLink(
            'https://shopify.com/${config.shopId}/account/customer/api/$apiVersion/graphql');

  AuthLink get _authLink => AuthLink(
        getToken: () async => await getAccessToken(),
      );

  GraphQLClient get _client => GraphQLClient(
        cache: GraphQLCache(),
        link: _authLink.concat(_httpLink),
      );

  String get clientId => config.clientId;

  String get authorizationEndpoint => config.authorizationEndpoint;

  String get redirectUri => config.redirectUri;

  String get tokenEndpoint => config.tokenEndpoint;

  String get logoutEndpoint => config.logoutEndpoint;

  String get shopId => config.shopId;

  // Generate a random string for the code verifier
  String _generateCodeVerifier() {
    const charset =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~';
    final random = Random.secure();
    return List.generate(128, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  // Generate code challenge from code verifier using S256 method
  String _generateCodeChallenge(String verifier) {
    final List<int> bytes = utf8.encode(verifier);
    final digest = sha256.convert(bytes);
    return base64Url.encode(digest.bytes).replaceAll('=', '');
  }

  // Save tokens to secure storage
  void _saveTokens({
    required String accessToken,
    required String refreshToken,
    String? idToken,
    required int expiresIn,
  }) async {
    UserBox().saveTokens(
      accessToken: accessToken,
      idToken: idToken,
      refreshToken: refreshToken,
      expiresIn: expiresIn,
    );
  }

  // Get stored access token
  Future<String?> getAccessToken() async {
    final token = UserBox().accessToken;
    printLog('Customer Account API access_token: $token');
    final expiryTime = UserBox().tokenExpiry;

    // Check if token exists and is not expired
    if (token != null && expiryTime != null) {
      final now = DateTime.now().millisecondsSinceEpoch;
      if (now < expiryTime) {
        return token;
      } else {
        // Token expired, try to refresh
        return await refreshToken();
      }
    }
    return null;
  }

  // Refresh the access token using the refresh token
  Future<String?> refreshToken() async {
    final refreshToken = UserBox().refreshToken;

    if (refreshToken == null) {
      return null;
    }

    try {
      final response = await http.post(
        Uri.parse(tokenEndpoint),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'grant_type': 'refresh_token',
          'client_id': clientId,
          'refresh_token': refreshToken,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final accessToken = data['access_token'];
        _saveTokens(
          accessToken: data['access_token'],
          refreshToken: data['refresh_token'],
          expiresIn: data['expires_in'],
        );
        printLog('Customer Account API Token after refresh: $accessToken');
        return accessToken;
      }
    } catch (e) {
      printLog('Error refreshing token: $e');
    }

    // If refresh fails, clear tokens and return null
    await clearTokens();
    return null;
  }

  // Clear all stored tokens
  Future<void> clearTokens() async {
    UserBox()
      ..accessToken = null
      ..refreshToken = null
      ..idToken = null
      ..tokenExpiry = null;
  }

  // Initiate the OAuth login flow
  Future<User?> login() async {
    try {
      // Generate and store code verifier
      final codeVerifier = _generateCodeVerifier();
      UserBox().codeVerifier = codeVerifier;

      // Generate code challenge
      final codeChallenge = _generateCodeChallenge(codeVerifier);

      // Generate state parameter to prevent CSRF
      final state = _generateCodeVerifier().substring(0, 16);

      // Build authorization URL
      final authUrl = Uri.parse(authorizationEndpoint).replace(
        queryParameters: {
          'client_id': clientId,
          'response_type': 'code',
          'redirect_uri': redirectUri,
          'scope': 'openid email customer-account-api:full',
          'state': state,
          'code_challenge': codeChallenge,
          'code_challenge_method': 'S256',
        },
      ).toString();

      // Launch the web auth flow
      final result = await FlutterWebAuth2.authenticate(
        url: authUrl,
        callbackUrlScheme: Uri.parse(redirectUri).scheme,
      );

      // Extract the authorization code from the callback URL
      final uri = Uri.parse(result);
      final code = uri.queryParameters['code'];
      final returnedState = uri.queryParameters['state'];

      // Verify state to prevent CSRF attacks
      if (returnedState != state) {
        throw Exception('Invalid state parameter');
      }

      if (code != null) {
        // Exchange code for tokens
        final tokenResponse = await http.post(
          Uri.parse(tokenEndpoint),
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
          body: {
            'grant_type': 'authorization_code',
            'client_id': clientId,
            'code': code,
            'redirect_uri': redirectUri,
            'code_verifier': codeVerifier,
          },
        );

        if (tokenResponse.statusCode == 200) {
          final data = json.decode(tokenResponse.body);

          // Save tokens
          _saveTokens(
            accessToken: data['access_token'],
            idToken: data['id_token'],
            refreshToken: data['refresh_token'],
            expiresIn: data['expires_in'],
          );

          // Get user info using the access token
          return await getUserInfo(data['access_token']);
        } else {
          printLog('Token exchange failed: ${tokenResponse.body}');
          throw Exception('Failed to exchange code for tokens');
        }
      }
    } catch (e) {
      printLog('Login error: $e');
      return null;
    }
    return null;
  }

  // Get user information using the access token
  Future<User?> getUserInfo(String? accessToken) async {
    if (accessToken == null) {
      return null;
    }
    try {
      final response = await _client.query(
        QueryOptions(
          document: gql(CustomerAccountAPI.getCustomerInfo),
          fetchPolicy: FetchPolicy.noCache,
          queryRequestTimeout: _timeOut,
        ),
      );

      if (response.hasException) {
        printLog(response.exception.toString());
        throw Exception(response.exception.toString());
      }

      final data = response.data;
      final customerData = data?['customer'];

      // Create User object from customer data
      return User.fromShopifyCustomerAccount(customerData, accessToken);
    } catch (e) {
      printLog('Error getting user info: $e');
    }
    return null;
  }

  Future<PagingResponse<Order>> getMyOrders({
    dynamic cursor,
    int limit = 10,
  }) async {
    try {
      const nRepositories = 50;
      final options = QueryOptions(
        document: gql(CustomerAccountAPI.getOrders),
        fetchPolicy: FetchPolicy.noCache,
        queryRequestTimeout: _timeOut,
        variables: <String, dynamic>{
          'nRepositories': nRepositories,
          if (cursor != null) 'cursor': cursor,
          'pageSize': limit,
        },
      );
      final result = await _client.query(options);

      if (result.hasException) {
        printLog(result.exception.toString());
      }

      var list = <Order>[];
      String? lastCursor;

      for (var item in result.data!['customer']['orders']['edges']) {
        lastCursor = item['cursor'];
        var order = item['node'];
        list.add(Order.fromCustomerAccountShopify(order));
      }
      return PagingResponse(
        cursor: lastCursor,
        data: list,
      );
    } catch (e) {
      printLog('::::Customer Account API getMyOrders shopify error');
      printLog(e.toString());
      return const PagingResponse();
    }
  }

  Future<Order?> getLatestOrder() async {
    final orders = await getMyOrders(limit: 1);
    return orders.data?.firstOrNull;
  }

  /// Just allow update firstName and lastName
  Future<Map<String, dynamic>> updateUserInfo(
      Map<String, dynamic> json, String? token) async {
    try {
      printLog('::::Customer Account API update customer info');

      const nRepositories = 50;
      // Shopify does not accept an empty string value when update
      final firstName = json['firstName']?.toString() ?? '';
      final lastName = json['lastName']?.toString() ?? '';
      final options = QueryOptions(
          document: gql(CustomerAccountAPI.customerUpdate),
          fetchPolicy: FetchPolicy.networkOnly,
          variables: <String, dynamic>{
            'nRepositories': nRepositories,
            'input': {
              'firstName': firstName.isEmpty ? null : firstName,
              'lastName': lastName.isEmpty ? null : lastName,
            },
          });

      final result = await _client.query(options);

      if (result.hasException) {
        printLog(result.exception.toString());
        throw Exception(result.exception.toString());
      }
      final List? errors = result.data!['customerUpdate']['userErrors'];
      final error =
          errors?.firstWhereOrNull((element) => element['message'] != null);
      if (error != null) {
        throw Exception(error['message']);
      }

      // When update password, full user info will get null
      final userData = result.data?['customerUpdate']['customer'];

      final user =
          User.fromShopifyCustomerAccount(userData, await getAccessToken());
      return user.toJson();
    } catch (e, trace) {
      printLog('::::Customer Account API update customer info shopify error');
      printError(e, trace);
      throw ErrorType.updateUserFailed;
    }
  }

  // Logout the user
  Future<bool> logout() async {
    try {
      // Build the logout URL
      final logoutUrl = Uri.parse(logoutEndpoint).replace(
        queryParameters: {
          'id_token_hint': UserBox().idToken,
          // 'post_logout_redirect_uri': redirectUri,
        },
      );

      // Redirect to the Shopify logout endpoint
      final response = await http.get(logoutUrl);
      if (response.statusCode != 200) {
        throw Exception('Logout failed');
      }

      // Clear local tokens
      await clearTokens();
      return true;
    } catch (e) {
      printLog('Logout error: $e');
      return false;
    }
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null;
  }
}
