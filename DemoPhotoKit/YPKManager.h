//
//  YPKManager.h
//  DemoPhotoKit
//
//  Created by yxf on 2017/6/12.
//  Copyright © 2017年 yxf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

typedef void(^YPMCompletion)(id ,NSError *error);

@interface YPKManager : NSObject

/** imageManager*/
@property(nonatomic,strong,readonly)PHImageManager *imageManager;

/** PHImageRequestOptions*/
@property(nonatomic,strong,readonly)PHImageRequestOptions *imageOption;

/** image PHFetchOptions*/
@property(nonatomic,strong,readonly)PHFetchOptions *imagefetchOption;

/** collection PHFetchOptions*/
@property(nonatomic,strong,readonly)PHFetchOptions *collectionFetchOption;

/** 初始化*/
+(instancetype)shareInstance;

-(void)startWork;

-(void)stopWork;

/** 获取所有相册*/
+(void)getAllAlbums:(YPMCompletion)completion;

/** 获取某个相册的图片*/
+(void)getAlbum:(id)album completion:(YPMCompletion)completion;

/** 获取某个图片的信息*/
+(void)getImage:(id)image completion:(YPMCompletion)completion;

@end
