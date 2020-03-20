//
//  HDCitySelectViewController.m
//  HDUIKit
//
//  Created by VanJay on 2019/9/26.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDCitySelectViewController.h"
#import "HDAppTheme.h"
#import "HDCityGroupsModel.h"
#import "HDCitySearchViewController.h"
#import "HDCitySelectSearchBar.h"
#import "HDCommonDefines.h"
#import "HDSelectCityTableViewCell.h"
#import "HDTableHeaderFootView.h"
#import "NSBundle+HDUIKit.h"
#import "UIView+WJFrameLayout.h"
#import "UIViewController+Extension.h"
#import "UIViewController+HDUIKit.h"
#import <CoreLocation/CoreLocation.h>
#import <HDServiceKit/HDLocationUtils.h>
#import <HDVendorKit/FBKVOController+HDVendorKit.h>
#import <YYModel/YYModel.h>

#define kRecentlyCitysCachePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"recentlyCitys.data"]

@interface HDCitySelectViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, HDSelectCityTableViewCellDelegate>
@property (nonatomic, strong) NSMutableArray<HDCityModel *> *recentlySearchedCities;  ///< 最近搜索
@property (nonatomic, strong) HDCitySearchViewController *citySearchViewController;   ///< 搜索控制器
@property (nonatomic, strong) HDCitySelectSearchBar *searchBar;                       ///< 搜索框
@property (nonatomic, strong) UITableView *tableView;                                 ///< tableView
@property (nonatomic, strong) UIButton *coverView;                                    ///< 阴影
@property (nonatomic, strong) NSMutableArray<HDCityGroupsModel *> *cityGroups;        ///< 数据源
@property (nonatomic, strong) CLLocationManager *locationManager;                     ///< 位置管理者
@property (nonatomic, strong) HDCityGroupsModel *locationCityGroupModel;              ///< 定位的数据模型
@property (nonatomic, strong) HDCityModel *locationCityModel;                         ///< 定位的数据源模型
@property (nonatomic, strong) FBKVOController *KVOController;                         ///< 监听器
@end

@implementation HDCitySelectViewController

- (instancetype)initWithDelegate:(id)delegate {
    self = [super init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    self.hd_navigationItem.title = @"选择城市";

    [self.view addSubview:self.searchBar];
    self.searchBar.hidden = false;
    [self.view addSubview:self.tableView];

    [self.view bringSubviewToFront:self.hd_navigationBar];

    [self loadLocalCityGroup];
    [self addRecentlyCityGroupToDataSource];
    [self addLocationCityGroupToDataSource];
}

- (BOOL)shouldHideNavigationBarBottomShadow {
    return true;
}

#pragma mark - Data
- (void)loadLocalCityGroup {

    NSString *path = [[NSBundle hd_UIKITCitySelectResources] pathForResource:@"cities.json" ofType:nil];
    NSArray *json = [NSArray arrayWithContentsOfFile:path];
    // 去除不可用的
    NSArray<HDCityGroupsModel *> *dataSource = [NSArray yy_modelArrayWithClass:HDCityGroupsModel.class json:json];
    [self.cityGroups removeAllObjects];
    for (HDCityGroupsModel *groupModel in dataSource) {
        NSArray *shownlist = [groupModel.cities filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(HDCityModel *model, NSDictionary *bindings) {
                                                    return true;
                                                }]];
        groupModel.cities = shownlist;
        [self.cityGroups addObject:groupModel];
    }
}

- (void)addRecentlyCityGroupToDataSource {
    // 隐藏最近选择
    [self loadRecentlyCityGroup];
    if (self.recentlySearchedCities.count) {
        HDCityGroupsModel *recentlyCityGroupsModel = [[HDCityGroupsModel alloc] init];
        recentlyCityGroupsModel.title = @"最近";
        // 去除隐藏的
        recentlyCityGroupsModel.cities = [self.recentlySearchedCities filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(HDCityModel *model, NSDictionary *bindings) {
                                                                          return !model.hidden;
                                                                      }]];

        for (HDCityGroupsModel *tempModel in _cityGroups) {
            if ([tempModel.title isEqualToString:recentlyCityGroupsModel.title]) {
                tempModel.cities = recentlyCityGroupsModel.cities;
                return;
            }
        }
        if (_locationCityGroupModel) {
            [_cityGroups insertObject:recentlyCityGroupsModel atIndex:1];
        } else {
            [_cityGroups insertObject:recentlyCityGroupsModel atIndex:0];
        }
    }
}

