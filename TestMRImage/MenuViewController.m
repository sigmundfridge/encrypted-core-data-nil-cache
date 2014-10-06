//
//  MenuViewController.m
//  TestMRImage
//
//  Created by Nicholas Jones on 03/10/2014.
//  Copyright (c) 2014 sigf. All rights reserved.
//

#import "MenuViewController.h"
#import "SyncObject+CustomMethods.h"
#import "Item+CustomMethods.h"
#import "Image+CustomMethods.h"


@interface MenuViewController ()
- (IBAction)clearList:(id)sender;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)clearList:(id)sender {
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        [SyncObject MR_truncateAllInContext:localContext];
        [Item MR_truncateAllInContext:localContext];
        [Image MR_truncateAllInContext:localContext];
    }];
}
@end
