import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/providers/place_provider.dart';
import 'package:google_maps_place_picker/src/components/floating_card.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:provider/provider.dart';

typedef SelectedPlaceWidgetBuilder = Widget Function(
  BuildContext context,
  PlaceDetails placeDetails,
);

class GoogleMapPlacePicker extends StatelessWidget {
  const GoogleMapPlacePicker({
    Key key,
    @required this.initialTarget,
    this.mapType = MapType.normal,
    @required this.selectedPlaceWidgetBuilder,
  }) : super(key: key);

  final LatLng initialTarget;
  final MapType mapType;
  final SelectedPlaceWidgetBuilder selectedPlaceWidgetBuilder;

  @override
  Widget build(BuildContext context) {
    debugPrint(">>> Build [GoogleMapPlacePicker] Component");

    return Center(
      child: Stack(
        children: <Widget>[
          GoogleMap(
            myLocationButtonEnabled: false,
            initialCameraPosition: CameraPosition(target: initialTarget, zoom: 15),
            mapType: mapType,
            myLocationEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              PlaceProvider.of(context, listen: false).mapController = controller;
            },
            onCameraIdle: () {},
            onCameraMoveStarted: () {},
            onCameraMove: (CameraPosition position) {},
          ),
          Selector<PlaceProvider, PlaceDetails>(
            selector: (_, provider) => provider.selectedPlace,
            builder: (_, data, __) {
              if (data == null) {
                return Container();
              } else {
                if (selectedPlaceWidgetBuilder == null) {
                  return _buildFloatingCard(context, data);
                } else {
                  return Builder(builder: (builderContext) => selectedPlaceWidgetBuilder(builderContext, data));
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingCard(BuildContext context, PlaceDetails data) {
    return FloatingCard(
      bottomPosition: MediaQuery.of(context).size.height * 0.05,
      leftPosition: MediaQuery.of(context).size.width * 0.05,
      width: MediaQuery.of(context).size.width * 0.9,
      borderRadius: BorderRadius.circular(12.0),
      elevation: 4.0,
      color: Theme.of(context).brightness == Brightness.dark ? Colors.black54 : Colors.white,
      child: _buildSelectionDetails(context, data),
    );
  }

  Widget _buildSelectionDetails(BuildContext context, PlaceDetails details) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Text(
            details.formattedAddress,
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          MaterialButton(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Text(
              "이 위치 선택",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            color: Theme.of(context).buttonColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
            ),
            onPressed: () {
              Navigator.of(context).pop(details);
            },
          ),
        ],
      ),
    );
  }
}
