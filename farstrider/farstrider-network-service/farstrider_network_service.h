//
//  farstrider_network_service.h
//  farstrider-network-service
//
//  Created by Jonathon Rubin on 3/22/16.
//  Copyright © 2016 Jonathon Rubin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "farstrider_network_serviceProtocol.h"

// This object implements the protocol which we have defined. It provides the actual behavior for the service. It is 'exported' by the service to make it available to the process hosting the service over an NSXPCConnection.
@interface farstrider_network_service : NSObject <farstrider_network_serviceProtocol>
@end
