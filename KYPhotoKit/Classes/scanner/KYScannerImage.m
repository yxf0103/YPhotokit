//
//  KYScannerImage.m
//  KYPhotoKit
//
//  Created by yxf on 2018/5/8.
//

#import "KYScannerImage.h"
#import "KYImageScannerCell.h"
#import "KYPhotoTool.h"

@interface KYScannerImage ()

@property (nonatomic,assign)CGRect destFrame;

@end

@implementation KYScannerImage

-(CGRect)destFrame{
    if (CGRectIsEmpty(_destFrame) && _originImage) {
        _destFrame = [KYPhotoTool destFrameWithImage:_originImage];
    }
    return _destFrame;
}

@end
