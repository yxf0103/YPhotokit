//
//  KYPhotoTool.h
//  KYPhotosKit
//
//  Created by yxf on 2019/4/23.
//  Copyright © 2019 k_yan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KYPhotoTool : NSObject

@end

@interface KYPhotoTool (image)

+(CGRect)destFrameWithImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
