//
//  KYImageScannerViewController.h
//  KYPhotoKit
//
//  Created by yxf on 2018/5/4.
//

#import <UIKit/UIKit.h>

@class KYImageScannerViewController;

@protocol KYImageScannerViewControllerDelegate<NSObject>

///scannerVc alpha changed
-(void)scannerVc:(KYImageScannerViewController *)scannerVc alphaChanged:(double)alpha;

///dismiss scanner
-(CGRect)scannerVc:(KYImageScannerViewController *)scannerVc dismissAtIndex:(NSInteger)index;

///selected status changed at index
-(void)scannerVc:(KYImageScannerViewController *)scannerVc
      selectItem:(NSInteger)index
          status:(BOOL)selected;
@end

@interface KYImageScannerViewController : UIViewController

/*images*/
@property (nonatomic,strong)NSArray *images;

/*delegate*/
@property (nonatomic,weak)id<KYImageScannerViewControllerDelegate> scannerDelegate;

/*index*/
@property (nonatomic,assign)NSInteger index;

@end
