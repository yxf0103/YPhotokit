//
//  YPKAlbumCell.m
//  DemoPhotoKit
//
//  Created by yxf on 2017/6/12.
//  Copyright © 2017年 yxf. All rights reserved.
//

#import "YPKAlbumCell.h"
#import "YPKAlbumModel.h"

@interface YPKAlbumCell ()

/** cover*/
@property(nonatomic,weak)UIImageView *coverimageView;

/** title*/
@property(nonatomic,weak)UILabel *titleLabel;

@end

@implementation YPKAlbumCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *coverView = [[UIImageView alloc] init];
        [self.contentView addSubview:coverView];
        coverView.contentMode = UIViewContentModeScaleAspectFill;
        coverView.layer.masksToBounds = YES;
        _coverimageView = coverView;
        
        UILabel *titleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:titleLabel];
        _titleLabel = titleLabel;
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    _coverimageView.frame = CGRectMake(5, 10, 50, 50);
    _titleLabel.frame = CGRectMake(70, 0, 250, 70);
}

-(void)setAlbum:(YPKAlbumModel *)album{
    _album = album;
    _coverimageView.image = album.coverImage ? album.coverImage : [UIImage imageNamed:@"beauty"];
    _titleLabel.text = [NSString stringWithFormat:@"%@(%zd)",album.album.localizedTitle,album.count];
}

@end
