import '../../../../common/config.dart';
import '../../../../services/service_config.dart';

mixin ConfigRegisterMixin {
  bool get showPhoneNumberWhenRegister =>
      kLoginSetting.showPhoneNumberWhenRegister;
  bool get requirePhoneNumberWhenRegister =>
      kLoginSetting.requirePhoneNumberWhenRegister;
  bool get requireUsernameWhenRegister =>
      kLoginSetting.requireUsernameWhenRegister;
  bool get isVendorRegister =>
      kVendorConfig.vendorRegister && ServerConfig().isVendorType();
  bool get isDeliveryRegister =>
      kVendorConfig.deliveryRegister && ServerConfig().isDeliverySupported;
  bool get isOwnerRegister =>
      kVendorConfig.ownerRegister && ServerConfig().isListeoType;
}
