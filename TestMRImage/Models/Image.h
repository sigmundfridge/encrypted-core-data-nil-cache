//
//  Image.h
//  TestMRImage
//
//  Created by Nicholas Jones on 03/10/2014.
//  Copyright (c) 2014 sigf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SyncObject.h"


@interface Image : NSManagedObject

@property (nonatomic, retain) NSData * data;
@property (nonatomic, retain) NSString * mimeType;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSString * uuid;

@end