- (void)addLocationCityGroupToDataSource {

    self.locationCityModel = self.currentCityModel;

    self.locationCityGroupModel = HDCityGroupsModel.new;
    self.locationCityGroupModel.title = @"定位";

    // 初始化定位数据源
    self.locationCityModel = HDCityModel.new;
    self.locationCityModel.isLocationCell = true;
    self.locationCityGroupModel = HDCityGroupsModel.new;
    self.locationCityGroupModel.title = @"定位";

    // 监听定位名称和状态变化
    [self.KVOController hd_observe:self.locationCityModel keyPath:@"locationState" action:@selector(locationInfoChanged)];
    [self.KVOController hd_observe:self.locationCityModel keyPath:@"name" action:@selector(locationInfoChanged)];

    // 获取授权情况并处理
    [self loadLatestAuthStateToRefreshLocationInfo];

    self.locationCityGroupModel.cities = @[self.locationCityModel];
    [self.cityGroups insertObject:self.locationCityGroupModel atIndex:0];
}

- (void)startUpdatingLocationInfo {
    self.locationCityModel.locationState = HDCitySelectLocationStateProcessing;
    self.locationCityModel.name = @"正在定位中...";
    [self.locationManager startUpdatingLocation];
}

- (void)loadRecentlyCityGroup {
    NSArray<HDCityModel *> *array;
    if ([self.delegate respondsToSelector:@selector(citySelectViewControllerRecentlyCitys:)]) {
        array = [self.delegate citySelectViewControllerRecentlyCitys:self];
    } else {
        array = [NSKeyedUnarchiver unarchiveObjectWithFile:kRecentlyCitysCachePath];
    }
    // 去除隐藏的
    self.recentlySearchedCities = [NSMutableArray arrayWithArray:[array filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(HDCityModel *model, NSDictionary *bindings) {
                                                                            return !model.hidden;
                                                                        }]]];
}

/// 随时检查权限变更
- (void)loadLatestAuthStateToRefreshLocationInfo {
    // 获取授权情况
    HDCLAuthorizationStatus status = [HDLocationUtils getCLAuthorizationStatus];
    if (status == HDCLAuthorizationStatusNotDetermined) {
        self.locationCityModel.locationState = HDCitySelectLocationStateDefault;
        self.locationCityModel.name = @"点击开始获取位置";
    } else if (status == HDCLAuthorizationStatusAuthed) {  // 已授权，直接定位
        [self startUpdatingLocationInfo];
    } else if (status == HDCLAuthorizationStatusNotAuthed) {  // 用户拒绝授权
        self.locationCityModel.locationState = HDCitySelectLocationStateUserDenyed;
        self.locationCityModel.name = @"未授权";
    }
}

#pragma mark - private methods
- (void)saveRecentlyCityGroup {
    if ([self.delegate respondsToSelector:@selector(citySelectViewController:saveRecentlyCitys:)]) {
        [self.delegate citySelectViewController:self saveRecentlyCitys:self.recentlySearchedCities];
    } else {
        [NSKeyedArchiver archiveRootObject:self.recentlySearchedCities toFile:kRecentlyCitysCachePath];
    }
    [self addRecentlyCityGroupToDataSource];
    [self.tableView reloadData];
}

- (void)selectedCityModel:(HDCityModel *)cityModel {

    if (self.delegate && [self.delegate respondsToSelector:@selector(citySelectViewController:didSelectedCicy:)]) {
        [self.delegate citySelectViewController:self didSelectedCicy:cityModel];
    }

    NSMutableArray<HDCityModel *> *tempCityNames = [NSMutableArray array];
    for (HDCityModel *tempCity in self.recentlySearchedCities) {
        if ([tempCity.name isEqualToString:cityModel.name]) {
            [tempCityNames addObject:tempCity];
        }
    }
    [self.recentlySearchedCities removeObjectsInArray:tempCityNames];
    if (self.recentlySearchedCities.count == 3) {
        [self.recentlySearchedCities removeLastObject];
    }
    // 保存到本地移除是定位的模型标志
    if (cityModel.isLocationCell) {
        cityModel.isLocationCell = false;
    }
    [self.recentlySearchedCities insertObject:cityModel atIndex:0];
    [self saveRecentlyCityGroup];

    if (!self.citySearchViewController.view.isHidden) {
        self.citySearchViewController.view.hidden = true;
        [self cancelBtnClick];
    }
    self.coverView.hidden = true;
    [self.citySearchViewController removeFromParentViewController];
    // 界面退出
    [self dismissAnimated:true completion:nil];
}

