//
//  ModelDescribeSObject.h
//  LeadManagement
//
//  Created by Stefano Acerbetti on 6/15/11.
//  Copyright 2011 CloudSpokes. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Model.h"

@class ZKDescribeSObject;

@interface ModelDescribeSObject : Model {
	ZKDescribeSObject *_result;
}

@property (nonatomic, readonly) ZKDescribeSObject *result;

@end
