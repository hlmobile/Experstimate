//
//  MyClaimsVC.h
//  Exprestimate
//
//  Created by devmania on 3/4/14.
//  Copyright (c) 2014 HybridClaims. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface MyClaimsVC : UIViewController<MFMailComposeViewControllerDelegate>

@property (nonatomic,retain) NSMutableArray *formsArray;
@property (nonatomic,retain)  NSMutableData * data;
@property (nonatomic,retain) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UIView *maskView;
@property (retain, nonatomic) IBOutlet UIView *drawingView;

- (IBAction)onBack:(id)sender;
- (IBAction)onEmailUS:(id)sender;
- (IBAction)onCallUS:(id)sender;
- (IBAction)onSetting:(id)sender;
- (IBAction)onLogo:(id)sender;

@end
