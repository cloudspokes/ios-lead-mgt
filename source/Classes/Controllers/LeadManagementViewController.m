//
//  LeadManagementViewController.m
//  LeadManagement
//
//  Created by Stefano Acerbetti on 6/14/11.
//  Copyright 2011 CloudSpokes. All rights reserved.
//

#import "LeadManagementViewController.h"

#import "AddPickListViewController.h"
#import "AddTextViewController.h"
#import "ModelAttachment.h"
#import "ModelCreate.h"
#import "ModelDescribeSObject.h"
#import "UIImage+Resize.h"
#import "ZKDescribeField.h"
#import "ZKDescribeSObject.h"
#import "ZKSaveResult.h"

#define kImageModeFullSize		0
#define kImageModeMediumSize	1
#define kImageModeSmallSize		2

#define kHudStatusCompleted     @"Completed"
#define kHudStatusEncoding      @"Encoding Photo..."
#define kHudStatusSaving        @"Saving..."

// this is to intotruce the required property without using the describe layout
// it's not 100% accurate, but it's ok for the scope of this app

@interface ZKDescribeField(Required)

- (BOOL)required;

@end

#pragma mark -

@implementation ZKDescribeField(Required)

- (BOOL)required {
	return ![self nillable];
}

@end

#pragma mark -

@implementation LeadManagementViewController

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	
	// init the model to save a lead
	_modelCreate = [ModelCreate new];
	_modelCreate.objectName = @"Lead";

	// init the model to send the attachment
	_modelAttach = [ModelAttachment new];
	
	// init the model to describe the fields
	_modelDescribe = [ModelDescribeSObject new];
	_modelDescribe.objectName = @"Lead";
	
	// set myself for notifications
	[_modelAttach.delegates addObject:self];
	[_modelCreate.delegates addObject:self];
	[_modelDescribe.delegates addObject:self];
	
	// The hud will dispable all input on the view
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.delegate = self;
    
    // The sample image is based on the work by www.pixelpressicons.com, http://creativecommons.org/licenses/by/2.5/ca/
    // Make the customViews 37 by 37 pixels for best results (those are the bounds of the build-in progress indicators)
    HUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] autorelease];
    [self.navigationController.view addSubview:HUD];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	// update the content of the cells 
	[self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

#pragma mark -
#pragma mark Actions

- (void)parseLayout:(ZKDescribeSObject *)result {
	// this is the array of field name that we want to show on the page
	// order is important
	NSArray *fieldNames = [NSArray arrayWithObjects:@"lastname", @"firstname", @"company", @"status", @"email", @"website", @"phone", @"mobilephone", @"street", @"city", @"state", @"postalcode", nil];
	
	// now get the field data using the names
	for (NSString *fName in fieldNames) {
		ZKDescribeField *field = [result fieldWithName:fName];
		
		// make sure the field exists
		if (field != nil) {
			[_fields addObject:field];
		}
	}
}

- (NSString *)valueForIndex:(NSUInteger)index {
	ZKDescribeField *field = [_fields objectAtIndex:index];
	return [_values objectForKey:[field name]];
}

- (void)clean {
	[HUD hide:YES];

	// remove all the data e reload the table
	[_values removeAllObjects];
	[self.tableView reloadData];
}

- (void)save {
	// check if the required fields are populated
	BOOL isValidLead = YES;
	for (ZKDescribeField *field in _fields) {
		if (isValidLead && [field required] && [[_values objectForKey:[field name]] length] == 0) {
			isValidLead = NO;
		}
	}
	
	if (isValidLead) {
		// save the lead
		_modelCreate.values = _values;
		[_modelCreate execute];
		
	} else {
		// show the error for missing required field
		NSDictionary *errorInfo = [NSDictionary dictionaryWithObject:@"Missing some required fields" forKey:NSLocalizedDescriptionKey];
		[self modelHasFailed:_modelCreate withError:[NSError errorWithDomain:@"InsertLeadBasicInfo"
																		code:-2001
																	userInfo:errorInfo]];
	}
}


#pragma mark -
#pragma mark LoginModel Delegate

- (void)loginSuccess {
	// get the fields if necessary
	if (_modelDescribe.result == nil) {
		[_modelDescribe execute];
		
		// create the array for storing the fields
		[_fields release];
		_fields = [[NSMutableArray alloc] init];
		
		// create the array for storing the values
		[_values release];
		_values = [[NSMutableDictionary alloc] init];
	}
}


#pragma mark -
#pragma mark Model Delegate

- (void)modelWillExecute:(Model *)model {
	if (model != _modelDescribe) {
		HUD.mode = MBProgressHUDModeIndeterminate;
		HUD.labelText = kHudStatusSaving;
		[HUD show:YES];
	}
}

- (void)modelHasChanged:(Model *)model {
    
    if (model != _modelDescribe) {
        HUD.labelText = kHudStatusCompleted;
        HUD.mode = MBProgressHUDModeCustomView;
    }
	
	// show the completed status for a little bit
	if (model == _modelCreate) {
		// go for the attachment
		[self performSelector:@selector(askForAttachment) withObject:nil afterDelay:1.0];
		
	} else if (model == _modelAttach) {
		// start from the beginning
		[self performSelector:@selector(clean) withObject:nil afterDelay:1.0];
	
	} else if (model == _modelDescribe) {
		// build the layout of the page
		[self parseLayout:_modelDescribe.result];
		
		// enable the save button
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
																								target:self
																								action:@selector(save)]
												  autorelease];
		
		// reload the page with the fields loaded from the API
		[self.tableView reloadData];
	}
}

