import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flux_interface/flux_interface.dart';
import 'package:inspireui/utils/logs.dart';

import 'firebase_collection_service.dart';

class ServerlessFirestoreServiceImpl extends ServerlessFirestoreService {
  FirebaseApp? _app;
  ServerlessFirestoreServiceImpl({
    FirebaseApp? app,
  }) {
    setFirebaseApp(app ?? Firebase.app());
  }

  void setFirebaseApp(FirebaseApp app) {
    _app = app;
    _firestoreCollection = FirestoreCollection(_app);
  }

  FirestoreCollection _firestoreCollection = FirestoreCollection();

  @override
  Future<List<Map>> getCategories({
    int? parent,
    String? searchTerm,
    required String languageCode,
  }) async {
    var queryRef = _firestoreCollection.categories;
    Query query = queryRef;

    if (parent != null) {
      query = query.where('parentId', isEqualTo: parent.toString());
    }

    if (searchTerm?.isNotEmpty ?? false) {
      query = query
          .where('name', isGreaterThanOrEqualTo: searchTerm)
          .where('name', isLessThan: '${searchTerm}z');
    }
    query = query.where('IsVisible', isEqualTo: true);

    final snapshot = await query.get();

    final docs = snapshot.docs;

    return docs.map((doc) {
      final data = doc.data();
      final mapData = data is Map ? Map.from(data) : {};

      if (mapData['Counts'] is Map && mapData['Counts'][languageCode] != null) {
        mapData['Count'] = mapData['Counts'][languageCode];
      }

      return Map.from({
        'id': doc.id,
        ...mapData,
      });
    }).toList();
  }

  @override
  Future<List<Map>> getProducts({
    required String languageCode,
    String? categoryId,
    bool? featured,
    String? search,
  }) async {
    var queryRef = _firestoreCollection.products;
    Query query = queryRef;

    // Apply other filters
    if (featured != null) {
      query = query.where('IsFeatured', isEqualTo: featured);
    }

    if (languageCode.isNotEmpty) {
      query = query.where('Language', isEqualTo: languageCode);
    }

    query = query.where('IsVisible', isEqualTo: true);

    // Filter by category if specified
    if (categoryId != null && categoryId != '0') {
      /// Get all products that have the category in their CategoryIds
      // final childCategories = await _firestoreCollection.categories
      //     .where('ParentId', isEqualTo: categoryId)
      //     .get();
      // final childCategoryIds = childCategories.docs
      //     .map((doc) => doc.data()['id'] as String)
      //     .toList();
      // query = query.where('CategoryIds', arrayContainsAny: [
      //   ...childCategoryIds,
      //   categoryId,
      // ]);

      query = query.where('CategoryIds', arrayContainsAny: [
        categoryId,
      ]);

      printLog('[FetchProductsByCategory] categoryId: $categoryId');
    }

    var result;
    final snapshot = await query.get();

    if (search?.isNotEmpty ?? false) {
      final searchTerms = <String>[];
      // Original search term
      searchTerms.add(search!);
      // Lowercase variant
      searchTerms.add(search.toLowerCase());
      // Uppercase first letter variant (capitalized)
      if (search.length > 1) {
        searchTerms.add(
            '${search[0].toUpperCase()}${search.substring(1).toLowerCase()}');
      } else if (search.isNotEmpty) {
        searchTerms.add(search.toUpperCase());
      }
      // All uppercase variant
      searchTerms.add(search.toUpperCase());
      // Remove duplicates
      final uniqueSearchTerms = searchTerms.toSet().toList();

      final matchingDocs = snapshot.docs.where((doc) {
        final data = doc.data();
        final mapData = data as Map<String, dynamic>;
        final title = mapData['Title']?.toString().toLowerCase() ?? '';
        final description =
            mapData['Description']?.toString().toLowerCase() ?? '';

        for (final term in uniqueSearchTerms) {
          if (title.contains(term) || description.contains(term)) {
            return true;
          }
        }
        return false;
      }).toList();

      result = matchingDocs;
    } else {
      result = snapshot.docs;
    }

    final list = result
        .map((doc) {
          final data = doc.data();
          final mapData = data is Map ? Map.from(data) : null;
          if (mapData == null) {
            return null;
          }

          return Map.from({
            ...mapData,
            'id': doc.id,
          });
        })
        .whereType<Map>()
        .toList();

    return List<Map>.from(list);
  }

