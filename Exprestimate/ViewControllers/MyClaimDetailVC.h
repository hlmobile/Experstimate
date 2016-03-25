//
//  MyClaimDetailVC.h
//  Exprestimate
//
//  Created by devmania on 3/12/14.
//  Copyright (c) 2014 HybridClaims. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface MyClaimDetailVC : UIViewController<MFMailComposeViewControllerDelegate>
{
    IBOutlet UIView *formView;
}

@property (assign) NSDictionary * aFormDic;

@property (retain, nonatomic) IBOutlet UITextField *claimTypeText;
@property (retain, nonatomic) IBOutlet UITextField *nameText;
@property (retain, nonatomic) IBOutlet UITextField *addressText;
@property (retain, nonatomic) IBOutlet UITextField *emailText;
@property (retain, nonatomic) IBOutlet UITextField *phoneNOText;
@property (retain, nonatomic) IBOutlet UITextField *referringCarrier;
@property (retain, nonatomic) IBOutlet UITextField *deductibleText;
@property (retain, nonatomic) IBOutlet UITextField *referringAdjuster;
@property (retain, nonatomic) IBOutlet UITextField *referringAdjusterPhoneNOText;
@property (retain, nonatomic) IBOutlet UITextField *referringAdjusterEmailAddressText;
@property (retain, nonatomic) IBOutlet UITextField *claimNOText;
@property (retain, nonatomic) IBOutlet UITextField *dateOfLossText;
@property (retain, nonatomic) IBOutlet UITextField *vehicleYearText;
@property (retain, nonatomic) IBOutlet UITextField *vehicleMakeText;
@property (retain, nonatomic) IBOutlet UITextField *vehicleModelTet;
@property (retain, nonatomic) IBOutlet UITextField *VINNOText;
@property (retain, nonatomic) IBOutlet UITextField *insuranceCardIDText;
@property (retain, nonatomic) IBOutlet UITextField *insuranceCarrierText;
@property (retain, nonatomic) IBOutlet UITextView *noteText;

@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)onVINNO:(id)sender;
- (IBAction)onInsuranceIDCard:(id)sender;
- (IBAction)onEmail:(id)sender;
- (IBAction)onHome:(id)sender;
- (IBAction)onCallUS:(id)sender;
- (IBAction)onSetting:(id)sender;
- (IBAction)onBack:(id)sender;
- (IBAction)onLogo:(id)sender;

@end
