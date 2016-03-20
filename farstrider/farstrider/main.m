//
//  main.m
//  farstrider
//
//  Created by Jonathon Rubin on 3/17/16.
//  Copyright © 2016 Jonathon Rubin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <farstrider-Swift.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {

        TrackerController *tracker = [[TrackerController alloc] init];

        [[NSRunLoop currentRunLoop] run];
        
        tracker = nil;

    }
    return 0;
}