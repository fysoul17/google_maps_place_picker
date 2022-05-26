## [2.0.0-mb.19] - 26/May/2022

- Remove unnecessary null-aware operation `!` that throws a compiler warning since Flutter 3.0.1

## [2.0.0-mb.18] - 14/May/2022

- Update packages for Flutter 3.0.0

## [2.0.0-mb.17] - 28/Apr/2022

- Add custom zoom buttons

## [2.0.0-mb.16] - 21/Apr/2022

- Add [FVM](https://fvm.app) config
- Add `onMapTypeChanged` callback event

## [2.0.0-mb.15] - 06/Mar/2022

- Fix autocomplete search vertical offset in containers

## [2.0.0-mb.14] - 24/Feb/2022

- Update geolocator
- onMapCreated event pass-through

## [2.0.0-mb.13] - 08/Dec/2021

- Update google_maps_webservice
- Update geolocator

## [2.0.0-mb.11] - 16/Nov/2021

- Upgrade packages and target platforms

## [2.0.0-mb.10] - 25/Oct/2021

- Fix passing-through GoogleMap widget callbacks

## [2.0.0-mb.9] - 08/Sep/2021

- Fix permanent loading indicator when using search bar on iOS

## [2.0.0-mb.8] - 08/Sep/2021

- Fix old address showing up when moving the pin

## [2.0.0-mb.7] - 08/Sep/2021

- Remove automatic scrolling to pick area when trying to pick an invalid location
- Allow providing button texts
- Allow providing an introduction modal

## [2.0.0-mb.6] - 03/Sep/2021

- Add possibility to use custom back navigation event

## [2.0.0-mb.5] - 19/Aug/2021

- Provide additional `PlaceProvider` on some `GoogleMap` events

## [2.0.0-mb.4] - 19/Aug/2021

- Hot fix regarding `GoogleMap` event access

## [2.0.0-mb.3] - 19/Aug/2021

- Updated colors and shapes
- Expose essential `GoogleMap` events

## [2.0.0-mb.2] - 19/Aug/2021

- Fixed runtime and deploy issues on iOS

## [2.0.0-mb.1] - 18/Aug/2021

- Forked
- Added allowed pick area feature
- Improved place details widget

## [2.0.0-nullsafety.3] - 18/Mar/2021

- Updated google_maps_webservice to 0.0.20-nullsafety.2

## [2.0.0-nullsafety.2] - 17/Mar/2021

- Fixed bugs (PR #106, #108)

## [2.0.0-nullsafety.1] - 11/Mar/2021

- Updated to handle nullsafety.

## [2.0.0-nullsafety.0] - 08/Mar/2021

- Updated to solve nullsafety issues

## [1.0.1] - 23/Nov/2020

- Fixed bug related to infinite loading.

## [1.0.0] - 05/Oct/2020

- Updated google_maps_flutter version to 1.0.2 which is now out of developer preview.

## [0.10.0] - 09/Sep/2020

- Updated geolocator version to 6.0.0.
- Added permission package to improve checking permissions. Issue #66
- Added gestureRecognizers to make it possible to navigate the map when it's a child in a scroll view. Issue #52. Pull-request #64.
- Applied pull-request #67 (@Darkeyren)

## [0.9.5] - 02/Aug/2020

- Added [autocompleteOnTrailingWhitespace] parameter. Issue(Pull request) #54 (@therladbsgh)

## [0.9.4] - 21/Apr/2020

- Updated geolocator version to 5.3.1 which contains updated version of google_api_availability.

## [0.9.3] - 15/Apr/2020

- Updated google_maps_flutter package to 0.5.25+3

## [0.9.2] - 09/Apr/2020

- Added NSLocation Descriptions in order to avoid iOS error when using useCurrentLocation. (See Geolocator pacakge regarding iOS Settings)
- Added [automaticallyImplyAppBarLeading] parameter to allow removing back button on the app bar if needed. Issue #23

## [0.9.1] - 05/Apr/2020

- Added [forceSearchOnZoomChanged] parameter to allow place search even when the zoom has changed. Issue #21

## [0.9.0] - 11/Mar/2020

- Hot fix. DO NOT use 0.8.1 anymore.
- Fixed bug that auto complete search prediction layout is not displaying.

## [0.8.1] - 10/Mar/2020

- Added location service checking logic when using [useCurrentLocation].
- Added [forceAndroidLocationManager] parameter for GeoLocator package.
- Updated GeoLocator version to 5.3.0.
- Bug Fixed. Changing orientation of the device will not break UI of search prediction anymore. Issue #15

## [0.8.0] - 07/Mar/2020

- New feature. You can now set [initialSearchString] and [searchForInitialValue]. Issue(Pull Request) #14 (@moritzdouda)
- Bug Fixed. Changing orientation of the device will not break UI of Floating card anymore. Issue #15

## [0.7.1] - 06/Mar/2020

- Bug Fixed. [autoCompleteLanguage] will now display the correct result.

## [0.7.0] - 25/Feb/2020

- Bug Fixed. Fixed throwing rendering exception when [useCurrentLocation] is set to false. Issue #11.
- [initialPosition] has been set to Required paramater since Google Map needs at least one initial position of the camera. Issue #10.

## [0.6.4] - 22/Feb/2020

- Feature added. You can set resizeToAvoidBottomInset for the scaffold to avoid resizing screen when keyboard is shown.
- Example modified. Removed MediaQuery.of(context) from the example as it will cause rebuild.

## [0.6.3] - 20/Feb/2020

- Feature added. Now, initial position of the map can be 'selected' automatically.

## [0.6.2] - 17/Feb/2020

- Fixed bug. Map icons are now positioned correctly.
- Fixed iOS obsoleted in swift 4.2 issue for the example.

## [0.6.1] - 6/Feb/2020

- Added region option for auto-complete search.
- Updated README.md for added parameters.

## [0.6.0] - 5/Feb/2020

- Added options for auto-complete search. Now you can narrow down the result using offset, radius, language, types, components and strictbounds.
- Updated README.md for added parameters.

## [0.5.1] - 3/Feb/2020

- Minor bug Fix.

## [0.5.0] - 31/Jan/2020

- Added 'usePinPointingSearch' option. Setting it to false will not allow user to get a place info with map dragging. Defaults to true.
- Added 'usePlaceDetailSearch' option. Setting this to true will get detailed result from searching by dragging the map, but will use +1 request on Place Detail API. Defaults to false.
- Fixed bug of not returning Searching state to 'selectedPlaceWidgetBuilder'.
- Fixed bug of unnecessary search (issue #4). No extra searching will be performed from now when camera is moved by auto-complete search.

## [0.4.0] - 29/Jan/2020

- Fixed bug that autoComplete search prediction is remaining on screen when poping from map page. (Issue #3)
- Search bar no longer relies on appBarRenderBox height. Position is fixed to 86 on top.
- Added example for changing colour
- AutoComplete search prediction's title colour now relies on Theme.of(context).textTheme.title.color

## [0.3.0] - 27/Jan/2020

- The colors of FloatingCard (Prediction tile on the map) can be controlled by Theme Data.
- Fixed back button for iOS (StanfordLin).
- Pin color will be default to [Red] from now. You can still customize your pin using pinBuilder if you don't like default style ;).

## [0.2.2] - 24/Jan/2020

- Updated example to apply changed function

## [0.2.1] - 24/Jan/2020

- Updated README for more information about result callback

## [0.2.0] - 24/Jan/2020

- Added onResult callback. Now we can listen for the callback to get the result instead of using Navigator callback.

## [0.1.4] - 23/Jan/2020

- Updated additional information regarding 'PickResult' data
- Fixed typo

## [0.1.3] - 23/Jan/2020

- Updated additional information regarding 'geolocator' settings

## [0.1.2] - 23/Jan/2020

- flutter format for suggested files

## [0.1.1] - 23/Jan/2020

- flutter format for suggested files
- Re-write package description

## [0.1.0] - 23/Jan/2020

- Update parameter info
- Map buttons added

## [0.0.3] - 22/Jan/2020

- Added function. Picking place by dragging camera
- Bug fix: minor
- Fix typo

## [0.0.2] - 20/Jan/2020

- Refactoring

## [0.0.1] - 19/Jan/2020

- Initial release
