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
    [self.dataSource addObject:[ExampleItem itemWithDesc:@"输入框" destVcName:@"HDViewController"]];
    [self.dataSource addObject:[ExampleItem itemWithDesc:@"Toast" destVcName:@"HDViewController"]];
    [self.dataSource addObject:[ExampleItem itemWithDesc:@"弹窗" destVcName:@"HDViewController"]];
    [self.dataSource addObject:[ExampleItem itemWithDesc:@"星星评分" destVcName:@"HDViewController"]];
    [self.dataSource addObject:[ExampleItem itemWithDesc:@"函数防抖" destVcName:@"HDViewController"]];
    [self.dataSource addObject:[ExampleItem itemWithDesc:@"城市选择器" destVcName:@"HDViewController"]];
    [self.dataSource addObject:[ExampleItem itemWithDesc:@"类 Masonry 实现 UIView、CALayer 快速 Frame 布局" destVcName:@"HDViewController"]];
    [self.dataSource addObject:[ExampleItem itemWithDesc:@"栅栏布局" destVcName:@"HDViewController"]];
    [self.dataSource addObject:[ExampleItem itemWithDesc:@"骨架 loading" destVcName:@"HDViewController"]];
    [self.dataSource addObject:[ExampleItem itemWithDesc:@"新功能引导层" destVcName:@"HDViewController"]];
    [self.dataSource addObject:[ExampleItem itemWithDesc:@"倒计时按钮" destVcName:@"HDViewController"]];
    [self.dataSource addObject:[ExampleItem itemWithDesc:@"自定义键盘" destVcName:@"HDViewController"]];
    [self.dataSource addObject:[ExampleItem itemWithDesc:@"AlertView" destVcName:@"HDViewController"]];
    [self.dataSource addObject:[ExampleItem itemWithDesc:@"社会化分享" destVcName:@"HDViewController"]];
    [self.dataSource addObject:[ExampleItem itemWithDesc:@"万能按钮" destVcName:@"HDViewController"]];
    [self.dataSource addObject:[ExampleItem itemWithDesc:@"条形/环形进度条" destVcName:@"HDViewController"]];
    [self.dataSource addObject:[ExampleItem itemWithDesc:@"AFN超时/重试机制" destVcName:@"HDViewController"]];
    [self.dataSource addObject:[ExampleItem itemWithDesc:@"流式布局" destVcName:@"HDViewController"]];
    [self.dataSource addObject:[ExampleItem itemWithDesc:@"一对多代理实现" destVcName:@"HDViewController"]];
    [self.dataSource addObject:[ExampleItem itemWithDesc:@"全局窗口管理" destVcName:@"HDViewController"]];
    [self.dataSource addObject:[ExampleItem itemWithDesc:@"线程安全键值存储方案" destVcName:@"HDViewController"]];
    [self.dataSource addObject:[ExampleItem itemWithDesc:@"应用内服务器域名切换" destVcName:@"HDViewController"]];
    [self.dataSource addObject:[ExampleItem itemWithDesc:@"条形码/二维码生成" destVcName:@"HDCodeViewController"]];
}

- (void)setupUI {

    self.hd_navigationItem.title = @"ViPay 组件";
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
    HDLog(@"打开：%@", item.destVcName);

    Class cls = NSClassFromString(item.destVcName);
    if (cls) {
        UIViewController *vc = [[cls alloc] init];
        [self.navigationController pushViewController:vc animated:true];
    } else {
        HDLog(@"类不存在");
    }
}

#pragma mark - lazy load
- (NSMutableArray<ExampleItem *> *)dataSource {
    return _dataSource ?: ({ _dataSource = [NSMutableArray array]; });
}
@end
