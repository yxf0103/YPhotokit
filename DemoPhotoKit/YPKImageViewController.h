//
//  YPKImageViewController.h
//  DemoPhotoKit
//
//  Created by yxf on 2017/6/12.
//  Copyright © 2017年 yxf. All rights reserved.
//

#import "YPKBaseViewController.h"

@interface YPKImageViewController : YPKBaseViewController

/** images*/
@property(nonatomic,strong)NSArray *images;

/** curreny index*/
@property(nonatomic,assign)NSInteger currentIndex;

@end
