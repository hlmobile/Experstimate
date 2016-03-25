//
//  ReferredVC.m
//  Exprestimate
//
//  Created by devmania on 3/4/14.
//  Copyright (c) 2014 HybridClaims. All rights reserved.
//

#import "ReferredVC.h"
#import "PhotoVC.h"
#import "SettingVC.h"

@interface ReferredVC ()

@end

@implementation ReferredVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        aForm = [[MyForm alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.scrollView addSubview:formView];
    self.scrollView.contentSize = formView.frame.size;
    
    // calendar
    calendarViewController = [[CalendarViewController alloc] initWithNibName:@"CalendarView" bundle:nil];
    calendarViewController.delegate = self;
    calendarViewController.view.frame = CGRectMake(0,self.view.frame.size.height,
                                                   calendarViewController.view.frame.size.width,
                                                   calendarViewController.view.frame.size.height );
    [self.view addSubview:calendarViewController.view];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    self.dateOfLossText.text = [formatter stringFromDate:[NSDate date]];
    
    [formatter release];
//    chooseView = [[UIActionSheet alloc] initWithTitle:@"Choose Image" delegate:self cancelButtonTitle:@"Back" destructiveButtonTitle:nil otherButtonTitles:@"Select from library", @"Take a photo", nil];
}

//-(void)actionSheetCancel:(UIActionSheet *)actionSheet{
//    NSLog(@"action sheet cancel");
//}
//
//-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
//    NSLog(@"action sheet Index=%d",buttonIndex);
//    if(buttonIndex==1){
//        [self useCamera:self];
//    }
//    if(buttonIndex==0){
//        [self useCameraRoll:self];
//    }
//}

//- (void)useCameraRoll:(id)sender{
//    if ([UIImagePickerController isSourceTypeAvailable:
//         UIImagePickerControllerSourceTypeSavedPhotosAlbum])
//    {
//        UIImagePickerController *imagePicker =
//        [[UIImagePickerController alloc] init];
//        imagePicker.delegate = self;
//        imagePicker.sourceType =
//        UIImagePickerControllerSourceTypePhotoLibrary;
//        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
//        imagePicker.allowsEditing = NO;
//        [self presentViewController:imagePicker
//                           animated:YES completion:nil];
//    }
//}

- (void) useCamera:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = NO;
        
        NSString *bRuler = [[NSUserDefaults standardUserDefaults] objectForKey:@"showRuler"];
        
        if (bRuler && [bRuler isEqualToString:@"YES"]) {
            UIImageView *overlayImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"grid.png"]];
            CGFloat height=423, y=0;
            
            if (imagePicker.cameraOverlayView.frame.size.height>480) { // 568
                y = 70;
            }
            
            CGRect overlayRect = CGRectMake(0, y, imagePicker.cameraOverlayView.frame.size.width, height);
            [overlayImage setFrame:overlayRect];
            [imagePicker setCameraOverlayView:overlayImage];
        }
        
        [self presentViewController:imagePicker
                           animated:YES completion:nil];
    }
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil]; //Do this first!!
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [aForm addImage:image withPOI:imageOption];
    
    UIImage *tickImage = [UIImage imageNamed:@"tick.png"];
    
    switch (imageOption) {
        case VINImage:
            [self.vinNOButton setImage:tickImage forState:UIControlStateNormal];
            break;
            
        case InsuranceIDCardImage:
            [self.insuranceIDCardButton setImage:tickImage forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
}

-(void)image:(UIImage *)image
finishedSavingWithError:(NSError *)error
 contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onEmailUS:(id)sender {
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

- (IBAction)onCallUS:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:9413095310"]];
}

- (IBAction)onSetting:(id)sender {
    SettingVC *nextVC = [[SettingVC alloc] initWithNibName:@"SettingVC" bundle:nil];
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (IBAction)onTakePhoto:(id)sender {
    aForm.type = 1;
    aForm.Name = self.nameText.text;
    aForm.Address = self.addressText.text;
    aForm.PhoneNO = self.phoneNOText.text;
    aForm.ReferringCarrier = self.referringCarrierText.text;
    aForm.Deductible = self.deductibleText.text;
    aForm.ReferringAdjuster = self.referringAdjusterText.text;
    aForm.ReferringAdjusterPhoneNO = self.referringAdjusterPhoneNOText.text;
    aForm.ReferringAdjusterEmailAddress = self.referringAdjustEmailAddressText.text;
    aForm.ClaimNO = self.claimNOText.text;
    aForm.DateOfLoss = self.dateOfLossText.text;
    aForm.VehicleYear = self.vehicleText.text;
    aForm.VehicleMake = self.vehicleMakeText.text;
    aForm.VehicleModel = self.vehicleModelText.text;
    aForm.VINNO = self.vinNOText.text;
    aForm.InsuranceIDCard = self.insuranceIDCardText.text;
    aForm.Notes = self.noteText.text;
    
    PhotoVC *nextVC = [[PhotoVC alloc] initWithNibName:@"PhotoVC" bundle:nil];
    nextVC.aForm = aForm;
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (IBAction)onLogo:(id)sender {
    NSURL *myURL = [NSURL URLWithString:@"http://www.hybridclaims.com"];
    
    if( [[UIApplication sharedApplication] canOpenURL:myURL] )
        [[UIApplication sharedApplication] openURL:myURL];
}

- (IBAction)onVINNO:(id)sender {
    imageOption = VINImage;
    [self useCamera:self];
//    [chooseView showInView:self.view];
}

- (IBAction)onInsuranceIDCard:(id)sender {
    imageOption = InsuranceIDCardImage;
    [self useCamera:self];
//    [chooseView showInView:self.view];
}

- (void) showCalendar
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    calendarViewController.view.frame = CGRectMake(self.view.frame.size.width - calendarViewController.view.frame.size.width,
                                                   self.view.frame.size.height - calendarViewController.view.frame.size.height,
                                                   calendarViewController.view.frame.size.width,
                                                   calendarViewController.view.frame.size.height );
    [UIView commitAnimations];
    
}

- (void) hideCalendar
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    calendarViewController.view.frame = CGRectMake(0,
                                                   self.view.frame.size.height ,
                                                   calendarViewController.view.frame.size.width,
                                                   calendarViewController.view.frame.size.height );
    [UIView commitAnimations];
}

#pragma mark - CalendarViewDelegate
- (void)calendarViewController:(CalendarViewController *)controller setDate:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    self.dateOfLossText.text = [formatter stringFromDate:date];
    
    [formatter release];
}

- (void)emptyClickedByCalendarViewController:(CalendarViewController *)controller
{
    [self hideCalendar];
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    [self hideCalendar];
    
    if (textField==self.dateOfLossText) {
        [textField resignFirstResponder];
        
        [self showCalendar];
        return NO;
    }
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)dealloc {
    [_vehicleMakeText release];
    [_vehicleModelText release];
    [_vinNOButton release];
    [_insuranceIDCardButton release];
    [super dealloc];
}
@end
