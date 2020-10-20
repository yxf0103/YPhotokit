//
//  KYAsset+Display.h
//  KYPhotoKit
//
//  Created by yxf on 2020/10/19.
//

#import <KYPhotoKit/KYPhotoKit.h>
#import <KYPhotoKit/KYPhotoSource.h>

NS_ASSUME_NONNULL_BEGIN

@interface KYPhotoSource (Display)

@property (nonatomic,weak)UIImage *displayImage;

-(void)setImageToImgView:(UIImageView *)imgView;

@end

NS_ASSUME_NONNULL_END
