import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

import '../../common/config.dart';
import '../../common/constants.dart';
import '../../models/entities/prediction.dart';
import 'models/google_maps_models.dart';

/// Centralized service for Google Maps API calls
class GoogleMapsService {
  static GoogleMapsService? _instance;

  GoogleMapsService._internal();

  factory GoogleMapsService() {
    _instance ??= GoogleMapsService._internal();
    return _instance!;
  }

  /// Get the appropriate Google API key based on platform
  String get _apiKey {
    if (isIos) {
      return kGoogleApiKey.ios;
    } else if (isAndroid) {
      return kGoogleApiKey.android;
    } else {
      return kGoogleApiKey.web;
    }
  }

  /// Base URL for Google Maps API
  static const String _baseUrl = 'https://maps.googleapis.com/maps/api';

  /// Get autocomplete place predictions
  Future<List<Prediction>> getAutoCompletePlaces(
    String term,
    String? sessionToken,
  ) async {
    try {
      final endpoint = '$_baseUrl/place/autocomplete/json?'
          'input=$term&key=$_apiKey'
          '&sessiontoken=$sessionToken';

      final response = await httpGet(endpoint.toUri()!);
      final result = convert.jsonDecode(response.body);

      if (result['error_message'] != null) {
        throw result['error_message'];
      }

      final list = <Prediction>[];
      for (final item in result['predictions']) {
        list.add(Prediction.fromJson(item));
      }
      return list;
    } catch (e) {
      printLog('getAutoCompletePlaces: $e');
      rethrow;
    }
  }

  /// Get place details by place ID
  Future<Prediction> getPlaceDetail(
    Prediction prediction,
    String? sessionToken,
  ) async {
    try {
      final endpoint = '$_baseUrl/place/details/json?'
          'place_id=${prediction.placeId}'
          '&fields=geometry&key=$_apiKey'
          '&sessiontoken=$sessionToken';

      final response = await httpGet(endpoint.toUri()!);
      final result = convert.jsonDecode(response.body);
      final lat = result['result']['geometry']['location']['lat'].toString();
      final long = result['result']['geometry']['location']['lng'].toString();
      prediction.lat = lat;
      prediction.long = long;
    } catch (e) {
      printLog('getPlaceDetail: $e');
    }
    return prediction;
  }

  /// Get address from coordinates using reverse geocoding
  Future<String> getAddressFromLocation(double? lat, double? long) async {
    try {
      final endpoint = '$_baseUrl/geocode/json?latlng=$lat,$long&key=$_apiKey';
      final response = await httpGet(endpoint.toUri()!);
      final result = convert.jsonDecode(response.body)['results'];
      return result.isNotEmpty ? result.first['formatted_address'] : '';
    } catch (e) {
      printLog('getAddressFromLocation: $e');
      return '';
    }
  }

  /// Get coordinates from country code
  Future<LocationResult?> getLocationFromCountryCode(String countryCode) async {
    try {
      final endpoint =
          '$_baseUrl/geocode/json?components=country:$countryCode&key=$_apiKey';
      final response = await http.get(endpoint.toUri()!);

      if (response.statusCode == 200) {
        final data = convert.jsonDecode(response.body);
        if (data['results'] != null && data['results'].isNotEmpty) {
          final location = data['results'][0]['geometry']['location'];
          return LocationResult(
            latitude: double.tryParse(location['lat'].toString()) ?? 0.0,
            longitude: double.tryParse(location['lng'].toString()) ?? 0.0,
          );
        }
      }
    } catch (e) {
      printLog('getLocationFromCountryCode: $e');
    }
    return null;
  }

  /// Build static map URL
  Uri buildStaticMapUrl({
    required double lat,
    required double lng,
    String size = '800x600',
    String zoom = '13',
    String mapType = 'roadmap',
    String markerColor = 'red',
    String markerLabel = 'C',
    List<String>? styleParams,
  }) {
    final queryParameters = <String, String>{
      'size': size,
      'center': '$lat,$lng',
      'zoom': zoom,
      'maptype': mapType,
      'markers': 'color:$markerColor|label:$markerLabel|$lat,$lng',
      'key': _apiKey,
    };

    // Add style parameters if provided
    if (styleParams != null && styleParams.isNotEmpty) {
      for (var i = 0; i < styleParams.length; i++) {
        queryParameters['style'] = styleParams[i];
      }
    }

    return Uri(
      scheme: 'https',
      host: 'maps.googleapis.com',
      port: 443,
      path: '/maps/api/staticmap',
      queryParameters: queryParameters,
    );
  }

  /// Search for places with autocomplete
  Future<List<PlaceSuggestion>> searchPlaces({
    required String query,
    String? sessionToken,
    double? latitude,
    double? longitude,
  }) async {
    try {
      final cleanQuery = query.replaceAll(' ', '+');
      var endpoint = '$_baseUrl/place/autocomplete/json?'
          'key=$_apiKey&'
          'input={$cleanQuery}&sessiontoken=$sessionToken';

      if (latitude != null && longitude != null) {
        endpoint += '&location=$latitude,$longitude';
      }

      final response = await http.get(endpoint.toUri()!);

      if (response.statusCode == 200) {
        final data = convert.jsonDecode(response.body);
        final suggestions = <PlaceSuggestion>[];

        for (final prediction in data['predictions']) {
          suggestions.add(PlaceSuggestion.fromJson(prediction));
        }

        return suggestions;
      }
    } catch (e) {
      printLog('searchPlaces: $e');
    }
    return [];
  }

  /// Get place details by place ID for place picker
  Future<PlaceDetail?> getPlaceDetailById(String placeId) async {
    try {
      final endpoint =
          '$_baseUrl/place/details/json?key=$_apiKey&placeid=$placeId';
      final response = await http.get(endpoint.toUri()!);

      if (response.statusCode == 200) {
        final data = convert.jsonDecode(response.body);
        final location = data['result']['geometry']['location'];

        return PlaceDetail(
          placeId: placeId,
          latitude: double.tryParse(location['lat'].toString()) ?? 0.0,
          longitude: double.tryParse(location['lng'].toString()) ?? 0.0,
        );
      }
    } catch (e) {
      printLog('getPlaceDetailById: $e');
    }
    return null;
  }

  /// Search nearby places
  Future<List<NearbyPlaceResult>> getNearbyPlaces({
    required double latitude,
    required double longitude,
    int radius = 150,
  }) async {
    try {
      final endpoint = '$_baseUrl/place/nearbysearch/json?'
          'key=$_apiKey&'
          'location=$latitude,$longitude&radius=$radius';

      final response = await http.get(endpoint.toUri()!);

      if (response.statusCode == 200) {
        final data = convert.jsonDecode(response.body);
        final places = <NearbyPlaceResult>[];

        for (final item in data['results']) {
          places.add(NearbyPlaceResult.fromJson(item));
        }

        return places;
      }
    } catch (e) {
      printLog('getNearbyPlaces: $e');
    }
    return [];
  }
}
