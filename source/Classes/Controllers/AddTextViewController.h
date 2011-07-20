//
//  AddTextViewController.h
//  LeadManagement
//
//  Created by Stefano Acerbetti on 6/14/11.
//  Copyright 2011 CloudSpokes. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AddFieldControllerProtocol.h"

@interface AddTextViewController : UIViewController<AddFieldControllerProtocol, UITextFieldDelegate> {
	ZKDescribeField *_field;
	NSMutableDictionary *_values;
	
	UITextField *_textField;
	UILabel *_counter;
}

@end
