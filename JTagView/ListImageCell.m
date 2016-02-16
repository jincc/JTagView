//
//  ListImageCell.m
//  JTagView
//
//  Created by junlongj on 16/2/16.
//  Copyright © 2016年 junlongj. All rights reserved.
//

#import "ListImageCell.h"
#import "SCCommodityTagsView.h"
id objectInArrayAtIndex(NSArray *array_, NSUInteger index) {
    if ([array_ count] > index) {
        return [array_ objectAtIndex:index];
    } else {
        return nil;
    }
}

@interface ListImageCell ()
@end

@implementation ListImageCell

- (void)awakeFromNib {
    // Initialization code
    SCListCommodityTagsModel *model = [SCListCommodityTagsModel new];
    model.tagDataSourcStyle = SCTagDataSourcStyleBrand;
    model.tagsDisplayStyle = SCCommodityTagsViewShowStyleAllRight;
    model.leftProportion = 0.3;
    model.TopProportion = 0.7;
    model.brandName = @"nick";
    model.brandId = @"12";
    model.tradeName = @"全新鞋子";
    model.tradeId = @"12";
    model.currency = @"RMB";
    model.price = @"123";
    model.country = @"中国";
    model.detailsAddtress = @"春熙路上传";
    
    
    SCListCommodityTagsModel *model2= [SCListCommodityTagsModel new];
    model2.tagDataSourcStyle = SCTagDataSourcStyleBrand;
    model2.tagsDisplayStyle = SCCommodityTagsViewShowStyleRightLeft;
    model2.leftProportion = 0.7;
    model2.TopProportion = 0.4;
    model2.brandName = @"nick";
    model2.brandId = @"12";
    model2.tradeName = @"全新鞋子";
    model2.tradeId = @"12";
    model2.country = @"中国";
    model2.detailsAddtress = @"春熙路上传";
    
    SCListCommodityTagsModel *model3 = [SCListCommodityTagsModel new];
    model3.tagDataSourcStyle = SCTagDataSourcStyleCommmon;
    model3.tagsDisplayStyle = SCCommodityTagsViewShowStyleRightLeft;
    model3.leftProportion = 0.9;
    model3.TopProportion = 0.9;
    model3.commonTagTextDes = @"nick";
    model3.commonTagId = @"12";
    
    
//    SCListCommodityTagsView *tag = [SCListCommodityTagsView creatTagViewWithTagModel:model
//                                                                           superView:self.imageV];
//    tag.tagViewDidSelectTextDesCallBack = ^(id _){
//        
//    };
//    tag.tagViewDidSelectTradeCallBack = ^(id _){
//        
//    };
//    tag.tagViewDidSelectBrandCallBack = ^(id _){
//        
//    };
    
   [SCListCommodityTagsView creatTagViewWithTagModel:model2
                                                                           superView:self.imageV];
//    [SCListCommodityTagsView creatTagViewWithTagModel:model3
//                                                                           superView:self.imageV];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
