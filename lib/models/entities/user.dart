import '../../common/constants.dart';
import '../../common/tools.dart';
import '../../services/index.dart';
import '../serializers/user.dart';
import 'user_address.dart';

class User {
  String? id;
  String? name;
  String? firstName;
  String? lastName;
  String? username;
  String? email;
  String? nicename;
  String? userUrl;
  String? picture;
  String? cookie;
  String? jwtToken;
  Shipping? shipping;
  Billing? billing;
  bool isVender = false;
  bool isDeliveryBoy = false;
  bool? isSocial = false;
  bool? isDriverAvailable;
  bool? isLoyaltyManager;

  /// Token expiration date for Shopify
  DateTime? expiresAt;

  /// Allow or deny vendor to update order status.
  ///
  /// WCFM: WCFM -> Capability -> Orders -> Status Update
  ///
  /// Dokan: Dokan -> Settings -> Selling options -> Vendor Capabilities -> Order Status Change
  ///
  /// Note: ***Required Mstore API plugin version 4.16.9 or higher.***
  bool? isOrderStatusChangeable;

  /// Google Auth
  String? phoneNumber;
  String? ggTokenId;

  User();

  User.init({
    this.id,
    this.name,
    this.firstName,
    this.lastName,
    this.username,
    this.email,
    this.nicename,
    this.userUrl,
    this.picture,
    this.cookie,
    this.jwtToken,
    this.shipping,
    this.billing,
    this.isSocial,
    this.isDriverAvailable,
    this.isOrderStatusChangeable,
    this.phoneNumber,
    this.ggTokenId,
    this.isLoyaltyManager,
  });

  String get fullName =>
      name ?? [firstName ?? '', lastName ?? ''].join(' ').trim();

  String get identifierInformation =>
      (email?.isEmpty ?? true) ? username ?? '' : email ?? '';

  ///FluxListing
  String? role;

  User.fromGoogleAuth({this.phoneNumber, this.ggTokenId});

  User.fromWooJson(Map json, String? cookieVal, {bool? isSocial}) {
    try {
      cookie = cookieVal;
      this.isSocial = isSocial;
      id = json['id'].toString();
      name = json['displayname'];
      username = json['username'];
      phoneNumber =
          (json['shipping']?['phone'] ?? json['billing']?['phone']) ?? '';
      firstName = json['firstname'];
      lastName = json['lastname'];
      email = json['email'];
      picture = json['avatar'];
      nicename = json['nicename'];
      userUrl = json['url'];
      var roles = [];
      if (json['role'] is Map) {
        roles = json['role'].values.toList();
      } else {
        roles = json['role'] as List;
      }

      isVender = false;
      isLoyaltyManager = false;
      if (roles.isNotEmpty) {
        role = roles.first;
        if (roles.contains('seller') ||
            roles.contains('wcfm_vendor') ||
            roles.contains('administrator') ||
            roles.contains('shop_manager')) {
          isVender = true;
        }
        if (roles.contains('wcfm_delivery_boy') || roles.contains('driver')) {
          isDeliveryBoy = true;
        }
        if (roles.contains('administrator')) {
          isLoyaltyManager = true;
        }
      } else {
        isVender = (json['capabilities']['wcfm_vendor'] as bool?) ?? false;
      }
      if ((ServerConfig().typeName == 'dokan' ||
              ServerConfig().platform == 'dokan' ||

              // Check Listeo merge Dokan
              ServerConfig().isVendorType()) &&
          json['dokan_enable_selling'] != null &&
          json['dokan_enable_selling'].trim().isNotEmpty) {
        isVender = json['dokan_enable_selling'] == 'yes';
      }

      if (json['shipping'] != null) {
        shipping = Shipping.fromJson(json['shipping']);
      }
      if (json['billing'] != null) {
        billing = Billing.fromJson(json['billing']);
      }
      if (json['is_driver_available'] != null) {
        isDriverAvailable = json['is_driver_available'] == 'on' ||
            json['is_driver_available'] == true;
      }
      if (json['order_status_change'] != null) {
        isOrderStatusChangeable = json['order_status_change'];
      }
    } catch (e) {
      printLog(e.toString());
    }
  }

  User.fromJson(Map json) {
    try {
      isSocial = json['isSocial'] ?? false;
      id = json['id'].toString();
      cookie = json['cookie'];
      username = json['username'];
      nicename = json['nicename'];
      firstName = json['firstName'];
      lastName = json['lastName'];
      phoneNumber = json['phoneNumber'];
      name = json['displayname'] ??
          json['displayName'] ??
          '${firstName ?? ''}${(lastName?.isEmpty ?? true) ? '' : ' $lastName'}';

      email = json['email'] ?? id;
      userUrl = json['avatar'];
      picture = json['avatar'];
    } catch (e) {
      printLog(e.toString());
    }
  }

