# iOS


BlueBar Beacon SDK, ProximitySense SDK, support code and code samples for iOS.
Copyright 2014 [Blue Sense Networks](http://bluesensenetworks.com)

## Building

1. Make sure you have [CocoaPods](http://cocoapods.org/) installed on your Mac;
2. Run "pod install" in a terminal from within the project folder of a specific app you want to build in order to update all project dependencies;
3. Open the corresponding ".xcworkspace" file in Xcode instead of the .xcodeproj file, in order to use the prebuilt configurations by CocoaPods;


## SDKs

The SDK folder contains the following projects:
- BlueBarSDK - SDK for BlueBar beacons detection, configuration and calibration;
- BlueBar Configuration Utility app - allows for easy integration into existing systems or easy rebranding as your own configuration app
- ProximitySenseSDK - SDK to integrate with [ProximitySense](http://proximitysense.com), the proximity services cloud platform by [Blue Sense Networks](http://bluesensenetworks.com);

Installation
-------

The best way to use the SDKs is to use [CocoaPods](http://cocoapods.org/). 

To use the BlueBarSDK include the following line into your Podfile
```
pod 'BlueBarSDK'
```

For ProximitySenseSDK include the following line into your Podfile
```
pod 'ProximitySenseSDK'
```

## Samples

The Samples folder contains several small projects illustrating different aspects of using iBeacon, the BlueBar Beacon, 
the BlueBarSDK and the ProximitySenseSDK; 

1. BlueBar iBeacon Demo app - A simple app to display an offer banner when coming in Immediate proximity of a BlueBar iBeacon.
Features:
 - Demonstrates simple use of iOS CoreLocation ranging functionality;
 - Does simple filtering on sightings to limit the effect of “bad” values, reported by iOS

 Known limitations:
 - Takes into account only the closest beacon it detects;

2. BlueBar Beacon Locator - an app that demonstrates simple ranging functionality for the factory default BlueBar Beacon UUID;

3. Virtual iBeacon - an app that demostrates how to make an iOS device broadcast as iBeacon; 

4. ProximitySense Campaign Demo - app that demonstrates integration with ProximitySenseSDK in order to run proximity campaigns powered by [ProximitySense](http://ProximitySense.com) in a 3rd party app.
