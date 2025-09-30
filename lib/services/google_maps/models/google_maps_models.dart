/// Models for Google Maps API responses

class LocationResult {
  final double latitude;
  final double longitude;

  LocationResult({
    required this.latitude,
    required this.longitude,
  });

  factory LocationResult.fromJson(Map<String, dynamic> json) {
    return LocationResult(
      latitude: double.tryParse(json['lat'].toString()) ?? 0.0,
      longitude: double.tryParse(json['lng'].toString()) ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': latitude,
      'lng': longitude,
    };
  }
}

class PlaceSuggestion {
  final String description;
  final String placeId;
  final String? mainText;
  final String? secondaryText;

  PlaceSuggestion({
    required this.description,
    required this.placeId,
    this.mainText,
    this.secondaryText,
  });

  factory PlaceSuggestion.fromJson(Map<String, dynamic> json) {
    return PlaceSuggestion(
      description: json['description'] ?? '',
      placeId: json['place_id'] ?? '',
      mainText: json['structured_formatting']?['main_text'],
      secondaryText: json['structured_formatting']?['secondary_text'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'place_id': placeId,
      'structured_formatting': {
        'main_text': mainText,
        'secondary_text': secondaryText,
      },
    };
  }
}

class PlaceDetail {
  final String placeId;
  final double latitude;
  final double longitude;
  final String? name;
  final String? address;

  PlaceDetail({
    required this.placeId,
    required this.latitude,
    required this.longitude,
    this.name,
    this.address,
  });

  factory PlaceDetail.fromJson(Map<String, dynamic> json) {
    final geometry = json['geometry'];
    final location = geometry['location'];

    return PlaceDetail(
      placeId: json['place_id'] ?? '',
      latitude: double.tryParse(location['lat'].toString()) ?? 0.0,
      longitude: double.tryParse(location['lng'].toString()) ?? 0.0,
      name: json['name'],
      address: json['formatted_address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'place_id': placeId,
      'geometry': {
        'location': {
          'lat': latitude,
          'lng': longitude,
        },
      },
      'name': name,
      'formatted_address': address,
    };
  }
}

class NearbyPlaceResult {
  final String? name;
  final String? icon;
  final double latitude;
  final double longitude;
  final String? placeId;
  final double? rating;
  final String? vicinity;

  NearbyPlaceResult({
    this.name,
    this.icon,
    required this.latitude,
    required this.longitude,
    this.placeId,
    this.rating,
    this.vicinity,
  });

  factory NearbyPlaceResult.fromJson(Map<String, dynamic> json) {
    final geometry = json['geometry'];
    final location = geometry['location'];

    return NearbyPlaceResult(
      name: json['name'],
      icon: json['icon'],
      latitude: double.tryParse(location['lat'].toString()) ?? 0.0,
      longitude: double.tryParse(location['lng'].toString()) ?? 0.0,
      placeId: json['place_id'],
      rating: json['rating']?.toDouble(),
      vicinity: json['vicinity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'icon': icon,
      'geometry': {
        'location': {
          'lat': latitude,
          'lng': longitude,
        },
      },
      'place_id': placeId,
      'rating': rating,
      'vicinity': vicinity,
    };
  }
}

class StaticMapConfig {
  final String size;
  final String zoom;
  final String mapType;
  final String markerColor;
  final String markerLabel;
  final List<String>? styleParams;

  StaticMapConfig({
    this.size = '800x600',
    this.zoom = '13',
    this.mapType = 'roadmap',
    this.markerColor = 'red',
    this.markerLabel = 'C',
    this.styleParams,
  });

  Map<String, dynamic> toJson() {
    return {
      'size': size,
      'zoom': zoom,
      'mapType': mapType,
      'markerColor': markerColor,
      'markerLabel': markerLabel,
      'styleParams': styleParams,
    };
  }
}
