//
//  KYScannerPresentModel.h
//  KYPhotoKit
//
//  Created by yxf on 2018/5/11.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, KYScannerPresentType) {
    KYScannerPresentPop = 0, // 弹出
    KYScannerPresentPush//右向左推出
};

@interface KYScannerPresentModel : NSObject<UIViewControllerAnimatedTransitioning>

/*animation type,default:KYScannerPresentPop*/
@property (nonatomic,assign)KYScannerPresentType modalType;

/*touch view frame*/
@property (nonatomic,assign)CGRect touchFrame;

/*touch view back frame*/
@property (nonatomic,assign)CGRect destFrame;

/*touch view image*/
@property (nonatomic,strong)UIImage *touchImage;

/*popback*/
@property (nonatomic,assign)BOOL popBack;

@end
