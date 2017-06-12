//
//  YPKAlbumModel.h
//  DemoPhotoKit
//
//  Created by yxf on 2017/6/12.
//  Copyright © 2017年 yxf. All rights reserved.
//

#import <Foundation/Foundation.h>


//相册
@interface YPKAlbumModel : NSObject

/** album*/
@property(nonatomic,strong)PHAssetCollection *album;

/** 封面*/
@property(nonatomic,strong)UIImage *coverImage;

/** count*/
@property(nonatomic,assign)NSInteger count;

-(instancetype)initWithAlbum:(PHAssetCollection *)album
                       count:(NSInteger)count
                       image:(UIImage *)image NS_DESIGNATED_INITIALIZER;

@end
