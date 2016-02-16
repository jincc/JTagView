//
//  SCEditCommodityTagsView.h
//  Module
//
//  Created by junlongj on 16/1/25.
//  Copyright © 2016年 junlongj. All rights reserved.
//

#import "SCListCommodityTagsView.h"
typedef void(^DidSelectClickLabelCallBack)();
@interface SCEditCommodityTagsView : SCListCommodityTagsView

@property (nonatomic  ,copy)DidSelectClickLabelCallBack didSelectClickLabelCallBack;
@end
