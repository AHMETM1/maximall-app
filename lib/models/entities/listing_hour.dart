import 'package:flux_ui/flux_ui.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../../common/config.dart';
import '../../common/constants.dart';
import '../../services/service_config.dart';

const _kNumOfWeekDay = 7;
const _kStartOfDate = '00:00';
const _kEndOfDate = '23:59';

class ListingHour {
  /// Only support for listeo
  bool isShowOpeningStatus = false;
  String? timezone;

  /// Only support for mylisting
  List<MyListingHourStatus?> status =
      List.generate(_kNumOfWeekDay, (index) => null);

  List<List<String>> closingHour = [];
  List<List<String>> openingHour = [];

  /// To display the opening time list
  Map<int, List<String>> openingHourList = {};

  /// To display the closing time list
  Map<int, List<String>> closingHourList = {};

  Map<String, dynamic> toJsonLocal() {
    return {
      'isShowOpeningStatus': isShowOpeningStatus,
      'timezone': timezone,
      'openingHour': openingHour,
      'closingHour': closingHour,
      'openingHourList': openingHourList,
      'closingHourList': closingHourList,
      'status': status.map((e) => e?.name).toList(),
    };
  }

  ListingHour.fromLocalJson(Map<String, dynamic> json) {
    isShowOpeningStatus = json['isShowOpeningStatus'] ?? false;
    timezone = json['timezone']?.toString();
    closingHourList = json['closingHourList'] is Map
        ? Map<int, List<String>>.from(json['closingHourList'])
        : {};
    openingHourList = json['openingHourList'] is Map
        ? Map<int, List<String>>.from(json['openingHourList'])
        : {};
    openingHour = json['openingHour'] is List
        ? List<List<String>>.from(json['openingHour'])
        : [];
    closingHour = json['closingHour'] is List
        ? List<List<String>>.from(json['closingHour'])
        : [];
    status = json['status'] is List
        ? List<MyListingHourStatus?>.from(json['status']
            .map((e) => MyListingHourStatus.convert(e.toString())))
        : [];
  }

  ListingHour.fromListeo(Map<String, dynamic> json) {
    isShowOpeningStatus = Tools.getValueByKey(
            json, DataMapping().kProductDataMapping['openingHourStatus']) ==
        'on';

    openingHour = [
      _convertToListHoursFromListeo(json, 'mondayOpeningHour'),
      _convertToListHoursFromListeo(json, 'tuesdayOpeningHour'),
      _convertToListHoursFromListeo(json, 'wednesdayOpeningHour'),
      _convertToListHoursFromListeo(json, 'thursdayOpeningHour'),
      _convertToListHoursFromListeo(json, 'fridayOpeningHour'),
      _convertToListHoursFromListeo(json, 'saturdayOpeningHour'),
      _convertToListHoursFromListeo(json, 'sundayOpeningHour'),
    ];

    closingHour = [
      _convertToListHoursFromListeo(json, 'mondayClosingHour'),
      _convertToListHoursFromListeo(json, 'tuesdayClosingHour'),
      _convertToListHoursFromListeo(json, 'wednesdayClosingHour'),
      _convertToListHoursFromListeo(json, 'thursdayClosingHour'),
      _convertToListHoursFromListeo(json, 'fridayClosingHour'),
      _convertToListHoursFromListeo(json, 'saturdayClosingHour'),
      _convertToListHoursFromListeo(json, 'sundayClosingHour'),
    ];

    timezone = Tools.getValueByKey(
        json, DataMapping().kProductDataMapping['timezone']);

    openingHourList.addAll(openingHour.asMap());
    closingHourList.addAll(closingHour.asMap());
  }

