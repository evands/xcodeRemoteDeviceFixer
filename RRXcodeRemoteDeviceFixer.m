//
//  RRXcodeRemoteDeviceFixer.m
//  xcodeRemoteDeviceFixer
//
//  Created by Evan Schoenberg on 8/2/11.
//  Copyright 2011 Regular Rate and Rhythm Software. All rights reserved.
//

#import "RRXcodeRemoteDeviceFixer.h"
#import "JRSwizzle.h"

@interface DTDKRemoteDeviceToken : NSObject
@end

@implementation DTDKRemoteDeviceToken (_RRXcodeRemoteDeviceFixer_DTDKRemoteDeviceToken)
- (BOOL)_RRXcodeRemoteDeviceFixer_getNeedsToFetchSharedCache:(id)cache error:(NSError **)outError
{
    NSLog(@"Preventing an attempt to connect to a remote iOS device via getNeedsToFetchSharedCache:error:.");
    if (outError != NULL)
        *outError = nil;
    
    return NO;
}

@end

@implementation RRXcodeRemoteDeviceFixer

/**
 * A special method called by SIMBL once the application has started and all classes are initialized.
 */
+ (void) load
{
    if (self == [RRXcodeRemoteDeviceFixer class]) {
        static RRXcodeRemoteDeviceFixer *plugin = nil;
        
        if (plugin == nil)
            plugin = [[RRXcodeRemoteDeviceFixer alloc] init];
     
        NSLog(@"XcodeRemoteDeviceFixer installed");
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        NSError *error = nil;
        NSLog(@"Swizzling to prevent %@ from calling getNeedsToFetchSharedCache:error:", NSStringFromClass(NSClassFromString(@"DTDKRemoteDeviceToken")));

        if (![NSClassFromString(@"DTDKRemoteDeviceToken") jr_swizzleMethod:@selector(getNeedsToFetchSharedCache:error:)
                                                         withMethod:@selector(_RRXcodeRemoteDeviceFixer_getNeedsToFetchSharedCache:error:)
                                                              error:&error]) {
            NSLog(@"Couldn't swizzle; error was %@", error);
        }
    }
    
    return self;
}

@end
