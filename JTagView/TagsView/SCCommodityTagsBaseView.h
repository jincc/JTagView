//
//  SCCommodityTagsView.h
//  Module
//
//  Created by junlongj on 16/1/22.
//  Copyright © 2016年 junlongj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCStrokeLabel.h"
#import "SCListCommodityTagsModel.h"

@interface SCCommodityTagsBaseView : UIView<PPLabelDelegate>
@property (nonatomic  ,strong,readonly) CALayer *circleLayer;
@property (nonatomic  ,strong,readonly) UIImageView  *circleContainerView;

@property (nonatomic  ,strong,readonly) CAShapeLayer *brandNameLayer;
@property (nonatomic  ,strong,readonly) CAShapeLayer *priceCurrencyLayer;
@property (nonatomic  ,strong,readonly) CAShapeLayer *countyAddressLayer;

@property (nonatomic  ,strong,readonly) SCStrokeLabel *brandNameLabel;
@property (nonatomic  ,strong,readonly) SCStrokeLabel *priceCurrencyLabel;
@property (nonatomic  ,strong,readonly) SCStrokeLabel *countyAddressLabel;

/**
 *  array[0,1,2]
 *  nicker 经典款
 *  55 日元
 *  美国 第五大道
 */
@property (nonatomic  ,strong) NSArray<NSString *> *showTexts;
/**
 *  tag样式
 */
@property (nonatomic  ,assign) SCCommodityTagsViewShowStyle showStyle;
/**
 *  相对于superView point
 */
@property (nonatomic  ,assign) CGPoint touchPoint;

@property (nonatomic  ,assign) CGSize superViewSize;

@property (nonatomic  ,assign) CGPoint isWantAccuracyCalculateViewHeight;
/**
 *  几行label，用来限制showStyle的切换样式
 */
@property (nonatomic  ,assign,readonly) NSInteger lineCount;
/**
 *  创建tagView
 *
 *  @return <#return value description#>
 */
+ (instancetype)creatView;
/**
 *  draw animation line path
 */
- (void)layoutLayerPaths;
/**
 *  update view frame
 */
- (void)layoutFrames;

@end



@interface SCCommodityTagsBaseView (Animation)
/**
 *  cancle all aniamtion
 */
- (void)resetAnimations;

@end


@interface CAShapeLayer (TwoSegment)
@property (nonatomic ,strong) NSNumber *segmentPoint;
@end


@interface SCTwoSegmentPath : NSObject

@property (nonatomic , assign)CGPoint startPoint;
@property (nonatomic , assign)CGPoint middlePoint;
@property (nonatomic , assign)CGPoint endPoint;
+ (instancetype)pathWithFirstPoint:(CGPoint)startPoint
                       middlePoint:(CGPoint)middlePoint
                          endPoint:(CGPoint)endPoint;

- (UIBezierPath *)drawPath;
- (NSNumber *)calculateSegmentPoint;

@end