  // from Magento Json
  User.fromMagentoJson(Map json, token) {
    final fName = json['firstname']?.toString();
    final lName = json['lastname']?.toString();

    try {
      id = json['id'].toString();
      name = '${fName ?? ''} ${lName ?? ''}'.trim();
      username = '';
      cookie = token;
      firstName = fName;
      lastName = lName;
      email = json['email'];
      picture = '';
      final address = (json['addresses'] as List?)?.firstWhere(
          (item) => item['default_billing'] || item['default_shipping'],
          orElse: () => null);
      if (address != null) {
        billing = Billing.fromMagentoJson(address);
        shipping = Shipping.fromMagentoJson(address);
      }
    } catch (e) {
      printLog(e.toString());
    }
  }

  // from Opencart Json
  User.fromOpencartJson(Map json, token) {
    final fName = json['firstname']?.toString();
    final lName = json['lastname']?.toString();
    try {
      id = (json['customer_id'] != null ? int.parse(json['customer_id']) : 0)
          .toString();
      name = '${fName ?? ''} ${lName ?? ''}'.trim();
      username = '';
      cookie = token;
      firstName = fName;
      lastName = lName;
      email = json['email'];
      picture = '';
    } catch (e) {
      printLog(e.toString());
    }
  }

  // from Shopify json
  User.fromShopifyJson(Map json, token, {DateTime? tokenExpiresAt}) {
    try {
      printLog('fromShopifyJson user $json');

      id = json['id'].toString();
      username = '';
      cookie = token;
      firstName = json['firstName'];
      lastName = json['lastName'];
      name = json['displayName'] ?? json['displayname'] ?? _getDisplayName;
      email = json['email'];
      picture = '';
      phoneNumber = json['phone'];
      isSocial = json['isSocial'];
      expiresAt = tokenExpiresAt;
    } catch (e) {
      printLog(e.toString());
    }
  }

  /// Create a User from Shopify Customer Account API response
  factory User.fromShopifyCustomerAccount(
      Map<String, dynamic> json, String? token) {
    try {
      printLog('fromShopifyCustomerAccount user $json');

      return User.init(
        id: json['id'].toString(),
        name: json['displayName'] ??
            '${json['firstName'] ?? ''} ${json['lastName'] ?? ''}'.trim(),
        firstName: json['firstName'],
        lastName: json['lastName'],
        username: json['email'],
        email: json['emailAddress']['emailAddress'],
        phoneNumber: json['phoneNumber'],
        cookie: token,
        isSocial: true,
      );
    } catch (e) {
      printLog(e.toString());
      rethrow;
    }
  }

  User.fromPrestaJson(Map json) {
    final fName = json['firstname']?.toString();
    final lName = json['lastname']?.toString();
    try {
      printLog('fromPresta user $json');

      id = json['id'].toString();
      name = '${fName ?? ''} ${lName ?? ''}'.trim();
      username = json['email'];
      firstName = fName;
      lastName = lName;
      email = json['email'];
      cookie = json['token'];
      phoneNumber = json['phone'];
    } catch (e) {
      printLog(e.toString());
    }
  }

  User.fromHaravanJson(Map json) {
    final fName = json['first_name']?.toString();
    final lName = json['last_name']?.toString();
    try {
      printLog('fromHaravan user $json');

      id = json['id'].toString();
      name = '${fName ?? ''} ${lName ?? ''}'.trim();
      username = json['email'];
      firstName = fName;
      lastName = lName;
      email = json['email'];
      cookie = id;
      phoneNumber = json['phone'];
    } catch (e) {
      printLog(e.toString());
    }
  }

  User.fromHaravanLoyaltyJson(Map json) {
    try {
      printLog('fromHaravanLoyaltyJson user $json');

      id = json['source_id']?.toString();
      name = json['customer_fullname'];
      username = json['email'];
      firstName = json['customer_firstname'];
      lastName = json['customer_lastname'];
      email = json['customer_email'];
      phoneNumber = json['customer_phone'];
    } catch (e) {
      printLog(e.toString());
    }
  }

