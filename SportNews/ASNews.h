//
//  ASNews.h
//  SportNews
//
//  Created by Hack on 12/24/15.
//  Copyright © 2015 TestJson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASNews : NSObject

@property (strong, nonatomic) NSString* identifierNews;
@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* content;
@property (strong, nonatomic) NSString* classNews;
@property (strong, nonatomic) NSString* nick;
@property (strong, nonatomic) NSString* category_id;
@property (strong, nonatomic) NSString* posted_time;

@property (assign, nonatomic) NSInteger comment_count;
@property (assign, nonatomic) BOOL      isMainNews;
@property (strong, nonatomic) NSString* linkNews;


-(instancetype) initWithServerResponse:(NSDictionary*) responseObject;


@end