//
//  Image+CustomMethods.h
//  TestMRImage
//
//  Created by Nicholas Jones on 03/10/2014.
//  Copyright (c) 2014 sigf. All rights reserved.
//

#import "Image.h"
#import "constants.h"

@interface Image (CustomMethods)
+ (Image *)imageFromUIImage:(UIImage *)originalImage imageType:(EImageType)type inContext:(NSManagedObjectContext*)context;
@end
