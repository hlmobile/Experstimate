//
//  ViewPhotoVC.m
//  Exprestimate
//
//  Created by devmania on 3/12/14.
//  Copyright (c) 2014 HybridClaims. All rights reserved.
//

#import "ViewPhotoVC.h"
#import "ActivityIndicator.h"
#import "KElement.h"
#import "ParserXML.h"

#define kGetPhotoURL    @"http://198.66.209.87/API/getPhoto.php"
#define kServerStorageURL @"http://198.66.209.87/Uploads/"

@interface ViewPhotoVC ()

@end

@implementation ViewPhotoVC

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
    
    [self loadImage];
}

- (void) loadImage
{
    NSURL *aUrl = [NSURL URLWithString:kGetPhotoURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"*****com.hybridclaims.formboundary";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData * postBody = [NSMutableData data];
    
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"formid"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[self.formid dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", @"poi"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[self.poi dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:postBody];
    [request setValue:[NSString stringWithFormat:@"%d", [postBody length]] forHTTPHeaderField:@"Content-Length"];
    
    NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request
                                                                 delegate:self];
    
    [[ActivityIndicator currentIndicator] displayActivity:@"Loading..."];
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
    NSLog(@"%@", error);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn
{
    NSString * xml = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", xml);
    
    KElement * rootElement = [ParserXML parse:xml];
    
    NSString *status = [rootElement getValueOfTag:@"status"];
    
    NSString *imageURL;
    
    if( [status isEqualToString:@"ok"] )
    {
        NSArray* arrItems = ((KElement*)[rootElement.chld objectAtIndex:1]).chld;
        
        if (arrItems==nil || [arrItems count]==0) {
            [[ActivityIndicator currentIndicator] hide];
            return;
        }
        
        KElement *firstRecord  = [arrItems objectAtIndex:0];
        
        imageURL = [kServerStorageURL stringByAppendingString:[firstRecord getValueOfTag:@"UDID"]];
        imageURL = [NSString stringWithFormat:@"%@/%@__%@", imageURL, self.formid, [firstRecord getValueOfTag:@"path"]];
        NSLog(imageURL);
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]];
        self.imageView.image = image;
    }
    
    [[ActivityIndicator currentIndicator] hide];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    [_imageView release];
    [super dealloc];
}
@end
