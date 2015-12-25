//
//  ASNewsTVC.m
//  SportNews
//
//  Created by Hack on 12/24/15.
//  Copyright © 2015 TestJson. All rights reserved.
//

#import "ASNewsTVC.h"
#import "MBProgressHUD.h"
#import "SCLAlertView.h"
#import "ASServerManager.h"
#import "ASNewsCell.h"
#import "ANHelperFunctions.h"
#import "ASNews.h"

#import <SystemConfiguration/SystemConfiguration.h>
#import <SystemConfiguration/SCNetworkReachability.h>
#import "Reachability.h"

#define sportNewsCategory @"208"

/// Поправить
typedef NS_ENUM(NSInteger, ASSortedSegment) {
    ASSortedByVozrastan = 0,
    ASSortedUbyvan      = 1,
};



@interface ASNewsTVC () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, MBProgressHUDDelegate>

@property (weak,   nonatomic) IBOutlet UISegmentedControl *segmentControll;
@property (strong, nonatomic) MBProgressHUD *HUD;

@property (assign, nonatomic) ASSortedSegment* sortedMask;
@property (strong, nonatomic) NSMutableArray*  arraySportNews;
@property (assign, nonatomic) BOOL loadingData;

@end

@implementation ASNewsTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.arraySportNews = [NSMutableArray array];
    self.sortedMask     = ASSortedByVozrastan;
    
    // Потом поставить if (![self isInternetConnection])
    if ([self isInternetConnection]) {
        ANDispatchBlockToBackgroundQueue(^{
            [self getSportNewsFromServer];
        });
    }
}

-(void) sortingByAscending:(BOOL) isAscending {
    
    ANDispatchBlockToBackgroundQueue(^{
        NSSortDescriptor* sortByTime  = [NSSortDescriptor sortDescriptorWithKey:@"posted_time"  ascending:isAscending];
        [self.arraySportNews sortUsingDescriptors:[NSArray arrayWithObjects:sortByTime,nil]];
        
        ANDispatchBlockToMainQueue(^{
            [self.tableView reloadData];
        });
    });
}

- (IBAction)segmentControlAction:(UISegmentedControl *)sender {
    
    if (sender.selectedSegmentIndex == ASSortedByVozrastan) {
        [self sortingByAscending:YES];
    } else if (sender.selectedSegmentIndex == ASSortedUbyvan) {
        [self sortingByAscending:NO];
    }
}


#pragma mark - Server
-(void) getSportNewsFromServer{
    
    [[ASServerManager sharedManager] getSportNewsWithOffset:[self.arraySportNews count] count:20 onSuccess:^(NSArray *news) {
        
        if ([news count] > 0) {
            
            [self.arraySportNews addObjectsFromArray:news];
            
            NSMutableArray* newPaths = [NSMutableArray array];
            for (int i = (int)[self.arraySportNews count] - (int)[news count]; i < [self.arraySportNews count]; i++){
                [newPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            }
            
            ANDispatchBlockToMainQueue(^{
                [self.tableView beginUpdates];
                [self.tableView insertRowsAtIndexPaths:newPaths withRowAnimation:UITableViewRowAnimationTop];
                [self.tableView endUpdates];
                
                self.loadingData = NO;
            });
        }
        
    } onFailure:^(NSError *error, NSInteger statusCode) {
        NSLog(@"Error = %@ \n statusCode = %ld",error,(long)statusCode);
    }];
  
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
        if (!self.loadingData)
        {
            self.loadingData = YES;
            ANDispatchBlockToBackgroundQueue(^{
                [self getSportNewsFromServer];
            });
        }
    }
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 149.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arraySportNews count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        static NSString* identifier = @"ASNewsCell";
    
        ASNewsCell *cell = (ASNewsCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell = (ASNewsCell*)[[ASNewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }

         ANDispatchBlockToBackgroundQueue(^{
            
           ASNews* news = self.arraySportNews[indexPath.row];
             
             ANDispatchBlockToMainQueue(^{
                  cell.dateLabel.text = news.posted_time;
                 
                 // Если главная новость - выбираем жирный шрифт
                 if (news.main) {
                     [cell.mainLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:16]];
                 } else {
                     [cell.mainLabel setFont:[UIFont fontWithName:@"System-Font" size:16]];
                 }
                 
                 // Если категори id равен 208 - ставим в лейбл "Футбол"
                
                 if ([news.category_id isEqualToString:sportNewsCategory]) {
                    cell.categoryLabel.text = @"Футбол";
                 } else {
                    cell.categoryLabel.text = news.category_id;
                 }
                 
                 cell.mainLabel.text   = news.title;
                 NSString *number = @(news.comment_count).stringValue;
                 [cell.commentButton setTitle:number forState:UIControlStateNormal];
             });
             
         });
        return cell;
}


#pragma mark - Other
-(BOOL) isInternetConnection {
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable) {
        NSLog(@"There IS NO internet connection");
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            SCLAlertView* alert = [[SCLAlertView alloc] init];
            [alert showError:self.parentViewController title:@"Ошибка" subTitle:@"Соедиения с интернетом" closeButtonTitle:@"OK" duration:0.0f];
        });
        return NO;
    }
    return YES;
}

@end
