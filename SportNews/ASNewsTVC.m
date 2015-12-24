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

#import <SystemConfiguration/SystemConfiguration.h>
#import <SystemConfiguration/SCNetworkReachability.h>
#import "Reachability.h"

@interface ASNewsTVC () <UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate,MBProgressHUDDelegate>

@property (strong, nonatomic) NSMutableArray* arraySportNews;
@property (assign, nonatomic) BOOL loadingData;
@property (strong, nonatomic) MBProgressHUD *HUD;

@end

@implementation ASNewsTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self isInternetConnection]) {
        [self getSportNewsFromServer];
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
            
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:newPaths withRowAnimation:UITableViewRowAnimationTop];
            [self.tableView endUpdates];
            
            self.loadingData = NO;
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
            [self getSportNewsFromServer];
        }
    }
}


#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 117.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arraySportNews count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        /*
        static NSString* identifier = @"ASListFineCell";
        
        ASListFineCell *cell = (ASListFineCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            cell = (ASListFineCell*)[[ASListFineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }*/
        
        static NSString *CellIdentifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        }
        
        cell.textLabel.text = [NSString stringWithFormat:@"index %ld",(long)indexPath.row];
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
