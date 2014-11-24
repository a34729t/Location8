//
//  Created by Nicolas Flacco on 11/24/14.
//  Copyright (c) 2014 Nicolas Flacco. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BeaconManagerDelegate


@end

@interface BeaconEmulator : NSObject

+ (instancetype)sharedInstance;
- (void)broadcastBeaconWithMajor:(UInt16)major minor:(UInt16)minor;
- (void)stopBroadcastingBeacon;

@end
