//
//  ViewController.m
//  Virtual iBeacon
//
//  Created by Vladimir Petrov on 08/10/2014.
//  Copyright (c) 2014 Blue Sense Networks. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.uuid.text = @"A0B13730-3A9A-11E3-AA6E-0800200C9A66";
    self.major.text = @"32895";
    self.minor.text = @"16220";
    
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self
                                                                     queue:nil
                                                                   options:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    if (peripheral.state == CBPeripheralManagerStatePoweredOff) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Bluetooth is Off" message:@"Please turn Bluetooth On to be able to advertise" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

- (IBAction)onStart:(id)sender {
    
    self.isStarted = !self.isStarted;

    if (self.isStarted)
    {
        [self.btnStart setTitle:@"Stop" forState:UIControlStateNormal];
        [self startBroadcasting];
    }
    else
    {
        [self.btnStart setTitle:@"Start" forState:UIControlStateNormal];
        [self stopBroadcasting];
    }
}

- (void) startBroadcasting
{
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:self.uuid.text];
    NSInteger major = self.major.text.integerValue;
    NSInteger minor = self.minor.text.integerValue;
    
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                                major:major
                                                                minor:minor
                                                           identifier:@"com.bluesensenetworks.samples.virtual.ibeacon"];
    
    self.beaconPeripheralData = [self.beaconRegion peripheralDataWithMeasuredPower:nil];
    
    [self.peripheralManager startAdvertising:self.beaconPeripheralData];
}

- (void) stopBroadcasting
{
    [self.peripheralManager stopAdvertising];
}

@end
