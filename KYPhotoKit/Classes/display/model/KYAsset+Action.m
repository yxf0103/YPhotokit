//
//  KYAsset+Action.m
//  KYPhotoKit
//
//  Created by yxf on 2020/10/20.
//

#import "KYAsset+Action.h"
#import <objc/runtime.h>

char *num_changed = "num_changed";
char *num_number = "number";
char *num_selected = "num_selected";
char *num_sel = "sel";

@implementation KYAsset (Action)

-(void)setNumChanged:(void (^)(KYAsset * _Nonnull))numChanged{
    objc_setAssociatedObject(self, num_changed, numChanged, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(void (^)(KYAsset * _Nonnull))numChanged{
    return objc_getAssociatedObject(self, num_changed);
}

- (void)setNumber:(NSInteger)number{
    NSInteger oldNum = self.number;
    if (number == oldNum) {
        return;
    }
    objc_setAssociatedObject(self, num_number, @(number), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.numChanged) {
        self.numChanged(self);
    }
}

-(NSInteger)number{
    NSNumber *num = objc_getAssociatedObject(self, num_number);
    return num.integerValue;
}

-(void)setSelectChanged:(void (^)(KYAsset * _Nonnull))selectChanged{
    objc_setAssociatedObject(self, num_selected, selectChanged, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(void (^)(KYAsset * _Nonnull))selectChanged{
    return objc_getAssociatedObject(self, num_selected);
}

-(void)setSelected:(BOOL)selected{
    BOOL sel = self.selected;
    if (selected == sel) {
        return;
    }
    objc_setAssociatedObject(self, num_sel, @(selected), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.selectChanged) {
        self.selectChanged(self);
    }
}

-(BOOL)selected{
    NSNumber *sel = objc_getAssociatedObject(self, num_sel);
    return sel.boolValue;
}

@end
