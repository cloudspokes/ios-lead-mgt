    //
//  AddTextViewController.m
//  LeadManagement
//
//  Created by Stefano Acerbetti on 6/14/11.
//  Copyright 2011 CloudSpokes. All rights reserved.
//

#import "AddTextViewController.h"

#import "ZKDescribeField.h"

@implementation AddTextViewController

@synthesize field = _field;
@synthesize values = _values;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	// set the done button	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
																							target:self
																							action:@selector(done)]
											  autorelease];
	
	// create the textfield
	_textField = [[UITextField alloc] initWithFrame:CGRectMake(5.0, 5.0, self.view.frame.size.width-10.0, 30.0)];
	_textField.delegate = self;
	_textField.font = [UIFont systemFontOfSize:18.0];
	_textField.text = [self.values objectForKey:[self.field name]];
	_textField.autocorrectionType = UITextAutocorrectionTypeNo;
	
	// chose the keyboard associated at this controller
	NSString *type = [self.field type];
	if ([type isEqualToString:@"phone"]) {
		_textField.keyboardType = UIKeyboardTypePhonePad;
		
	} else if ([type isEqualToString:@"email"]) {
		_textField.keyboardType = UIKeyboardTypeEmailAddress;
		_textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
		
	} else if ([type isEqualToString:@"url"]) {
		_textField.keyboardType = UIKeyboardTypeURL;
		_textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	}
	
	[_textField becomeFirstResponder];
	[self.view addSubview:_textField];
	
	// create the counter label
	_counter = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 100.0, self.view.frame.size.width-20.0, 16.0)];
	_counter.textAlignment = UITextAlignmentRight;
	_counter.textColor = [UIColor darkGrayColor];
	_counter.font = [UIFont systemFontOfSize:14.0];
	[self.view addSubview:_counter];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	// update the layout
	_textField.frame = CGRectMake(5.0, 5.0, self.view.frame.size.width-10.0, 200.0);
	_counter.frame = CGRectMake(10.0, 80.0, self.view.frame.size.width-20.0, 16.0);
}

#pragma mark -
#pragma mark UITextFieldDelegate

// return NO to not change text
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	// update the counter
	NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
	NSUInteger inputLen = [newString length];
	NSUInteger maxLen = [self.field length];	
	_counter.text = [NSString stringWithFormat:@"%d / %d", inputLen, maxLen];
	
	// check the limit
    return inputLen < maxLen;
}


#pragma mark -
#pragma mark Actions

- (void)done {
	// update the dictionary with the new value
	[self.values setObject:_textField.text forKey:[self.field name]];
	
	// remove the view from the navigation controller
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


#pragma mark -
#pragma mark Memory management


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
	[_textField release]; _textField = nil;
	[_counter release]; _counter = nil;
	[super dealloc];
}

@end
