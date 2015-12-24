//
//  ASServerManager.h
//  SportNews
//
//  Created by Hack on 12/24/15.
//  Copyright © 2015 TestJson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
@interface ASServerManager : NSObject

+ (ASServerManager*) sharedManager;

-(void) getSportNewsWithOffset:(NSInteger) offset
                         count:(NSInteger) count
                     onSuccess:(void(^)(NSArray* news)) success
                     onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;
@end
