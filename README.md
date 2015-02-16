# iOS


BlueBar SDK, support code and code samples for iOS.
Copyright 2014 [Blue Sense Networks](http://bluesensenetworks.com)

## Building

1. Make sure you have [CocoaPods](http://cocoapods.org/) installed on your Mac;
2. Run "pod install" in a terminal from within the project folder of a specific app you want to build in order to update all project dependencies;
3. Open the corresponding ".xcworkspace" file in Xcode instead of the .xcodeproj file, in order to use the prebuilt configurations by CocoaPods;



## SDK

The SDK folder contains the following projects:
- BlueBarSDK - SDK for BlueBar beacons configuration and ranging;
- BlueBar Configuration Utility app - allows for easy integration into existing systems or easy rebranding as your own configuration app

Installation
-------

The best way to use the SDK is to use [CocoaPods](http://cocoapods.org/). Include the following line into your Podfile

```
pod 'BlueBarSDK'
```


## Samples

The Samples folder contains several small projects illustrating different aspects of using iBeacon, the BlueBar Beacon and the BlueBarSDK

1. BlueBar iBeacon Demo app - A simple app to display an offer banner when coming in Immediate proximity of a BlueBar iBeacon.
Features:
- Demonstrates simple use of iOS CoreLocation ranging functionality;
- Does simple filtering on sightings to limit the effect of “bad” values, reported by iOS

Known limitations:
- Takes into account only the closest beacon it detects;

2. BlueBar Beacon Locator - an app that demonstrates simple ranging functionality for the factory default BlueBar Beacon UUID

3. Campaign Demo - app that demonstrates integration with BlueBarSDK in order to run proximity campaigns powered by [ProximitySense](http://ProximitySense.com) in a 3rd party app.
