import 'package:flutter/material.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// ignore: implementation_imports, unused_import
import 'package:google_maps_place_picker_mb/src/google_map_place_picker.dart'; // do not import this yourself
import 'dart:io' show Platform;

// Your api key storage.
import 'keys.dart';

// Only to control hybrid composition and the renderer in Android
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // Light Theme
  final ThemeData lightTheme = ThemeData.light().copyWith(
    // Background color of the FloatingCard
    cardColor: Colors.white,
  );

  // Dark Theme
  final ThemeData darkTheme = ThemeData.dark().copyWith(
    // Background color of the FloatingCard
    cardColor: Colors.grey,
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Map Place Picker Demo',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.light,
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  static final kInitialPosition = LatLng(-33.8567844, 151.213108);

  final GoogleMapsFlutterPlatform mapsImplementation =
      GoogleMapsFlutterPlatform.instance;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PickResult? selectedPlace;
  bool _showPlacePickerInContainer = false;
  bool _showGoogleMapInContainer = false;

  bool _mapsInitialized = false;
  String _mapsRenderer = "latest";

  void initRenderer() {
    if (_mapsInitialized) return;
    if (widget.mapsImplementation is GoogleMapsFlutterAndroid) {
      switch (_mapsRenderer) {
        case "legacy":
          (widget.mapsImplementation as GoogleMapsFlutterAndroid)
              .initializeWithRenderer(AndroidMapRenderer.legacy);
          break;
        case "latest":
          (widget.mapsImplementation as GoogleMapsFlutterAndroid)
              .initializeWithRenderer(AndroidMapRenderer.latest);
          break;
      }
    }
    setState(() {
      _mapsInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Google Map Place Picker Demo"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!_mapsInitialized &&
                      widget.mapsImplementation
                          is GoogleMapsFlutterAndroid) ...[
                    Switch(
                        value: (widget.mapsImplementation
                                as GoogleMapsFlutterAndroid)
                            .useAndroidViewSurface,
                        onChanged: (value) {
                          setState(() {
                            (widget.mapsImplementation
                                    as GoogleMapsFlutterAndroid)
                                .useAndroidViewSurface = value;
                          });
                        }),
                    Text("Hybrid Composition"),
                  ]
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!_mapsInitialized &&
                      widget.mapsImplementation
                          is GoogleMapsFlutterAndroid) ...[
                    Text("Renderer: "),
                    Radio(
                        groupValue: _mapsRenderer,
                        value: "auto",
                        onChanged: (value) {
                          setState(() {
                            _mapsRenderer = "auto";
                          });
                        }),
                    Text("Auto"),
                    Radio(
                        groupValue: _mapsRenderer,
                        value: "legacy",
                        onChanged: (value) {
                          setState(() {
                            _mapsRenderer = "legacy";
                          });
                        }),
                    Text("Legacy"),
                    Radio(
                        groupValue: _mapsRenderer,
                        value: "latest",
                        onChanged: (value) {
                          setState(() {
                            _mapsRenderer = "latest";
                          });
                        }),
                    Text("Latest"),
                  ]
                ],
              ),
              !_showPlacePickerInContainer
                  ? ElevatedButton(
                      child: Text("Load Place Picker"),
                      onPressed: () {
                        initRenderer();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return PlacePicker(
                                resizeToAvoidBottomInset:
                                    false, // only works in page mode, less flickery
                                apiKey: Platform.isAndroid
                                    ? APIKeys.androidApiKey
                                    : APIKeys.iosApiKey,
                                hintText: "Find a place ...",
                                searchingText: "Please wait ...",
                                selectText: "Select place",
                                outsideOfPickAreaText: "Place not in area",
                                initialPosition: HomePage.kInitialPosition,
                                useCurrentLocation: true,
                                selectInitialPosition: true,
                                usePinPointingSearch: true,
                                usePlaceDetailSearch: true,
                                zoomGesturesEnabled: true,
                                zoomControlsEnabled: true,
                                onMapCreated: (GoogleMapController controller) {
                                  print("Map created");
                                },
                                onPlacePicked: (PickResult result) {
                                  print(
                                      "Place picked: ${result.formattedAddress}");
                                  setState(() {
                                    selectedPlace = result;
                                    Navigator.of(context).pop();
                                  });
                                },
                                onMapTypeChanged: (MapType mapType) {
                                  print(
                                      "Map type changed to ${mapType.toString()}");
                                },
                                // #region additional stuff
                                // forceSearchOnZoomChanged: true,
                                // automaticallyImplyAppBarLeading: false,
                                // autocompleteLanguage: "ko",
                                // region: 'au',
                                // pickArea: CircleArea(
                                //   center: HomePage.kInitialPosition,
                                //   radius: 300,
                                //   fillColor: Colors.lightGreen
                                //       .withGreen(255)
                                //       .withAlpha(32),
                                //   strokeColor: Colors.lightGreen
                                //       .withGreen(255)
                                //       .withAlpha(192),
                                //   strokeWidth: 2,
                                // ),
                                // selectedPlaceWidgetBuilder: (_, selectedPlace, state, isSearchBarFocused) {
                                //   print("state: $state, isSearchBarFocused: $isSearchBarFocused");
                                //   return isSearchBarFocused
                                //       ? Container()
                                //       : FloatingCard(
                                //           bottomPosition: 0.0, // MediaQuery.of(context) will cause rebuild. See MediaQuery document for the information.
                                //           leftPosition: 0.0,
                                //           rightPosition: 0.0,
                                //           width: 500,
                                //           borderRadius: BorderRadius.circular(12.0),
                                //           child: state == SearchingState.Searching
                                //               ? Center(child: CircularProgressIndicator())
                                //               : ElevatedButton(
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
                                // introModalWidgetBuilder: (context,  close) {
                                //   return Positioned(
                                //     top: MediaQuery.of(context).size.height * 0.35,
                                //     right: MediaQuery.of(context).size.width * 0.15,
                                //     left: MediaQuery.of(context).size.width * 0.15,
                                //     child: Container(
                                //       width: MediaQuery.of(context).size.width * 0.7,
                                //       child: Material(
                                //         type: MaterialType.canvas,
                                //         color: Theme.of(context).cardColor,
                                //         shape: RoundedRectangleBorder(
                                //             borderRadius: BorderRadius.circular(12.0),
                                //         ),
                                //         elevation: 4.0,
                                //         child: ClipRRect(
                                //           borderRadius: BorderRadius.circular(12.0),
                                //           child: Container(
                                //             padding: EdgeInsets.all(8.0),
                                //             child: Column(
                                //               children: [
                                //                 SizedBox.fromSize(size: new Size(0, 10)),
                                //                 Text("Please select your preferred address.",
                                //                   style: TextStyle(
                                //                     fontWeight: FontWeight.bold,
                                //                   )
                                //                 ),
                                //                 SizedBox.fromSize(size: new Size(0, 10)),
                                //                 SizedBox.fromSize(
                                //                   size: Size(MediaQuery.of(context).size.width * 0.6, 56), // button width and height
                                //                   child: ClipRRect(
                                //                     borderRadius: BorderRadius.circular(10.0),
                                //                     child: Material(
                                //                       child: InkWell(
                                //                         overlayColor: MaterialStateColor.resolveWith(
                                //                           (states) => Colors.blueAccent
                                //                         ),
                                //                         onTap: close,
                                //                         child: Row(
                                //                           mainAxisAlignment: MainAxisAlignment.center,
                                //                           children: [
                                //                             Icon(Icons.check_sharp, color: Colors.blueAccent),
                                //                             SizedBox.fromSize(size: new Size(10, 0)),
                                //                             Text("OK",
                                //                               style: TextStyle(
                                //                                 color: Colors.blueAccent
                                //                               )
                                //                             )
                                //                           ],
                                //                         )
                                //                       ),
                                //                     ),
                                //                   ),
                                //                 )
                                //               ]
                                //             )
                                //           ),
                                //         ),
                                //       ),
                                //     )
                                //   );
                                // },
                                // #endregion
                              );
                            },
                          ),
                        );
                      },
                    )
                  : Container(),
              !_showPlacePickerInContainer
                  ? ElevatedButton(
                      child: Text("Load Place Picker in Container"),
                      onPressed: () {
                        initRenderer();
                        setState(() {
                          _showPlacePickerInContainer = true;
                        });
                      },
                    )
                  : Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      height: MediaQuery.of(context).size.height * 0.35,
                      child: PlacePicker(
                          forceAndroidLocationManager: true,
                          apiKey: Platform.isAndroid
                              ? APIKeys.androidApiKey
                              : APIKeys.iosApiKey,
                          hintText: "Find a place ...",
                          searchingText: "Please wait ...",
                          selectText: "Select place",
                          initialPosition: HomePage.kInitialPosition,
                          useCurrentLocation: true,
                          selectInitialPosition: true,
                          usePinPointingSearch: true,
                          usePlaceDetailSearch: true,
                          zoomGesturesEnabled: true,
                          zoomControlsEnabled: true,
                          onPlacePicked: (PickResult result) {
                            setState(() {
                              selectedPlace = result;
                              _showPlacePickerInContainer = false;
                            });
                          },
                          onTapBack: () {
                            setState(() {
                              _showPlacePickerInContainer = false;
                            });
                          })),
              if (selectedPlace != null) ...[
                Text(selectedPlace!.formattedAddress!),
                Text("(lat: " +
                    selectedPlace!.geometry!.location.lat.toString() +
                    ", lng: " +
                    selectedPlace!.geometry!.location.lng.toString() +
                    ")"),
              ],
              // #region Google Map Example without provider
              _showPlacePickerInContainer
                  ? Container()
                  : ElevatedButton(
                      child: Text("Toggle Google Map w/o Provider"),
                      onPressed: () {
                        initRenderer();
                        setState(() {
                          _showGoogleMapInContainer =
                              !_showGoogleMapInContainer;
                        });
                      },
                    ),
              !_showGoogleMapInContainer
                  ? Container()
                  : Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      height: MediaQuery.of(context).size.height * 0.25,
                      child: GoogleMap(
                        zoomGesturesEnabled: false,
                        zoomControlsEnabled: false,
                        myLocationButtonEnabled: false,
                        compassEnabled: false,
                        mapToolbarEnabled: false,
                        initialCameraPosition: new CameraPosition(
                            target: HomePage.kInitialPosition, zoom: 15),
                        mapType: MapType.normal,
                        myLocationEnabled: true,
                        onMapCreated: (GoogleMapController controller) {},
                        onCameraIdle: () {},
                        onCameraMoveStarted: () {},
                        onCameraMove: (CameraPosition position) {},
                      )),
              !_showGoogleMapInContainer ? Container() : TextField(),
              // #endregion
            ],
          ),
        ));
  }
}
