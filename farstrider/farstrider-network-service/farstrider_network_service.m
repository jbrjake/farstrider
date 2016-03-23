//
//  farstrider_network_service.m
//  farstrider-network-service
//
//  Created by Jonathon Rubin on 3/22/16.
//  Copyright © 2016 Jonathon Rubin. All rights reserved.
//

#import "farstrider_network_service.h"

@implementation farstrider_network_service

// This implements the example protocol. Replace the body of this class with the implementation of this service's protocol.
- (void)upperCaseString:(NSString *)aString withReply:(void (^)(NSString *))reply {
    NSString *response = [aString uppercaseString];
    reply(response);
}

@end
