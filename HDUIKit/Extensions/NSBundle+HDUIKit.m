//
//  NSBundle+HDKitCore.m
//  HDKitCore
//
//  Created by VanJay on 2020/3/4.
//  Copyright © 2019 chaos network technology. All rights reserved.

#import "NSBundle+HDUIKit.h"

@implementation NSBundle (HDUIKit)
+ (NSBundle *)hd_UIKitMainFrameResourcesBundle {
    static NSBundle *resourceBundle = nil;
    return [self bundleWithStaticResourceBundle:resourceBundle bundleName:@"HDUIKitMainFrameResources"];
}

+ (NSBundle *)hd_UIKitTipsResourcesBundle {
    static NSBundle *resourceBundle = nil;
    return [self bundleWithStaticResourceBundle:resourceBundle bundleName:@"HDUIKitTipsResources"];
}

+ (NSBundle *)hd_UIKitKeyboardResources {
    static NSBundle *resourceBundle = nil;
    return [self bundleWithStaticResourceBundle:resourceBundle bundleName:@"HDUIKitKeyboardResources"];
}

+ (NSBundle *)hd_UIKitSearchBarResources {
    static NSBundle *resourceBundle = nil;
    return [self bundleWithStaticResourceBundle:resourceBundle bundleName:@"HDUIKitSearchBarResources"];
}

+ (NSBundle *)hd_UIKITCitySelectResources {
    static NSBundle *resourceBundle = nil;
    return [self bundleWithStaticResourceBundle:resourceBundle bundleName:@"HDUIKITCitySelectResources"];
}

+ (NSBundle *)hd_UIKITImageBrowserResources {
    static NSBundle *resourceBundle = nil;
    return [self bundleWithStaticResourceBundle:resourceBundle bundleName:@"HDUIKitImageBrowserResources"];
}

#pragma mark - private methods
+ (NSBundle *)bundleWithStaticResourceBundle:(NSBundle *)resourceBundle bundleName:(NSString *)name {
    if (!resourceBundle) {
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSString *resourcePath = [mainBundle pathForResource:[NSString stringWithFormat:@"Frameworks/HDUIKit.framework/%@", name] ofType:@"bundle"];
        if (!resourcePath) {
            resourcePath = [mainBundle pathForResource:name ofType:@"bundle"];
        }
        resourceBundle = [NSBundle bundleWithPath:resourcePath] ?: mainBundle;
    }
    return resourceBundle;
}
@end
