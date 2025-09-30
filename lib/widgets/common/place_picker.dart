/// This widget is customize from the place_picker - https://pub.dev/packages/place_picker
import 'dart:async';
import 'dart:convert';
import 'dart:math' show Random;

import 'package:flutter/material.dart';
import 'package:flux_localization/flux_localization.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

import '../../common/config.dart';
import '../../common/constants.dart';
import '../../screens/common/google_map_mixin.dart';
import '../../services/services.dart';

/// A UUID generator.
///
/// This will generate unique IDs in the format:
///
///     f47ac10b-58cc-4372-a567-0e02b2c3d479
///
/// The generated uuids are 128 bit numbers encoded in a specific string format.
/// For more information, see
/// [en.wikipedia.org/wiki/Universally_unique_identifier](http://en.wikipedia.org/wiki/Universally_unique_identifier).
class Uuid {
  final Random _random = Random();

  /// Generate a version 4 (random) uuid. This is a uuid scheme that only uses
  /// random numbers as the source of the generated uuid.
  String generateV4() {
    // Generate xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx / 8-4-4-4-12.
    var special = 8 + _random.nextInt(4);

    return '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}-'
        '${_bitsDigits(16, 4)}-'
        '4${_bitsDigits(12, 3)}-'
        '${_printDigits(special, 1)}${_bitsDigits(12, 3)}-'
        '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}';
  }

  String _bitsDigits(int bitCount, int digitCount) =>
      _printDigits(_generateBits(bitCount), digitCount);

  int _generateBits(int bitCount) => _random.nextInt(1 << bitCount);

  String _printDigits(int value, int count) =>
      value.toRadixString(16).padLeft(count, '0');
}

/// The result returned after completing location selection.
class LocationResult {
  /// The human readable name of the location. This is primarily the
  /// name of the road. But in cases where the place was selected from Nearby
  /// places list, we use the <b>name</b> provided on the list item.
  String? name; // or road

  /// The human readable locality of the location.
  String? locality;

  /// Latitude/Longitude of the selected location.
  LatLng? latLng;

  String? street;

  String? country;

  String? state;

  String? city;

  String? zip;

  /// The full formatted address from Google
  String? formattedAddress;
}

/// Nearby place data will be deserialized into this model.
class NearbyPlace {
  /// The human-readable name of the location provided. This value is provided
  /// for [LocationResult.name] when the user selects this nearby place.
  String? name;

  /// The icon identifying the kind of place provided. Eg. lodging, chapel,
  /// hospital, etc.
  String? icon;

  // Latitude/Longitude of the provided location.
  LatLng? latLng;
}

/// Autocomplete results item returned from Google will be deserialized
/// into this model.
class AutoCompleteItem {
  /// The id of the place. This helps to fetch the lat,lng of the place.
  String? id;

  /// The text (name of place) displayed in the autocomplete suggestions list.
  String? text;

  /// Assistive index to begin highlight of matched part of the [text] with
  /// the original query
  int? offset;

  /// Length of matched part of the [text]
  int? length;
}

/// Place picker widget made with map widget from
/// [google_maps_flutter](https://github.com/flutter/plugins/tree/master/packages/google_maps_flutter)
/// and other API calls to [Google Places API](https://developers.google.com/places/web-service/intro)
///
/// API key provided should have `Maps SDK for Android`, `Maps SDK for iOS`
/// and `Places API`  enabled for it
class PlacePicker extends StatefulWidget {
  /// API key generated from Google Cloud Console. You can get an API key
  /// [here](https://cloud.google.com/maps-platform/)
  final String? apiKey;

  const PlacePicker(this.apiKey);

  @override
  State<StatefulWidget> createState() {
    return PlacePickerState();
  }
}

/// Place picker state
class PlacePickerState extends State<PlacePicker> with GoogleMapMixin {
  /// Initial waiting location for the map before the current user location
  /// is fetched.
  static const LatLng initialTarget = LatLng(0, 0);

  final Completer<GoogleMapController> mapController = Completer();

