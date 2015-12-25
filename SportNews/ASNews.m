//
//  ASNews.m
//  SportNews
//
//  Created by Hack on 12/24/15.
//  Copyright © 2015 TestJson. All rights reserved.
//

#import "ASNews.h"

@implementation ASNews


-(instancetype) initWithServerResponse:(NSDictionary*) responseObject {
    
    self = [super init];
    if (self) {
        
        self.id                 = [[responseObject objectForKey:@"id"] stringValue];
        self.title              = [responseObject objectForKey:@"title"];
        self.content            = [responseObject objectForKey:@"content"];
        self.class              = [responseObject objectForKey:@"class"];
        self.nick               = [responseObject objectForKey:@"nick"];
        self.category_id        = [[responseObject objectForKey:@"category_id"] stringValue];
        
        NSString* tmpPostedTime = [[responseObject objectForKey:@"posted_time"] stringValue];
        self.posted_time        = [self parseDataWithDateFormetter:@"HH:mm" andDate:tmpPostedTime];
        
        self.comment_count      = [[responseObject objectForKey:@"comment_count"] integerValue];
        self.main               = [[responseObject objectForKey:@"main"] boolValue];
        self.link               = [responseObject objectForKey:@"link"];
    }
    return self;
}

-(NSString*) description {
    
    NSLog(@"self.identifierNews = %@ ", self.id);
    NSLog(@"self.title          = %@ ", self.title);
    NSLog(@"self.content        = %@ ", self.content);
    NSLog(@" self.classNews     = %@ ", self.class);
    NSLog(@"self.nick           = %@ ", self.nick);
    NSLog(@"self.category_id    = %@ ", self.category_id);
    NSLog(@"self.posted_time    = %@ ", self.posted_time);
    
    NSLog(@"self.comment_count  = %ld ", (long)self.comment_count);
    NSLog(@"self.isMainNews     = %hhd ", self.main);
    NSLog(@"self.linkNews       = %@ ",      self.link);
    
    return nil;
}


-(NSString*) parseDataWithDateFormetter:(NSString*)dateFormat andDate:(NSString*) date {
    
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc]init];
    [dateFormater setDateFormat:dateFormat];
    NSDate *dateTime = [NSDate dateWithTimeIntervalSince1970:[date floatValue]];
    NSString *parseDate = [dateFormater stringFromDate:dateTime];
    
    return parseDate;
}


@end
