//
//  MyClaimDetailVC.m
//  Exprestimate
//
//  Created by devmania on 3/12/14.
//  Copyright (c) 2014 HybridClaims. All rights reserved.
//

#import "MyClaimDetailVC.h"
#import "ViewPhotoVC.h"
#import "MyForm.h"
#import "SettingVC.h"

@interface MyClaimDetailVC ()

@end

@implementation MyClaimDetailVC

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
    [self.scrollView addSubview:formView];
    self.scrollView.contentSize = formView.frame.size;
    // Do any additional setup after loading the view from its nib.
    [self populateTextfromDictionary];
}

- (void) populateTextfromDictionary
{
    if ([[self.aFormDic objectForKey:@"id"] isEqualToString:@"1"]) {
        self.claimTypeText.text = @"Referred";
    }
    else
        self.claimTypeText.text = @"Consumer";
    
    self.nameText.text = [self.aFormDic objectForKey:@"Name"];
    self.addressText.text = [self.aFormDic objectForKey:@"Address"];
    self.emailText.text = [self.aFormDic objectForKey:@"EmailAddress"];
    self.phoneNOText.text = [self.aFormDic objectForKey:@"PhoneNumber"];
    self.referringCarrier.text = [self.aFormDic objectForKey:@"ReferringCarrier"];
    self.deductibleText.text = [self.aFormDic objectForKey:@"Deductible"];
    self.referringAdjuster.text = [self.aFormDic objectForKey:@"ReferringAdjuster"];
    self.referringAdjusterPhoneNOText.text = [self.aFormDic objectForKey:@"ReferringAdjusterPhoneNumber"];
    self.referringAdjusterEmailAddressText.text = [self.aFormDic objectForKey:@"ReferringAdjusterEmailAddress"];
    self.claimNOText.text = [self.aFormDic objectForKey:@"ClaimNumber"];
    self.dateOfLossText.text = [self.aFormDic objectForKey:@"DateofLoss"];
    self.vehicleYearText.text = [self.aFormDic objectForKey:@"VehicleYear"];
    self.vehicleMakeText.text = [self.aFormDic objectForKey:@"VehicleMake"];
    self.vehicleModelTet.text = [self.aFormDic objectForKey:@"VehicleModel"];
    self.VINNOText.text = [self.aFormDic objectForKey:@"VINNumber"];
    self.insuranceCardIDText.text = [self.aFormDic objectForKey:@"InsuranceIDCard"];
    self.insuranceCarrierText.text = [self.aFormDic objectForKey:@"InsuranceCarrier"];
    self.noteText.text = [self.aFormDic objectForKey:@"Notes"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onVINNO:(id)sender {
    ViewPhotoVC *nextVC = [[ViewPhotoVC alloc] initWithNibName:@"ViewPhotoVC" bundle:nil];
    nextVC.formid = [self.aFormDic objectForKey:@"id"];
    nextVC.poi = [NSString stringWithFormat:@"%d", VINImage];
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (IBAction)onEmail:(id)sender {
    MFMailComposeViewController * controller = [[[MFMailComposeViewController alloc] init] autorelease];
    [controller.view setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0]];
    
    if ( [MFMailComposeViewController canSendMail] ) {
        controller.mailComposeDelegate = self;
        [controller setSubject:@"Feedback"];
        [controller setToRecipients:[NSArray arrayWithObjects:@"support@hybridclaims.com",nil]];
        [self.navigationController presentViewController:controller animated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        }];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    NSString * messageResult ;
	switch (result)
	{
		case MFMailComposeResultCancelled:
			messageResult = @"Mail canceled.";
			break;
		case MFMailComposeResultSaved:
			messageResult = @"Mail saved.";
			break;
		case MFMailComposeResultSent:
			messageResult = @"Mail sended.";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Email has been successfully sent." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
			break;
		case MFMailComposeResultFailed:
			messageResult = @"Mail failed.";
			break;
		default:
			messageResult = @"Mail don't send.";
			break;
	}
	[self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onInsuranceIDCard:(id)sender {
    ViewPhotoVC *nextVC = [[ViewPhotoVC alloc] initWithNibName:@"ViewPhotoVC" bundle:nil];
    nextVC.formid = [self.aFormDic objectForKey:@"id"];
    nextVC.poi = [NSString stringWithFormat:@"%d", InsuranceIDCardImage];
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (IBAction)onHome:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)onCallUS:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:9413095310"]];
}

- (IBAction)onSetting:(id)sender {
    SettingVC *nextVC = [[SettingVC alloc] initWithNibName:@"SettingVC" bundle:nil];
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onLogo:(id)sender {
    NSURL *myURL = [NSURL URLWithString:@"http://www.hybridclaims.com"];
    
    if( [[UIApplication sharedApplication] canOpenURL:myURL] )
        [[UIApplication sharedApplication] openURL:myURL];
}

- (void)dealloc {
    [formView release];
    [_scrollView release];
    [_claimTypeText release];
    [_nameText release];
    [_addressText release];
    [_emailText release];
    [_phoneNOText release];
    [_referringCarrier release];
    [_deductibleText release];
    [_referringAdjuster release];
    [_referringAdjusterPhoneNOText release];
    [_referringAdjusterEmailAddressText release];
    [_claimNOText release];
    [_dateOfLossText release];
    [_vehicleYearText release];
    [_vehicleMakeText release];
    [_vehicleModelTet release];
    [_VINNOText release];
    [_insuranceCardIDText release];
    [_insuranceCarrierText release];
    [_noteText release];
    [super dealloc];
}
@end
