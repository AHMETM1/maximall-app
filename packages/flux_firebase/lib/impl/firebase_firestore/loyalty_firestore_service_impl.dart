import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flux_interface/flux_interface.dart';
import 'package:fstore/common/config.dart';
import 'package:fstore/models/entities/loyalty/member_type_enum.dart';
import 'package:fstore/models/entities/loyalty/transaction_type_enum.dart';
import 'package:fstore/models/index.dart';

import 'firebase_collection_service.dart';

class LoyaltyFirestoreServiceImpl extends LoyaltyFirestoreService {
  FirebaseApp? _app;
  LoyaltyFirestoreServiceImpl({
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
  Future<LoyaltyUser?> getLoyaltyUser(String userId) async {
    final userDoc = await _firestoreCollection.loyaltyUsers.doc(userId).get();

    return userDoc.exists ? LoyaltyUser.fromMap(userDoc.data()!) : null;
  }

  @override
  Future<void> addLoyaltyUser(LoyaltyUser loyaltyUser) async {
    await _firestoreCollection.loyaltyUsers
        .doc(loyaltyUser.userId)
        .set(loyaltyUser.toMap(), SetOptions(merge: true));
  }

  @override
  Future<void> addPoints({
    required String userId,
    required int points,
    required String? note,
  }) async {
    return _firestoreCollection.runTransaction((transaction) async {
      final userDoc = await _firestoreCollection.loyaltyUsers.doc(userId).get();
      if (userDoc.exists) {
        var data = LoyaltyUser.fromMap(userDoc.data()!);
        final newPoints = data.points + points;
        final newTotalPoints = data.totalPoints + points;
        final newType = kLoyaltyConfig.useTotalPointsForTier
            ? getMemberTypeByPoints(newTotalPoints)
            : getMemberTypeByPoints(newPoints);

        final updatedData = data.copyWith(
          points: newPoints,
          totalPoints: newTotalPoints,
          type: newType,
        );
        transaction.set(_firestoreCollection.loyaltyUsers.doc(userId),
            updatedData.toMap(), SetOptions(merge: true));

        var transactionMap = LoyaltyTransaction(
          docId: '',
          userId: userId,
          points: points,
          type: TransactionType.add,
          note: note,
        ).toMap();
        if (transactionMap['created_at'] != null &&
            DateTime.tryParse(transactionMap['created_at']) != null) {
          transactionMap['created_at'] =
              Timestamp.fromDate(DateTime.parse(transactionMap['created_at']));
        }
        transaction.set(
            _firestoreCollection.loyaltyTransactions.doc(), transactionMap);
      }
    });
  }

  @override
  Future<void> usePoints({
    required String userId,
    required int points,
    required String? note,
  }) async {
    return _firestoreCollection.runTransaction((transaction) async {
      final userDoc = await _firestoreCollection.loyaltyUsers.doc(userId).get();
      if (userDoc.exists) {
        var data = LoyaltyUser.fromMap(userDoc.data()!);
        final newPoints = data.points - points;

        final newType = kLoyaltyConfig.useTotalPointsForTier
            ? data.type
            : getMemberTypeByPoints(newPoints);

        final updatedData = data.copyWith(points: newPoints, type: newType);

        transaction.set(_firestoreCollection.loyaltyUsers.doc(userId),
            updatedData.toMap(), SetOptions(merge: true));

        var transactionMap = LoyaltyTransaction(
                docId: '',
                userId: userId,
                points: points,
                type: TransactionType.redeem,
                note: note)
            .toMap();
        if (transactionMap['created_at'] != null &&
            DateTime.tryParse(transactionMap['created_at']) != null) {
          transactionMap['created_at'] =
              Timestamp.fromDate(DateTime.parse(transactionMap['created_at']));
        }
        transaction.set(
            _firestoreCollection.loyaltyTransactions.doc(), transactionMap);
      }
    });
  }

  @override
  Future<List<LoyaltyTransaction>> getTransactionsByUserId(
      {required String userId, TransactionType? type, String? keyword}) async {
    var query = _firestoreCollection.loyaltyTransactions
        .where('user_id', isEqualTo: userId);

    if (type != null) {
      query = query.where('type', isEqualTo: type.rawValue);
    }
    if (keyword?.isNotEmpty ?? false) {
      query = query
          .orderBy('note') // orderBy for the search field
          .orderBy('created_at', descending: false) // then secondary orderBy
          .startAt([keyword]).endAt(['${keyword!}\uf8ff']);
    } else {
      query = query.orderBy('created_at', descending: false);
    }

    final snapshot = await query.get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return LoyaltyTransaction.fromMap(data, doc.id);
    }).toList();
  }

  @override
  Future<List<LoyaltyCoupon>> getCoupons(
      {required LoyaltyUser user, int? limit}) async {
    var query1 = _firestoreCollection.loyaltyCoupons
        .where('expired_at', isGreaterThan: Timestamp.fromDate(DateTime.now()))
        .where('tier_restrictions', arrayContains: user.type.rawValue);
    var query2 = _firestoreCollection.loyaltyCoupons
        .where('expired_at', isNull: true)
        .where('tier_restrictions', arrayContains: user.type.rawValue);

    final snapshot1 = await query1.get();
    final snapshot2 = await query2.get();

    return [...snapshot1.docs, ...snapshot2.docs].map((doc) {
      final data = doc.data();
      return LoyaltyCoupon.fromMap(data, doc.id);
    }).toList();
  }

