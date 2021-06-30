//
//  KYAssetsViewController+Scanner.h
//  KYPhotoKit
//
//  Created by yxf on 2021/6/30.
//

#import <KYPhotoKit/KYAssetsViewController.h>

NS_ASSUME_NONNULL_BEGIN

@interface KYAssetsViewController (Scanner)

-(void)selectIndex:(NSInteger)index allAssets:(NSArray<KYAssetviewModel *> *)assets;

@end

NS_ASSUME_NONNULL_END
