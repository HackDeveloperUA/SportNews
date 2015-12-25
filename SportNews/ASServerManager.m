//
//  ASServerManager.m
//  SportNews
//
//  Created by Hack on 12/24/15.
//  Copyright © 2015 TestJson. All rights reserved.
//

#import "ASServerManager.h"
#import "ASNews.h"

#define sportNewsCategory @"208"

@interface ASServerManager ()

@property (strong, nonatomic) AFHTTPRequestOperationManager* requestOperationManager;
@property (strong, nonatomic) dispatch_queue_t requestQueue;

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
        self.requestQueue = dispatch_queue_create("sportNews.requestNews", DISPATCH_QUEUE_PRIORITY_DEFAULT);
        self.requestOperationManager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:@""]];
    }
    return self;
}


-(void) getSportNewsWithOffset:(NSInteger) offset
                         count:(NSInteger) count
             onSuccess:(void(^)(NSArray* news)) success
             onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
 
    
    NSDictionary* params = @{};
    [self.requestOperationManager GET:@"https://copy.com/0HHJnviugOy2w3xd"  //@"http://calvera.su/5839.json"
                           parameters:params
                              success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
            
    
                                  NSArray*  items  = [responseObject  objectForKey:@"news"];
                                  NSMutableArray* objectsArray = [NSMutableArray array];
                                  
                                  for (NSDictionary* dict in items) {
                                      ASNews* news = [[ASNews alloc] initWithServerResponse:dict];
                                      
                                      // Нам нужны только новости с категорией 208
                                      if ([news.category_id isEqualToString:sportNewsCategory]) {
                                          [objectsArray addObject:news];
                                      }
                                  }
                                  success(objectsArray);
                          
                              }
                              failure:^(AFHTTPRequestOperation *operation, NSError* error){
                                  NSLog(@"Error: %@",error);
                                  if (failure) {
                                      failure(error, operation.response.statusCode);
                                  }
                              }];
}

@end
