//
//  ParserXML.h
//  Forex Yellow Pages
//
//  Created by toltol gim on 2/15/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KElement.h"

@interface ParserXML : NSObject 
{
    
}

+ (KElement *)parse:(NSString *)strXML;

@end
