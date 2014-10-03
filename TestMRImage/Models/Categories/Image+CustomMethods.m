//
//  Image+CustomMethods.m
//  TestMRImage
//
//  Created by Nicholas Jones on 03/10/2014.
//  Copyright (c) 2014 sigf. All rights reserved.
//

#import "Image+CustomMethods.h"

@implementation Image (CustomMethods)

+ (Image *)imageFromUIImage:(UIImage *)originalImage imageType:(EImageType)type inContext:(NSManagedObjectContext*)context{
    Image *image = [Image MR_createEntityInContext:context];
    image.uuid = [[[NSUUID UUID] UUIDString] lowercaseString];
    image.data = UIImageJPEGRepresentation(originalImage, 0.7);
    image.mimeType = @"image/jpeg";
    switch (type) {
        case EImageTypeCatalogImage:
            image.type = @1;
            break;
        case EImageTypeMerchantLogo:
            image.type = @2;
            break;
        case EImageTypeSignature:
            image.type = @3;
            break;
        case EImageTypeTransactionImage:
            image.type = @4;
            break;
        case EImageTypeInvoiceSignature:
            image.type = @5;
            break;
        default:
            image.type = @4;
            break;
    }
//    image.createdAt = [NSDate date];
//    image.operationType = @(kSyncOperationCreate);
    return image;
}

@end
