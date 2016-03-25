//
//  MyCustomCell.m
//  Exprestimate
//
//  Created by devmania on 3/13/14.
//  Copyright (c) 2014 HybridClaims. All rights reserved.
//

#import "MyCustomCell.h"

@interface MyCustomCell ()

@end

@implementation MyCustomCell

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.itemName.text = self.strName;
    self.itemClaimNO.text = self.strClaimNo;
    self.itemDateOfLoss.text = self.strDateofLoss;
    self.itemDateSubmitted.text = self.strDateSubmitted;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_itemName release];
    [_itemClaimNO release];
    [_itemDateSubmitted release];
    [_itemDateOfLoss release];
    [super dealloc];
}
@end
