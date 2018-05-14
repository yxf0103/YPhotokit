//
//  KYAlbumCell.m
//  KYPhotoKit
//
//  Created by yxf on 2018/5/4.
//

#import "KYAlbumCell.h"
#import "KYAlbum.h"
NSString * const KYAlbumCellIdentifier = @"KYAlbumCellIdentifier";

@interface KYAlbumCell ()
/*封面*/
@property (nonatomic,weak)UIImageView *coverImgView;

/*相册信息*/
@property (nonatomic,weak)UILabel *albumDetailLabel;


@end

@implementation KYAlbumCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 50, 50)];
        [self.contentView addSubview:imgView];
        _coverImgView = imgView;
        
        UILabel *detailLabel = [[UILabel alloc] init];
        [self.contentView addSubview:detailLabel];
        _albumDetailLabel = detailLabel;
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGPoint center = self.contentView.center;
    
    //cover
    CGPoint imgviewCenter = _coverImgView.center;
    imgviewCenter.y = center.y;
    _coverImgView.center = imgviewCenter;
    
    //detaillabel
    CGFloat dx = CGRectGetMaxX(_coverImgView.frame) + 10;
    CGFloat dw = CGRectGetWidth(self.contentView.frame) - dx - 10;
    CGFloat dy = 10;
    CGFloat dh = CGRectGetHeight(self.contentView.frame) - 20;
    _albumDetailLabel.frame = CGRectMake(dx, dy, dw, dh);
}


-(void)setAlbum:(KYAlbum *)album{
    _album = album;
    _coverImgView.image = album.coverImage;
    _albumDetailLabel.text = [NSString stringWithFormat:@"%@(%zd)",album.album.localizedTitle,album.count];
}


@end
