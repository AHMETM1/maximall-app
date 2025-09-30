import 'package:flutter/cupertino.dart';
import 'package:flux_localization/flux_localization.dart';

enum ErrorType {
  loginFailed,
  loginSuccess,
  loginInvalid,
  loginCancelled,
  updateFailed,
  updateSuccess,
  registerSuccess,
  registerFailed,
  missingLoginCredential,
  registrationUnderReview,
  invalidEmail,
  invalidPhone,
  invalidCountry,
  invalidPostalCode,
  invalidProvince,
  invalidCity,
  invalidAddress,
  invalidCountryCode,
  networkError,
  graphqlError,
  unknownError,
  cartNotAvailable,
  cartNotReadyForCheckout,
  generalError,
  updateUserFailed,
  ;

  String getMessage(BuildContext context) {
    switch (this) {
      case ErrorType.loginFailed:
        return S.of(context).loginFailed;
      case ErrorType.loginSuccess:
        return S.of(context).loginSuccess;
      case ErrorType.loginInvalid:
        return S.of(context).loginInvalid;
      case ErrorType.loginCancelled:
        return S.of(context).loginCanceled;
      case ErrorType.updateFailed:
        return S.of(context).updateFailed;
      case ErrorType.updateSuccess:
        return S.of(context).updateSuccess;
      case ErrorType.registerSuccess:
        return S.of(context).registerSuccess;
      case ErrorType.registerFailed:
        return S.of(context).registerFailed;
      case ErrorType.missingLoginCredential:
        return S.of(context).usernameAndPasswordRequired;
      case ErrorType.registrationUnderReview:
        return S.of(context).yourAccountIsUnderReview;
      case ErrorType.invalidEmail:
        return S.of(context).invalidEmail;
      case ErrorType.invalidPhone:
        return S.of(context).invalidPhone;
      case ErrorType.invalidCountry:
        return S.of(context).invalidCountry;
      case ErrorType.invalidPostalCode:
        return S.of(context).invalidPostalCode;
      case ErrorType.invalidProvince:
        return S.of(context).invalidProvince;
      case ErrorType.invalidCity:
        return S.of(context).invalidCity;
      case ErrorType.invalidAddress:
        return S.of(context).invalidAddress;
      case ErrorType.invalidCountryCode:
        return S.of(context).invalidCountryCode;
      case ErrorType.networkError:
        return S.of(context).networkError;
      case ErrorType.graphqlError:
        return S.of(context).graphqlError;
      case ErrorType.unknownError:
        return S.of(context).unknownError;
      case ErrorType.cartNotAvailable:
        return S.of(context).cartNotAvailable;
      case ErrorType.cartNotReadyForCheckout:
        return S.of(context).cartNotReadyForCheckout;
      case ErrorType.generalError:
        return S.of(context).somethingWrong;
      case ErrorType.updateUserFailed:
        return S.of(context).updateUserFailed;
    }
  }
}
