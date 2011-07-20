//
//  LeadManagementViewController.h
//  LeadManagement
//
//  Created by Stefano Acerbetti on 6/14/11.
//  Copyright 2011 CloudSpokes. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ModelProtocols.h"
#import "MBProgressHUD.h"

@class ModelAttachment;
@class ModelCreate;
@class ModelDescribeSObject;

@interface LeadManagementViewController : UITableViewController<LoginModelDelegate, ModelDelegate, MBProgressHUDDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
	ModelCreate *_modelCreate;
	ModelAttachment *_modelAttach;
	ModelDescribeSObject *_modelDescribe;
	
	MBProgressHUD *HUD;
	
	NSMutableArray *_fields;
	NSMutableDictionary *_values;
	
	int _imageMode;
}

@end

