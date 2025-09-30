import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';

import '../../../common/config.dart';
import '../../../models/entities/index.dart';
import '../../../services/services.dart';

class PhonePeServices {
  PhonePeServices(
      {required this.amount,
      required this.orderId,
      this.user,
      required this.onSuccess,
      required this.onFail,
      required this.onCancel});

  final domain = Services().api.domain;
  final double amount;
  final String orderId;
  final User? user;
  final VoidCallback onSuccess;
  final Function(String) onFail;
  final Function() onCancel;

  String _generateTransactionId() {
    return '$orderId${DateFormat('yyyyMMddhhmmss').format(DateTime.now())}'; //shouldn't change dateformat, it must be matched with server format YmdHis
  }

  String _getBase64Body() {
    var body = {
      'merchantId': kPhonePeConfig['merchantId'],
      'merchantTransactionId': _generateTransactionId(),
      'merchantUserId': user?.id ?? 'guest',
      'amount': amount.toInt() * 100,
      'callbackUrl': '$domain/wp-json/api/flutter_phonepe/callback',
      'mobileNumber': user?.phoneNumber ?? '',
      'paymentInstrument': {'type': 'PAY_PAGE'}
    };
    var jsonString = jsonEncode(body);
    var base64String = base64Encode(utf8.encode(jsonString));
    return base64String;
  }

  String _getChecksum() {
    var base64Body = _getBase64Body();
    var apiEndPoint = '/pg/v1/pay';
    var saltKey = kPhonePeConfig['saltKey'];
    var saltIndex = kPhonePeConfig['saltKeyIndex'];

    var data = base64Body + apiEndPoint + saltKey;
    List<int> bytes = utf8.encode(data);
    return '${sha256.convert(bytes)}###$saltIndex';
  }

  void openPayment(BuildContext context) {
    PhonePePaymentSdk.init(
            kPhonePeConfig['production'] == true ? 'PRODUCTION' : 'SANDBOX',
            null,
            kPhonePeConfig['merchantId'],
            false)
        .then((val) {
      PhonePePaymentSdk.startTransaction(
              _getBase64Body(),
              kPhonePeConfig['iOSBundleId'],
              _getChecksum(),
              kPhonePeConfig['androidPackageName'])
          .then((response) {
        if (response != null) {
          var status = response['status'].toString();
          var error = response['error'].toString();
          if (status == 'SUCCESS') {
            onSuccess();
          } else {
            onFail(error.toString());
          }
        } else {
          // "Flow Incomplete";
        }
      }).catchError((error) {
        onFail(error.toString());
      });
    }).catchError((error) {
      onFail(error.toString());
    });
  }
}
