//
//  YPKImageCell.h
//  DemoPhotoKit
//
//  Created by yxf on 2017/6/12.
//  Copyright © 2017年 yxf. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ImageCellIdentifier @"ImageCellIdentifier"

@class YPKImageModel;

@interface YPKImageCell : UICollectionViewCell

/** iamge*/
@property(nonatomic,strong)YPKImageModel *model;

@end
