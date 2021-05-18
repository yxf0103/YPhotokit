//
//  KYImageScannerViewController.h
//  KYPhotoKit
//
//  Created by yxf on 2018/5/4.
//

#import <UIKit/UIKit.h>

@class KYImageScannerViewController;

@protocol KYImageScannerViewControllerDelegate<NSObject>
-(void)scannerVc:(KYImageScannerViewController *)scannerVc alphaChanged:(double)alpha;
-(CGRect)scannerVc:(KYImageScannerViewController *)scannerVc dismissAtIndex:(NSInteger)index;
@end

@interface KYImageScannerViewController : UIViewController

/*images*/
@property (nonatomic,strong)NSArray *images;

/*delegate*/
@property (nonatomic,weak)id<KYImageScannerViewControllerDelegate> scannerDelegate;

/*index*/
@property (nonatomic,assign)NSInteger index;

@end
