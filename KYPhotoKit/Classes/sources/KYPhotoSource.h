//
//  KYPhotoSource.h
//  KYPhotoKit
//
//  Created by yxf on 2020/10/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KYPhotoSource : NSObject

///缩略图
@property(nonatomic,strong)UIImage *image;

-(instancetype)initWithImg:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
