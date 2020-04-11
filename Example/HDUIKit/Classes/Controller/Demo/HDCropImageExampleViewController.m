//
//  HDCropImageExampleViewController.m
//  HDUIKit_Example
//
//  Created by VanJay on 2020/4/11.
//  Copyright © 2020 wangwanjie. All rights reserved.
//

#import "HDCropImageExampleViewController.h"

@interface HDCropImageExampleViewController () <HDImageCropViewControllerDelegate>

@end

@implementation HDCropImageExampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UIImage *photo = [UIImage imageNamed:@"世界地图"];
    HDImageCropViewController *imageCropVC = [[HDImageCropViewController alloc] initWithImage:photo cropMode:HDImageCropModeSquare];
    imageCropVC.delegate = self;
    [self presentViewController:imageCropVC animated:true completion:nil];
}

#pragma mark - HDImageCropViewControllerDelegate

- (void)imageCropViewControllerDidCancelCrop:(HDImageCropViewController *)controller {
    [controller dismissAnimated:true completion:nil];
}

- (void)imageCropViewController:(HDImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect rotationAngle:(CGFloat)rotationAngle {
    HDLog(@"图片:%@", croppedImage);
    [controller dismissAnimated:true completion:nil];
}
@end