  final Set<Marker> markers = <Marker>{};

  /// Result returned after user completes selection
  LocationResult? locationResult;

  /// Overlay to display autocomplete suggestions
  OverlayEntry? overlayEntry;

  List<NearbyPlace> nearbyPlaces = [];

  /// Session token required for autocomplete API call
  String sessionToken = Uuid().generateV4();

  GlobalKey appBarKey = GlobalKey();

  bool hasSearchTerm = false;

  String previousSearchTerm = '';

  static LatLng? lastKnownLocation;

  @override
  void initState() {
    super.initState();
    if (lastKnownLocation == null) {
      _initializeMap();
    }
  }

  Future<void> _initializeMap() async {
    try {
      final countryCode = kPaymentConfig.defaultCountryISOCode;
      if (countryCode != null &&
          widget.apiKey != null &&
          widget.apiKey!.isNotEmpty) {
        final locationResult =
            await Services().api.getLocationFromCountryCode(countryCode);

        if (locationResult != null) {
          final target =
              LatLng(locationResult.latitude, locationResult.longitude);

          final controller = await mapController.future;
          await controller.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: target,
                zoom: 5,
              ),
            ),
          );

          setState(() {
            markers.clear();
            markers.add(
              Marker(
                position: target,
                markerId: const MarkerId('selected-location'),
              ),
            );
          });
        }
      }
    } catch (_) {
    } finally {
      moveToCurrentUserLocation();
    }
  }

  void onMapCreated(GoogleMapController controller) {
    mapController.complete(controller);
    if (lastKnownLocation != null) {
      moveToLocation(lastKnownLocation!);
    }
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        key: appBarKey,
        title: SearchInput(searchPlace),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
          ),
          color: Theme.of(context).colorScheme.secondary,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: <Widget>[
          Expanded(
            child: renderGoogleMap(
              initialCameraPosition: CameraPosition(
                target: lastKnownLocation ?? initialTarget,
                zoom: lastKnownLocation != null ? 15 : 2,
              ),
              onMapCreated: onMapCreated,
              onTap: (latLng) {
                clearOverlay();
                moveToLocation(latLng);
              },
              markers: markers,
            ),
          ),
          hasSearchTerm
              ? const SizedBox()
              : Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SelectPlaceAction(getLocationName(), () {
                        Navigator.of(context).pop(locationResult);
                      }),
                      const Divider(
                        height: 8,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 8,
                        ),
                        child: Text(
                          S.of(context).nearbyPlaces,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: nearbyPlaces
                                .map((it) => NearbyPlaceItem(it, () {
                                      moveToLocation(it.latLng!);
                                    }))
                                .toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  /// Hides the autocomplete overlay
  void clearOverlay() {
    if (overlayEntry != null) {
      overlayEntry!.remove();
      overlayEntry = null;
    }
  }

  /// Begins the search process by displaying a "wait" overlay then
  /// proceeds to fetch the autocomplete list. The bottom "dialog"
  /// is hidden so as to give more room and better experience for the
  /// autocomplete list overlay.
  void searchPlace(String place) {
    // on keyboard dismissal, the search was being triggered again
    // this is to cap that.
    if (place == previousSearchTerm) {
      return;
    } else {
      previousSearchTerm = place;
    }

    clearOverlay();

    setState(() {
      hasSearchTerm = place.isNotEmpty;
    });

    if (place.isEmpty) {
      return;
    }

    final renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;

    final appBarBox =
        appBarKey.currentContext!.findRenderObject() as RenderBox?;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: appBarBox!.size.height,
        width: size.width,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 24,
          ),
          color: Theme.of(context).colorScheme.surface,
          child: const Row(
            children: <Widget>[
              SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                ),
              ),
              SizedBox(
                width: 24,
              ),
            ],
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry!);

    autoCompleteSearch(context, place);
  }

  /// Fetches the place autocomplete list with the query [place].
  void autoCompleteSearch(context, String place) async {
    try {
      final suggestions = await Services().api.searchPlaces(
            query: place,
            sessionToken: sessionToken,
            latitude: locationResult?.latLng?.latitude,
            longitude: locationResult?.latLng?.longitude,
          );

      var richSuggestions = <RichSuggestion>[];

      if (suggestions.isEmpty) {
        var aci = AutoCompleteItem();
        aci.text = S.of(context).noResultFound;
        aci.offset = 0;
        aci.length = 0;
        richSuggestions.add(RichSuggestion(aci, () {}));
      } else {
        for (final suggestion in suggestions) {
          var aci = AutoCompleteItem();
          aci.id = suggestion.placeId;
          aci.text = suggestion.description;
          aci.offset =
              0; // Default offset since we don't have matched_substrings
          aci.length = suggestion.description.length;

          richSuggestions.add(RichSuggestion(aci, () {
            FocusScope.of(context).requestFocus(FocusNode());
            decodeAndSelectPlace(aci.id);
          }));
        }
      }

      displayAutoCompleteSuggestions(richSuggestions);
    } catch (e) {
      var aci = AutoCompleteItem();
      aci.text = 'Error: $e';
      aci.offset = 0;
      aci.length = 0;
      displayAutoCompleteSuggestions([RichSuggestion(aci, () {})]);
    }
  }

  /// To navigate to the selected place from the autocomplete list to the map,
  /// the lat,lng is required. This method fetches the lat,lng of the place and
  /// proceeds to moving the map to that location.
  void decodeAndSelectPlace(String? placeId) async {
    clearOverlay();

    if (placeId != null) {
      try {
        final placeDetail = await Services().api.getPlaceDetailById(placeId);

        if (placeDetail != null) {
          final latLng = LatLng(placeDetail.latitude, placeDetail.longitude);
          moveToLocation(latLng);
        }
      } catch (e) {
        // Handle error silently or show a message
      }
    }
  }

  /// Display autocomplete suggestions with the overlay.
  void displayAutoCompleteSuggestions(List<RichSuggestion> suggestions) {
    final renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;

    final appBarBox =
        appBarKey.currentContext!.findRenderObject() as RenderBox?;

    clearOverlay();

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        top: appBarBox!.size.height,
        child: Container(
          color: Theme.of(context).colorScheme.surface,
          child: Column(
            children: suggestions,
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry!);
  }

  /// Utility function to get clean readable name of a location. First checks
  /// for a human-readable name from the nearby list. This helps in the cases
  /// that the user selects from the nearby list (and expects to see that as a
  /// result, instead of road name). If no name is found from the nearby list,
  /// then the road name returned is used instead.
  String? getLocationName() {
    if (locationResult == null || (locationResult!.name?.isEmpty ?? true)) {
      return S.of(context).unnamedLocation;
    }

    for (var np in nearbyPlaces) {
      if (np.latLng == locationResult!.latLng) {
        locationResult!.name = np.name;
        return np.name;
      }
    }

    if (locationResult!.formattedAddress?.isNotEmpty ?? false) {
      return locationResult!.formattedAddress;
    }

    return '${locationResult!.street}, ${locationResult!.locality}';
  }

  /// Moves the marker to the indicated lat,lng
  void setMarker(LatLng latLng) {
    // markers.clear();
    setState(() {
      markers.clear();
      markers.add(
        Marker(
          markerId: const MarkerId('selected-location'),
          position: latLng,
        ),
      );
    });
  }

  /// Fetches and updates the nearby places to the provided lat,lng
  void getNearbyPlaces(LatLng latLng) async {
    try {
      final places = await Services().api.getNearbyPlaces(
            latitude: latLng.latitude,
            longitude: latLng.longitude,
            radius: 150,
          );

      nearbyPlaces.clear();
      for (final place in places) {
        var nearbyPlace = NearbyPlace();
        nearbyPlace.name = place.name;
        nearbyPlace.icon = place.icon;
        nearbyPlace.latLng = LatLng(place.latitude, place.longitude);
        nearbyPlaces.add(nearbyPlace);
      }

      // to update the nearby places
      setState(() {
        // this is to require the result to show
        hasSearchTerm = false;
      });
    } catch (error) {
      // Handle error silently
    }
  }

  /// This method gets the human readable name of the location. Mostly appears
  /// to be the road name and the locality.
  void reverseGeocodeLatLng(LatLng latLng) {
    http
        .get(
            'https://maps.googleapis.com/maps/api/geocode/json?latlng=${latLng.latitude},${latLng.longitude}&key=${widget.apiKey}'
                .toUri()!)
        .then((response) {
      Map<String, dynamic> responseJson = jsonDecode(response.body);
      if (response.statusCode == 200 &&
          responseJson['results'] is List &&
          List.from(responseJson['results']).isNotEmpty) {
        String? road = '';
        String? locality = '';

        String? number = '';
        String? street = '';
        String? state = '';

        String? city = '';
        String? country = '';
        String? zip = '';

        List components = responseJson['results'][0]['address_components'];
        for (var i = 0; i < components.length; i++) {
          final item = components[i];
          List types = item['types'];

          // Handle street number and name
          if (types.contains('street_number') ||
              types.contains('premise') ||
              types.contains('sublocality') ||
              types.contains('sublocality_level_2')) {
            if (number!.isEmpty) {
              number = item['long_name'];
            }
          }
          if (types.contains('route')) {
            if (street!.isEmpty) {
              street = item['long_name'];
            }
            if (road!.isEmpty) {
              road = item['long_name'];
            }
          } else if (types.contains('neighborhood')) {
            if (street!.isEmpty) {
              street = item['long_name'];
            }
          }

          // Handle city - prioritize locality
          if (types.contains('locality')) {
            city = item['long_name'];
            locality = item['long_name'];
          }

          // Handle state/province
          if (types.contains('administrative_area_level_1')) {
            state = item['long_name'];
          }

          // Handle country
          if (types.contains('country')) {
            country = item['short_name'];
          }

          // Handle postal code
          if (types.contains('postal_code')) {
            if (zip!.isEmpty) {
              zip = item['long_name'];
            }
          }
        }

        if (city!.isEmpty) {
          final localityComponent = components.firstWhere(
              (item) => item['types'].contains('locality'),
              orElse: () => null);
          if (localityComponent != null) {
            city = localityComponent['long_name'];
            locality = localityComponent['long_name'];
          } else {
            final adminArea2 = components.firstWhere(
                (item) => item['types'].contains('administrative_area_level_2'),
                orElse: () => null);
            if (adminArea2 != null) {
              city = adminArea2['long_name'];
              locality = adminArea2['long_name'];
            }
          }
        }

        if (zip!.isEmpty) {
          final postalComponent = components.firstWhere(
              (item) => item['types'].contains('postal_code'),
              orElse: () => null);
          if (postalComponent != null) {
            zip = postalComponent['long_name'];
          } else {
            final formattedAddr =
                responseJson['results'][0]['formatted_address'];
            final zipRegex = RegExp(r'\b\d{5,6}\b');
            final match = zipRegex.firstMatch(formattedAddr);
            if (match != null) {
              zip = match.group(0);
            }
          }
        }

        setState(() {
          locationResult = LocationResult();
          locationResult!.name = road;
          locationResult!.locality = locality;
          locationResult!.latLng = latLng;
          locationResult!.street = '$number $street';
          locationResult!.state = state;
          locationResult!.city = city;
          locationResult!.country = country;
          locationResult!.zip = zip;
        });
      } else {
        setState(() {
          locationResult = LocationResult();
          locationResult!.name = '';
          locationResult!.latLng = latLng;
          locationResult!.street = '';
          locationResult!.state = '';
          locationResult!.city = '';
          locationResult!.country = '';
          locationResult!.zip = '';
        });
      }
    });
  }

  /// Moves the camera to the provided location and updates other UI features to
  /// match the location.
  void moveToLocation(LatLng latLng) {
    mapController.future.then((controller) {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: latLng,
            zoom: 15.0,
          ),
        ),
      );
    });

    setMarker(latLng);

    lastKnownLocation = latLng;

    reverseGeocodeLatLng(latLng);

    getNearbyPlaces(latLng);
  }

  void moveToCurrentUserLocation() {
    var location = Location();
    location.getLocation().then((locationData) {
      var target = LatLng(locationData.latitude!, locationData.longitude!);
      moveToLocation(target);
    });
  }
}

