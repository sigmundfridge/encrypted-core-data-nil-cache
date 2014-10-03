//
//  ItemDetailViewController.h
//  TestMRImage
//
//  Created by Nicholas Jones on 03/10/2014.
//  Copyright (c) 2014 sigf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemEditViewController.h"

@interface ItemDetailViewController : UIViewController <ModalDelegate>
@property(nonatomic,strong) NSString *itemUuid;
@end