  ListingHour.fromJson(Map<String, dynamic> json) {
    isShowOpeningStatus = true; // Mặc định là hiển thị trạng thái
    timezone = json['timezone'];

    final weeklyHours = Map<String, dynamic>.from(json);
    weeklyHours.remove('timezone'); // Loại bỏ timezone khỏi map giờ

    // Ánh xạ tên ngày từ JSON sang index (0=Monday, 6=Sunday)
    final dayMap = {
      'monday': 0,
      'tuesday': 1,
      'wednesday': 2,
      'thursday': 3,
      'friday': 4,
      'saturday': 5,
      'sunday': 6,
    };

    // Khởi tạo list
    openingHour = List.generate(_kNumOfWeekDay, (_) => <String>[]);
    closingHour = List.generate(_kNumOfWeekDay, (_) => <String>[]);
    status = List.generate(_kNumOfWeekDay, (_) => null); // Reset status

    weeklyHours.forEach((dayKey, hoursData) {
      final dayIndex = dayMap[dayKey.toLowerCase()];
      if (dayIndex != null && hoursData is List) {
        final dayOpeningHours = <String>[];
        final dayClosingHours = <String>[];
        final displayOpeningHours = <String>[];
        final displayClosingHours = <String>[];

        if (hoursData.isEmpty) {
          status[dayIndex] = MyListingHourStatus.closedAllDay;
        } else {
          status[dayIndex] = MyListingHourStatus
              .enterHours; // Giả sử là enterHours nếu có data

          for (var slot in hoursData) {
            if (slot is Map &&
                slot['open'] is String &&
                slot['close'] is String) {
              final startStr = slot['open']!;
              final endStr = slot['close']!;

              displayOpeningHours.add(startStr);
              displayClosingHours.add(endStr);

              try {
                final startHour = DateFormat(DateFormat.HOUR24_MINUTE, 'en_US')
                    .parse(startStr);
                final endHour =
                    DateFormat(DateFormat.HOUR24_MINUTE, 'en_US').parse(endStr);

                dayOpeningHours.add(startStr);
                if (startHour.isAfter(endHour) ||
                    startHour.isAtSameMomentAs(endHour)) {
                  // Nếu giờ bắt đầu sau hoặc bằng giờ kết thúc -> qua ngày mới
                  dayClosingHours.add(_kEndOfDate); // Kết thúc ngày hiện tại
                  // Thêm slot cho ngày hôm sau (nếu có thể)
                  final nextDayIndex = (dayIndex + 1) % _kNumOfWeekDay;
                  // Cần đảm bảo list đã được khởi tạo đủ 7 ngày
                  if (openingHour.length > nextDayIndex) {
                    openingHour[nextDayIndex]
                        .insert(0, _kStartOfDate); // Bắt đầu ngày mới
                    closingHour[nextDayIndex].insert(0, endStr);
                  }
                } else {
                  dayClosingHours.add(endStr);
                }
              } catch (e) {
                printLog('Error parsing time slot in ListingHour.fromJson: $e');
                // Bỏ qua slot này nếu có lỗi parse
              }
            } else if (slot == 'open') {
              status[dayIndex] = MyListingHourStatus.openAllDay;
              dayOpeningHours.clear();
              dayClosingHours.clear();
              displayOpeningHours.clear();
              displayClosingHours.clear();
              break; // Không cần xử lý slot khác nếu đã mở cả ngày
            } else if (slot == 'closed') {
              status[dayIndex] = MyListingHourStatus.closedAllDay;
              dayOpeningHours.clear();
              dayClosingHours.clear();
              displayOpeningHours.clear();
              displayClosingHours.clear();
              break; // Không cần xử lý slot khác nếu đã đóng cả ngày
            }
          }
        }
        // Chỉ gán nếu không phải là open/closed all day
        if (status[dayIndex] == MyListingHourStatus.enterHours) {
          openingHour[dayIndex].addAll(dayOpeningHours);
          closingHour[dayIndex].addAll(dayClosingHours);
          openingHourList[dayIndex] = displayOpeningHours;
          closingHourList[dayIndex] = displayClosingHours;
        } else if (status[dayIndex] == MyListingHourStatus.openAllDay) {
          openingHour[dayIndex] = [_kStartOfDate];
          closingHour[dayIndex] = [_kEndOfDate];
          openingHourList[dayIndex] = ['Open 24 hours'];
          closingHourList[dayIndex] = [''];
        } else {
          // closedAllDay or null
          openingHour[dayIndex] = [];
          closingHour[dayIndex] = [];
          openingHourList[dayIndex] = ['Closed'];
          closingHourList[dayIndex] = [''];
        }
      }
    });
  }

  ListingHour.fromMyListing(Map<String, dynamic> json) {
    isShowOpeningStatus = true;
    _convertToListHoursFromMyListing(json['Monday']);
    _convertToListHoursFromMyListing(json['Tuesday']);
    _convertToListHoursFromMyListing(json['Wednesday']);
    _convertToListHoursFromMyListing(json['Thursday']);
    _convertToListHoursFromMyListing(json['Friday']);
    _convertToListHoursFromMyListing(json['Saturday']);
    _convertToListHoursFromMyListing(json['Sunday']);
    timezone = json['timezone'];
  }

  bool? isNowOpening() {
    final now = DateTime.now();
    final day = now.weekday - 1;
    var previousDate = day - 1;

    if (previousDate < 0) {
      previousDate = 6;
    }
    final isPreviousDayOpening = _isNowWithinTimeRange(
      previousDate,
      isPrevDay: true,
    );

    if (isPreviousDayOpening == true) {
      return true;
    }

    return _isNowWithinTimeRange(day);
  }

  void _convertToListHoursFromMyListing(Map<String, dynamic> json) {
    final start = <String>[];
    final end = <String>[];
    openingHour.add(<String>[]);
    closingHour.add(<String>[]);

    final index = openingHour.length - 1;
    status[index] = MyListingHourStatus.convert(json['status']);
    var startList = <String>[];
    var endList = <String>[];

    var i = 0;
    if (status[index] == MyListingHourStatus.enterHours) {
      while (true) {
        final data = json['$i'];

        if (data == null) break;
        final from = data['from'].toString();
        final to = data['to'].toString();
        startList.add(from);
        endList.add(to);

        final startHour =
            DateFormat(DateFormat.HOUR24_MINUTE, 'en_US').parse(from);
        final endHour = DateFormat(DateFormat.HOUR24_MINUTE, 'en_US').parse(to);
        start.add(from);
        if (startHour.hour > endHour.hour ||
            (startHour.hour == endHour.hour &&
                startHour.minute > endHour.minute)) {
          end.add(_kEndOfDate);

          openingHour[index].add(_kStartOfDate);
          closingHour[index].add(to);
        } else {
          end.add(to);
        }
        i++;
      }
      openingHourList.addAll({index: startList});
      closingHourList.addAll({index: endList});
    }

    openingHour[index].addAll(start);
    closingHour[index].addAll(end);
  }

