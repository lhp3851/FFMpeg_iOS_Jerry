//
//  BaseTableView.m
//  StarZone
//
//  Created by 宋林峰 on 16/6/14.
//  Copyright © 2016年 xiangChaoKanKan. All rights reserved.
//

#import "KKBaseTableView.h"

@interface KKBaseTableView ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong)NSMutableArray *tableList; //数据列表

@end

@implementation KKBaseTableView


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame style:UITableViewStylePlain]) {
        self.tableList = [NSMutableArray arrayWithCapacity:50];
        self.delegate = self;
        self.dataSource = self;
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.backgroundColor = kDEEP_COLOR;
        
        MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshDynamic:)];
        self.mj_header = refreshHeader;
        MJRefreshAutoNormalFooter *refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshDynamic:)];
        self.mj_footer = refreshFooter;
        
        [refreshFooter setTitle:@"求你别拉了，没有啦~" forState:MJRefreshStateNoMoreData];
        [refreshFooter setTitle:@"" forState:MJRefreshStateIdle];
        [refreshFooter setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
        [self.mj_header beginRefreshing];
    }
    return self;
}


-(void)refreshData
{
    [self.mj_header beginRefreshing];
}

#pragma mark - MJRefresh

- (void)refreshDynamic:(UIView *)refreshView
{
    if ([refreshView isKindOfClass:[MJRefreshNormalHeader class]]) {
        if (self.kdelegate && [self.kdelegate respondsToSelector:@selector(loadTopDatas:)]) {
            [self.kdelegate loadTopDatas:self];
        }
    }
    else if ([refreshView isKindOfClass:[MJRefreshAutoNormalFooter class]])
    {
        if (self.kdelegate && [self.kdelegate respondsToSelector:@selector(loadMoreDatas:)]) {
            [self.kdelegate loadMoreDatas:self];
        }
    }
}


-(void)endRefreshing
{
    if (self.mj_header.state == MJRefreshStateRefreshing) {
        [self.mj_header endRefreshing];
    }
    
    if (self.mj_footer.state == MJRefreshStateRefreshing) {
        [self.mj_footer endRefreshing];
    }
}

-(void)setNoDataView:(UIView *)noDataView
{
    if (_noDataView && [self.noDataView superview]) {
        [self.noDataView removeFromSuperview];
    }
    _noDataView = noDataView;
}

-(void)loadResult:(BOOL)result lists:(NSArray *)lists isNews:(BOOL)isNews
{
    [self endRefreshing];
    
    if (lists.count <= 0) {
        [self.mj_footer endRefreshingWithNoMoreData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.mj_footer resetNoMoreData];
        });
    }
    else if(self.mj_footer.state == MJRefreshStateNoMoreData)
    {
        [self.mj_footer resetNoMoreData];
    }
    
    if (result==NO || lists.count<=0) {
        if (self.tableList.count<=0) {
            if (_noDataView && [self.noDataView superview] == nil) {
                _noDataView.center = self.center;
                self.scrollEnabled = NO;
                [[self superview] addSubview:_noDataView];
            }
        }
        return;
    }
    
    self.scrollEnabled = YES;
    if (_noDataView && [self.noDataView superview]) {
        [self.noDataView removeFromSuperview];
    }
    
    if (isNews) {
        [self insertItemsWith:lists isNews:YES];
    }
    else
    {
        [self insertItemsWith:lists isNews:NO];
    }
}


-(void)insertItemsWith:(NSArray *)items isNews:(BOOL)isNews
{
    if (items.count<=0) {
        return;
    }
    @synchronized(_tableList)
    {
        if (_tableList.count<=0 || isNews == YES) {
            [_tableList removeAllObjects];
            [_tableList addObjectsFromArray:items];
        }
        else
        {
            [_tableList addObjectsFromArray:items];
        }
        [self reloadData];
    }
}


#pragma mark Table view methods

-(id)modelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    return [self.tableList objectAtIndex:row];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowCount = self.tableList.count;
    return rowCount;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0.0f;
    if (self.kdelegate && [self.kdelegate respondsToSelector:@selector(heightForRowAtIndexPath:baseView:)]) {
        height = [self.kdelegate heightForRowAtIndexPath:indexPath baseView:self];
    }
    return height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (self.kdelegate && [self.kdelegate respondsToSelector:@selector(cellForRowAtIndexPath:baseView:)]) {
        cell = [self.kdelegate cellForRowAtIndexPath:indexPath baseView:self];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.kdelegate && [self.kdelegate respondsToSelector:@selector(didSelectRowAtIndexPath:baseView:)]) {
        [self.kdelegate didSelectRowAtIndexPath:indexPath baseView:self];
    }
}

@end
