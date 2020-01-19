import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class PlaceProvider extends ChangeNotifier {
  static PlaceProvider of(BuildContext context, {bool listen = true}) => Provider.of<PlaceProvider>(context, listen: listen);

  LatLng _lastIdleLocation;

  LatLng get lastIdleLocation => _lastIdleLocation;

  void setLastIdleLocation(LatLng lastIdleLocation) {
    if (_lastIdleLocation != lastIdleLocation) {
      _lastIdleLocation = lastIdleLocation;
      notifyListeners();
    }
  }
}
