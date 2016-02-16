//
//  EditViewController.m
//  JTagView
//
//  Created by junlongj on 16/2/16.
//  Copyright © 2016年 junlongj. All rights reserved.
//

#import "EditViewController.h"
#import "SCCommodityTagsView.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
@interface EditViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *clickGes;

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    RAC(self.tipLabel,text) = [RACObserve(self.imageView, tagViews) map:^id(NSMutableArray * tags) {
        if (tags.count == 0) {
            return @"点击图片添加标签";
        }else{
            return @"长安删除，点击标签圆圈更换样式";
        }
    }];
    @weakify(self)
    [[self.clickGes.rac_gestureSignal map:^id(UITapGestureRecognizer *ges){
        return [NSValue valueWithCGPoint:[ges locationInView:ges.view]];
    }] subscribeNext:^(NSValue *point) {
       //do something
        //then get tag info
        SCListCommodityTagsModel *model = [SCListCommodityTagsModel new];
        model.tagDataSourcStyle = SCTagDataSourcStyleBrand;
        model.tagsDisplayStyle = SCCommodityTagsViewShowStyleAllRight;
        model.leftProportion  =  point.CGPointValue.x / self.imageView.bounds.size.width;
        model.TopProportion = point.CGPointValue.y / self.imageView.bounds.size.height;
        model.brandName = @"nick";
        model.brandId = @"12";
        model.tradeName = @"全新鞋子";
        model.tradeId = @"12";
        model.currency = @"RMB";
        model.price = @"123";
        model.country = @"中国";
        model.detailsAddtress = @"春熙路上传";
        @strongify(self)
        SCEditCommodityTagsView *tagView = [SCEditCommodityTagsView creatTagViewWithTagModel:model
                                                                                   superView:self.imageView];
        
        //重新编辑标签
        tagView.didSelectClickLabelCallBack = ^(){
            

        };
    }];
}

@end
