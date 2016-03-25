//
//  PhotoVC.m
//  Exprestimate
//
//  Created by devmania on 3/4/14.
//  Copyright (c) 2014 HybridClaims. All rights reserved.
//

#import "PhotoVC.h"
#import "KElement.h"
#import "ParserXML.h"
#import "ActivityIndicator.h"
#import "SettingVC.h"

#define kReportURL    @"http://198.66.209.87/API/report.php"

@interface PhotoVC ()

@end

@implementation PhotoVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        dQueue = dispatch_queue_create(NULL, NULL);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

}

- (void) viewDidAppear:(BOOL)animated
{
    NSArray *vehicleArr = [[[NSArray alloc] initWithObjects:@"convertible", @"ferrari", @"porsche", @"sedan", @"truck", nil] autorelease];
    NSString *strVehicleType = [[NSUserDefaults standardUserDefaults] objectForKey:@"VehicleType"];
    int vehicleIndex = 2;
    
    if (strVehicleType) {
        vehicleIndex = [strVehicleType intValue];
    }
    
    NSString *imgName = [[vehicleArr objectAtIndex:vehicleIndex] stringByAppendingString:@".png"];
    [self.carImage setImage:[UIImage imageNamed:imgName]];
}

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
    
    [self.aForm addImage:image withPOI:imageOption];
    
    UIImage *tickImage = [UIImage imageNamed:@"tick.png"];
    
    switch (imageOption) {
        case POIDriverSideDoors:
            [self.driverSideDoorButton setImage:tickImage forState:UIControlStateNormal];
            break;
            
        case POIDriverSideFront:
            [self.driverSideFrontButton setImage:tickImage forState:UIControlStateNormal];
            break;
            
        case POIDriverSideRear:
            [self.driverSideRearButton setImage:tickImage forState:UIControlStateNormal];
            break;
            
        case POIFrontCenter:
            [self.frontCenterButton setImage:tickImage forState:UIControlStateNormal];
            break;
            
        case POIHailDamage:
            [self.hailDamageButton setImage:tickImage forState:UIControlStateNormal];
            break;
            
        case POIPassengerSideDoors:
            [self.passengerSideDoorButton setImage:tickImage forState:UIControlStateNormal];
            break;
            
        case POIPassengerSideFront:
            [self.passengerSideFrontButton setImage:tickImage forState:UIControlStateNormal];
            break;
            
        case POIPassengerSideRear:
            [self.passengerSideRearButton setImage:tickImage forState:UIControlStateNormal];
            break;
            
        case POIRearCenter:
            [self.rearCenterButton setImage:tickImage forState:UIControlStateNormal];
            break;
            
        case POIRoofPanel:
            [self.roofPanelButton setImage:tickImage forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"Help"
                          message: @"Do you want to add more picture?"
                          delegate: self
                          cancelButtonTitle:@"NO"
                          otherButtonTitles:@"YES", nil];
    [alert show];
    [alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==123) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else if (buttonIndex==1) {
        [self useCamera:self];
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
        [alert release];
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

- (IBAction)onHome:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
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

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onSubmit:(id)sender {
    NSURL *aUrl = [NSURL URLWithString:kReportURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"*****com.exprestimate.formboundary";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData * postBody = [NSMutableData data];
    
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"Name"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[self.aForm.Name dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *type = [NSString stringWithFormat:@"%d", self.aForm.type];
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"type"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[type dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"Address"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[self.aForm.Address dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"PhoneNO"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[self.aForm.PhoneNO dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"ReferringCarrier"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[self.aForm.ReferringCarrier dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"Deductible"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[self.aForm.Deductible dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"ReferringAdjuster"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[self.aForm.ReferringAdjuster dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"ReferringAdjusterPhoneNO"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[self.aForm.ReferringAdjusterPhoneNO dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"ReferringAdjusterEmailAddress"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[self.aForm.ReferringAdjusterEmailAddress dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"ClaimNO"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[self.aForm.ClaimNO dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"DateOfLoss"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[self.aForm.DateOfLoss dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"VehicleYear"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[self.aForm.VehicleYear dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"VehicleMake"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[self.aForm.VehicleMake dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"VehicleModel"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[self.aForm.VehicleModel dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"VINNO"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[self.aForm.VINNO dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"InsuranceIDCard"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[self.aForm.InsuranceIDCard dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"Note"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[self.aForm.Notes dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSUUID *oNSUUID = [[UIDevice currentDevice] identifierForVendor];
    NSString *udid = [oNSUUID UUIDString];
    self.aForm.UDID = udid;
    
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"UDID"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[udid dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"InsuranceCarrier"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[self.aForm.InsuranceCarrier dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"EmailAddress"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[self.aForm.EmailAddress dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:postBody];
    [request setValue:[NSString stringWithFormat:@"%d", [postBody length]] forHTTPHeaderField:@"Content-Length"];
    
    self.connection= [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.maskView.hidden = NO;
    [[ActivityIndicator currentIndicator] displayActivity:@"Submitting form..."];
}

#pragma mark - NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)conn didReceiveResponse:(NSURLResponse *)response
{
    self.data = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)receivedData
{
    [self.data appendData:receivedData];
}

- (void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error
{
    [self.connection release];
    self.connection = nil;
    
    NSLog(@"%@", error);
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"Error"
                          message: @"Connection failed."
                          delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn
{
    [self.connection release];
    self.connection = nil;
    
    NSString * xml = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", xml);
    
    KElement * rootElement = [ParserXML parse:xml];
    
    NSString *status = [rootElement getValueOfTag:@"status"];
    
    if( [status isEqualToString:@"ok"] )
    {
        NSString *formid = [rootElement getValueOfTag:@"description"];
        self.aForm.FormID = formid;
        dispatch_async(dQueue, ^{
            dispatch_sync(dispatch_get_main_queue(), ^{
                self.maskView.hidden = NO;
                [[ActivityIndicator currentIndicator] displayActivity:@"Uploading images..."];
            });
            [self.aForm uploadImages];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                self.maskView.hidden = YES;
                [[ActivityIndicator currentIndicator] hide];
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle: @"Info"
                                      message: @"Form has been successfully submitted."
                                      delegate: self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
                alert.tag = 123;
                [alert show];
                [alert release];
                return;
            });
        });
    }
}

- (IBAction)onFrontCenter:(id)sender {
    imageOption = POIFrontCenter;
    [self useCamera:self];
}

- (IBAction)onDriverSideFront:(id)sender {
    imageOption = POIDriverSideFront;
    [self useCamera:self];
}

- (IBAction)onDriverSideDoor:(id)sender {
    imageOption = POIDriverSideDoors;
    [self useCamera:self];
}

- (IBAction)onDriverSideRear:(id)sender {
    imageOption = POIDriverSideRear;
    [self useCamera:self];
}

- (IBAction)onPassengerSideFront:(id)sender {
    imageOption = POIPassengerSideFront;
    [self useCamera:self];
}

- (IBAction)onPassengerSideDoor:(id)sender {
    imageOption = VINImage;
    [self useCamera:self];
}

- (IBAction)onPassengerSideRead:(id)sender {
    imageOption = POIPassengerSideRear;
    [self useCamera:self];
}

- (IBAction)onHailDamage:(id)sender {
    imageOption = POIHailDamage;
    [self useCamera:self];
}

- (IBAction)onRoofPanel:(id)sender {
    imageOption = POIRoofPanel;
    [self useCamera:self];
}

- (IBAction)onRearCenter:(id)sender {
    imageOption = POIRearCenter;
    [self useCamera:self];
}

- (IBAction)onLogo:(id)sender {
    NSURL *myURL = [NSURL URLWithString:@"http://www.hybridclaims.com"];
    
    if( [[UIApplication sharedApplication] canOpenURL:myURL] )
        [[UIApplication sharedApplication] openURL:myURL];
}

- (void)dealloc {
    dispatch_release(dQueue);
    if( self.connection )
    {
        [self.connection cancel];
        [self.connection release];
    }
    
    [_driverSideFrontButton release];
    [_frontCenterButton release];
    [_passengerSideFrontButton release];
    [_hailDamageButton release];
    [_driverSideDoorButton release];
    [_passengerSideDoorButton release];
    [_roofPanelButton release];
    [_driverSideRearButton release];
    [_rearCenterButton release];
    [_passengerSideRearButton release];
    [_maskView release];
    [_carImage release];
    [super dealloc];
}
@end