  User.fromStrapi(Map<String, dynamic> parsedJson) {
    printLog('User.fromStrapi $parsedJson');

    var model = SerializerUser.fromJson(parsedJson);
    id = model.user!.id.toString();
    jwtToken = model.jwt;
    email = model.user!.email;
    username = model.user!.username;
    nicename = model.user!.displayName;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'phoneNumber': phoneNumber,
      'email': email,
      'picture': picture,
      'cookie': cookie,
      'nicename': nicename,
      'url': userUrl,
      'isSocial': isSocial,
      'isVender': isVender,
      'isDeliveryBoy': isDeliveryBoy,
      'billing': billing?.toJson(),
      'jwtToken': jwtToken,
      'role': role,
      'isOrderStatusChangeable': isOrderStatusChangeable,
      'expiresAt': expiresAt?.toIso8601String(),
    };
  }

  User.fromLocalJson(Map json) {
    try {
      id = json['id'].toString();
      name = json['name'];
      cookie = json['cookie'];
      username = json['username'];
      phoneNumber = json['phoneNumber'];
      firstName = json['firstName'];
      lastName = json['lastName'];
      email = json['email'];
      picture = json['picture'];
      nicename = json['nicename'];
      userUrl = json['url'];
      isSocial = json['isSocial'];
      isVender = json['isVender'];
      isDeliveryBoy = json['isDeliveryBoy'];
      jwtToken = json['jwtToken'];
      if (json['billing'] != null) {
        billing = Billing.fromJson(json['billing']);
      }
      role = json['role'];
      isOrderStatusChangeable = json['isOrderStatusChangeable'];

      // Parse expiresAt if available
      if (json['expiresAt'] != null) {
        try {
          expiresAt = DateTime.parse(json['expiresAt']);
        } catch (e) {
          printLog('Error parsing expiresAt: ${e.toString()}');
        }
      }
    } catch (e) {
      printLog(e.toString());
    }
  }

  User.fromBigCommerce(Map json) {
    id = '${json['id']}';
    cookie = id;
    username = json['email'];
    email = username;

    final spaceNicename =
        json['first_name'] != null && json['last_name'] != null ? ' ' : '';
    nicename =
        '${json['first_name'] ?? ''}$spaceNicename${json['last_name'] ?? ''}';
    name = nicename;
    firstName = json['first_name'];
    lastName = json['last_name'];
    phoneNumber = json['phone'];
  }

  User.fromNotion(Map json) {
    id = json['id'];
    final properties = json['properties'];
    username = NotionDataTools.fromRichText(properties['Email'])?.first;
    email = username;
    nicename = NotionDataTools.fromTitle(properties['Name']);
    name = nicename;
    firstName = NotionDataTools.fromRichText(properties['Firstname'])?.first;
    lastName = NotionDataTools.fromRichText(properties['Lastname'])?.first;
    phoneNumber = NotionDataTools.fromRichText(properties['Mobile'])?.first;
  }

  User.fromWordpressUser(Map json, String? cookieVal) {
    try {
      cookie = cookieVal;
      id = json['id'].toString();
      name = json['displayname'];
      username = json['username'];
      firstName = json['firstname'];
      lastName = json['lastname'];
      email = json['email'];
      picture = json['avatar'];
      nicename = json['nicename'];
      userUrl = json['url'];
      var roles = [];
      if (json['role'] is Map) {
        roles = json['role'].values.toList();
      } else {
        roles = json['role'] as List;
      }

      if (roles.isNotEmpty) {
        role = roles.first;
      }
    } catch (e) {
      printLog(e.toString());
    }
  }

  User.fromFirebase(Map json) {
    try {
      id = json['id'].toString();
      username = json['Username'] ?? json['Email'];
      cookie = json['token'];
      firstName = json['FirstName'];
      lastName = json['LastName'];
      phoneNumber = json['PhoneNumber'];
      name = json['DisplayName'] ??
          '${firstName ?? ''}${(lastName?.isEmpty ?? true) ? '' : ' $lastName'}';
      email = json['Email'] ?? id;
      userUrl = json['ProfilePicture'];
      picture = json['ProfilePicture'];
    } catch (e) {
      printLog(e.toString());
    }
  }

  String get _getDisplayName =>
      '${firstName ?? ''}${(lastName?.isEmpty ?? true) ? '' : ' $lastName'}';

  Future<String?> getIdToken([bool forceRefresh = false]) => Future.value(null);

  @override
  String toString() => 'User { username: $id $name $email}';
}

class UserPoints {
  int? points;
  List<UserEvent> events = [];

  UserPoints.fromJson(Map json) {
    points = json['points_balance'];

    if (json['events'] != null) {
      for (var event in json['events']) {
        events.add(UserEvent.fromJson(event));
      }
    }
  }
}

class UserEvent {
  String? id;
  String? userId;
  String? orderId;
  String? date;
  String? description;
  String? points;

  UserEvent.fromJson(Map json) {
    id = json['id'];
    userId = json['user_id'];
    orderId = json['order_id'];
    date = json['date_display_human'];
    description = json['description'];
    points = json['points'];
  }
}