/// Custom Search input field, showing the search and clear icons.
class SearchInput extends StatefulWidget {
  final ValueChanged<String> onSearchInput;

  const SearchInput(this.onSearchInput);

  @override
  State<StatefulWidget> createState() {
    return SearchInputState();
  }
}

class SearchInputState extends State<SearchInput> {
  TextEditingController editController = TextEditingController();

  Timer? debouncer;

  bool hasSearchEntry = false;

  SearchInputState();

  @override
  void initState() {
    super.initState();
    editController.addListener(onSearchInputChange);
  }

  @override
  void dispose() {
    editController.removeListener(onSearchInputChange);
    editController.dispose();

    super.dispose();
  }

  void onSearchInputChange() {
    if (editController.text.isEmpty) {
      debouncer?.cancel();
      widget.onSearchInput(editController.text);
      return;
    }

    if (debouncer?.isActive ?? false) {
      debouncer!.cancel();
    }

    debouncer = Timer(const Duration(milliseconds: 500), () {
      widget.onSearchInput(editController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Theme.of(context).canvasColor,
      ),
      child: Row(
        children: <Widget>[
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: S.of(context).searchPlace,
                border: InputBorder.none,
              ),
              controller: editController,
              onChanged: (value) {
                setState(() {
                  hasSearchEntry = value.isNotEmpty;
                });
              },
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          hasSearchEntry
              ? GestureDetector(
                  onTap: () {
                    editController.clear();
                    setState(() {
                      hasSearchEntry = false;
                    });
                  },
                  child: const Icon(
                    Icons.clear,
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}

class SelectPlaceAction extends StatelessWidget {
  final String? locationName;
  final VoidCallback onTap;

  const SelectPlaceAction(this.locationName, this.onTap);

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    locationName!,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    S.of(context).tapSelectLocation,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward,
            )
          ],
        ),
      ),
    );
  }
}

