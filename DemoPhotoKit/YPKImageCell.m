//
//  YPKImageCell.m
//  DemoPhotoKit
//
//  Created by yxf on 2017/6/12.
//  Copyright © 2017年 yxf. All rights reserved.
//

#import "YPKImageCell.h"
#import "YPKImageModel.h"

@interface YPKImageCell ()

/** image*/
@property(nonatomic,weak)UIImageView *imageView;

/** bgScrollview*/
@property(nonatomic,weak)UIScrollView *bgScrollView;

@end


@implementation YPKImageCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:imageView];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.masksToBounds = YES;
        _imageView = imageView;
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    _imageView.frame = self.contentView.bounds;
}

-(void)setModel:(YPKImageModel *)model{
    _model = model;
    _imageView.image = model.image;
}

@end

