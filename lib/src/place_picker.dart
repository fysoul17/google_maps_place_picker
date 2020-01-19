import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/providers/place_provider.dart';
import 'package:google_maps_place_picker/src/google_map_place_picker.dart';
import 'package:provider/provider.dart';

class PlacePicker extends StatelessWidget {
  PlacePicker({
    Key key,
    @required this.initialPosition,
  }) : super(key: key);

  final LatLng initialPosition;

  @override
  Widget build(BuildContext context) {
    print(">>> Build [PlacePicker] Page");

    return ChangeNotifierProvider(
      create: (_) => PlaceProvider(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
            ),
            body: GoogleMapPlacePicker(
              initialTarget: initialPosition,
            ),
          );
        },
      ),
    );
  }
}
