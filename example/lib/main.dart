import 'package:flutter/material.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// Your api key storage.
import 'keys.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Map Place Picer Demo',

      // Example of changing theme for FloatingCard and texts.
      theme: ThemeData.dark().copyWith(
        // Background color of the FloatingCard
        cardColor: Colors.grey,
        buttonTheme: ButtonThemeData(
          // Select here's button color
          buttonColor: Colors.yellow,
          // Applying this will automatically change text color based on buttonColor. (Button color is dark ? white / is light ? black)
          textTheme: ButtonTextTheme.primary,
        ),
        textTheme: TextTheme(
          // This will change the address(text) color of FloatingCard
          body1: TextStyle(color: Colors.white),
        ),
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
  PickResult selectedPlace;

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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlacePicker(
                        apiKey: APIKeys.apiKey,
                        initialPosition: HomePage.kInitialPosition,
                        useCurrentLocation: true,
                        onPlacePicked: (result) {
                          selectedPlace = result;
                          Navigator.of(context).pop();
                          setState(() {});
                        },
                        // selectedPlaceWidgetBuilder: (_, selectedPlace, state, isSearchBarFocused) {
                        //   return isSearchBarFocused
                        //       ? Container()
                        //       : FloatingCard(
                        //           bottomPosition: MediaQuery.of(context).size.height * 0.05,
                        //           leftPosition: MediaQuery.of(context).size.width * 0.05,
                        //           width: MediaQuery.of(context).size.width * 0.9,
                        //           borderRadius: BorderRadius.circular(12.0),
                        //           child: state == SearchingState.Searching
                        //               ? Center(child: CircularProgressIndicator())
                        //               : RaisedButton(
                        //                   child: Text("Pick Here"),
                        //                   onPressed: () {
                        //                     // IMPORTANT: You MUST manage selectedPlace data yourself as using this build will not invoke onPlacePicker as
                        //                     //            this will override default 'Select here' Button.
                        //                     print("do something with [selectedPlace] data");
                        //                     Navigator.of(context).pop();
                        //                   },
                        //                 ),
                        //         );
                        // },
                        // pinBuilder: (context, state) {
                        //   if (state == PinState.Idle) {
                        //     return Icon(Icons.favorite_border);
                        //   } else {
                        //     return Icon(Icons.favorite);
                        //   }
                        // },
                      ),
                    ),
                  );
                },
              ),
              selectedPlace == null
                  ? Container()
                  : Text(selectedPlace.address ?? ""),
            ],
          ),
        ));
  }
}
