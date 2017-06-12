//
//  YPKAlbumCell.h
//  DemoPhotoKit
//
//  Created by yxf on 2017/6/12.
//  Copyright © 2017年 yxf. All rights reserved.
//

#import <UIKit/UIKit.h>

#define albumCellIdentifier @"albumCellIdentifier"

@class YPKAlbumModel;

@interface YPKAlbumCell : UITableViewCell

/** album*/
@property(nonatomic,strong)YPKAlbumModel *album;

@end
