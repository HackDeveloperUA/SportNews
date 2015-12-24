//
//  ASNewsCell.h
//  SportNews
//
//  Created by MD on 24.12.15.
//  Copyright (c) 2015 TestJson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASNewsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;

@property (weak, nonatomic) IBOutlet UILabel *mainLabel;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@end
