//
//  MyForm.m
//  Exprestimate
//
//  Created by devmania on 3/12/14.
//  Copyright (c) 2014 HybridClaims. All rights reserved.
//

#import "MyForm.h"
#import "UploadFile.h"

#define kUploadImageURL    @"http://198.66.209.87/API/uploadPhoto.php"

@implementation MyForm

- (void) addImage:(UIImage*)img withPOI:(int)poi
{
    if (self.images==nil) {
        self.images = [NSMutableArray array];
    }
    
    if (poi == VINImage || poi == InsuranceIDCardImage) {
        for (int i=0; i<[self.images count]; i++) {
            
            MyImageFile *tempImage = [self.images objectAtIndex:i];
            
            if (tempImage.poi == poi)
            {
                tempImage.image = img;
                return;
            }
        }
    }
    
    MyImageFile *tempImage = [[MyImageFile alloc] init];
    tempImage.poi = poi;
    tempImage.image = img;
    
    [self.images addObject:tempImage];
}

- (void) uploadImages
{
    NSString *imageName;
    NSString *poiStr;
    MyImageFile *aImage;
    
    for (int i=0; i<[self.images count]; i++) {
        imageName = [NSString stringWithFormat:@"img%d.jpg",i];
        aImage = [self.images objectAtIndex:i];
        poiStr = [NSString stringWithFormat:@"%d", aImage.poi];
        
        UploadFile * uploadFile = [[UploadFile alloc] initWithURLOfServer:kUploadImageURL andFile:aImage.image andFileName:imageName];
        [uploadFile addUploadParameter:@"formid" andValue:self.FormID];
        [uploadFile addUploadParameter:@"UDID" andValue:self.UDID];
        [uploadFile addUploadParameter:@"POI" andValue:poiStr];
        [uploadFile startWithSynchronize:YES];
        NSLog(@"%@", [uploadFile getString]);
        [uploadFile release];
    }
}

@end
