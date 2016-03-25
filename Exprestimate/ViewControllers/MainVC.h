//
//  MainVC.h
//  Exprestimate
//
//  Created by devmania on 3/4/14.
//  Copyright (c) 2014 HybridClaims. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface MainVC : UIViewController<MFMailComposeViewControllerDelegate>

@property (nonatomic,retain) IBOutlet UIButton *homeButton;

- (IBAction)onEmailUS:(id)sender;
- (IBAction)onCallUS:(id)sender;
- (IBAction)onSetting:(id)sender;
- (IBAction)onReferred:(id)sender;
- (IBAction)onConsumer:(id)sender;
- (IBAction)onMyClaims:(id)sender;
- (IBAction)onLogo:(id)sender;

@end
