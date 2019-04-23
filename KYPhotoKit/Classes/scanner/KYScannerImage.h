//
//  KYScannerImage.h
//  KYPhotoKit
//
//  Created by yxf on 2018/5/8.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KYScannerImage : NSObject

/*image*/
@property (nonatomic,strong)UIImage *originImage;

/*origin frame in window*/
@property (nonatomic,assign)CGRect originFrame;

/*destination frame in window*/
@property (nonatomic,assign,readonly)CGRect destFrame;

@end
