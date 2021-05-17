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
@property (nonatomic,strong)NSArray *assets;

-(instancetype)initWithAlbum:(PHAssetCollection *)album assets:(NSArray *)assets; NS_DESIGNATED_INITIALIZER;

-(NSInteger)count;

@end
