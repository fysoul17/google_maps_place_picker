import 'package:google_maps_webservice/geocoding.dart';
import 'package:google_maps_webservice/places.dart';

class PickResult {
  PickResult({
    this.placeId,
    this.geometry,
    this.address,
    this.types,
    this.addressComponents,
  });

  final String placeId;
  final Geometry geometry;
  final String address;
  final List<String> types;
  final List<AddressComponent> addressComponents;

  factory PickResult.fromGeocodingResult(GeocodingResult result) {
    return PickResult(
      placeId: result.placeId,
      geometry: result.geometry,
      address: result.formattedAddress,
      types: result.types,
      addressComponents: result.addressComponents,
    );
  }

  factory PickResult.fromPlaceDetailResult(PlaceDetails result) {
    return PickResult(
      placeId: result.placeId,
      geometry: result.geometry,
      address: result.formattedAddress,
      types: result.types,
      addressComponents: result.addressComponents,
    );
  }
}
