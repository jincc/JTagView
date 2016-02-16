//
//  SCListCommodityTagsView.h
//  Module
//
//  Created by junlongj on 16/1/25.
//  Copyright © 2016年 junlongj. All rights reserved.
//

#import "SCCommodityTagsBaseView.h"
/**
 *  click CommodityTag Brand Label
 *
 *  @param NSString brandID
 */
typedef void(^TagViewDidSelectBrandCallBack)(NSString *);
/**
 *  click CommodityTag trade Label
 *
 *  @param NSString tradeID
 */
typedef void(^TagViewDidSelectTradeCallBack)(NSString *);

/**
 *  click commonTag label
 *
 *  @param NSString commonTagId
 */

typedef void(^TagViewDidSelectTextDesCallBack)(NSString *);
/**
 * 适用于首页,tableView cell上展示标签
 */
@class SCListCommodityTagsModel;
@interface SCListCommodityTagsView : SCCommodityTagsBaseView
/**
 *  创建标签，superView添加了show、hidden动画
 *
 *  @param tagModel  <#tagModel description#>
 *  @param superView <#superView description#>
 *
 *  @return <#return value description#>
 */
+ (instancetype)creatTagViewWithTagModel:(SCListCommodityTagsModel *)tagModel
                               superView:(UIView *)superView;

@property (nonatomic , strong)SCListCommodityTagsModel *tagModel;
@property (nonatomic , assign)BOOL isShowExpandAnimation;
@property (nonatomic , copy)TagViewDidSelectBrandCallBack tagViewDidSelectBrandCallBack;
@property (nonatomic , copy)TagViewDidSelectTradeCallBack tagViewDidSelectTradeCallBack;
@property (nonatomic , copy)TagViewDidSelectTextDesCallBack tagViewDidSelectTextDesCallBack;

@end




@interface SCListCommodityTagsView (Animation)
- (void)showLineAnimationWithCompletionBlock:(void (^)(void))completionBlock;
/**
 *  小红书动画  闪两下，暂定 ，一直循环 ，
 *  内部通过 observe isShowExpandAnimation这个属性
 */
- (void)prepareCircleLayerRepeatScaleAnimation;
- (void)showCircleLayerRepeatScaleAnimation;
- (void)showCircleContainerViewScaleAnimationWithcompletionBlock:(void (^)())completionBlock;
- (void)hiddenAnimationWithCompletionBlock:(void (^)(void))completionBlock;
@end



@interface UIView (TagView)
@property (nonatomic , strong)UITapGestureRecognizer *tagViewClickTapGestureRecognizer;
@property (nonatomic , strong)NSArray<SCListCommodityTagsView *> *tagViews;
- (void)resetTagViews;
- (void)addTagView:(SCListCommodityTagsView *)tagView;
- (void)removeTagView:(SCListCommodityTagsView *)tagView;

@end
