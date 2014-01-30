//
//  BSNViewController.m
//  BlueBar iBeacon Demo
//
//  Created by Vladimir Petrov on 15/01/2014.
//  Copyright (c) 2014 Blue Sense Networks. All rights reserved.
//

#import "BSNViewController.h"

@interface BSNViewController ()

@end

@implementation BSNViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.currentState = 0;
    self.filterBuffer = [[NSMutableArray alloc] init];
    
    // Initialize location manager and set ourselves as the delegate
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    // Create a NSUUID with the same UUID as the broadcasting beacon
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"A0B13730-3A9A-11E3-AA6E-0800200C9A66"];
    
    // Setup a new region with that UUID and same identifier as the broadcasting beacon
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                             identifier:@"BlueBar Beacon Region"];
    
    // Tell location manager to start monitoring for the beacon region
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
    
    // Check if beacon monitoring is available for this device
    if (![CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Monitoring not available" message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil]; [alert show]; return;
    }

    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)displayImage:(NSString*) imageName
{
    NSString* fullPath = [imageName stringByAppendingString:@"@2x.png"];

    UIImage* image = [UIImage imageNamed: fullPath];
    [self.offerDisplay setImage: image forState: UIControlStateNormal];
}


- (IBAction)TouchUpInside:(id)sender {
    if (self.currentState != 1)
        return;
    
    NSURL* url = [[NSURL alloc] initWithString:@"http://BlueSenseNetworks.com"];
    [[UIApplication sharedApplication] openURL:url];
}

- (void)locationManager:(CLLocationManager*)manager didEnterRegion:(CLRegion *)region
{
    // Entered a region
}

-(void)locationManager:(CLLocationManager*)manager didExitRegion:(CLRegion *)region
{
    // Exited the region
}

-(void)locationManager:(CLLocationManager*)manager
       didRangeBeacons:(NSArray*)beacons
              inRegion:(CLBeaconRegion*)region
{
    // Beacon found!
    CLBeacon *foundBeacon = [beacons firstObject];
    if (foundBeacon == nil)
        return;
    
    [self.filterBuffer enqueue:foundBeacon];
    if (self.filterBuffer.count < 10)
    {
        [self displayImage:@"Welcome"];
        return;
    }
    
    [self.filterBuffer dequeue];
    
    NSInteger minImmediateProximitySightings = 0;
    for (NSInteger i=0; i < self.filterBuffer.count; i++) {
        CLProximity proximity = ((CLBeacon*)self.filterBuffer[i]).proximity;
        if (proximity == CLProximityNear || proximity == CLProximityImmediate)
            minImmediateProximitySightings++;
    }
    
    if (minImmediateProximitySightings > 5)
    {
        self.currentState = 1;
        [self displayImage:@"Offer"];
    }
    else
    {
        self.currentState = 0;
        [self displayImage:@"Welcome"];
    }
    
    // You can retrieve the beacon data from its properties
    //NSString *uuid = foundBeacon.proximityUUID.UUIDString;
    //NSString *major = [NSString stringWithFormat:@"%@", foundBeacon.major];
    //NSString *minor = [NSString stringWithFormat:@"%@", foundBeacon.minor];
}

@end
