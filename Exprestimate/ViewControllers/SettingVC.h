//
//  SettingVC.h
//  Exprestimate
//
//  Created by devmania on 3/13/14.
//  Copyright (c) 2014 HybridClaims. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface SettingVC : UIViewController<MFMailComposeViewControllerDelegate>
{
    NSArray *vehicleArr;
}

@property (retain, nonatomic) IBOutlet UIButton *rulerButton;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)onBack:(id)sender;
- (IBAction)onHome:(id)sender;
- (IBAction)onEmailUS:(id)sender;
- (IBAction)onCallUS:(id)sender;
- (IBAction)onRuler:(id)sender;
- (IBAction)onLogo:(id)sender;

@end
