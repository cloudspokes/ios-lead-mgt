//
//  AddPickListViewController.h
//  LeadManagement
//
//  Created by Stefano Acerbetti on 6/14/11.
//  Copyright 2011 CloudSpokes. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AddFieldControllerProtocol.h"

@interface AddPickListViewController : UITableViewController<AddFieldControllerProtocol> {
	ZKDescribeField *_field;
	NSMutableDictionary *_values;
}

@end
