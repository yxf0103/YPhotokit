//
//  KYPhotoConfig.h
//  KYPhotoKit
//
//  Created by yxf on 2021/6/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, KYPhotoSelectType) {
    KYPhotoSelectTypeNumber,///<数字类型
    KYPhotoSelectTypeSelected///<✅
};

@interface KYPhotoConfig : NSObject

+(instancetype)shareConfig;

///可以选择的图片数量
@property (nonatomic,assign)NSInteger maxCount;
///确认按钮标题
@property (nonatomic,copy)NSString *doneTitle;
///展示空目录
@property (nonatomic,assign)BOOL showEmptyAlbum;
@property (nonatomic,assign)KYPhotoSelectType selectedType;

@end

NS_ASSUME_NONNULL_END
