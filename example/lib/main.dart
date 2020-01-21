import 'package:flutter/material.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

// Your api key storage.
import 'keys.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Map Place Picer Demo',
      theme: ThemeData(
        buttonColor: Color(0xFF00bfa5),
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  static final kInitialPosition = LatLng(-33.8567844, 151.213108);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PlaceDetails selectedPlace;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Google Map Place Picer Demo"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                child: Text("Load Google Map"),
                onPressed: () async {
                  selectedPlace = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlacePicker(
                        apiKey: APIKeys.apiKey,
                        initialPosition: HomePage.kInitialPosition,
                        useCurrentLocation: true,
                        // selectedPlaceWidgetBuilder: (_, placeDetails) {
                        //   return FloatingCard(
                        //     bottomPosition: MediaQuery.of(context).size.height * 0.05,
                        //     leftPosition: MediaQuery.of(context).size.width * 0.05,
                        //     width: MediaQuery.of(context).size.width * 0.9,
                        //     borderRadius: BorderRadius.circular(12.0),
                        //     child: Text(placeDetails.formattedAddress),
                        //   );
                        // },
                      ),
                    ),
                  );
                  setState(() {});
                },
              ),
              selectedPlace == null ? Container() : Text(selectedPlace.formattedAddress ?? ""),
            ],
          ),
        ));
  }
}
