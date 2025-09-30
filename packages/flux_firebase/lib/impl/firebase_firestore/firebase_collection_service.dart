import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firestore_collection_constants.dart';

class FirestoreCollection {
  FirestoreCollection([FirebaseApp? firebaseApp])
      : _firebase =
            FirebaseFirestore.instanceFor(app: firebaseApp ?? Firebase.app());

  late final FirebaseFirestore _firebase;

  CollectionReference<Map<String, dynamic>> get categories =>
      _collection(FirestoreCollectionConstants.categories);

  CollectionReference<Map<String, dynamic>> get brands =>
      _collection(FirestoreCollectionConstants.brands);

  CollectionReference<Map<String, dynamic>> get productCategory =>
      _collection(FirestoreCollectionConstants.productCategory);

  CollectionReference<Map<String, dynamic>> get users =>
      _collection(FirestoreCollectionConstants.users);

  CollectionReference<Map<String, dynamic>> get products =>
      _collection(FirestoreCollectionConstants.products);

  CollectionReference<Map<String, dynamic>> get orders =>
      _collection(FirestoreCollectionConstants.orders);

  CollectionReference<Map<String, dynamic>> get settings =>
      _collection(FirestoreCollectionConstants.settings);

  CollectionReference<Map<String, dynamic>> get shippingMethods =>
      _collection(FirestoreCollectionConstants.shippingMethods);

  CollectionReference<Map<String, dynamic>> get paymentMethods =>
      _collection(FirestoreCollectionConstants.paymentMethods);

  CollectionReference<Map<String, dynamic>> get productAttributes =>
      _collection(FirestoreCollectionConstants.productAttributes);

  CollectionReference<Map<String, dynamic>> get coupons =>
      _collection(FirestoreCollectionConstants.coupons);

  CollectionReference<Map<String, dynamic>> get orderCoupon =>
      _collection(FirestoreCollectionConstants.orderCoupon);

  CollectionReference<Map<String, dynamic>> get loyaltyUsers =>
      _collection(FirestoreCollectionConstants.loyaltyUsers);

  CollectionReference<Map<String, dynamic>> get loyaltyTransactions =>
      _collection(FirestoreCollectionConstants.loyaltyTransactions);

  CollectionReference<Map<String, dynamic>> get loyaltyCoupons =>
      _collection(FirestoreCollectionConstants.loyaltyCoupons);

  CollectionReference<Map<String, dynamic>> get loyaltyRedemptions =>
      _collection(FirestoreCollectionConstants.loyaltyRedemptions);

  Future<T> runTransaction<T>(
    TransactionHandler<T> transactionHandler, {
    Duration timeout = const Duration(seconds: 30),
    int maxAttempts = 5,
  }) async {
    return _firebase.runTransaction(transactionHandler,
        timeout: timeout, maxAttempts: maxAttempts);
  }

  CollectionReference<Map<String, dynamic>> _collection(
          String collectionName) =>
      _firebase.collection(collectionName);
}
