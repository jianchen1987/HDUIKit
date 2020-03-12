//
//  HDProgressViewViewController.m
//  HDUIKit_Example
//
//  Created by VanJay on 2020/3/12.
//  Copyright © 2020 wangwanjie. All rights reserved.
//

#import "HDProgressViewViewController.h"

@interface HDProgressViewViewController ()

@end

@implementation HDProgressViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    HDRectangleProgressView *view = ({
        HDRectangleProgressView *view = HDRectangleProgressView.new;
        [view setProgress:0.3 animated:YES];
        view.frame = CGRectMake(50, 150, 300, 40);
        view;
    });

    [self.view addSubview:view];

    HDPieProgressView *view2 = ({
        HDPieProgressView *view = HDPieProgressView.new;
        [view setProgress:0.3 animated:YES];
        view.frame = CGRectMake(50, 250, 60, 60);
        view;
    });

    [self.view addSubview:view2];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [view setProgress:0.9 animated:YES];
        [view2 setProgress:0.9 animated:YES];
    });
}

@end
