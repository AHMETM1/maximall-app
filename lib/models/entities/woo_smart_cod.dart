import '../../modules/dynamic_layout/helper/helper.dart';

class WooSmartCod {
  final List? disallowedPaymentGateways;
  final double? realTotal;
  final double? remainingAmount;
  final double? userAdvanceAmount;
  final double? extraFee;
  final bool? isRiskFreeEnabled;

  const WooSmartCod(
      {this.disallowedPaymentGateways,
      this.realTotal,
      this.remainingAmount,
      this.userAdvanceAmount,
      this.extraFee,
      this.isRiskFreeEnabled});

  factory WooSmartCod.fromJson(Map parsedJson) => WooSmartCod(
        disallowedPaymentGateways: parsedJson['disallowed_payment_gateways'],
        realTotal: Helper.formatDouble(parsedJson['real_total']),
        remainingAmount: Helper.formatDouble(parsedJson['remaining_amount']),
        userAdvanceAmount:
            Helper.formatDouble(parsedJson['user_advance_amount']),
        extraFee: Helper.formatDouble(parsedJson['extra_fee']),
        isRiskFreeEnabled: parsedJson['is_risk_free_enabled'] == true,
      );
}
