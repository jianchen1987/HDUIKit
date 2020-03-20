//
//  HDViewController.m
//  HDUIKit
//
//  Created by wangwanjie on 02/26/2020.
//  Copyright (c) 2020 wangwanjie. All rights reserved.
//

#import "HDViewController.h"
#import "ExampleItem.h"
#import <HDUIKit/HDUIKit.h>
#import <objc/runtime.h>

@interface HDViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray<ExampleItem *> *dataSource;  ///< 数据源
@end

@implementation HDViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    HDLog(@"HDUIKit 版本：%@", HDUIKit_VERSION);

    [self initDataSource];
    [self setupUI];
}

- (void)initDataSource {
    [self.dataSource addObject:[ExampleItem itemWithDesc:@"输入框" destVcName:@"HDInputFieldViewController"]];
    [self.dataSource addObject:[ExampleItem itemWithDesc:@"Toast" destVcName:@"HDToastViewController"]];
    [self.dataSource addObject:[ExampleItem itemWithDesc:@"弹窗" destVcName:@"HDSheetViewViewController"]];
    [self.dataSource addObject:[ExampleItem itemWithDesc:@"星星评分" destVcName:@"HDStarRatingViewController"]];
    [self.dataSource addObject:[ExampleItem itemWithDesc:@"函数防抖" destVcName:@"HDFunctionThrottleViewController"]];
    [self.dataSource addObject:[ExampleItem itemWithDesc:@"搜索框" destVcName:@"HDSearchBarViewController"]];
    [self.dataSource addObject:[ExampleItem itemWithDesc:@"标题滚动栏" destVcName:@"HDScrollTitleBarViewController"]];
    [self.dataSource addObject:[ExampleItem itemWithDesc:@"城市选择器" destVcName:@"HDCitySelectViewController"]];
    [self.dataSource addObject:[ExampleItem itemWithDesc:@"类 Masonry 实现 UIView、CALayer 快速 Frame 布局" destVcName:@"HDQuickFrameViewController"]];
    [self.dataSource addObject:[ExampleItem itemWithDesc:@"栅栏布局" destVcName:@"HDGridViewViewController"]];
    [self.dataSource addObject:[ExampleItem itemWithDesc:@"骨架 loading" destVcName:@"HDSkeletonViewController"]];
    [self.dataSource addObject:[ExampleItem itemWithDesc:@"新功能引导层" destVcName:@"HDNewFunctionTipViewController"]];
    [self.dataSource addObject:[ExampleItem itemWithDesc:@"倒计时按钮" destVcName:@"HDCountDownViewController"]];
    [self.dataSource addObject:[ExampleItem itemWithDesc:@"自定义键盘" destVcName:@"HDKeyboardViewController"]];
    [self.dataSource addObject:[ExampleItem itemWithDesc:@"AlertView" destVcName:@"HDAlertViewViewController"]];
    [self.dataSource addObject:[ExampleItem itemWithDesc:@"社会化分享" destVcName:@"HDSocialShareViewController"]];
    [self.dataSource addObject:[ExampleItem itemWithDesc:@"万能按钮" destVcName:@"HDUniversalButtonViewController"]];
    [self.dataSource addObject:[ExampleItem itemWithDesc:@"条形/环形进度条" destVcName:@"HDProgressViewViewController"]];
    [self.dataSource addObject:[ExampleItem itemWithDesc:@"AFN超时/重试机制" destVcName:@"HDAFNRetryViewController"]];
    [self.dataSource addObject:[ExampleItem itemWithDesc:@"流式布局" destVcName:@"HDFlowLayoutViewController"]];
    [self.dataSource addObject:[ExampleItem itemWithDesc:@"一对多代理实现" destVcName:@"HDMultiDelagateViewController"]];
    [self.dataSource addObject:[ExampleItem itemWithDesc:@"全局窗口管理" destVcName:@"HDWindowManageViewController"]];
    [self.dataSource addObject:[ExampleItem itemWithDesc:@"应用内服务器域名切换" destVcName:@"HDSwitchServerViewController"]];
    [self.dataSource addObject:[ExampleItem itemWithDesc:@"条形码/二维码生成" destVcName:@"HDCodeGeneratorViewController"]];
}

- (void)setupUI {

    self.hd_navigationItem.title = @"混沌 UI 组件";
    self.view.backgroundColor = UIColor.whiteColor;

    UITableView *tableView = [[UITableView alloc] initWithFrame:(CGRect){0, CGRectGetMaxY(self.hd_navigationBar.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - CGRectGetMaxY(self.hd_navigationBar.frame)}];
    [self.view addSubview:tableView];

    tableView.dataSource = self;
    tableView.delegate = self;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 新建标识
    static NSString *ID = @"ReusableCellIdentifier";
    // 创建cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    ExampleItem *item = self.dataSource[indexPath.row];
    cell.textLabel.text = item.desc;
    cell.textLabel.numberOfLines = 0;

    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];

    ExampleItem *item = self.dataSource[indexPath.row];

    UIViewController *vc;
    const char *className = [item.destVcName cStringUsingEncoding:NSASCIIStringEncoding];
    Class cls = objc_getClass(className);
    if (!cls) {
        // 创建一个类
        Class superClass = [HDBaseViewController class];
        cls = objc_allocateClassPair(superClass, className, 0);
        // 注册你创建的这个类
        objc_registerClassPair(cls);
        vc = [[cls alloc] init];
    } else {
        vc = [[cls alloc] init];
    }

    vc.hd_navigationItem.title = item.desc;
    [self.navigationController pushViewController:vc animated:true];
    HDLog(@"打开：%@", item.destVcName);
}

#pragma mark - lazy load
- (NSMutableArray<ExampleItem *> *)dataSource {
    return _dataSource ?: ({ _dataSource = [NSMutableArray array]; });
}
@end
