import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:flux_localization/flux_localization.dart';
import 'package:inspireui/inspireui.dart';
import 'package:quiver/strings.dart';
import '../../../screens/users/registration/mixins/config_register_mixin.dart';
import '../../../services/services.dart';
import '../models/role.dart';

class MembershipServices with ConfigRegisterMixin {
  final domain = Services().api.domain;

  Future<List<WholesaleRole>> getRoles(BuildContext context) async {
    try {
      var list = <WholesaleRole>[];
      var response = await httpGet(
          Uri.parse('$domain/wp-json/api/flutter_wholesale/roles'));
      var jsonDecode = convert.jsonDecode(response.body);
      if (jsonDecode is Map && isNotBlank(jsonDecode['message'])) {
        throw Exception(jsonDecode['message']);
      } else {
        list.add(WholesaleRole(
          key: 'subscriber',
          name: S.of(context).customer,
          desc: S.of(context).thisIsCustomerRole,
        ));
        if (isVendorRegister) {
          list.add(WholesaleRole(
            key: 'vendor',
            name: S.of(context).vendor,
            desc: S.of(context).thisIsVendorRole,
          ));
        }
        if (isDeliveryRegister) {
          list.add(WholesaleRole(
            key: 'delivery',
            name: S.of(context).deliveryBoy,
            desc: S.of(context).thisIsDeliveryrRole,
          ));
        }
        for (var item in jsonDecode) {
          list.add(WholesaleRole.fromJson(item));
        }
        return list;
      }
    } catch (e) {
      //This error exception is about your Rest API is not config correctly so that not return the correct JSON format, please double check the document from this link https://support.inspireui.com/help-center/
      rethrow;
    }
  }

  Future<Map<String, dynamic>> signUp(
      {username,
      email,
      firstName,
      lastName,
      password,
      phoneNumber,
      selectedRole}) async {
    try {
      var response = await httpPost(
          Uri.parse('$domain/wp-json/api/flutter_wholesale/register'),
          body: convert.jsonEncode({
            'username': username,
            'email': email,
            'first_name': firstName,
            'last_name': lastName,
            'password': password,
            'phone': phoneNumber,
            'role': selectedRole,
          }),
          headers: {'Content-Type': 'application/json'});
      var jsonDecode = convert.jsonDecode(response.body);
      if (jsonDecode is Map && isNotBlank(jsonDecode['message'])) {
        throw Exception(jsonDecode['message']);
      } else {
        return jsonDecode;
      }
    } catch (e) {
      //This error exception is about your Rest API is not config correctly so that not return the correct JSON format, please double check the document from this link https://support.inspireui.com/help-center/
      rethrow;
    }
  }
}
