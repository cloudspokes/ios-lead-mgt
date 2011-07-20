//
//  ModelDescribeSObject.m
//  LeadManagement
//
//  Created by Stefano Acerbetti on 6/15/11.
//  Copyright 2011 CloudSpokes. All rights reserved.
//

#import "ModelDescribeSObject.h"

#import "FDCServerSwitchboard+Describe.h"
#import "ZKDescribeSObject.h"

@implementation ModelDescribeSObject

@synthesize result = _result;

- (void)execute {
	[super execute];
	
	[[FDCServerSwitchboard switchboard] describeSObject:self.objectName
												 target:self
											   selector:@selector(describeSObjectResult:error:context:)
												context:nil];
}



- (void)describeSObjectResult:(ZKDescribeSObject *)result error:(NSError *)error context:(id)context {
    NSLog(@"describeLayoutResult: %@ error: %@ context: %@", result, error, context);
  
	if (result && !error) {
		_result = [result retain];
		[_result fields];
		[self modelHasChanged];
		
    } else if (error) {
		_result = nil;
        [self modelFailedWithError:error];
    }
}

- (void)dealloc {
	[_result release]; _result = nil;
	[super dealloc];
}

@end
