//
//  ItemEditViewController.m
//  TestMRImage
//
//  Created by Nicholas Jones on 03/10/2014.
//  Copyright (c) 2014 sigf. All rights reserved.
//

#import "ItemEditViewController.h"
#import "Item+CustomMethods.h"
#import "Image+CustomMethods.h"
#import "AppDelegate.h"
#import "constants.h"


@interface ItemEditViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    AppDelegate *app;
}
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *refTextField;
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *imageUuidLabel;

@property (nonatomic, strong) UIActionSheet *photoActionSheet;
@property (nonatomic, strong) UIPopoverController *imagePickerPopOver;
@property (nonatomic) BOOL newImage;

- (IBAction)editImage:(id)sender;

@end

@implementation ItemEditViewController

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
    Item *localItem = [self item];
    self.nameTextField.text = localItem.name;
    self.imageUuidLabel.text = localItem.imageUuid;
    self.refTextField.text = localItem.ref;
    self.itemImageView.image = [UIImage imageWithData:localItem.image.data];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    self.newImage = NO;
}

-(Item*)item {
    return [Item MR_findFirstByAttribute:@"uuid" withValue:self.itemUuid];
}

-(void)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)done:(id)sender {
    if(self.nameTextField.text.length==0){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"Product Error", nil)
                              message:NSLocalizedString(@"Please enter a name for the product.", nil)
                              delegate: self
                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    NSManagedObjectID *catID = [[self item] objectID];
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext){
        Item *item = [self prepareItemInContext:localContext WithID:catID];
        self.itemUuid = item.uuid;
        if(self.itemImageView.image) {
            Image *image = [self prepareImageForItem:item inContext:localContext];
            item.imageUuid = image.uuid;
        }
        else item.imageUuid = nil;
    }completion:^(BOOL success, NSError *error) {
        if (success) {
            [self dismissViewControllerAnimated:YES completion:^(void){
                [self.delegate refreshAfterModalDismiss];
            }];
        } else {
#if DEBUG
            NSLog(@"%@: %@", error, error.userInfo);
#endif
        }
        
    }];
}

- (Item*)prepareItemInContext:(NSManagedObjectContext*)context WithID:(NSManagedObjectID*)objID{
    Item *item;
    if(objID)item = (Item*)[context objectWithID:objID];
    if(!item) {
        item = [Item MR_createEntityInContext:context];
        item.uuid = [[[NSUUID UUID] UUIDString] lowercaseString];
//        item.createdAt = [NSDate date];
    }
    item.name = self.nameTextField.text;
    item.ref = self.refTextField.text;
    return item;
}

-(Image*)prepareImageForItem:(Item*)item inContext:(NSManagedObjectContext*)context {
    Image *image;
    if(!self.newImage) {
        image = [Image MR_findFirstByAttribute:@"uuid" withValue:item.imageUuid inContext:context];
    }
    else {
        image = [Image imageFromUIImage:self.itemImageView.image imageType:EImageTypeCatalogImage inContext:context];
    }
    return image;
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

- (IBAction)editImage:(id)sender {
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Device has no camera"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            
        [alert show];
        return;
    }
    [self.photoActionSheet showInView:self.view];
}


#pragma mark - Action sheets
- (UIActionSheet *)photoActionSheet {
    if (!_photoActionSheet) {
        _photoActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        [_photoActionSheet addButtonWithTitle:@"Take Photo"];
        [_photoActionSheet addButtonWithTitle:@"Choose From Library"];
        [_photoActionSheet addButtonWithTitle:@"Cancel"];
        _photoActionSheet.cancelButtonIndex = [_photoActionSheet numberOfButtons] - 1;
    }
    return _photoActionSheet;
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if(actionSheet==self.photoActionSheet){
        if(buttonIndex==0){
            [self performSelector:@selector(capturePhotoFromCamera) withObject:nil afterDelay:0.1];
        }else if(buttonIndex==1){
            [self performSelector:@selector(capturePhotoFromGallery) withObject:nil afterDelay:0.1];
        }
    }
}


- (void)capturePhotoFromCamera {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)capturePhotoFromGallery {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if(app.isPhone) {
        picker.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:picker animated:YES completion:NULL];
    }
    else  {
        self.imagePickerPopOver = [[UIPopoverController alloc] initWithContentViewController:picker];
        [self.imagePickerPopOver presentPopoverFromRect:self.itemImageView.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    UIImage *tempImage = nil;
    float aspectRatio = (float)(chosenImage.size.width/chosenImage.size.height);
    CGSize targetSize = CGSizeMake(160,160.0/aspectRatio);
    UIGraphicsBeginImageContext(targetSize);
    CGRect thumbnailRect = CGRectMake(0, 0, 0, 0);
    thumbnailRect.origin = CGPointMake(0.0,0.0);
    thumbnailRect.size.width  = targetSize.width;
    thumbnailRect.size.height = targetSize.height;
    [chosenImage drawInRect:thumbnailRect];
    tempImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self setImageFromData:UIImageJPEGRepresentation(tempImage, 0.5f)];
    tempImage = nil;
    self.newImage = YES;
    if(app.isPhone || picker.sourceType == UIImagePickerControllerSourceTypeCamera) [picker dismissViewControllerAnimated:YES completion:nil];
    else [self.imagePickerPopOver dismissPopoverAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (UIImage*)resizedImage:(UIImage*)inImage thumbRect:(CGRect) thumbRect {
    CGImageRef          imageRef = [inImage CGImage];
    CGImageAlphaInfo    alphaInfo = CGImageGetAlphaInfo(imageRef);
    if (alphaInfo == kCGImageAlphaNone)
        alphaInfo = kCGImageAlphaNoneSkipLast;
    CGContextRef bitmap = CGBitmapContextCreate(
                                                NULL,
                                                thumbRect.size.width,       // width
                                                thumbRect.size.height,      // height
                                                CGImageGetBitsPerComponent(imageRef),
                                                4 * thumbRect.size.width,   // rowbytes
                                                CGImageGetColorSpace(imageRef),
                                                alphaInfo
                                                );
    
    CGContextDrawImage(bitmap, thumbRect, imageRef);
    CGImageRef  ref = CGBitmapContextCreateImage(bitmap);
    UIImage*    result = [UIImage imageWithCGImage:ref];
    CGContextRelease(bitmap);   // ok if NULL
    CGImageRelease(ref);
    return result;
}

- (void)setImageFromData:(NSData*)imgData {
    self.itemImageView.image = [UIImage imageWithData:imgData];
}


@end
