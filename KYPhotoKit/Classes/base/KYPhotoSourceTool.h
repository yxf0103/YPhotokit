//
//  KYPhotoSourceTool.h
//  KYPhotoKit
//
//  Created by yxf on 2020/8/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN NSString *TALocalizationStringWithKey(NSString *key,NSString *_Nullable defaultValue);


@interface KYPhotoSourceTool : NSObject

/// 获取图片
+(UIImage *)imageWithName:(NSString *_Nullable)name type:(NSString *_Nullable)type;

/// 获取文件的地址
+(NSString *)filepathWithName:(NSString *_Nullable)name type:(NSString *_Nullable)type;

@end

NS_ASSUME_NONNULL_END
