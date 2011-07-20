//
//  LeadManagementAppDelegate.h
//  LeadManagement
//
//  Created by Stefano Acerbetti on 6/14/11.
//  Copyright 2011 CloudSpokes. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LeadManagementViewController;
@class ModelLogin;

@interface LeadManagementAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	LeadManagementViewController *leadManagerController;
	ModelLogin *_loginModel;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet LeadManagementViewController* leadManagerController;

- (IBAction)logOut;

@end

