//
//  MyImageFile.h
//  Exprestimate
//
//  Created by devmania on 3/12/14.
//  Copyright (c) 2014 HybridClaims. All rights reserved.
//

#import <Foundation/Foundation.h>

#define POIPassengerSideFront           1
#define POIPassengerSideRear            2
#define POIPassengerSideDoors           3
#define POIDriverSideFront              4
#define POIDriverSideRear               5
#define POIDriverSideDoors              6
#define POIFrontCenter                  7
#define POIRearCenter                   8
#define POIRoofPanel                    9
#define POIHailDamage                   10
#define POIUnknown                      11
#define VINImage                        100
#define InsuranceIDCardImage            101

@interface MyImageFile : NSObject

@property int poi;
@property (retain) UIImage* image;

@end
