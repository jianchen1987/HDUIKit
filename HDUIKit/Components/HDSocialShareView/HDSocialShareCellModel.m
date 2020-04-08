//
//  HDSocialShareCellModel.m
//  HDUIKit
//
//  Created by VanJay on 2019/8/23.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDSocialShareCellModel.h"

@implementation HDSocialShareCellModel
+ (instancetype)modelWithTitle:(NSString *)title image:(UIImage *)image {
    return [[self alloc] initWithTitle:title image:image];
}

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image {
    if (self = [super init]) {
        self.title = title;
        self.image = image;
    }
    return self;
}

+ (instancetype)modelWithTitle:(NSString *)title image:(UIImage *)image associatedObject:(id __nullable)associatedObject {
    return [[self alloc] initWithTitle:title image:image associatedObject:associatedObject];
}

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image associatedObject:(id __nullable)associatedObject {
    if (self = [super init]) {
        self.title = title;
        self.image = image;
        self.associatedObject = associatedObject;
    }
    return self;
}

+ (instancetype)modelWithTitle:(NSString *)title image:(UIImage *)image clickedHandler:(ClickedHandler __nullable)clickedHandler {
    return [[self alloc] initWithTitle:title image:image clickedHandler:clickedHandler];
}

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image clickedHandler:(ClickedHandler __nullable)clickedHandler {
    if (self = [super init]) {
        self.title = title;
        self.image = image;
        self.clickedHandler = clickedHandler;
    }
    return self;
}
@end
