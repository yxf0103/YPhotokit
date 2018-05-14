//
//  KYAlbum.h
//  KYPhotoKit
//
//  Created by yxf on 2018/5/3.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface KYAlbum : NSObject

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
