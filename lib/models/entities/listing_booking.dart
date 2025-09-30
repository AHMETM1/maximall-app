import 'dart:convert';

import '../../common/constants.dart';

class ListingBooking {
  String? title;
  String? featuredImage;
  String? status;
  String? price;
  String? createdDate;
  String? updatedAt;
  String? orderId;
  String? orderStatus;
  Map<String, String?> adults = {};
  List<Map<String, String>> services = [];
  ListingBooking(
      this.title,
      this.featuredImage,
      this.status,
      this.price,
      this.createdDate,
      this.updatedAt,
      this.adults,
      this.services,
      this.orderId,
      this.orderStatus);

  ListingBooking.fromJson(Map json) {
    title = json['title'];

    if (json['featured_image'] is String) {
      featuredImage = json['featured_image'];
    } else {
      featuredImage = kDefaultImage;
    }

    status = json['status'];
    price = json['price'];
    createdDate = json['created'];
    orderId = json['order_id'];
    orderStatus = json['order_status'] ?? '';
    var commentJson = jsonDecode(json['comment']);
    if (commentJson['adults'] != null) {
      adults['adults'] = commentJson['adults'];
    }
    if (commentJson['tickets'] != null) {
      adults['tickets'] = commentJson['tickets'];
    }
    if (commentJson['service'] is bool) {
      return;
    }
    for (var item in commentJson['service']) {
      services.add({
        'name': item['service']['name'],
        'price': item['service']['price'],
      });
    }
  }

  ListingBooking.fromServerlessJson(Map json) {
    orderId = json['id'];
    title = json['title'];
    featuredImage = json['featuredImage'];
    status = json['statusBooking'];
    price = json['price']?.toString() ?? json['totalAmount']?.toString();

    final rawCreateDate = json['createdAt'] ?? json['orderDate'];
    final rawUpdatedAt = json['updatedAt'] ?? json['updateDate'];

    createdDate = DateTimeUtils.tryParseDateTime(rawCreateDate)?.toString();
    updatedAt = DateTimeUtils.tryParseDateTime(rawUpdatedAt)?.toString();
    orderStatus = json['status'] ?? '';
    final bookingInfo = json['bookingInfo'];
    if (bookingInfo != null) {
      adults['adults'] = bookingInfo['adults']?.toString() ?? '';
      adults['tickets'] = (bookingInfo['tickets'] ?? 1)?.toString() ?? '';
      if (bookingInfo['services'] is List) {
        for (var item in bookingInfo['services']) {
          final quantityValue = int.parse(item['value']?.toString() ?? '1');
          final priceValue = double.parse(item['price']?.toString() ?? '0');
          services.add({
            'name': item['name']?.toString() ?? '',
            'price': priceValue.toString(),
            'id': item['id']?.toString() ?? '',
            'quantity': quantityValue.toString(),
            'total': (quantityValue * priceValue).toString(),
          });
        }
      }
    }
  }
}
