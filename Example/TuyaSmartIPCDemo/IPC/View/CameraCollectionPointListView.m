//
//  CameraCollectionPointListView.m
//  TuyaSmartIPCDemo_Example
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "CameraCollectionPointListView.h"
#import "CameraCollectionPointListCell.h"

@interface CameraCollectionPointListView ()<TuyaSmartPTZManagerDeletate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<TYCameraCollectionPointModel *> *dataSource;
@property (nonatomic, strong) TuyaSmartPTZManager *ptzManager;
@end

@implementation CameraCollectionPointListView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.tableView];
    }
    return self;
}

- (void)setDeviceId:(NSString *)deviceId {
    _deviceId = deviceId;
    if (![self.ptzManager isSupportCollectionPoint]) {
        NSLog(@"Not Support");
    } else {
        [self requestCollectionPointList];
    }
}

- (void)refreshUI {
    [self requestCollectionPointList];
}

- (void)requestCollectionPointList {
    __weak typeof(self) weakSelf = self;
    [self.ptzManager requestCollectionPointListWithSuccess:^(NSArray *list) {
        weakSelf.dataSource = list;
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - action
- (void)renameAction:(TYCameraCollectionPointModel *)model {
    if (![self.ptzManager couldOperateCollectionPoint]) {
        NSLog(@"Is support.");
        return;
    }
    __weak typeof(self) weakSelf = self;
    NSString *randomName = [NSString stringWithFormat:@"randomName_%u", arc4random()%100];
    [self.ptzManager renameCollectionPoint:model name:randomName success:^{
        [weakSelf requestCollectionPointList];
    } failure:^(NSError *error) {
        
    }];
}

- (void)removeAction:(TYCameraCollectionPointModel *)model {
    if (![self.ptzManager couldOperateCollectionPoint]) {
        NSLog(@"Is support.");
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [self.ptzManager deleteCollectionPoints:@[model] success:^{
//        NSMutableArray *arrM = [weakSelf.dataSource mutableCopy];
//        [arrM removeObject:model];
//        weakSelf.dataSource = [arrM copy];
//        [weakSelf.tableView reloadData];
        [weakSelf requestCollectionPointList];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CameraCollectionPointListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CameraCollectionPointListCell"];
    TYCameraCollectionPointModel *model = self.dataSource[indexPath.row];
    cell.model = model;
    __weak typeof(self) weakSelf = self;
    cell.didClickRenameButton = ^(TYCameraCollectionPointModel * _Nonnull model) {
        [weakSelf renameAction:model];
    };
    cell.didClickRemoveButton = ^(TYCameraCollectionPointModel * _Nonnull model) {
        [weakSelf removeAction:model];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.bounds.size.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 81;
        [_tableView registerClass:[CameraCollectionPointListCell class] forCellReuseIdentifier:@"CameraCollectionPointListCell"];
    }
    return _tableView;
}

#pragma mark - Getters
- (TuyaSmartPTZManager *)ptzManager {
    if (!_ptzManager) {
        _ptzManager = [[TuyaSmartPTZManager alloc] initWithDeviceId:_deviceId];
        _ptzManager.delegate = self;
    }
    return _ptzManager;
}

@end
