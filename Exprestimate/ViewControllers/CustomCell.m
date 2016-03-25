//
//  CustomCell.m
//  Exprestimate
//
//  Created by devmania on 3/4/14.
//  Copyright (c) 2014 HybridClaims. All rights reserved.
//

#import "CustomCell.h"
#import <CoreGraphics/CoreGraphics.h>

@implementation CustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

- (void)dealloc {
    [_itemName release];
    [_itemClaimNO release];
    [_itemDateSubmitted release];
    [_itemDateofLoss release];
    [super dealloc];
}
@end
