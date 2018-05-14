//
//  KYAlbumCell.h
//  KYPhotoKit
//
//  Created by yxf on 2018/5/4.
//

#import <UIKit/UIKit.h>
#import "KYAlbum.h"

UIKIT_EXTERN  NSString * const KYAlbumCellIdentifier;

@interface KYAlbumCell : UITableViewCell

/*相册*/
@property (nonatomic,strong)KYAlbum *album;

@end
