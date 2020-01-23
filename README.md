# Google Maps Place Picker

A Flutter plugin which provides 'Picking Place' using [Google Maps](https://developers.google.com/maps/) widget.

The project relies on below packages.

Map using Flutter's official [google_maps_flutter](https://pub.dev/packages/google_maps_flutter)
Fetching current location using Baseflow's [geolocator](https://pub.dev/packages/geolocator)
Place and Geocoding API using hadrienlejard's [google_maps_webservice](https://pub.dev/packages/google_maps_webservice)
Builder using kevmoo's [tuple](https://pub.dev/packages/tuple)

## Support
If the package was useful or saved your time, please do not hesitate to buy me a cup of coffee! ;)  
The more caffeine I get, the more useful projects I can make in the future. 

<a href="https://www.buymeacoffee.com/Oj17EcZ" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png" alt="Buy Me A Coffee" style="height: 41px !important;width: 174px !important;box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;-webkit-box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;" ></a>

## Getting Started

Get an API key at <https://cloud.google.com/maps-platform/>.

### Android

Specify your API key in the application manifest `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest ...
  <application ...
    <meta-data android:name="com.google.android.geo.API_KEY"
               android:value="YOUR KEY HERE"/>
```

### iOS

Specify your API key in the application delegate `ios/Runner/AppDelegate.m`:

```objectivec
#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import "GoogleMaps/GoogleMaps.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GMSServices provideAPIKey:@"YOUR KEY HERE"];
  [GeneratedPluginRegistrant registerWithRegistry:self];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}
@end
```

Or in your swift code, specify your API key in the application delegate `ios/Runner/AppDelegate.swift`:

```swift
import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("YOUR KEY HERE")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```
Opt-in to the embedded views preview by adding a boolean property to the app's `Info.plist` file
with the key `io.flutter.embedded_views_preview` and the value `YES`.

## Usage

### Basic usage

You can use PlacePicker by pushing to a new page using Navigator.
When the use picks a place on the map, it will return the result (PickResult).

```dart
PickResult selectedPlace = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PlacePicker(
                                  apiKey: APIKeys.apiKey,   // Put YOUR OWN KEY here.
                                  initialPosition: HomePage.kInitialPosition,
                                  useCurrentLocation: true,
                                ),
                              ),
                            );
```

Parameter | Type | Description
--------- | ---- | -----------
apiKey | String | (Required) Your google map API Key
initialPosition | LatLng | Initial center position of google map when it is created. If useCurrentLocation is set to true, it will try to get device's current location first using GeoLocator.
useCurrentLocation | bool | Whether to use device's current location for initial center position
desiredLocationAccuracy | [LocationAccuracy](https://pub.dev/packages/geolocator) | Accuracy of fetching current location. Default to 'high'.
hintText | String | Hint text of search bar
searchingText | String | A text which appears when searching is performing. Default to 'Searching...'
searchBarHeight | double | Height of search bar. Default 40. Recommended using together with contentPadding.
contentPadding | EdgeInsetsGeomery | content padding of search bar input textField's InputDecoration
proxyBaseUrl | String | Used for API calling on google maps. In case of using a proxy the baseUrl can be set. The apiKey is not required in case the proxy sets it.
httpClient | [Client](https://pub.dev/packages/google_maps_webservice) | Used for API calling on google maps. In case of using a proxy url that requires authentication or custom configuration.
autoCompleteDebounceInMilliseconds | int | Debounce timer for auto complete input. Default 500
cameraMoveDebounceInMilliseconds | int | Debounce timer for searching place with camera(map) dragging. Default 750
intialMapType | MapType | MapTypes of google map. Default normal.
enableMapTypeButton | bool | Whether to display MapType change button on the map
enableMyLocationButton | bool | Whether to display my location button on the map
onAutoCompleteFailed | Callback(String) | Invoked when auto complete search is failed
onGeocodingSearchFailed | Callback(String) | Invoked when searching place by dragging the map failed
onMapCreated | MapCreatedCallback | Returens google map controller when created
selectedPlaceWidgetBuilder | WidgetBuilder | Specified on below section
pinBuilder | WidgetBuilder | Specified on below section


### Customzing picked place visualisation

By default, when a user picks a place by using auto complete search or dragging the map, we display the information at the bottom of the screen (FloatingCard).  

However, if you don't like this UI/UX, simple override the builder using 'selectedPlaceWidgetBuilder'. FlocatingCard widget can be reused which floating around the screen or build entirly new widget as you want. It is stacked with the map, so you might want to use [Positioned](https://api.flutter.dev/flutter/widgets/Positioned-class.html) widget.

```dart
...
PlacePicker(apiKey: APIKeys.apiKey,
            ...
            selectedPlaceWidgetBuilder: (_, selectedPlace, state, isSearchBarFocused) {
              return isSearchBarFocused
                  ? Container()
                  // Use FloatingCard or just create your own Widget.
                  : FloatingCard(
                      bottomPosition: MediaQuery.of(context).size.height * 0.05,
                      leftPosition: MediaQuery.of(context).size.width * 0.05,
                      width: MediaQuery.of(context).size.width * 0.9,
                      borderRadius: BorderRadius.circular(12.0),
                      child: state == SearchingState.Searching ? 
                                      Center(child: CircularProgressIndicator()) : 
                                      RaisedButton(onPressed: () { Navigator.of(context).pop(selectedPlace); },),
                   );
            },
            ...
          ),
...
```
Parameters | Type | Description
---------- | ---- | -----------
context | BuildContext | Flutter's build context value
selectedPlace | PickResult | Result data of user selected place
state | SearchingState | State of searching action. (Idle, Searching)
isSearchBarFocused | bool | Whether the search bar is currently focused so the keyboard is shown

### Customizing Pin
By default, Pin icon is provided with very simple picking animation when moving around.   
However, you can also create your own pin widget using 'pinBuilder'

```dart
PlacePicker(apiKey: APIKeys.apiKey,
            ...
            pinBuilder: (context, state) {
                  if (state == PinState.Idle) {
                    return Icon(Icons.favorite_border);
                  } else {
                    return AnimatedIcon(.....);
                  }
                },
            ...                        
          ),
...
```

Parameters | Type | Description
---------- | ---- | -----------
context | BuildContext | Flutter's build context value
state | PinState | State of pin. (Preparing; When map loading, Idle, Dragging)

## Feature Requests and Issues
Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/fysoul17/google_maps_place_picker/issues/new

<a href="https://www.buymeacoffee.com/Oj17EcZ" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png" alt="Buy Me A Coffee" style="height: 41px !important;width: 174px !important;box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;-webkit-box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;" ></a>
