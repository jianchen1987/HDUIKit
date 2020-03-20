//
//  HDCitySearchViewController.m
//  HDUIKit
//
//  Created by VanJay on 2019/9/26.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDCitySearchViewController.h"
#import "HDCityGroupsModel.h"
#import "HDCityModel.h"
#import "NSBundle+HDUIKit.h"
#import "YYModel.h"

static NSString *reuseIdentifierID = @"HDCitySearchViewController_reuseIdentifier";

@interface HDCitySearchViewController ()
@property (nonatomic, strong) NSMutableArray<HDCityModel *> *cityArray;    ///< 城市数组
@property (nonatomic, strong) NSMutableArray<HDCityModel *> *resultArray;  ///< 搜索结果
@end

@implementation HDCitySearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44;

    [self loadAllCityModels];
    _resultArray = [NSMutableArray<HDCityModel *> array];
}

- (void)loadAllCityModels {
    NSString *path = [[NSBundle hd_UIKITCitySelectResources] pathForResource:@"cities.json" ofType:nil];
    NSArray *json = [NSArray arrayWithContentsOfFile:path];
    NSMutableArray<HDCityGroupsModel *> *cityGroups = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:HDCityGroupsModel.class json:json]];

    _cityArray = [NSMutableArray array];
    for (HDCityGroupsModel *group in cityGroups) {
        [_cityArray addObjectsFromArray:group.cities];
    }
}

#pragma mark - getters and setters
- (void)setSearchText:(NSString *)searchText {
    _searchText = searchText.lowercaseString;

    [_resultArray removeAllObjects];

    for (HDCityModel *cityModel in _cityArray) {
        if ([cityModel.name containsString:searchText] || [cityModel.pinYin containsString:searchText] || [cityModel.pinYinHead containsString:searchText]) {
            [_resultArray addObject:cityModel];
        }
    }
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.resultArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifierID];
    }
    HDCityModel *cityModel = self.resultArray[indexPath.row];
    cell.textLabel.text = cityModel.name;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"有 %zd 个搜索结果", self.resultArray.count];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:false];

    HDCityModel *cityModel = self.resultArray[indexPath.row];
    !self.choosedCityModelHandler ?: self.choosedCityModelHandler(cityModel);
}
@end
