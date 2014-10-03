//
//  AppDelegate.h
//  TestMRImage
//
//  Created by Nicholas Jones on 29/09/2014.
//  Copyright (c) 2014 sigf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic) BOOL isPhone;
@property (nonatomic) BOOL isiOS7Plus;
@property (nonatomic) BOOL isiOS8Plus;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

