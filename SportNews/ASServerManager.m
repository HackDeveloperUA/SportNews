//
//  ASServerManager.m
//  SportNews
//
//  Created by Hack on 12/24/15.
//  Copyright © 2015 TestJson. All rights reserved.
//

#import "ASServerManager.h"
#import "ASNews.h"

@interface ASServerManager ()

@property (strong, nonatomic) AFHTTPRequestOperationManager* requestOperationManager;
@property (strong,nonatomic) dispatch_queue_t requestQueue;

@end


@implementation ASServerManager

+ (ASServerManager*) sharedManager {
    
    static ASServerManager* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ASServerManager alloc] init];
    });
    return manager;
}


- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.requestQueue = dispatch_queue_create("iOSDevCourse.requestVk", DISPATCH_QUEUE_PRIORITY_DEFAULT);
        self.requestOperationManager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:@""]];
    }
    return self;
}


-(void) getSportNewsWithOffset:(NSInteger) offset
                         count:(NSInteger) count
             onSuccess:(void(^)(NSArray* news)) success
             onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    /*
     NSString *requestString = @"http://calvera.su/5839.json";
     NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:requestString]];
     NSError *error;
     NSDictionary *arrayJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
     
     
     
     NSDictionary* params = @{};
     NSData   *jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
     NSString *parametersString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
     
     [self.requestOperationManager GET:@"http://calvera.su/5839.json"
     parameters:@{@"setting" : parametersString}
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
     // code
     
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     /// code
     }];*/
    
    NSDictionary* params = @{};
    [self.requestOperationManager GET:@"https://copy.com/P6VPnVncesxVayHT"//@"http://calvera.su/5839.json"
                           parameters:nil//params
                              success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
                
                                  NSMutableArray* objectsArray = [NSMutableArray array];
                                  if (success) {
                                      success(objectsArray);
                                  }
                              }
                              failure:^(AFHTTPRequestOperation *operation, NSError* error){
                                  NSLog(@"Error: %@",error);
                                  if (failure) {
                                      failure(error, operation.response.statusCode);
                                  }
                              }];
}

@end
