//
//  CalibrateViewController.m
//  BlueBar Configuration Utility
//
//  Created by Vladimir Petrov on 01/10/2014.
//  Copyright (c) 2014 Blue Sense Networks. All rights reserved.
//

#import "BlueBarSDK.h"
#import "CalibrateViewController.h"

@interface CalibrateViewController () <BeaconCalibrationProgressDelegate>

@end

@implementation CalibrateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView.contentSize = CGSizeMake(320, 550);
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.beacon)
    {
        self.beaconName.text = self.beacon.name;
        self.beaconSerial.text = self.beacon.serial;
    }
    
    self.progress.hidden = YES;
    self.rssi.hidden = YES;

    [[BlueBarSDK Calibration] setCalibrationProgressDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setBeacon:(DetectedBeacon *)newBeacon
{
    if (_beacon != newBeacon)
    {
        _beacon = newBeacon;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)startCalibration:(id)sender {
    
    if (![BlueBarSDK Calibration].isCalibrating)
    {
        [[BlueBarSDK Calibration] setCalibrationProgressDelegate:self];
        [[BlueBarSDK Calibration] startCalibrationFor:self.beacon];
    }
    else
    {
        [[BlueBarSDK Calibration] stopCalibration];
    }
}

- (IBAction)back:(id)sender {
    [[BlueBarSDK Calibration] stopCalibration];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) calibrationProgressChanged:(NSInteger)progress withRssi:(NSNumber*)currentRssi
{
    [self.progress setProgress:(progress / 100.0) animated:NO];
    self.rssi.text = currentRssi.stringValue;
}

- (void) calibrationStarted
{
    [self.btnStart setTitle:@"Stop" forState:UIControlStateNormal];
    
    self.progress.hidden = NO;
    self.rssi.hidden = NO;
}

- (void) calibrationStopped
{
    [self.btnStart setTitle:@"Retry" forState:UIControlStateNormal];
    
    self.progress.hidden = YES;
}

- (void) calibrationFinished:(NSInteger)calibratedValue
{
    self.beacon.configuration.calibrationValue = [[NSNumber alloc]initWithInteger:calibratedValue];
    self.beacon.configuration.calibrationChanged = YES;
    
    self.rssi.text = self.beacon.configuration.calibrationValue.stringValue;
}

@end
