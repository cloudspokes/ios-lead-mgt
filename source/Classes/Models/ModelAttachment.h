//
//  ModelAttachment.h
//  LeadManagement
//
//  Created by Stefano Acerbetti on 6/14/11.
//  Copyright 2011 CloudSpokes. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ModelCreate.h"

@interface ModelAttachment : ModelCreate {

}

- (void)setImage:(UIImage *)image andReferenceId:(NSString *)reference;

@end
