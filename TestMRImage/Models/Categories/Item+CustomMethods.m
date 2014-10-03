//
//  Item+CustomMethods.m
//  TestMRImage
//
//  Created by Nicholas Jones on 03/10/2014.
//  Copyright (c) 2014 sigf. All rights reserved.
//

#import "Item+CustomMethods.h"
#import "Image+CustomMethods.h"

@implementation Item (CustomMethods)

-(NSString*)nameInitial {
    if ([self.name length] > 0) {
        //     NSLog(@"Item Name: %@", self.name);
        return [[self.name substringToIndex:1] uppercaseString];
    } else {
        return @"";
    }
}
-(Image*)image {
    return [Image MR_findFirstByAttribute:@"uuid" withValue:self.imageUuid];
}

@end