  @override
  Future<List<String>> getListIdsCategoryByProductId(String productId) async {
    final categoriesSnapshot = await _firestoreCollection.productCategory
        .where('productId', isEqualTo: productId)
        .get();

    if (categoriesSnapshot.docs.isEmpty) return [];

    return categoriesSnapshot.docs
        .map((catDoc) => catDoc.data()['categoryId'] as String)
        .toList();
  }

  @override
  Future<Map?> getCategoryById(String categoryId) async {
    final categoryDoc =
        await _firestoreCollection.categories.doc(categoryId).get();

    if (!categoryDoc.exists) {
      return null;
    }

    final data = categoryDoc.data();
    final mapData = data is Map ? Map.from(data!) : {};

    return {
      ...mapData,
      'id': categoryDoc.id,
    };
  }

  @override
  Future<Map?> getProduct(String id) async {
    final productDoc = await _firestoreCollection.products.doc(id).get();

    if (!productDoc.exists) {
      return null;
    }

    final data = productDoc.data();
    final mapData = data is Map ? Map.from(data!) : {};

    return {
      ...mapData,
      'id': productDoc.id,
    };
  }

  @override
  Future<List<Map>> getOrdersByUserId(
    String userId, {
    String? orderStatus,
  }) async {
    final query =
        _firestoreCollection.orders.where('userId', isEqualTo: userId);

    if (orderStatus != null) {
      query.where('status', isEqualTo: orderStatus);
    }

    query.where('type', isNotEqualTo: 'reservation');
    query.where('type', isNotEqualTo: 'booking-listing');

    final snapshot = await query.get();

    final orders = snapshot.docs
        .map((doc) {
          final data = doc.data();
          if (['booking-listing', 'reservation'].contains(data['type'])) {
            return null;
          }
          return Map.from(data);
        })
        .where((order) => order != null)
        .whereType<Map>()
        .toList();

    return orders;
  }

  @override
  Future<void> createUser({
    required String userId,
    required Map<String, dynamic> data,
  }) async {
    await _firestoreCollection.users.doc(userId).set({
      ...data,
      'CreatedAt': DateTime.now().toUtc(),
      'UpdatedAt': DateTime.now().toUtc(),
      'id': userId,
    });
  }

  @override
  Future<Map?> getUserById(String userId) async {
    final userDoc = await _firestoreCollection.users.doc(userId).get();

    if (!userDoc.exists) {
      return null;
    }

    final data = userDoc.data();
    final mapData = data is Map ? Map.from(data!) : {};

    return {
      ...mapData,
      'id': userId,
    };
  }

  @override
  Future<String?> createOrder(Map<String, dynamic> orderData) async {
    final now = DateTime.now();
    final updateDate = now.toUtc().toString();

    if (orderData.containsKey('orderDate')) {
      orderData.remove('orderDate');
    }

    orderData['orderDate'] = updateDate;

    if (orderData.containsKey('updateDate')) {
      orderData.remove('updateDate');
    }

    orderData['updateDate'] = updateDate;

    final orderRef = await _firestoreCollection.orders.add(orderData);
    if (orderRef.id.isEmpty) {
      return null;
    }

    await orderRef.set(orderData);
    return orderRef.id;
  }

  @override
  Future<Map?> getOrderById(String orderId) async {
    final orderDoc = await _firestoreCollection.orders.doc(orderId).get();

    if (!orderDoc.exists) {
      return null;
    }

    final data = orderDoc.data();
    final mapData = data is Map ? Map.from(data!) : {};

    return {
      ...mapData,
      'id': orderId,
    };
  }

  @override
  Future<Map?> updateOrder(
      String orderId, Map<String, dynamic> orderData) async {
    final querySnapshot =
        await _firestoreCollection.orders.where('id', isEqualTo: orderId).get();

    if (orderData.containsKey('updateDate')) {
      orderData.remove('updateDate');
    }
    orderData['updateDate'] = DateTime.now().toUtc();

    if (querySnapshot.docs.isNotEmpty) {
      await querySnapshot.docs.first.reference.update(orderData);
    } else {
      return null;
    }

    final orderDoc =
        await _firestoreCollection.orders.where('id', isEqualTo: orderId).get();

    if (orderDoc.docs.isEmpty) {
      return null;
    }

    final data = orderDoc.docs.first.data();
    final mapData = Map.from(data);

    return mapData;
  }

