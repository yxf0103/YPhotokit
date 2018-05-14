//
//  KYHud.h
//  KYPhotoKit
//
//  Created by yxf on 2018/5/8.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KYHudStyle) {
    KYHudCircle,///<圆
    KYHudIndicator///<菊花
};

@interface KYHud : UIView

/*模式:默认圆*/
@property (nonatomic,assign)KYHudStyle style;
/*圆角:默认5*/
@property (nonatomic,assign)CGFloat radius;
/*背景色:默认灰色*/
@property (nonatomic,strong)UIColor *bgColor;
/*loading图的颜色:默认白色*/
@property (nonatomic,strong)UIColor *loadingColor;


-(instancetype)initWithFrame:(CGRect)frame
                       style:(KYHudStyle)style
             backgroundColor:(UIColor *)bgColor
                loadingColor:(UIColor *)loadingColor
                cornerRadius:(CGFloat)radius;

-(void)startAnimation;

-(void)stopAnimation;

@end
