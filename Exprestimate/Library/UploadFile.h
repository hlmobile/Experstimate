//
//  UploadFile.h
//  Vizzume
//
//  Created by devmania on 11/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    UPLOAD_READY,
    UPLOAD_STARTED,
    UPLOAD_FAILED,
    UPLOAD_SUCCESS
    
} UPLOAD_STATUS;

@interface UploadFile : NSObject
{

    NSString *          urlOfServerToUpload;
    NSString *          pathOfFileToUpload;
    
    NSMutableDictionary *   uploadParameters;//(key => string)
    NSMutableData *         receivedData;
    NSURLConnection *       connection;
    
    UPLOAD_STATUS   status;
    int             tag;
}

@property ( assign ) UPLOAD_STATUS  status;
@property ( assign ) int            tag;

@property ( copy ) NSString *     urlOfServerToUpload;
@property ( copy ) NSString *     pathOfFileToUpload;
@property ( retain ) UIImage *    imageToUpload;
@property ( retain ) NSString *     fileName;

- (id)initWithURLOfServer:(NSString *)serverURL andFilePath:(NSString *)path;
- (id)initWithURLOfServer:(NSString *)serverURL andFile:(UIImage *)img andFileName:(NSString*)fname;
- (void)addUploadParameter:(NSString *)param andValue:(NSString *)val;
- (void)startWithSynchronize:(BOOL)isSynch;
- (void)stop;
- (NSString *)getString;
- (BOOL)isUploadSuccess;
@end



#define kUploadFinishedNotification             @"UploadDidFinishedNotification"