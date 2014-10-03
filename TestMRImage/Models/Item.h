//
//  Item.h
//  TestMRImage
//
//  Created by Nicholas Jones on 03/10/2014.
//  Copyright (c) 2014 sigf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SyncObject.h"


@interface Item : NSManagedObject

@property (nonatomic, retain) NSString * imageUuid;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * ref;
@property (nonatomic, retain) NSString * uuid;
@end
