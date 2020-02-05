## [0.6.0] - 5/Feb/2020

- Added options for auto complete search. Now you can narrow down the result using offset, radius, language, types, components and strictbounds.
- Updated README.md for added parameters.

## [0.5.1] - 3/Feb/2020

- Minor bug Fix.

## [0.5.0] - 31/Jan/2020

- Added 'usePinPointingSearch' option. Setting it to false will not allow user get a place info with map dragging. Defaults to true.
- Added 'usePlaceDetailSearch' option. Setting this to true will get detailed result from searching by dragging the map, but will use +1 request on Place Detail API. Defailts to false.
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
