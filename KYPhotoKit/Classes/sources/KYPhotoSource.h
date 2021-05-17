//
//  KYPhotoSource.h
//  KYPhotoKit
//
//  Created by yxf on 2020/10/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KYPhotoSource : NSObject

@property (nonatomic,copy)void (^thumImageChanged)(UIImage *image);

///资源ID
-(NSString *)sourceId;

///缩略图
-(UIImage *)thumImage;

@end

NS_ASSUME_NONNULL_END
