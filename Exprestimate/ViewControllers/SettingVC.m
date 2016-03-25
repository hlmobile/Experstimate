//
//  SettingVC.m
//  Exprestimate
//
//  Created by devmania on 3/13/14.
//  Copyright (c) 2014 HybridClaims. All rights reserved.
//

#import "SettingVC.h"

@interface SettingVC ()

@end

@implementation SettingVC

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
    // Do any additional setup after loading the view from its nib.
    
    NSString *bRuler = [[NSUserDefaults standardUserDefaults] objectForKey:@"showRuler"];
    
    if (bRuler && [bRuler isEqualToString:@"YES"]) {
        [self.rulerButton setImage:[UIImage imageNamed:@"check1.png"] forState:UIControlStateNormal];
    }
    
    vehicleArr = [[NSArray alloc] initWithObjects:@"convertible", @"ferrari", @"porsche", @"sedan", @"truck", nil];
    UIImageView *img;
    NSString *imgName;
    CGSize imgSize = self.scrollView.frame.size;
    
    for (int i=0; i<[vehicleArr count]; i++) {
        
        img = [[UIImageView alloc] initWithFrame:CGRectMake(imgSize.width*i, 0, imgSize.width, imgSize.height)];
        imgName = [[vehicleArr objectAtIndex:i] stringByAppendingString:@".png"];
        [img setImage:[UIImage imageNamed:imgName]];
        [self.scrollView addSubview:img];
    }
    
    [self.scrollView setContentSize:CGSizeMake(imgSize.width*[vehicleArr count], imgSize.height)];
    [self.scrollView setPagingEnabled:YES];
    [self loadVehicle];
}

- (void) viewWillDisappear:(BOOL)animated
{
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int pageindex = floor(self.scrollView.contentOffset.x / pageWidth);
    
    NSString *strIndex = [NSString stringWithFormat:@"%d", pageindex];
    
    [[NSUserDefaults standardUserDefaults] setObject:strIndex forKey:@"VehicleType"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) loadVehicle
{
    NSString *strVehicleType = [[NSUserDefaults standardUserDefaults] objectForKey:@"VehicleType"];
    int vehicleIndex = 2;
    
    if (strVehicleType) {
        vehicleIndex = [strVehicleType intValue];
    }

    CGFloat offsetX = self.scrollView.frame.size.width * vehicleIndex;
    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onHome:(id)sender {
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

- (IBAction)onRuler:(id)sender {
    NSString *bRuler = [[NSUserDefaults standardUserDefaults] objectForKey:@"showRuler"];
    
    if (bRuler && [bRuler isEqualToString:@"YES"]) {
        [self.rulerButton setImage:[UIImage imageNamed:@"check2.png"] forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"showRuler"];
    }
    else
    {
        [self.rulerButton setImage:[UIImage imageNamed:@"check1.png"] forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"showRuler"];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)onLogo:(id)sender {
    NSURL *myURL = [NSURL URLWithString:@"http://www.hybridclaims.com"];
    
    if( [[UIApplication sharedApplication] canOpenURL:myURL] )
        [[UIApplication sharedApplication] openURL:myURL];
}

- (void)dealloc {
    [_rulerButton release];
    [_scrollView release];
    [super dealloc];
}
@end
