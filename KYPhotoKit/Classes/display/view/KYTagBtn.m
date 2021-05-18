//
//  KYTagBtn.m
//  KYPhotoKit
//
//  Created by yxf on 2020/10/20.
//

#import "KYTagBtn.h"

@interface KYTagBtn ()

@end

@implementation KYTagBtn

+(instancetype)tagBtn{
    KYTagBtn *btn = [KYTagBtn buttonWithType:UIButtonTypeCustom];
    UIImage *image = [KYPhotoSourceTool imageWithName:@"tag_normal" type:@"png"];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setTitleColor:KYColorRGB(0xff6542) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    return btn;
}

-(void)setNumber:(NSInteger)number{
    if (_number == number) {
        return;
    }
    _number = number;
    NSString *title = @"";
    if (number > 0) {
        title = @(number).stringValue;
    }
    [self setTitle:title forState:UIControlStateNormal];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    self.imageView.frame = CGRectMake(5, 5, width - 10, height - 10);
    self.titleLabel.frame = self.bounds;
}

@end