- (void)cancelBtnClick {
    [self.searchBar resignFirstResponder];
    [UIView animateWithDuration:0.5
        animations:^{
            self.coverView.alpha = 0;
            [self.searchBar setShowsCancelButton:NO animated:YES];
        }
        completion:^(BOOL finished) {
            self.coverView.hidden = true;
        }];
}

#pragma mark - event response
- (void)clickedCoverViewHandler {
    [self cancelBtnClick];
}

- (void)hd_backItemClick:(UIBarButtonItem *)sender {
    self.coverView.hidden = true;
    [self.citySearchViewController removeFromParentViewController];

    [super hd_backItemClick:sender];
}

#pragma mark - KVO
- (void)locationInfoChanged {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationCitySelectLocationInfoChanged object:nil];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.coverView.hidden = false;
    self.coverView.alpha = 0;
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.coverView.alpha = 0.5;
                         [searchBar setShowsCancelButton:YES animated:YES];
                     }
                     completion:nil];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length) {
        self.citySearchViewController.view.hidden = NO;
        self.citySearchViewController.searchText = searchText;
    } else {
        self.citySearchViewController.view.hidden = YES;
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    _searchBar.text = nil;
    self.citySearchViewController.view.hidden = true;
    [self cancelBtnClick];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cityGroups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    HDCityGroupsModel *cityGroupModel = self.cityGroups[section];
    if (cityGroupModel.title.length > 1) {
        return 1;
    }
    return cityGroupModel.cities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"ReuseIdentifierID";
    HDCityGroupsModel *cityGroupModel = self.cityGroups[indexPath.section];
    UITableViewCell *cell;
    if (cityGroupModel.title.length > 1) {  // 这个判断不严谨，可以自行加属性判断
        HDSelectCityTableViewCell *cell = [HDSelectCityTableViewCell cellWithTableView:tableView];
        cell.cities = cityGroupModel.cities;
        cell.cellDelegate = self;
        return cell;
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        }
        cell.textLabel.text = cityGroupModel.cities[indexPath.row].name;
    }
    return cell;
}

/** 索引标题 */
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [self.cityGroups valueForKeyPath:@"title"];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HDCityGroupsModel *cityGroupModel = self.cityGroups[section];

    if (cityGroupModel.cities.count <= 0) return nil;

    HDTableHeaderFootView *header = [HDTableHeaderFootView headerWithTableView:tableView];
    HDTableHeaderFootViewModel *model = HDTableHeaderFootViewModel.new;
    model.marginToBottom = CGFLOAT_MIN;
    model.titleColor = [HDAppTheme HDColorG3];
    NSString *title = cityGroupModel.title;
    if ([cityGroupModel.title isEqualToString:@"热门"]) {
        title = @"热门城市";
    } else if ([cityGroupModel.title isEqualToString:@"最近"]) {
        title = @"最近选择的城市";
    } else if ([cityGroupModel.title isEqualToString:@"定位"]) {
        title = @"当前城市";
    }
    model.title = title;
    header.model = model;
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    HDCityGroupsModel *cityGroupModel = self.cityGroups[section];

    if (cityGroupModel.cities.count <= 0) return CGFLOAT_MIN;

    return 40;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HDCityGroupsModel *model = self.cityGroups[indexPath.section];
    HDCityModel *cityModel = model.cities[indexPath.row];
    [self selectedCityModel:cityModel];
}

