//
//  AddFieldControllerProtocol.h
//  LeadManagement
//
//  Created by Stefano Acerbetti on 6/15/11.
//  Copyright 2011 CloudSpokes. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZKDescribeField;

@protocol AddFieldControllerProtocol<NSObject>

@property (assign, nonatomic) ZKDescribeField *field;
@property (assign, nonatomic) NSMutableDictionary *values;

@end
