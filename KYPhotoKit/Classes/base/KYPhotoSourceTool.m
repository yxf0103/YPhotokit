//
//  KYPhotoSourceTool.m
//  KYPhotoKit
//
//  Created by yxf on 2020/8/11.
//

#import "KYPhotoSourceTool.h"

NSBundle *kyBunble(void){
    static dispatch_once_t onceToken;
    static NSBundle *bundle = nil;
    dispatch_once(&onceToken, ^{
        NSBundle *frameworkBundle = [NSBundle bundleForClass:[KYPhotoSourceTool class]];
        NSString *path = [frameworkBundle pathForResource:@"KYPhotoKit" ofType:@"bundle"];
        bundle = [NSBundle bundleWithPath:path];
    });
    return bundle;
}

@implementation KYPhotoSourceTool

+(UIImage *)imageWithName:(NSString *_Nullable)name type:(NSString *_Nullable)type{
    NSString *path = [self filepathWithName:name type:type];
    return [[UIImage alloc] initWithContentsOfFile:path];
}

+(NSString *)filepathWithName:(NSString *_Nullable)name type:(NSString *_Nullable)type{
    return [kyBunble() pathForResource:name ofType:type];
}

@end
