//
//  ConsumerVC.h
//  Exprestimate
//
//  Created by devmania on 3/4/14.
//  Copyright (c) 2014 HybridClaims. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "MyForm.h"
#import "CalendarViewController.h"

@interface ConsumerVC : UIViewController<UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate,CalendarViewDelegate>
{
    IBOutlet UIView *formView;
    MyForm *aForm;
    int imageOption;
    CalendarViewController * calendarViewController;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

@property (nonatomic, retain) IBOutlet UITextField *nameText;
@property (nonatomic, retain) IBOutlet UITextField *addressText;
@property (nonatomic, retain) IBOutlet UITextField *phoneNOText;
@property (nonatomic, retain) IBOutlet UITextField *claimNOText;
@property (nonatomic, retain) IBOutlet UITextField *insuranceCarrier;
@property (nonatomic, retain) IBOutlet UITextField *dateOfLossText;
@property (nonatomic, retain) IBOutlet UITextField *vehicleText;
@property (retain, nonatomic) IBOutlet UITextField *vehicleMakeText;
@property (retain, nonatomic) IBOutlet UITextField *vehicleModelText;
@property (nonatomic, retain) IBOutlet UITextField *VINNOText;
@property (nonatomic, retain) IBOutlet UITextField *insuranceIDCardText;
@property (nonatomic, retain) IBOutlet UITextField *emailAddressText;
@property (nonatomic, retain) IBOutlet UITextView *noteText;
@property (retain, nonatomic) IBOutlet UIButton *vinNOButton;
@property (retain, nonatomic) IBOutlet UIButton *insuranceIDCardButton;

- (IBAction)onBack:(id)sender;
- (IBAction)onTakePhoto:(id)sender;
- (IBAction)onEmailUS:(id)sender;
- (IBAction)onCallUS:(id)sender;
- (IBAction)onSetting:(id)sender;
- (IBAction)onVINNO:(id)sender;
- (IBAction)onInsuranceIDCard:(id)sender;
- (IBAction)onLogo:(id)sender;

@end