class NearbyPlaceItem extends StatelessWidget {
  final NearbyPlace nearbyPlace;
  final VoidCallback onTap;

  const NearbyPlaceItem(this.nearbyPlace, this.onTap);

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
        child: Row(
          children: <Widget>[
            Image.network(
              nearbyPlace.icon!,
              width: 16,
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Text(
                nearbyPlace.name.toString(),
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class RichSuggestion extends StatelessWidget {
  final VoidCallback onTap;
  final AutoCompleteItem autoCompleteItem;

  const RichSuggestion(this.autoCompleteItem, this.onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: RichText(
                text: TextSpan(children: getStyledTexts(context)),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<TextSpan> getStyledTexts(BuildContext context) {
    final result = <TextSpan>[];

    final startText =
        autoCompleteItem.text!.substring(0, autoCompleteItem.offset);
    if (startText.isNotEmpty) {
      result.add(
        TextSpan(
          text: startText,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 15,
          ),
        ),
      );
    }

    final boldText = autoCompleteItem.text!.substring(autoCompleteItem.offset!,
        autoCompleteItem.offset! + autoCompleteItem.length!);

    result.add(TextSpan(
      text: boldText,
      style: TextStyle(
        color: Theme.of(context).colorScheme.secondary,
        fontSize: 15,
      ),
    ));

    var remainingText = autoCompleteItem.text!
        .substring(autoCompleteItem.offset! + autoCompleteItem.length!);
    result.add(
      TextSpan(
        text: remainingText,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 15,
        ),
      ),
    );

    return result;
  }
}