  @override
  Future<List<Map>> getPaymentMethod() async {
    final snapshot = await _firestoreCollection.paymentMethods.get();

    final paymentMethods = snapshot.docs.map((doc) => doc.data()).toList();

    return paymentMethods;
  }

  @override
  Future<void> deleteUser(String userId) async {
    await _firestoreCollection.users.doc(userId).update({
      'Deleted': true,
      'UpdatedAt': DateTime.now().toUtc(),
    });
  }

  @override
  Future<List<Map>> getBooking(String userId) async {
    final snapshot = await _firestoreCollection.orders
        .where('userId', isEqualTo: userId)
        .where('type', isEqualTo: 'reservation')
        .get();

    final bookings = snapshot.docs.map((doc) => doc.data()).toList();

    return bookings;
  }

  @override
  Future<List<Map>> getCoupons({String search = ''}) async {
    var queryRef = _firestoreCollection.coupons;
    Query query = queryRef;

    // Filter by active status if available
    query = query.where('status', isEqualTo: 'active');

    // Search by coupon code if available
    if (search.isNotEmpty) {
      query = query
          .where('code', isGreaterThanOrEqualTo: search)
          .where('code', isLessThan: '${search}z');
    }

    final snapshot = await query.get();
    final docs = snapshot.docs;
    return docs
        .map((doc) {
          final data = doc.data();

          if (data == null || data is! Map) {
            return null;
          }

          final dataMap = Map.from(data);
          dataMap['id'] = doc.id;

          return dataMap;
        })
        .whereType<Map>()
        .toList();
  }

  @override
  Future<Map?> updateUser({
    required String userId,
    required Map<String, dynamic> data,
  }) async {
    if (data.containsKey('UpdatedAt')) {
      data.remove('UpdatedAt');
    }

    data['UpdatedAt'] = DateTime.now().toUtc();

    await _firestoreCollection.users.doc(userId).update(data);
    final dataUser = await _firestoreCollection.users.doc(userId).get();

    if (dataUser.exists) {
      final data = dataUser.data();

      return data;
    }

    return null;
  }

  @override
  Future<List<Map>> getBrands({String? slug, String? id}) async {
    Query query = _firestoreCollection.brands;
    if (slug?.isNotEmpty ?? false) {
      query = query.where('Slug', isEqualTo: slug);
    }

    if (id?.isNotEmpty ?? false) {
      query = query.where('Id', isEqualTo: id);
    }

    final snapshot = await query.get();

    final brands = snapshot.docs
        .map((doc) {
          final data = doc.data();
          if (data == null || data is! Map) {
            return null;
          }
          final dataMap = Map.from(data);
          dataMap['id'] = doc.id;

          return dataMap;
        })
        .whereType<Map>()
        .toList();

    return brands;
  }

  @override
  Future<Map?> getBrand({String? slug, String? id}) async {
    Query query = _firestoreCollection.brands;

    if (slug?.isNotEmpty ?? false) {
      query = query.where('Slug', isEqualTo: slug);
    }
    final snapshot = await query.get();

    if (snapshot.docs.isEmpty) {
      return null;
    }

    final data = snapshot.docs.first.data();
    if (data == null || data is! Map) {
      return null;
    }
    final dataMap = Map.from(data);
    dataMap['id'] = snapshot.docs.first.id;

    return dataMap;
  }

  @override
  Future<bool> deleteOrder(String orderId) async {
    final snapshot =
        await _firestoreCollection.orders.where('id', isEqualTo: orderId).get();

    if (snapshot.docs.isEmpty) {
      return false;
    }

    await snapshot.docs.first.reference.delete();

    return true;
  }

  @override
  Future<List<Map>> getShippingMethods() async {
    final snapshot = await _firestoreCollection.shippingMethods.get();

    final shippingMethods = snapshot.docs.map((doc) => doc.data()).toList();

    return shippingMethods;
  }
}
