import 'package:flux_localization/flux_localization.dart';
import 'package:flux_ui/flux_ui.dart';

class FluxUiLocalizationImpl extends FluxUILocalization {
  FluxUiLocalizationImpl(super.context);

  @override
  String get apply => S.of(context).apply;

  @override
  String get dateWiseClose => S.of(context).dateWiseClose;

  @override
  String endsIn(String time) {
    return S.of(context).endsIn(time);
  }

  @override
  String get instantlyClose => S.of(context).instantlyClose;

  @override
  bool isRTL(String languageCode) {
    return LocalWidgetsLocalizations.isRtlLanguage(languageCode);
  }

  @override
  String get seeAll => S.of(context).seeAll;

  @override
  String get selectStore => S.of(context).selectStore;
}
