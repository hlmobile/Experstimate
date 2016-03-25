//
//  CustomCell.h
//  Exprestimate
//
//  Created by devmania on 3/4/14.
//  Copyright (c) 2014 HybridClaims. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *itemName;
@property (retain, nonatomic) IBOutlet UILabel *itemClaimNO;
@property (retain, nonatomic) IBOutlet UILabel *itemDateSubmitted;
@property (retain, nonatomic) IBOutlet UILabel *itemDateofLoss;

@end