  @override
  Future<List<LoyaltyCoupon>> getAllCoupons() async {
    var query = _firestoreCollection.loyaltyCoupons
        .orderBy('expired_at', descending: false);

    final snapshot = await query.get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return LoyaltyCoupon.fromMap(data, doc.id);
    }).toList();
  }

  @override
  Future<List<LoyaltyRedemption>> getRedemptions(LoyaltyUser user) async {
    var query1 = _firestoreCollection.loyaltyRedemptions
        .where('coupon.expired_at',
            isGreaterThan: Timestamp.fromDate(DateTime.now()))
        .where('user_id', isEqualTo: user.userId)
        .where('is_used', isEqualTo: false);
    var query2 = _firestoreCollection.loyaltyRedemptions
        .where('coupon.expired_at', isNull: true)
        .where('user_id', isEqualTo: user.userId)
        .where('is_used', isEqualTo: false);

    final snapshot1 = await query1.get();
    final snapshot2 = await query2.get();

    return [...snapshot1.docs, ...snapshot2.docs].map((doc) {
      final data = doc.data();
      return LoyaltyRedemption.fromMap(data, doc.id);
    }).toList();
  }

  @override
  Future<void> claimCoupon({
    required LoyaltyUser user,
    required LoyaltyCoupon coupon,
  }) async {
    return _firestoreCollection.runTransaction((transaction) async {
      final snapshot = await _firestoreCollection.loyaltyRedemptions
          .where('user_id', isEqualTo: user.userId)
          .where('coupon.coupon_id', isEqualTo: coupon.docId)
          .get();
      if (snapshot.docs.isEmpty) {
        final couponDoc =
            await _firestoreCollection.loyaltyCoupons.doc(coupon.docId).get();
        if (couponDoc.exists) {
          var data = LoyaltyCoupon.fromMap(couponDoc.data()!, coupon.docId);
          transaction
              .update(_firestoreCollection.loyaltyCoupons.doc(coupon.docId), {
            'claimed_users': [...data.claimedUsers, user.userId]
          });
        }
        var redemptionMap = LoyaltyRedemption(
          docId: '',
          userId: user.userId,
          coupon: coupon,
          redemptionCode: _generateRedemptionCode(),
        ).toMap();
        if (redemptionMap['coupon'] != null &&
            redemptionMap['coupon']['expired_at'] != null &&
            DateTime.tryParse(redemptionMap['coupon']['expired_at']) != null) {
          redemptionMap['coupon']['expired_at'] = Timestamp.fromDate(
              DateTime.parse(redemptionMap['coupon']['expired_at']));
        }
        transaction.set(
            _firestoreCollection.loyaltyRedemptions.doc(), redemptionMap);
      } else {
        throw 'This coupon has already been claimed.';
      }
    });
  }

  @override
  Future<void> onCheckoutSuccess({
    required String userId,
    required LoyaltyCoupon coupon,
  }) async {
    return _firestoreCollection.runTransaction((transaction) async {
      final snapshot = await _firestoreCollection.loyaltyRedemptions
          .where('user_id', isEqualTo: userId)
          .where('coupon.coupon_id', isEqualTo: coupon.docId)
          .get();
      if (snapshot.docs.isNotEmpty) {
        var docId = snapshot.docs.first.id;
        transaction.update(_firestoreCollection.loyaltyRedemptions.doc(docId),
            {'is_used': true});
      }
    });
  }

  @override
  Future<void> deleteCoupon(LoyaltyCoupon coupon) async {
    await _firestoreCollection.loyaltyCoupons.doc(coupon.docId).delete();
  }

  @override
  Future<LoyaltyCoupon?> createCoupon(LoyaltyCoupon coupon) async {
    var couponMap = coupon.toMap();
    if (couponMap['expired_at'] != null &&
        DateTime.tryParse(couponMap['expired_at']) != null) {
      couponMap['expired_at'] =
          Timestamp.fromDate(DateTime.parse(couponMap['expired_at']));
    }
    var ref = await _firestoreCollection.loyaltyCoupons.add(couponMap);
    final snapshot =
        await _firestoreCollection.loyaltyCoupons.doc(ref.id).get();
    if (snapshot.exists) {
      return LoyaltyCoupon.fromMap(snapshot.data()!, snapshot.id);
    }
    return null;
  }

  @override
  Future<LoyaltyCoupon?> updateCoupon(LoyaltyCoupon coupon) async {
    var couponMap = coupon.toMap();
    if (couponMap['expired_at'] != null &&
        DateTime.tryParse(couponMap['expired_at']) != null) {
      couponMap['expired_at'] =
          Timestamp.fromDate(DateTime.parse(couponMap['expired_at']));
    }
    await _firestoreCollection.loyaltyCoupons
        .doc(coupon.docId)
        .set(couponMap, SetOptions(merge: true));
    return coupon;
  }

  @override
  Future<void> checkIndexesException(dynamic error,
      {Future<void> Function(String?)? openIndexUrl}) async {
    if (error is FirebaseException &&
        error.code == 'failed-precondition' &&
        error.message != null &&
        error.message!.contains('requires an index')) {
      // Extract the index creation URL from the error message
      final urlRegExp =
          RegExp(r'https://console\.firebase\.google\.com/[^\s]+');
      final match = urlRegExp.firstMatch(error.message!);

      if (match != null) {
        final indexUrl = match.group(0);

        // For development, you could automatically open this URL
        if (kDebugMode) {
          print('⚠️ Missing _Firestore index detected!');
          print('👉 Create the index at: $indexUrl');
        }
        await openIndexUrl?.call(indexUrl);
        return;
      }

      // Rethrow with a more helpful message
      throw FirebaseException(
          plugin: 'cloud_firestore',
          code: 'missing-index',
          message: 'This query requires an index. See logs for details.');
    } else {
      throw error;
    }
  }

  String _generateRedemptionCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final random = Random();
    return String.fromCharCodes(Iterable.generate(
        6, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }
}
