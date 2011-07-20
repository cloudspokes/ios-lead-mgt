//
//  UIImage+Resize.h
//  LeadManagement
//
//  Created by Stefano Acerbetti on 6/15/11.
//  Copyright 2011 CloudSpokes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage(Resize)

- (UIImage *)scaleAndRotateImageWithMaxResolution:(CGFloat)maxResolution;
- (UIImage *)rotateImage;

@end
