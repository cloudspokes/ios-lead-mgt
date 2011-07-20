//
//  AddPickListViewController.m
//  LeadManagement
//
//  Created by Stefano Acerbetti on 6/14/11.
//  Copyright 2011 CloudSpokes. All rights reserved.
//

#import "AddPickListViewController.h"

#import "ZKDescribeField.h"
#import "ZKPicklistEntry.h"

@implementation AddPickListViewController

@synthesize field = _field;
@synthesize values = _values;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[self.field picklistValues] count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	ZKPicklistEntry *plEntry = [[self.field picklistValues] objectAtIndex:[indexPath row]];
    cell.textLabel.text = [plEntry label];
	
	// Show the check for the previous selected option
	NSString *value = [self.values objectForKey:[self.field name]];
	cell.accessoryType = ([value isEqualToString:[plEntry label]]) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
	
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// update the dictionary with the new value
	ZKPicklistEntry *plEntry = [[self.field picklistValues] objectAtIndex:[indexPath row]];
	[self.values setObject:[plEntry value] forKey:[self.field name]];
	
	// remove the view from the navigation controller
	[self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

@end

