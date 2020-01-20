import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/providers/place_provider.dart';
import 'package:google_maps_place_picker/src/autocomplete_search.dart';
import 'package:google_maps_place_picker/src/google_map_place_picker.dart';
import 'package:google_maps_place_picker/utils/log.dart';
import 'package:google_maps_place_picker/utils/uuid.dart';
import 'package:provider/provider.dart';

class PlacePicker extends StatefulWidget {
  PlacePicker({
    Key key,
    @required this.apiKey,
    this.initialPosition,
    this.useCurrentLocation,
    this.desiredLocationAccuracy = LocationAccuracy.high,
    this.searchBarDecoration,
    this.hintText,
    this.searchingText,
    this.height,
    this.contentPadding,
  }) : super(key: key);

  final String apiKey;

  final LatLng initialPosition;
  final bool useCurrentLocation;
  final LocationAccuracy desiredLocationAccuracy;

  // Search Bar related
  final Decoration searchBarDecoration;
  final String hintText;
  final String searchingText;
  final double height;
  final EdgeInsetsGeometry contentPadding;

  @override
  _PlacePickerState createState() => _PlacePickerState();
}

class _PlacePickerState extends State<PlacePicker> {
  GlobalKey appBarKey = GlobalKey();
  String sessionToken = Uuid().generateV4();
  Completer<GoogleMapController> mapController = Completer();
  PlaceProvider provider = PlaceProvider();
  bool isFetchingLocation = false;

  @override
  void initState() {
    super.initState();

    if (widget.useCurrentLocation) _getCurrentLocation();
  }

  _getCurrentLocation() async {
    isFetchingLocation = true;

    try {
      provider.currentPosition = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

      debug("position = ${provider.currentPosition}");
    } on PlatformException catch (e) {
      provider.currentPosition = null;

      debug("_initCurrentLocation#e = $e");
    }

    isFetchingLocation = false;
  }

  // Future _moveToCurrentLocation() async {
  //   controller.animateCamera(CameraUpdate.newCameraPosition(
  //     CameraPosition(target: LatLng(provider.currentPosition.latitude, provider.currentPosition.longitude), zoom: 16),
  //   ));
  // }

  @override
  Widget build(BuildContext context) {
    print(">>> Build [PlacePicker] Page");

    return ChangeNotifierProvider.value(
      value: provider,
      child: Builder(
        builder: (context) {
          return Scaffold(
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                key: appBarKey,
                automaticallyImplyLeading: false,
                iconTheme: Theme.of(context).iconTheme,
                elevation: 0,
                backgroundColor: Colors.transparent,
                titleSpacing: 0.0,
                title: Row(
                  children: <Widget>[
                    IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back), padding: EdgeInsets.zero),
                    Expanded(
                      child: AutoCompleteSearch(
                        sessionToken: sessionToken,
                        apiKey: widget.apiKey,
                        appBarKey: appBarKey,
                        searchBarDecoration: widget.searchBarDecoration,
                        hintText: widget.hintText,
                        searchingText: widget.searchingText,
                        height: widget.height,
                        contentPadding: widget.contentPadding,
                        onPicked: (prediction) {
                          //_moveToCurrentLocation();
                        },
                      ),
                    ),
                    SizedBox(width: 15),
                  ],
                ),
              ),
              body: widget.useCurrentLocation ? _buildMapWithLocation() : _buildMap());
        },
      ),
    );
  }

  Widget _buildMapWithLocation() {
    // Use Selector instead of Consumer or setState to avoid rebuilding whole widget including AutoCompleteSearch widget.
    return Selector<PlaceProvider, Position>(
      selector: (_, provider) => provider.currentPosition,
      builder: (_, data, __) {
        if (data == null) {
          if (isFetchingLocation) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return _buildMap();
          }
        } else {
          return GoogleMapPlacePicker(initialTarget: LatLng(data.latitude, data.longitude));
        }
      },
    );
  }

  Widget _buildMap() {
    return GoogleMapPlacePicker(
      initialTarget: widget.initialPosition,
    );
  }
}
