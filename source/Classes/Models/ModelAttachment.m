//
//  ModelAttachment.m
//  LeadManagement
//
//  Created by Stefano Acerbetti on 6/14/11.
//  Copyright 2011 CloudSpokes. All rights reserved.
//

#import "ModelAttachment.h"

#import "NSData+Base64.h"

@implementation ModelAttachment

- (id)init {
	if (self = [super init]) {
		self.objectName = @"Attachment";
	}
	return self;
}

- (void)setImage:(UIImage *)image andReferenceId:(NSString *)reference {
	// convert the image to a base64 string
	NSData *imageData = UIImageJPEGRepresentation(image, 0.8f);
	NSString *encodedString = [imageData base64EncodedString];
	
	// now I can set the parameters
	self.values = [NSDictionary dictionaryWithObjectsAndKeys:
				   encodedString, @"Body",
				   @"image/JPEG", @"ContentType",
				   @"photo.jpg", @"Name",
				   reference, @"ParentId",
				   nil];
}

@end
