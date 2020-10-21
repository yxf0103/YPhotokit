//
//  KYAsset+Action.h
//  KYPhotoKit
//
//  Created by yxf on 2020/10/20.
//

#import <KYPhotoKit/KYAsset.h>

NS_ASSUME_NONNULL_BEGIN

@interface KYAsset (Action)

@property (nonatomic,copy)void (^numChanged)(KYAsset *asset);

@property (nonatomic,assign)NSInteger number;

@property (nonatomic,copy)void (^selectChanged)(KYAsset *asset);

@property (nonatomic,assign)BOOL selected;


@end

NS_ASSUME_NONNULL_END
