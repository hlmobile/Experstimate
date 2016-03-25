//
//  ViewPhotoVC.h
//  Exprestimate
//
//  Created by devmania on 3/12/14.
//  Copyright (c) 2014 HybridClaims. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewPhotoVC : UIViewController

@property (nonatomic,retain)  NSMutableData * data;

@property (retain, nonatomic) IBOutlet UIImageView *imageView;
@property (retain) NSString *formid;
@property (retain) NSString *poi;

- (IBAction)onBack:(id)sender;

@end
