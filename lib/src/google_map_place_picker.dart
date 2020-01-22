import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:google_maps_place_picker/providers/place_provider.dart';
import 'package:google_maps_place_picker/src/components/animated_pin.dart';
import 'package:google_maps_place_picker/src/components/floating_card.dart';
import 'package:google_maps_place_picker/src/place_picker.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

typedef SelectedPlaceWidgetBuilder = Widget Function(
  BuildContext context,
  PickResult seelctedPlace,
  SearchingState state,
  bool isSearchBarFocused,
);

typedef PinBuilder = Widget Function(
  BuildContext context,
  PinState state,
);

class GoogleMapPlacePicker extends StatelessWidget {
  const GoogleMapPlacePicker({
    Key key,
    @required this.initialTarget,
    this.mapType = MapType.normal,
    this.selectedPlaceWidgetBuilder,
    this.pinBuilder,
    this.onSearchFailed,
    this.onMoveStart,
    this.debounceMilliseconds,
  }) : super(key: key);

  final LatLng initialTarget;
  final MapType mapType;
  final SelectedPlaceWidgetBuilder selectedPlaceWidgetBuilder;
  final PinBuilder pinBuilder;
  final ValueChanged<String> onSearchFailed;
  final VoidCallback onMoveStart;
  final int debounceMilliseconds;

  _searchByCameraLocation(PlaceProvider provider) async {
    provider.placeSearchingState = SearchingState.Searching;

    final GeocodingResponse response = await provider.geocoding.searchByLocation(
      Location(provider.cameraPosition.target.latitude, provider.cameraPosition.target.longitude),
    );

    if (response.errorMessage?.isNotEmpty == true || response.status == "REQUEST_DENIED") {
      print("Camera Location Search Error: " + response.errorMessage);
      if (onSearchFailed != null) {
        onSearchFailed(response.status);
      }
      return;
    }

    provider.selectedPlace = PickResult.fromGeocodingResult(response.results[0]);

    provider.placeSearchingState = SearchingState.Idle;
    provider.setCameraPosition(null);
  }

  @override
  Widget build(BuildContext context) {
    PlaceProvider provider = PlaceProvider.of(context, listen: false);

    return Stack(
      children: <Widget>[
        // Google Map.
        GoogleMap(
          myLocationButtonEnabled: false,
          compassEnabled: false,
          mapToolbarEnabled: false,
          initialCameraPosition: CameraPosition(target: initialTarget, zoom: 15),
          mapType: mapType,
          myLocationEnabled: true,
          onMapCreated: (GoogleMapController controller) {
            provider.mapController = controller;
            provider.setCameraPosition(null);
            provider.pinState = PinState.Idle;
          },
          onCameraIdle: () {
            // Search current camera location only if camera has moved (dragged) before.
            if (provider.pinState == PinState.Dragging) {
              // Cancel previous timer.
              if (provider.debounceTimer?.isActive ?? false) {
                provider.debounceTimer.cancel();
              }
              provider.debounceTimer = Timer(Duration(milliseconds: debounceMilliseconds), () {
                _searchByCameraLocation(provider);
              });
            }

            provider.pinState = PinState.Idle;
          },
          onCameraMoveStarted: () {
            // Cancel any other timer.
            provider.debounceTimer?.cancel();

            // Update state, dismiss keyboard and clear text.
            provider.pinState = PinState.Dragging;

            onMoveStart();
          },
          onCameraMove: (CameraPosition position) {
            provider.setCameraPosition(position);
          },
        ),
        // Current Location Pin.
        Center(
          child: Selector<PlaceProvider, PinState>(
            selector: (_, provider) => provider.pinState,
            builder: (sContext, state, __) {
              if (pinBuilder == null) {
                return _defaultPinBuilder(sContext, state);
              } else {
                return Builder(builder: (builderContext) => pinBuilder(builderContext, state));
              }
            },
          ),
        ),
        // Floating Card.
        Selector<PlaceProvider, Tuple3<PickResult, SearchingState, bool>>(
          selector: (_, provider) => Tuple3(provider.selectedPlace, provider.placeSearchingState, provider.isSearchBarFocused),
          builder: (sContext, data, __) {
            if (data.item2 == SearchingState.Searching) {
              return _buildFloatingCard(sContext, data.item1, SearchingState.Searching);
            } else {
              // Hide if there is no PlaceDetails OR if user is searching with search bar.
              if (data.item1 == null || data.item3 == true) {
                return Container();
              } else {
                if (selectedPlaceWidgetBuilder == null) {
                  return _buildFloatingCard(sContext, data.item1, SearchingState.Idle);
                } else {
                  return Builder(builder: (builderContext) => selectedPlaceWidgetBuilder(builderContext, data.item1, data.item2, data.item3));
                }
              }
            }
          },
        ),
      ],
    );
  }

  Widget _defaultPinBuilder(BuildContext context, PinState state) {
    if (state == PinState.Preparing) {
      return Container();
    } else if (state == PinState.Idle) {
      return Stack(
        children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.place, size: 36),
                SizedBox(height: 42),
              ],
            ),
          ),
          Center(
            child: Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      );
    } else {
      return Stack(
        children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AnimatedPin(child: Icon(Icons.place, size: 36)),
                SizedBox(height: 42),
              ],
            ),
          ),
          Center(
            child: Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget _buildFloatingCard(BuildContext context, PickResult data, SearchingState state) {
    return FloatingCard(
      bottomPosition: MediaQuery.of(context).size.height * 0.05,
      leftPosition: MediaQuery.of(context).size.width * 0.05,
      width: MediaQuery.of(context).size.width * 0.9,
      borderRadius: BorderRadius.circular(12.0),
      elevation: 4.0,
      color: Theme.of(context).brightness == Brightness.dark ? Colors.black54 : Colors.white,
      child: state == SearchingState.Searching ? _buildLoadingIndicator() : _buildSelectionDetails(context, data),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      height: 48,
      child: const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildSelectionDetails(BuildContext context, PickResult result) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Text(
            result.address,
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          RaisedButton(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Text(
              "Select here",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
            ),
            onPressed: () {
              Navigator.of(context).pop(result);
            },
          ),
        ],
      ),
    );
  }
}
