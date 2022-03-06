# Example

Example project of Google Maps Place Picker

## Preparation

Search for files ending with `.example` and copy them in the same location without the `.example` suffix. Then, replace `YOUR ### KEY HERE` with your Google Maps API key in those files.

> You can also just run this bash from the example directory (replace curly braces closed placeholders with your keys):
> 
> ```bash
> \cp lib/keys.dart.example lib/keys.dart
> \cp android/app/src/main/AndroidManifest.xml.example android/app/src/main/AndroidManifest.xml
> \cp ios/Runner/AppDelegate.swift.example ios/Runner/AppDelegate.swift
> sed -i '' 's/YOUR ANDROID KEY HERE/{YOUR ANDROID KEY HERE}/g' lib/keys.dart android/app/src/main/AndroidManifest.xml
> sed -i '' 's/YOUR IOS KEY HERE/{YOUR IOS KEY HERE}/g' lib/keys.dart ios/Runner/AppDelegate.swift
> ```