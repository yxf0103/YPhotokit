//
//  ViewController.h
//  DemoPhotoKit
//
//  Created by yxf on 2017/6/12.
//  Copyright © 2017年 yxf. All rights reserved.
//

#import "YPKBaseViewController.h"

@class YPKAlbumModel;

@interface YPKImagesViewController : YPKBaseViewController

+(instancetype)initWithAlbum:(YPKAlbumModel *)album;

@end

