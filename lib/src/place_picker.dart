import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:google_maps_place_picker/providers/place_provider.dart';
import 'package:google_maps_place_picker/src/autocomplete_search.dart';
import 'package:google_maps_place_picker/src/controllers/autocomplete_search_controller.dart';
import 'package:google_maps_place_picker/src/google_map_place_picker.dart';
import 'package:google_maps_place_picker/src/utils/uuid.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

enum PinState { Preparing, Idle, Dragging }
enum SearchingState { Idle, Searching }

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
    this.searchBarHeight,
    this.contentPadding,
    this.onAutoCompleteFailed,
    this.onGecodingSearchFailed,
    this.proxyBaseUrl,
    this.httpClient,
    this.selectedPlaceWidgetBuilder,
    this.pinBuilder,
    this.autoCompleteDebounceInMilliseconds = 500,
    this.cameraMoveDebounceInMilliseconds = 750,
  }) : super(key: key);

  final String apiKey;

  final LatLng initialPosition;
  final bool useCurrentLocation;
  final LocationAccuracy desiredLocationAccuracy;

  final Decoration searchBarDecoration;
  final String hintText;
  final String searchingText;
  final double searchBarHeight;
  final EdgeInsetsGeometry contentPadding;

  final ValueChanged<String> onAutoCompleteFailed;
  final ValueChanged<String> onGecodingSearchFailed;
  final int autoCompleteDebounceInMilliseconds;
  final int cameraMoveDebounceInMilliseconds;

  /// optional - builds selected place's UI
  ///
  /// It is provided by default if you leave it as a null.
  final SelectedPlaceWidgetBuilder selectedPlaceWidgetBuilder;

  /// optional - builds customized pin widget which indicates current pointing position.
  ///
  /// It is provided by default if you leave it as a null.
  final PinBuilder pinBuilder;

  /// optional - sets 'proxy' value in google_maps_webservice
  ///
  /// In case of using a proxy the baseUrl can be set.
  /// The apiKey is not required in case the proxy sets it.
  /// (Not storing the apiKey in the app is good practice)
  final String proxyBaseUrl;

  /// optional - set 'client' value in google_maps_webservice
  ///
  /// In case of using a proxy url that requires authentication
  /// or custom configuration
  final BaseClient httpClient;

  @override
  _PlacePickerState createState() => _PlacePickerState();
}

class _PlacePickerState extends State<PlacePicker> {
  GlobalKey appBarKey = GlobalKey();
  PlaceProvider provider;
  bool isFetchingLocation = false;
  SearchBarController searchBarController = SearchBarController();

  @override
  void initState() {
    super.initState();

    provider = PlaceProvider(widget.apiKey, widget.proxyBaseUrl, widget.httpClient);
    provider.sessionToken = Uuid().generateV4();

    if (widget.useCurrentLocation) _getCurrentLocation();
  }

  @override
  void dispose() {
    searchBarController.dispose();

    super.dispose();
  }

  _getCurrentLocation() async {
    isFetchingLocation = true;

    try {
      provider.currentPosition = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    } on PlatformException catch (e) {
      provider.currentPosition = null;
    }

    isFetchingLocation = false;
  }

  @override
  Widget build(BuildContext context) {
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
                title: _buildSearchBar(),
              ),
              body: widget.useCurrentLocation ? _buildMapWithLocation() : _buildDefaultMap());
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: <Widget>[
        IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back), padding: EdgeInsets.zero),
        Expanded(
          child: AutoCompleteSearch(
            searchBarController: searchBarController,
            sessionToken: provider.sessionToken,
            appBarKey: appBarKey,
            searchBarDecoration: widget.searchBarDecoration,
            hintText: widget.hintText,
            searchingText: widget.searchingText,
            height: widget.searchBarHeight,
            contentPadding: widget.contentPadding,
            debounceMilliseconds: widget.autoCompleteDebounceInMilliseconds,
            onPicked: (prediction) {
              _pickPrediction(prediction);
            },
            onSearchFailed: (status) {
              if (widget.onAutoCompleteFailed != null) {
                widget.onAutoCompleteFailed(status);
              }
            },
          ),
        ),
        SizedBox(width: 15),
      ],
    );
  }

  _pickPrediction(Prediction prediction) async {
    provider.placeSearchingState = SearchingState.Searching;

    final PlacesDetailsResponse response = await provider.places.getDetailsByPlaceId(prediction.placeId, sessionToken: provider.sessionToken);

    if (response.errorMessage?.isNotEmpty == true || response.status == "REQUEST_DENIED") {
      print("AutoCompleteSearch Error: " + response.errorMessage);
      if (widget.onAutoCompleteFailed != null) {
        widget.onAutoCompleteFailed(response.status);
      }
      return;
    }

    provider.selectedPlace = PickResult.fromPlaceDetailResult(response.result);

    _moveTo(provider.selectedPlace.geometry.location.lat, provider.selectedPlace.geometry.location.lng);

    provider.placeSearchingState = SearchingState.Idle;
  }

  _moveTo(double latitude, double longitude) async {
    GoogleMapController controller = provider.mapController;
    if (controller == null) return;

    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(latitude, longitude),
          zoom: 16,
        ),
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
            return _buildDefaultMap();
          }
        } else {
          return GoogleMapPlacePicker(
            initialTarget: LatLng(data.latitude, data.longitude),
            selectedPlaceWidgetBuilder: widget.selectedPlaceWidgetBuilder,
            pinBuilder: widget.pinBuilder,
            debounceMilliseconds: widget.cameraMoveDebounceInMilliseconds,
            onMoveStart: () {
              searchBarController.reset();
            },
          );
        }
      },
    );
  }

  Widget _buildDefaultMap() {
    return GoogleMapPlacePicker(
      initialTarget: widget.initialPosition,
      selectedPlaceWidgetBuilder: widget.selectedPlaceWidgetBuilder,
      pinBuilder: widget.pinBuilder,
      onSearchFailed: widget.onGecodingSearchFailed,
      debounceMilliseconds: widget.cameraMoveDebounceInMilliseconds,
      onMoveStart: () {
        searchBarController.reset();
      },
    );
  }
}
