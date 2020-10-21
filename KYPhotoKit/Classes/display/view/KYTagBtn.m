//
//  KYTagBtn.m
//  KYPhotoKit
//
//  Created by yxf on 2020/10/20.
//

#import "KYTagBtn.h"

@interface KYTagBtn (){
    CAShapeLayer *_maskLayer;
}

@end

@implementation KYTagBtn

+(instancetype)tagBtn{
    KYTagBtn *btn = [KYTagBtn buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor blueColor]];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    btn.layer.mask = maskLayer;
    btn->_maskLayer = maskLayer;
    return btn;
}

-(void)setNumber:(NSInteger)number{
    if (_number == number) {
        return;
    }
    _number = number;
    [self setTitle:@(number).stringValue forState:UIControlStateNormal];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat radius = CGRectGetWidth(self.bounds) / 2;
    if (radius == 0) {
        return;
    }
    _maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:radius].CGPath;
}

@end
