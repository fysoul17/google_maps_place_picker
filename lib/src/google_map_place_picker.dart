import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapPlacePicker extends StatelessWidget {
  const GoogleMapPlacePicker({
    Key key,
    @required this.initialTarget,
    this.mapType = MapType.normal,
  }) : super(key: key);

  final LatLng initialTarget;
  final MapType mapType;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: <Widget>[
          GoogleMap(
            initialCameraPosition: CameraPosition(target: initialTarget, zoom: 15),
            mapType: mapType,
            myLocationEnabled: true,
            onMapCreated: (GoogleMapController controller) {},
            onCameraIdle: () {},
            onCameraMoveStarted: () {},
            onCameraMove: (CameraPosition position) {},
          ),
        ],
      ),
    );
  }
}
