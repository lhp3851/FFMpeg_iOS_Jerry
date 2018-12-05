//
//  BaseTableView.h
//  StarZone
//
//  Created by 宋林峰 on 16/6/14.
//  Copyright © 2016年 xiangChaoKanKan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"

/**
 *  对上下拉动作统一处理。
 *  处理有上下拉动作的View，如果要对tableView作细节处理，可以直接操作tabelView，tableView类型为UITableViewStylePlain
 *  默认tableView为无分隔线，kDEEP_COLOR背景色
 */


@class KKBaseTableView;
@protocol BaseTableViewDelegate <NSObject>
@required
/**
 *  加载最新数据
 */
-(void)loadTopDatas:(KKBaseTableView *)baseView;

/**
 *  加载更多数据
 */
-(void)loadMoreDatas:(KKBaseTableView *)baseView;


/**
 *  获取cell的高度
 *
 *  @param model    当前cell数据
 *  @param baseView
 *
 *  @return cell height
 */
-(CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath baseView:(KKBaseTableView *)baseView;

/**
 *  获取tableView的cell
 *
 *  @param indexPath
 *  @param baseView
 *
 *  @return cell
 */
- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath baseView:(KKBaseTableView *)baseView;

@optional
/**
 *  选择cell
 *
 *  @param indexPath
 *  @param baseView
 */
-(void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath baseView:(KKBaseTableView *)baseView;

@end


//适用于单列表处理
@interface KKBaseTableView : UITableView

@property(nonatomic, strong, readonly)NSMutableArray *tableList; //数据列表
@property(nonatomic, strong)UIView *noDataView;  //没有数据的显示
@property(nonatomic, weak)id<BaseTableViewDelegate> kdelegate;

/**
 *  刷新数据
 */
-(void)refreshData;

/**
 *  加载数据结果
 *
 *  @param result YES表示正确结果，NO,表示结果错误
 *  @param lists  正确的列表
 *  @param param  加载的参数
 *  @param isNews 是新数据还是旧数据
 */
-(void)loadResult:(BOOL)result lists:(NSArray *)lists isNews:(BOOL)isNews;

/**
 *  获得indexPath位置的数据
 *
 *  @param indexPath
 *
 *  @return model
 */
-(id)modelForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
