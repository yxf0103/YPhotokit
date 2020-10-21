//
//  KYAssetCell.h
//  KYPhotoKit
//
//  Created by yxf on 2018/5/4.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString * const KYAssetCellIdentifier;

@class KYAsset;

@interface KYAssetCell : UICollectionViewCell

/*图片*/
@property (nonatomic,strong)KYAsset *asset;

@property (nonatomic,copy)void (^bindSelectAction)(KYAsset *asset,BOOL isSelected);

@property (nonatomic,weak,readonly)UIImageView *ky_imgView;

@end
