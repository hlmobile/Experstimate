//
//  UploadFile.m
//  Vizzume
//
//  Created by devmania on 11/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UploadFile.h"
//#import "JSONKit.h"

@interface UploadFile ()
@property (retain) NSMutableData * receivedData;
@end;

@implementation UploadFile
@synthesize status;
@synthesize tag;
@synthesize urlOfServerToUpload;
@synthesize pathOfFileToUpload;
@synthesize receivedData;

- (id)initWithURLOfServer:(NSString *)serverURL andFilePath:(NSString *)path
{
    self = [super init];
    if( self != nil )
    {
        urlOfServerToUpload = [[NSString alloc] initWithString:serverURL];
        pathOfFileToUpload  = [[NSString alloc] initWithString:path];
        uploadParameters    = [[NSMutableDictionary alloc] init];
        
        receivedData = nil;    
        connection = nil;
        status = UPLOAD_READY;
    }
    
    return  self;
}

- (id)initWithURLOfServer:(NSString *)serverURL andFile:(UIImage *)img andFileName:(NSString*)fname
{
    self = [super init];
    if( self != nil )
    {
        urlOfServerToUpload = [[NSString alloc] initWithString:serverURL];
        self.imageToUpload  = img;
        self.fileName = fname;
        uploadParameters    = [[NSMutableDictionary alloc] init];
        
        receivedData = nil;
        connection = nil;
        status = UPLOAD_READY;
    }
    
    return  self;
}

- (void)dealloc
{
    [urlOfServerToUpload release];
    [pathOfFileToUpload release];
    [uploadParameters release];
    [receivedData release];

    [super dealloc];
}

- (void)addUploadParameter:(NSString *)param andValue:(NSString *)val
{
    if( param == nil || val == nil )
        return;
    [uploadParameters setObject:val forKey:param];
}

- (void)startWithSynchronize:(BOOL)isSynch
{
    if( urlOfServerToUpload == nil )
    {
        status = UPLOAD_FAILED;
        return;
    }
    
    NSURL * url = [NSURL URLWithString:urlOfServerToUpload];
    if( url == nil )
    {
        status = UPLOAD_FAILED;
        return;
    }

    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];

    NSString *boundary = @"*****com.exprestimate.formboundary";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];

    NSMutableData * postBody = [NSMutableData data];
    NSEnumerator * enumerator = [uploadParameters keyEnumerator];

    NSString * key;
    id val;
    while( (key = [enumerator nextObject]) )
    {
        val = [uploadParameters objectForKey:key];
        if( val == [NSNull null] )
            continue;

        // if it responds to stringValue selector (eg NSNumber) get the NSString
        if( [val respondsToSelector:@selector(stringValue)] )
        {
            val = [val stringValue];
        }
        
        // finally, check whether it is a NSString (for dataUsingEncoding selector below)
        if( ![val isKindOfClass:[NSString class]] )
            continue;
    
        [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[val dataUsingEncoding:NSUTF8StringEncoding]];
        [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }

    NSData *fileData = [NSData dataWithData:UIImageJPEGRepresentation(self.imageToUpload,0.2)];

    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\n", self.fileName] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"Content-Type: */*\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:fileData];
    [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];

    [request setHTTPBody:postBody];
    [request setValue:[NSString stringWithFormat:@"%d", [postBody length]] forHTTPHeaderField:@"Content-Length"];

    
    if( isSynch )
    {
        NSURLResponse * urlResponse = nil;
        NSError * error = nil;
        NSData * myData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
        if( (error == nil) && (myData != nil) )
        {
            self.receivedData = [NSMutableData dataWithData:myData];
            status = UPLOAD_SUCCESS;
        }
        else
            status = UPLOAD_FAILED;
    }
    else
    {
        connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        status = UPLOAD_STARTED;
    }
}

- (void)stop
{
    if( connection != nil )
    {
        if( status == UPLOAD_STARTED )
        {
            [connection cancel];
            status = UPLOAD_READY;
        }
    }    
}

- (BOOL)isUploadSuccess
{
    if( self.status == UPLOAD_SUCCESS )
    {
        NSString * response = [self getString];
        
        if( [response rangeOfString:@"Success"].location != NSNotFound )
            return YES;
    }
    
    return NO;
}

- (NSString *)getString
{
    NSString * retString = nil;
    if( self.status == UPLOAD_SUCCESS )
    {
        if( receivedData != nil )
        {
            retString = [[[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding] autorelease];
        }
    }
    return retString;
    
}

#pragma mark - URL Connection Delegate
- (void)connection:(NSURLConnection *)conn didReceiveResponse:(NSURLResponse *)response
{
    self.receivedData = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data
{
    [self.receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error
{
    [connection release];
    connection = nil;
    
    self.receivedData = nil;
    status = UPLOAD_FAILED;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kUploadFinishedNotification object:nil userInfo:nil];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn
{
    [connection release];
    connection = nil;

    status = UPLOAD_SUCCESS;
    [[NSNotificationCenter defaultCenter] postNotificationName:kUploadFinishedNotification object:nil userInfo:nil];
}

@end
