//
//  NSBundle+HDUIKit.m
//  HDUIKit
//
//  Created by VanJay on 2020/3/4.
//

#import "NSBundle+HDUIKit.h"

@implementation NSBundle (HDUIKit)
+ (NSBundle *)hd_UIKitBundle {
    static NSBundle *resourceBundle = nil;
    if (!resourceBundle) {
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSString *resourcePath = [mainBundle pathForResource:@"Frameworks/HDUIKit.framework/HDResources" ofType:@"bundle"];
        if (!resourcePath) {
            resourcePath = [mainBundle pathForResource:@"HDResources" ofType:@"bundle"];
        }
        resourceBundle = [NSBundle bundleWithPath:resourcePath] ?: mainBundle;
    }
    return resourceBundle;
}
@end
