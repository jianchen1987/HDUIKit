//
//  HDBaseViewController.m
//  HDUIKit_Example
//
//  Created by VanJay on 2020/3/4.
//  Copyright © 2020 wangwanjie. All rights reserved.
//

#import "HDBaseViewController.h"

@interface HDBaseViewController ()

@end

@implementation HDBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)dealloc {
    HDLog(@"%@ - dealloc", NSStringFromClass(self.class));
}

@end
