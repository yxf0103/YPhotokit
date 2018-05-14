//
//  KYImageScannerViewController.h
//  KYPhotoKit
//
//  Created by yxf on 2018/5/4.
//

#import <UIKit/UIKit.h>

@class KYImageScannerViewController;

@protocol KYImageScannerViewControllerDelegate<NSObject>
-(void)scannerVcWillPresent:(KYImageScannerViewController *)scannerVc;
-(void)scannerVcWillDismiss:(KYImageScannerViewController *)scannerVc;
@end

@interface KYImageScannerViewController : UIViewController

/*images*/
@property (nonatomic,strong)NSArray *images;

/*delegate*/
@property (nonatomic,weak)id<KYImageScannerViewControllerDelegate> ky_delegate;

/*index*/
@property (nonatomic,assign)NSInteger index;

@end