  List<String> _convertToListHoursFromListeo(
      Map<String, dynamic> json, String key) {
    final list =
        Tools.getValueByKey(json, DataMapping().kProductDataMapping[key]);

    if (list == null || (list != null && list is List && list.isEmpty)) {
      return [];
    }

    var result = <String>[];
    for (var i = 0; i < list.length; i++) {
      result.add(list[i]);
    }

    return result;
  }

  bool? _isNowWithinTimeRange(int indexDay, {bool isPrevDay = false}) {
    MyListingHourStatus? hoursStatus;
    List<String>? startHours;
    List<String>? endHours;

    if (indexDay >= 0) {
      hoursStatus = indexDay >= status.length ? null : status[indexDay];
      startHours =
          indexDay >= openingHour.length ? null : openingHour[indexDay];
      endHours = indexDay >= closingHour.length ? null : closingHour[indexDay];
    }

    switch (hoursStatus) {
      case MyListingHourStatus.openAllDay:
        return true;
      case MyListingHourStatus.closedAllDay:
        return false;
      case MyListingHourStatus.byAppointmentOnly:
        return null;
      default:
        // If there is no opening hour, consider it as closed
        if (startHours == null || startHours.isEmpty) {
          return false;
        }

        // If there is opening hour but no closing hour, check current time
        if (endHours == null || endHours.isEmpty) {
          final start = startHours[0];
          if (!start.isNotNullAndNotEmpty) {
            return false;
          }
          final startDate = _convertTime(start, isPrevDay: isPrevDay);
          final now = DateTime.now();
          return startDate.compareTo(now) < 0;
        }

        // If both opening and closing hours exist, check time range
        for (var i = 0; i < startHours.length; i++) {
          final start = startHours[i];
          final end = endHours[i];

          if (!start.isNotNullAndNotEmpty || !end.isNotNullAndNotEmpty) {
            continue;
          }

          final startDate = _convertTime(start, isPrevDay: isPrevDay);
          final now = DateTime.now();
          var endDate = _convertTime(end, isPrevDay: isPrevDay);
          if (endDate.compareTo(startDate) < 0) {
            endDate = endDate.add(const Duration(days: 1));
          }
          if (startDate.compareTo(now) < 0 && endDate.compareTo(now) > 0) {
            return true;
          }
        }
        return false;
    }
  }

  Duration _parseTimeZoneOffset(String offsetString) {
    if (ServerConfig().isListeoType) {
      // Support for Listeo
      if (offsetString.startsWith('UTC+') || offsetString.startsWith('UTC-')) {
        // Convert decimal hours to hours and minutes
        final number = double.parse(offsetString.substring(4));
        final hours = number.truncate();
        final minutes = ((number - hours) * 60).round();

        if (offsetString.startsWith('UTC+')) {
          return Duration(hours: hours, minutes: minutes);
        }
        return Duration(hours: -hours, minutes: -minutes);
      }
    }

    return Duration.zero;
  }

  DateTime _convertTime(String? time, {bool isPrevDay = false}) {
    var now = DateTime.now();
    if (isPrevDay) {
      now = now.subtract(const Duration(days: 1));
    }
    DateTime? date;
    if (time != null) {
      date = DateFormat('HH:mm', 'en').parse(time);
    }
    if (timezone?.contains('UTC') ?? false) {
      now = now.toUtc().add(_parseTimeZoneOffset(timezone!));
    }

    /// Support for myListing
    tzdata.initializeTimeZones();
    if (timezone?.contains('/') ?? false) {
      var now = DateTime.now();
      final current = tz.TZDateTime.from(now, tz.getLocation(timezone!));

      now = tz.TZDateTime(
        tz.getLocation(timezone!),
        current.year,
        current.month,
        current.day,
      );
    }
    return now.copyWith(
      hour: date?.hour,
      minute: date?.minute,
    );
  }
}

enum MyListingHourStatus {
  enterHours('enter-hours'),
  openAllDay('open-all-day'),
  closedAllDay('closed-all-day'),
  byAppointmentOnly('by-appointment-only');

  static MyListingHourStatus? convert(String status) {
    switch (status) {
      case 'enter-hours':
        return MyListingHourStatus.enterHours;
      case 'open-all-day':
        return MyListingHourStatus.openAllDay;
      case 'closed-all-day':
        return MyListingHourStatus.closedAllDay;
      case 'by-appointment-only':
        return MyListingHourStatus.byAppointmentOnly;
      default:
        return null;
    }
  }

  final String name;
  const MyListingHourStatus(this.name);
}
