//
//  Created by Nicolas Flacco on 11/24/14.
//  Copyright (c) 2014 Nicolas Flacco. All rights reserved.
//

#import "BeaconEmulator.h"
@import CoreLocation;
@import CoreBluetooth;

// Define some constants
#define BEACON_SERVICE_NAME     @"demo"
#define BEACON_PROXIMITY_UUID   [[NSUUID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57F666"]

@interface BeaconEmulator () <CBPeripheralManagerDelegate>

@property (nonatomic, strong) CBPeripheralManager *peripheralManager;
@property (nonatomic) int major;
@property (nonatomic) int minor;
@property (nonatomic) BOOL scheduleBroadcast;

@end

@implementation BeaconEmulator

+ (instancetype)sharedInstance
{
    static BeaconEmulator *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[BeaconEmulator alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:nil];
    }
    return self;
}

- (void)broadcastBeaconWithMajor:(UInt16)major minor:(UInt16)minor
{
    self.major = major;
    self.minor = minor;
    self.scheduleBroadcast = YES; // But the peripheral manager may not be in the 'Powered On' state (so we set a flag in case)
    [self startBroadcastingBeacon];
}

- (void)startBroadcastingBeacon
{
    NSLog(@"startBroadcastingBeacon...");
    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:BEACON_PROXIMITY_UUID major:self.major minor:self.minor identifier:BEACON_SERVICE_NAME];
    NSDictionary *beaconPeripheralData = [beaconRegion peripheralDataWithMeasuredPower:nil];
    [self.peripheralManager startAdvertising:beaconPeripheralData];
}

- (void)stopBroadcastingBeacon
{
    [self.peripheralManager stopAdvertising];
    self.scheduleBroadcast = NO;
}

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    // Enumerate all the states (see https://github.com/lgaches/BeaconEmitter/)
    switch (peripheral.state) {
        case CBPeripheralManagerStateUnknown:
            NSLog(@"The current state of the peripheral manager is unknown; an update is imminent.");
            break;
        case CBPeripheralManagerStateUnauthorized:
            NSLog(@"The app is not authorized to use the Bluetooth low energy peripheral/server role.");
            break;
        case CBPeripheralManagerStateResetting:
            NSLog(@"The connection with the system service was momentarily lost; an update is imminent.");
            break;
        case CBPeripheralManagerStatePoweredOff:
            NSLog(@"Bluetooth is currently powered off");
            break;
        case CBPeripheralManagerStateUnsupported:
            NSLog(@"The platform doesn't support the Bluetooth low energy peripheral/server role.");
            break;
        case CBPeripheralManagerStatePoweredOn:
            NSLog(@"Bluetooth is currently powered on and is available to use.");
            if (self.scheduleBroadcast) { // If state has switched, and flag is set
                [self startBroadcastingBeacon];
                self.scheduleBroadcast = NO;
            }
            break;
    }
}

@end
