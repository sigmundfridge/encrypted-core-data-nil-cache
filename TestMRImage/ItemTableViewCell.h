//
//  ItemTableViewCell.h
//  TestMRImage
//
//  Created by Nicholas Jones on 03/10/2014.
//  Copyright (c) 2014 sigf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *itemName;

@end
