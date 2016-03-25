//
//  PhotoVC.h
//  Exprestimate
//
//  Created by devmania on 3/4/14.
//  Copyright (c) 2014 HybridClaims. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <dispatch/dispatch.h>
#import "MyForm.h"

@interface PhotoVC : UIViewController<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate, MFMailComposeViewControllerDelegate>
{
    int imageOption;
    dispatch_queue_t        dQueue;
}

@property ( retain ) NSMutableData * data;
@property ( retain ) NSURLConnection * connection;
@property (retain) MyForm *aForm;

@property (retain, nonatomic) IBOutlet UIButton *driverSideFrontButton;
@property (retain, nonatomic) IBOutlet UIButton *frontCenterButton;
@property (retain, nonatomic) IBOutlet UIButton *passengerSideFrontButton;
@property (retain, nonatomic) IBOutlet UIButton *hailDamageButton;
@property (retain, nonatomic) IBOutlet UIButton *driverSideDoorButton;
@property (retain, nonatomic) IBOutlet UIButton *passengerSideDoorButton;
@property (retain, nonatomic) IBOutlet UIButton *roofPanelButton;
@property (retain, nonatomic) IBOutlet UIButton *driverSideRearButton;
@property (retain, nonatomic) IBOutlet UIButton *rearCenterButton;
@property (retain, nonatomic) IBOutlet UIButton *passengerSideRearButton;
@property (retain, nonatomic) IBOutlet UIView *maskView;
@property (retain, nonatomic) IBOutlet UIImageView *carImage;

- (IBAction)onHome:(id)sender;
- (IBAction)onEmailUS:(id)sender;
- (IBAction)onCallUS:(id)sender;
- (IBAction)onSetting:(id)sender;
- (IBAction)onBack:(id)sender;
- (IBAction)onSubmit:(id)sender;


- (IBAction)onFrontCenter:(id)sender;
- (IBAction)onDriverSideFront:(id)sender;
- (IBAction)onDriverSideDoor:(id)sender;
- (IBAction)onDriverSideRear:(id)sender;
- (IBAction)onPassengerSideFront:(id)sender;
- (IBAction)onPassengerSideDoor:(id)sender;
- (IBAction)onPassengerSideRead:(id)sender;
- (IBAction)onHailDamage:(id)sender;
- (IBAction)onRoofPanel:(id)sender;
- (IBAction)onRearCenter:(id)sender;
- (IBAction)onLogo:(id)sender;

@end
