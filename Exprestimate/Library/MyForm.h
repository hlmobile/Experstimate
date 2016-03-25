//
//  MyForm.h
//  Exprestimate
//
//  Created by devmania on 3/12/14.
//  Copyright (c) 2014 HybridClaims. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyImageFile.h"

@interface MyForm : NSObject

@property int type;
@property (retain ) NSString* FormID;
@property (retain ) NSString* Name;
@property (retain ) NSString* Address;
@property (retain ) NSString* PhoneNO;
@property (retain ) NSString* ReferringCarrier;
@property (retain ) NSString* Deductible;
@property (retain ) NSString* ReferringAdjuster;
@property (retain ) NSString* ReferringAdjusterPhoneNO;
@property (retain ) NSString* ReferringAdjusterEmailAddress;
@property (retain ) NSString* ClaimNO;
@property (retain ) NSString* DateOfLoss;
@property (retain ) NSString* VehicleYear;
@property (retain ) NSString* VehicleModel;
@property (retain ) NSString* VehicleMake;
@property (retain ) NSString* VINNO;
@property (retain ) NSString* InsuranceIDCard;
@property (retain ) NSString* Notes;
@property (retain ) NSString* UDID;
@property (retain ) NSString* ReportDate;
@property (retain ) NSString* InsuranceCarrier;
@property (retain ) NSString* EmailAddress;
@property (retain ) NSMutableArray* images;

- (void) addImage:(UIImage*)img withPOI:(int)poi;
- (void) uploadImages;

@end