- (void)modelHasFailed:(Model *)model withError:(NSError *)error {
	[HUD hide:YES];
	
	UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:nil
													 message:[error localizedDescription]
													delegate:nil 
										   cancelButtonTitle:@"OK"
										   otherButtonTitles:nil]
						  autorelease];
	[alert show];
}



#pragma mark -
#pragma mark Attachment

- (void)askForAttachment {
	[HUD hide:YES];
	
	UIActionSheet* imageActions = [[[UIActionSheet alloc] initWithTitle:@"Do you want to attach a photo?" 
															   delegate:self 
													  cancelButtonTitle:@"Skip"
												 destructiveButtonTitle:nil
													  otherButtonTitles:@"Full Size", @"Medium Size (50%)", @"Small Size (25%)", nil]
								   autorelease];
	imageActions.actionSheetStyle = UIActionSheetStyleDefault;
	[imageActions showInView:self.view];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 3) {
		// cancel button
		[self clean];
		
	} else {
		// set the selected image mode
		_imageMode = buttonIndex;
		
		// launch the camera app if it's mounted on the phone
		UIImagePickerController* controller = [[UIImagePickerController alloc] init];
		controller.sourceType = ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) ? UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypePhotoLibrary;
		controller.delegate = self;
		[self presentModalViewController:controller animated:YES];
		[controller release];
	}
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	// Access the uncropped image from info dictionary
	UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
	
	// calculate the size for the resize algo
	CGSize size = image.size;
	CGFloat maxsize = MAX(size.width, size.height);
	
	// limit to 3.2MP
	maxsize = MIN(maxsize, 2048.0f);
	
	switch (_imageMode) {
		case kImageModeFullSize:
			image = [image scaleAndRotateImageWithMaxResolution:maxsize];
			break;
			
		case kImageModeMediumSize:
			image = [image scaleAndRotateImageWithMaxResolution:maxsize/2.0f];
			break;
			
		case kImageModeSmallSize:
			image = [image scaleAndRotateImageWithMaxResolution:maxsize/4.0f];
			break;
	}
	
	// encode the image on a separate thread
    HUD.mode = MBProgressHUDModeIndeterminate;
	HUD.labelText = kHudStatusEncoding;
	[HUD showWhileExecuting:@selector(encodeImage:) onTarget:self withObject:image animated:YES];
	
	[picker dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[self clean];
	
	// don't add the attachment to this lead
	[picker dismissModalViewControllerAnimated:YES];
}

- (void)encodeImage:(UIImage *)image {
	// endode the image on the background thread
	[_modelAttach setImage:image andReferenceId:[_modelCreate.result id]];
}


#pragma mark -
#pragma mark MBProgressHUDDelegate

- (void)hudWasHidden {
    if ([HUD.labelText isEqualToString:kHudStatusEncoding]) {
        // this will be called when the task to encode the image is done
        [_modelAttach execute];
    }
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return MAX(1, [_fields count]);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if ([_fields count] > 0) {
		ZKDescribeField* field = [_fields objectAtIndex:section];
		if ([field required]) {
			return [NSString stringWithFormat:@"%@ - Required", [field label]];
		
		} else {
			return [field label];
		}
	}
	return nil;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	if (_modelDescribe.result != nil) {
		// when the layout is ready, load from the values
		cell.textLabel.text = [self valueForIndex:[indexPath section]];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
	} else {
		// before the layout is ready
		cell.textLabel.text = @"Loading the layout...";
		cell.accessoryType = UITableViewCellAccessoryNone;
	}

    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	// if the fields are not ready, don't do anything
	if (_modelDescribe.result != nil) {
		
		UIViewController<AddFieldControllerProtocol> *controller = nil;
		ZKDescribeField *field = [_fields objectAtIndex:[indexPath section]];
		NSString *fieldType = [field type];
		
		if ([fieldType isEqualToString:@"picklist"]) {
			// open the picklist controller
			controller = [[AddPickListViewController alloc] initWithStyle:UITableViewStylePlain];
			
		} else {
			// open the generic one to enter free text
			controller = [[AddTextViewController alloc] init];
		}
		
		// set the properies
		controller.values = _values;
		controller.field = field;
		controller.title = [field label];
		
		// show the controller
		[self.navigationController pushViewController:controller animated:YES];
		[controller release];
	}
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)dealloc {
	[HUD release]; HUD = nil;
	[_modelAttach release]; _modelAttach = nil;
	[_modelCreate release]; _modelCreate = nil;
	[_modelDescribe release]; _modelDescribe = nil;
	[_fields release]; _fields = nil;
	[_values release]; _values = nil;
    [super dealloc];
}

@end