#pragma mark - HDSelectCityTableViewCellDelegate
- (void)selectCityTableViewCell:(HDSelectCityTableViewCell *)tableViewCell didSelectedCity:(HDCityModel *)cityModel {
    if (cityModel.isLocationCell) {

        HDCitySelectLocationState state = cityModel.locationState;
        if (state == HDCitySelectLocationStateDefault) {
            [self.locationManager requestWhenInUseAuthorization];
        } else if (state == HDCitySelectLocationStateFailed) {
            [self startUpdatingLocationInfo];
        } else if (state == HDCitySelectLocationStateUserDenyed) {
            if ([self.delegate respondsToSelector:@selector(citySelectViewControllerShowUnAuthedTip:)]) {
                [self.delegate citySelectViewControllerShowUnAuthedTip:self];
            }
        } else if (state == HDCitySelectLocationStateKnownLocation) {
            [self startUpdatingLocationInfo];
        } else if (state == HDCitySelectLocationStateProcessing) {
            HDLog(@"正在定位");
        } else if (state == HDCitySelectLocationStateSuccees) {
            HDLog(@"已经定位成功");
            [self selectedCityModel:cityModel];
        }
    } else {
        [self selectedCityModel:cityModel];
    }
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            break;

        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusRestricted: {
            self.locationCityModel.locationState = HDCitySelectLocationStateUserDenyed;
            self.locationCityModel.name = @"用户拒绝授权";
            break;
        }

        case kCLAuthorizationStatusAuthorizedWhenInUse: {
            [self startUpdatingLocationInfo];
            break;
        }

        case kCLAuthorizationStatusAuthorizedAlways: {
            [self startUpdatingLocationInfo];
            break;
        }

        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = [locations firstObject];
    [self.locationManager stopUpdatingLocation];
    CLGeocoder *geocoder = [CLGeocoder new];
    [geocoder reverseGeocodeLocation:location
                   completionHandler:^(NSArray<CLPlacemark *> *_Nullable placemarks, NSError *_Nullable error) {
                       if (placemarks.count == 0 || error) {
                           self.locationCityModel.locationState = HDCitySelectLocationStateFailed;
                           self.locationCityModel.name = @"定位失败，请点击重试";
                           self.locationCityGroupModel.cities = @[self.locationCityModel];
                       } else {
                           CLPlacemark *placemark = placemarks.lastObject;
                           if (placemark.locality) {
                               NSString *cityName = [placemark.locality substringWithRange:NSMakeRange(0, placemark.locality.length - 1)];
                               self.locationCityModel.locationState = HDCitySelectLocationStateSuccees;
                               self.locationCityModel.name = cityName;
                               self.locationCityGroupModel.cities = @[self.locationCityModel];
                           } else {
                               self.locationCityModel.locationState = HDCitySelectLocationStateKnownLocation;
                               self.locationCityModel.name = @"未知位置";
                               self.locationCityGroupModel.cities = @[self.locationCityModel];
                           }
                       }
                   }];
}

#pragma mark - lazy load
- (NSMutableArray<HDCityGroupsModel *> *)cityGroups {
    return _cityGroups ?: ({ _cityGroups = NSMutableArray.array; });
}

- (NSMutableArray<HDCityModel *> *)recentlySearchedCities {
    if (!_recentlySearchedCities) {
        _recentlySearchedCities = [NSMutableArray array];
    }
    return _recentlySearchedCities;
}

- (HDCitySearchViewController *)citySearchViewController {
    if (!_citySearchViewController) {
        HDCitySearchViewController *citySearchCtrl = [HDCitySearchViewController new];
        [self addChildViewController:citySearchCtrl];
        [self.view addSubview:citySearchCtrl.view];
        citySearchCtrl.view.frame = CGRectMake(0, CGRectGetMaxY(self.searchBar.frame), self.view.width, self.view.height - CGRectGetMaxY(self.searchBar.frame));
        _citySearchViewController = citySearchCtrl;
        __weak __typeof(self) weakSelf = self;
        _citySearchViewController.choosedCityModelHandler = ^(HDCityModel *cityModel) {
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf selectedCityModel:cityModel];
        };
    }
    return _citySearchViewController;
}

- (HDCitySelectSearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[HDCitySelectSearchBar alloc] initWithFrame:CGRectMake(0, self.navigationBarHeight, self.view.width, 64)];
        _searchBar.placeholder = @"请输入城市名/拼音/首字母拼音";
        _searchBar.delegate = self;
    }
    return _searchBar;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.searchBar.isHidden ? self.navigationBarHeight : CGRectGetMaxY(_searchBar.frame), self.view.width, self.view.height - CGRectGetMaxY(_searchBar.frame)) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tintColor = [UIColor blackColor];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 44;
        _tableView.showsVerticalScrollIndicator = false;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:HDSelectCityTableViewCell.class forCellReuseIdentifier:NSStringFromClass(HDSelectCityTableViewCell.class)];
        [_tableView registerClass:HDTableHeaderFootView.class forHeaderFooterViewReuseIdentifier:NSStringFromClass(HDTableHeaderFootView.class)];
        if ([_tableView respondsToSelector:@selector(setSectionIndexColor:)]) {
            _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
            _tableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
        }
    }
    return _tableView;
}

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [CLLocationManager new];
        _locationManager.delegate = self;
    }
    return _locationManager;
}

- (UIButton *)coverView {
    if (!_coverView) {
        _coverView = [[UIButton alloc] init];
        _coverView.backgroundColor = [UIColor blackColor];
        [_coverView addTarget:self action:@selector(clickedCoverViewHandler) forControlEvents:UIControlEventTouchUpInside];
        _coverView.frame = _tableView.frame;
        _coverView.alpha = 0.5;
        [self.view addSubview:_coverView];
    }
    return _coverView;
}

- (FBKVOController *)KVOController {
    if (!_KVOController) {
        _KVOController = [FBKVOController controllerWithObserver:self];
    }
    return _KVOController;
}
@end
