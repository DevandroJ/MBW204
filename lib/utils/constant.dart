// ignore: implementation_imports
import 'package:timeago/src/messages/lookupmessages.dart';
import 'package:mbw204_club_ina/data/models/language.dart';

class AppConstants {
  static const String BASE_URL = 'https://api-w204.connexist.id';
  static const String BASE_URL_DISBURSEMENT_DENOM = 'https://pg-sandbox.connexist.id/disbursement/pub/v1/disbursement/denom';
  static const String BASE_URL_ECOMMERCE_DELIVERY_TIMESLOTS = 'https://smsapi.connexist.com:8443/commerce-mercyw204/pub/v1/ninja/deliveryTimeSlots';
  static const String BASE_URL_DISBURSEMENT_BANK = 'https://pg-sandbox.connexist.id/disbursement/pub/v1/disbursement/bank';
  static const String BASE_URL_DISBURSEMENT_EMONEY = 'https://pg-sandbox.connexist.id/disbursement/pub/v1/disbursement/emoney';
  static const String BASE_URL_DISBURSEMENT = 'https://pg-sandbox.connexist.id/disbursement/api/v1';
  static const String BASE_URL_IMG = 'http://feedapi.connexist.id/d/f';
  static const String BASE_URL_FEED = 'https://apidev.cxid.xyz:7443/api/v1';
  static const String BASE_URL_FEED_MEDIA = 'http://167.99.76.66:9000/p/f';
  static const String BASE_URL_FEED_IMG = 'http://167.99.76.66:9000/d/f';
  static const String BASE_URL_SOCKET_FEED = 'https://feedapi.connexist.id:5091'; 
  static const String BASE_URL_ECOMMERCE = 'https://apidev.cxid.xyz:8443/commerce-mercyw204/api/v1';
  static const String BASE_URL_PPOB = 'https://apidev.cxid.xyz:8443/ppob/api/v1';
  static const String BASE_URL_VA = 'https://pg-sandbox.connexist.id/payment/pub/v1/payment/channels';
  static const String BASE_URL_PAYMENT_BILLING = 'https://pg-sandbox.connexist.id/payment/page/guidance';
  static const String BASE_URL_HELP_PAYMENT = 'https://pg-sandbox.connexist.id/payment/help/howto';
  static const String BASE_URL_HELP_INBOX_PAYMENT = 'https://pg-sandbox.connexist.id/payment/help/howto/trx';
  static const String BASE_URL_ECOMMERCE_PICKUP_TIMESLOTS = 'https://smsapi.connexist.com:8443/commerce-mercyw204/pub/v1/ninja/pickupTimeSlots';
  static const String BASE_URL_ECOMMERCE_DIMENSTION_SIZE = 'https://smsapi.connexist.com:8443/commerce-mercyw204/pub/v1/ninja/dimensionSizes';
  static const String BASE_URL_ECOMMERCE_APPROXIMATELY_VOLUMES = 'https://smsapi.connexist.com:8443/commerce-mercyw204/pub/v1/ninja/pickupApproxVolumes';



  static const String X_CONTEXT_ID = '342790713173';
  static const String MOBILE_UA = 'Mozilla/5.0 (Linux; Android 7.0; SM-G930V Build/NRD90M) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.125 Mobile Safari/537.36';
  static const String PRODUCT_ID = 'dfadf7e6-6a8d-4704-a082-9025289cb37e';

  // va prod https://pg-prod.sandbox.connexist.id/payment/pub/v1/payment/channels
  // va dev https://pg-sandbox.connexist.id/payment/pub/v1/payment/channels
  // feed prod https://feedapi.connexist.id/api/v1
  // feed dev https://apidev.cxid.xyz:7443/api/v1
  // e-commerce dev https://apidev.cxid.xyz:8443/commerce-ppdi/api/v1
  // e-commerce prod https://smsapi.connexist.com:8443/commerce-ppdi/api/v1

  // SharedPreferences
  static const String API_KEY_GMAPS = "AIzaSyBFRpXPf8BXaR22nDvvx2ghBfbUbGGX8N8";

  static const String COUNTRY_CODE = 'country_code';
  static const String LANGUAGE_CODE = 'language_code';
  static const String THEME = 'theme';

  static const double padding = 35;
  static const double avatarRadius = 45;

  static List<LanguageModel> languages = [
    LanguageModel(imageUrl: '', languageName: 'English', countryCode: 'US', languageCode: 'en'),
    LanguageModel(imageUrl: '', languageName: 'Indonesia', countryCode: 'ID', languageCode: 'id')
  ];
}

/// Indonesian messages
class CustomLocalDate implements LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => 'yang lalu';
  @override
  String suffixFromNow() => 'dari sekarang';
  @override
  String lessThanOneMinute(int seconds) => '1 detik';
  @override
  String aboutAMinute(int minutes) => '1 menit';
  @override
  String minutes(int minutes) => '$minutes menit';
  @override
  String aboutAnHour(int minutes) => '1 jam';
  @override
  String hours(int hours) => '$hours jam';
  @override
  String aDay(int hours) => 'sehari';
  @override
  String days(int days) => '$days hari';
  @override
  String aboutAMonth(int days) => 'sekitar sebulan';
  @override
  String months(int months) => '$months bulan';
  @override
  String aboutAYear(int year) => 'sekitar setahun';
  @override
  String years(int years) => '$years tahun';
  @override
  String wordSeparator() => ' ';
}
