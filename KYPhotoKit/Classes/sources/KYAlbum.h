//
//  KYAlbum.h
//  KYPhotoKit
//
//  Created by yxf on 2018/5/3.
//

#import "KYPhotoSource.h"
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface KYAlbum : KYPhotoSource

/** album*/
@property(nonatomic,strong,readonly)PHAssetCollection *album;

/** count*/
@property(nonatomic,assign)NSInteger count;

-(instancetype)initWithAlbum:(PHAssetCollection *)album; NS_DESIGNATED_INITIALIZER;

@end
