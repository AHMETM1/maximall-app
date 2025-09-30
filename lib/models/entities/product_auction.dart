import 'package:intl/intl.dart';
import 'package:quiver/strings.dart';

class ProductAuction {
  const ProductAuction({
    this.currentBid,
    this.type,
    this.itemCondition,
    this.startPrice,
    this.bidIncrement,
    this.reservedPrice,
    this.dateFrom,
    this.dateTo,
    this.hasStarted = false,
    this.hasClosed = false,
    this.bidCount,
    this.bidValue,
    this.isSold = false,
    this.isWon = false,
    this.isSealed = false,
  });
  final double? currentBid;
  final String? type;
  final String? itemCondition;
  final double? startPrice;
  final double? bidIncrement;
  final double? reservedPrice;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final bool hasStarted;
  final bool hasClosed;
  final int? bidCount;
  final double? bidValue;
  final bool isSold;
  final bool isWon;
  final bool isSealed;

  factory ProductAuction.fromJson(Map json) => ProductAuction(
        currentBid: isNotBlank(json['_auction_current_bid'])
            ? double.tryParse(json['_auction_current_bid'])
            : null,
        type: json['_auction_type'],
        itemCondition: json['_auction_item_condition'],
        startPrice: isNotBlank(json['_auction_start_price'])
            ? double.tryParse(json['_auction_start_price'])
            : null,
        bidIncrement: isNotBlank(json['_auction_bid_increment'])
            ? double.tryParse(json['_auction_bid_increment'])
            : null,
        reservedPrice: isNotBlank(json['_auction_reserved_price'])
            ? double.tryParse(json['_auction_reserved_price'])
            : null,
        dateFrom: isNotBlank(json['_auction_dates_from'])
            ? DateFormat('yyyy-MM-dd hh:mm', 'en')
                .tryParse(json['_auction_dates_from'], false)
            : null, //time from api is not utc time, so utc is false
        dateTo: isNotBlank(json['_auction_dates_to'])
            ? DateFormat('yyyy-MM-dd hh:mm', 'en')
                .tryParse(json['_auction_dates_to'], false)
            : null,
        hasStarted: json['_auction_has_started'] == '1',
        hasClosed: json['_auction_closed'] == '1',
        bidCount: isNotBlank(json['_auction_bid_count'])
            ? int.tryParse(json['_auction_bid_count'])
            : null,
        bidValue: json['_auction_bid_value'] != null &&
                isNotBlank(json['_auction_bid_value'].toString())
            ? double.tryParse(json['_auction_bid_value'].toString())
            : null,
        isSold: json['_order_id'] != null && json['_auction_closed'] == '3',
        isWon: json['_auction_closed'] == '2',
        isSealed: json['_auction_sealed'] == 'yes',
      );

  factory ProductAuction.fromProductMetaData(List metaData) {
    var json = {};
    var keys = [
      '_auction_current_bid',
      '_auction_type',
      '_auction_item_condition',
      '_auction_start_price',
      '_auction_bid_increment',
      '_auction_reserved_price',
      '_auction_dates_from',
      '_auction_dates_to',
      '_auction_has_started',
      '_auction_bid_count',
      '_auction_bid_value',
      '_auction_closed',
      '_order_id',
      '_auction_sealed',
      '_auction_buy_now_disabled'
    ];
    for (var item in metaData) {
      if (keys.contains(item['key'])) {
        json[item['key']] = item['value'];
      }
    }
    if (json.keys.length >= 9) {
      return ProductAuction.fromJson(json);
    } else {
      throw ArgumentError('Unexpected type for product auction');
    }
  }
}

class ProductAuctionHistory {
  const ProductAuctionHistory({
    this.bid,
    this.date,
    this.displayName,
  });

  final double? bid;
  final DateTime? date;
  final String? displayName;

  factory ProductAuctionHistory.fromJson(Map json) => ProductAuctionHistory(
        bid: isNotBlank(json['bid']) ? double.tryParse(json['bid']) : null,
        displayName: json['displayname'],
        date: isNotBlank(json['date'])
            ? DateFormat('yyyy-MM-dd hh:mm:ss').tryParse(json['date'], true)
            : null,
      );
}
