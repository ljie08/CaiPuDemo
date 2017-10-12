//
//  HomePageBaseCell.h
//  CBFDemo
//
//  Created by iMac on 2017/2/5.
//  Copyright © 2017年 yty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePageModel.h"
@interface HomePageBaseCell : UICollectionViewCell

@property (nonatomic, strong) HomePageModel * model;

@property (nonatomic, strong) NSIndexPath * indexPath;

@end
