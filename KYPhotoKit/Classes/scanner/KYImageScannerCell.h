//
//  KYImageScannerCell.h
//  KYPhotoKit
//
//  Created by yxf on 2018/5/4.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString * const KYImageScannerCellId;
@class KYScannerImage,KYImageScannerCell;

@protocol KYImageScannerCellDelegate<NSObject>

//视图dismiss
-(void)imgScannerCell:(KYImageScannerCell *)cell
       dismissWithImg:(UIImage *)image
          windowFrame:(CGRect)windowFrame;

//更改视图透明度
-(void)imgScannerCell:(KYImageScannerCell *)cell
 alphaChangedWithRate:(CGFloat)rate;

@end

@interface KYImageScannerCell : UICollectionViewCell

@property (nonatomic,strong)KYScannerImage *scannerImg;

/*delegate*/
@property (nonatomic,weak)id<KYImageScannerCellDelegate> delegate;

@end
