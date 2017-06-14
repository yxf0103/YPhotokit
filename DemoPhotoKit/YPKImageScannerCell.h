//
//  YPKImageScannerCell.h
//  DemoPhotoKit
//
//  Created by yxf on 2017/6/14.
//  Copyright © 2017年 yxf. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ScannerCellIdentifier @"ScannerCellIdentifier"

@class YPKImageModel;

@interface YPKImageScannerCell : UICollectionViewCell

/** iamge*/
@property(nonatomic,strong)YPKImageModel *model;

-(void)resetImage:(UIImage *)bigImage;

@end
