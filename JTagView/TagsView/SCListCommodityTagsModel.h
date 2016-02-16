//
//  SCListCommodityTagsModel.h
//  JuMei
//
//  Created by junlongj on 16/1/26.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SCTagDataSourcStyle) {
    SCTagDataSourcStyleCommmon = 0,
    SCTagDataSourcStyleBrand
};

/**
 *  3行   All
 
    2行   RightLeft | LeftRight
 
    1行   Right |  Left
 */
typedef NS_ENUM(NSUInteger, SCCommodityTagsViewShowStyle) {
    SCCommodityTagsViewShowStyleAllRight = 0,
    SCCommodityTagsViewShowStyleAllLeft,
    SCCommodityTagsViewShowStyleRightLeft,
    SCCommodityTagsViewShowStyleLeftRight,
};
/**
 *  商品信息
 */
@interface SCListCommodityTagsModel : NSObject
/**
 *  0普通标签，1品牌,
 */
@property (nonatomic ,assign)SCTagDataSourcStyle tagDataSourcStyle;
/**
 *  标签排列样式
 */
@property (nonatomic , assign) SCCommodityTagsViewShowStyle tagsDisplayStyle;


/**
 *  普通标签文字描述
 */
@property (nonatomic ,copy) NSString *commonTagTextDes;
/**
 *  普通标签Id
 */
@property (nonatomic ,copy) NSString *commonTagId;


//商品信息标签内容
@property (nonatomic , copy) NSString *brandName;
/**
 *  品牌Id，用于跳转
 */
@property (nonatomic , copy) NSString *brandId;

@property (nonatomic , copy) NSString *tradeName;
/**
 *  商品名Id，跳转
 */
@property (nonatomic , copy) NSString *tradeId;

@property (nonatomic , copy) NSString *currency;
@property (nonatomic , copy) NSString *currencyId;

@property (nonatomic , copy) NSString *price;

@property (nonatomic , copy) NSString *country;
@property (nonatomic , copy) NSString *countryId;

@property (nonatomic , copy) NSString *detailsAddtress;

/**
 *  touchPoint 左比例
 */
@property (nonatomic , assign)CGFloat leftProportion;
/**
 *  touchPoint 上比例
 */

@property (nonatomic , assign)CGFloat TopProportion;

/**
 *  父视图size
 */
@property (nonatomic , assign)CGSize superviewSize;

/**
 *  计算touchPoint
 *
 *  @return <#return value description#>
 */
- (CGPoint)tagViewTouchPoint;


- (NSArray<NSString *> *)transformToTagsViewData;


- (NSDictionary *)transformToJson;

@end


