//
//  SCCommodityTagsView.h
//  Module
//
//  Created by junlongj on 16/1/25.
//  Copyright © 2016年 junlongj. All rights reserved.
//


/**
 *  Inheritance relationship
 *  SCCommodityTagsBaseView ->
            SCListCommodityTagsView
                    SCEditCommodityTagsView
 */
#import "SCEditCommodityTagsView.h"
#import "SCListCommodityTagsView.h"
#import "SCCommodityTagsBaseView.h"


#define UIColorFromRGB(rgbValue)                                                                   \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0                           \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0                              \
blue:((float)(rgbValue & 0xFF)) / 255.0                                       \
alpha:1.0]

#define UIColorWithRGBA(r,g,b,a) [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]

#define kMainScreenWidth         ([UIScreen mainScreen].bounds).size.width              //屏幕的高度
#define kMainScreenHeight        ([UIScreen mainScreen].bounds).size.height             //屏幕的宽度