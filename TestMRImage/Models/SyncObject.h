//
//  SyncObject.h
//  TestMRImage
//
//  Created by Nicholas Jones on 03/10/2014.
//  Copyright (c) 2014 sigf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SyncObject : NSManagedObject

@property (nonatomic, retain) NSString * uuid;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSNumber * syncID;

@end
