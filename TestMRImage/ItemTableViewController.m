//
//  ItemTableViewController.m
//  TestMRImage
//
//  Created by Nicholas Jones on 01/10/2014.
//  Copyright (c) 2014 sigf. All rights reserved.
//

#import "ItemTableViewController.h"
#import "Item+CustomMethods.h"
#import "Image+CustomMethods.h"
#import "ItemDetailViewController.h"
#import "ItemTableViewCell.h"
#import "AppDelegate.h"

@interface ItemTableViewController () <NSFetchedResultsControllerDelegate> {
    AppDelegate *app;
}
@property(nonatomic, strong) NSFetchedResultsController *frc;
@end

@implementation ItemTableViewController

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
        app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem:)];
    NSError *error;
    if (![self.frc performFetch:&error]) {
        // Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);  // Fail
    }
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

-(void)addItem:(id)sender {
    ItemEditViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"EditItemVC"];
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

-(NSFetchedResultsController*)frc {
    if (!_frc) {
        _frc = [[NSFetchedResultsController alloc] init];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:nil];
        _frc = [Item MR_fetchAllSortedBy:@"name" ascending:YES withPredicate:predicate groupBy:@"nameInitial" delegate:self];
    }
    return _frc;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(self.frc.sections.count==0){
        return @"";
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    Item *item = [self.frc objectAtIndexPath:indexPath];
    return item.nameInitial;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 28;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 28)];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,0,280,28)];
    headerLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    headerLabel.backgroundColor=[UIColor blueColor];
    headerLabel.textColor=[UIColor whiteColor];
    [headerView addSubview:headerLabel];
    return headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.frc.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int rows = [self.frc.sections[section] numberOfObjects];
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.frc.sections.count==0){
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ItemCell"];
        return cell;
    }
    
    NSString *reusableIdentifier = @"ItemCell";
    ItemTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:reusableIdentifier];
    [self configureCell:cell atIndexPath:indexPath];
/*    cell.leftImageView.image = nil; //reset
    
    if(item.imageUuid == nil) {
        //could show placeholder
    }
    //already downloaded image
    else if(item.image !=nil) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *image = [UIImage imageWithData:item.image.data]; // expensive
            dispatch_async(dispatch_get_main_queue(), ^{
                CatalogueItemCell *currentCell = (CatalogueItemCell*)[tableView cellForRowAtIndexPath:indexPath];
                currentCell.leftImageView.image = image; // update UI
            });
        });
    }
    else if (item.image == nil && item.imageUuid !=nil) {
        //load existing image from database or download
        Image *existingImg = [Image MR_findFirstByAttribute:@"uuid" withValue:item.imageUuid];
        if(existingImg) {
            [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                CatalogueItem *localItem = (CatalogueItem*)[localContext objectWithID:itemID];
                localItem.image = existingImg;
            } completion:^(BOOL success, NSError *error) {
                CatalogueItemCell *currentCell = (CatalogueItemCell*)[tableView cellForRowAtIndexPath:indexPath];
                currentCell.leftImageView.image = [UIImage imageWithData:item.image.data];
            }];
        }
        else {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                id<ImageDTO> imageDTO = [[HessianTransport proxy] imageForAuthToken:[[User getCurrentUser] authenticationToken] withUUID:@{@"value": item.imageUuid}];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                        Image *image =[Image imageFromDTO:imageDTO inContext:localContext];
                        CatalogueItem *localItem = (CatalogueItem*)[localContext objectWithID:itemID];
                        localItem.image = image;
                    } completion:^(BOOL success, NSError *error) {
                        CatalogueItemCell *currentCell = (CatalogueItemCell*)[tableView cellForRowAtIndexPath:indexPath];
                        currentCell.leftImageView.image = [UIImage imageWithData:item.image.data];
                    }];
                });
            });
        }
    }*/
    
    return cell;
}

-(void)configureCell:(ItemTableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath {
    Item *localItem = [self.frc objectAtIndexPath:indexPath];
    cell.itemName.text = localItem.name;
    cell.itemImageView.image = [UIImage imageWithData:localItem.image.data];
}


- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56.0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Item *item = (Item*)[self.frc objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"ItemDetail" sender:item.uuid];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSString*)itemUuid {
    if([segue.destinationViewController respondsToSelector:@selector(setItemUuid:)]) {
        [segue.destinationViewController performSelector:@selector(setItemUuid:) withObject:itemUuid];
    }
}

#pragma mark - ModalDelegate

-(void)refreshAfterModalDismiss {
    NSError *error;
    if (![self.frc performFetch:&error]) {
        // Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);  // Fail
    }
    [self.tableView reloadData];
}
@end
