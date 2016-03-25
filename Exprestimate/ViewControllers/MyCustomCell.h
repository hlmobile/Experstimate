//
//  MyCustomCell.h
//  Exprestimate
//
//  Created by devmania on 3/13/14.
//  Copyright (c) 2014 HybridClaims. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCustomCell : UIViewController

@property (retain) NSString *strName;
@property (retain) NSString *strClaimNo;
@property (retain) NSString *strDateSubmitted;
@property (retain) NSString *strDateofLoss;

@property (retain, nonatomic) IBOutlet UILabel *itemName;
@property (retain, nonatomic) IBOutlet UILabel *itemClaimNO;
@property (retain, nonatomic) IBOutlet UILabel *itemDateSubmitted;
@property (retain, nonatomic) IBOutlet UILabel *itemDateOfLoss;

@end
