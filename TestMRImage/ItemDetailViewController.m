//
//  ItemDetailViewController.m
//  TestMRImage
//
//  Created by Nicholas Jones on 03/10/2014.
//  Copyright (c) 2014 sigf. All rights reserved.
//

#import "ItemDetailViewController.h"
#import "Item+CustomMethods.h"  
#import "Image+CustomMethods.h"
#import "ItemEditViewController.h"
#import "AppDelegate.h"

@interface ItemDetailViewController () {
    AppDelegate *app;
}
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *refLabel;
@property (weak, nonatomic) IBOutlet UILabel *imageUuidLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation ItemDetailViewController

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
        app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editItem:)];
    [self updateLabels];
}


-(void)updateLabels {
    Item *localItem = [self item];
    self.nameLabel.text = localItem.name;
    self.imageUuidLabel.text = localItem.imageUuid;
    self.refLabel.text = localItem.ref;
    self.itemImageView.image = [UIImage imageWithData:localItem.image.data];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)editItem:(id)sender {
    ItemEditViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"EditItemVC"];
    controller.itemUuid = self.itemUuid;
    controller.delegate = self;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    if (app.isiOS7Plus){
        navController.navigationBar.barStyle = UIBarStyleBlack;
    }
    if(app.isPhone) {
        navController.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    else  {
        navController.modalPresentationStyle = UIModalPresentationFormSheet;
        navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    }
    [self presentViewController:navController animated:YES completion:nil];
}
-(Item*)item {
    return [Item MR_findFirstByAttribute:@"uuid" withValue:self.itemUuid];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    if([segue.destinationViewController respondsToSelector:@selector(setItemUuid:)]) {
        [segue.destinationViewController performSelector:@selector(setItemUuid:) withObject:self.itemUuid];
    }
}

#pragma mark - ModalDelegate

-(void)refreshAfterModalDismiss {
    [self updateLabels];
}

@end
