//
//  SCEditCommodityTagsView.m
//  Module
//
//  Created by junlongj on 16/1/25.
//  Copyright © 2016年 junlongj. All rights reserved.
//

#import "SCEditCommodityTagsView.h"
#import "SCListCommodityTagsModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
@interface SCEditCommodityTagsView ()

@property (nonatomic  ,strong) UIButton *changeShowStyleButton;
@property (nonatomic  ,strong) UIView *brandNameGesContainerView;
@property (nonatomic  ,strong) UIView *priceGesContainerView;
@property (nonatomic  ,strong) UIView *addressGesContainerView;
@end


@implementation SCEditCommodityTagsView

+(instancetype)creatTagViewWithTagModel:(SCListCommodityTagsModel *)tagModel
                              superView:(UIView *)superView{
    SCEditCommodityTagsView *tagView =  [[self class] creatView];
    [superView addSubview:tagView];
    [superView addTagView:tagView];
    tagView.tagModel = tagModel;
    [tagView setupSubviews];
    //每次创建tagView的时候,看是否需要去修改展示样式，来显示label
    [tagView changeShowStyleToShowMoreContent];
    return tagView;
}

- (void)setupSubviews{
    
    self.brandNameLabel.delegate = nil;
    self.priceCurrencyLabel.delegate = nil;
    @weakify(self)
    self.changeShowStyleButton = ({
        UIButton *changeStyleBtn =  UIButton.new;
        changeStyleBtn.bounds = CGRectMake(0, 0, 25, 25);
        [self addSubview:changeStyleBtn];
        changeStyleBtn;
    });
    self.changeShowStyleButton.rac_command = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        //限制样式
        //3行4中样式
        if (self.lineCount == 3) {
            if (self.showStyle != SCCommodityTagsViewShowStyleLeftRight) {
                self.showStyle++;
            }else{
                self.showStyle = SCCommodityTagsViewShowStyleAllRight;
            }
        }else if (self.lineCount == 2){
            //2行两种
            if (self.showStyle == SCCommodityTagsViewShowStyleRightLeft) {
                self.showStyle = SCCommodityTagsViewShowStyleLeftRight;
            }else if(self.showStyle == SCCommodityTagsViewShowStyleLeftRight ){
                self.showStyle = SCCommodityTagsViewShowStyleRightLeft;
            }
        }else if (self.lineCount == 1){
            //一行两种
            if (self.showStyle == SCCommodityTagsViewShowStyleAllRight) {
                self.showStyle = SCCommodityTagsViewShowStyleAllLeft;
            }else if(self.showStyle == SCCommodityTagsViewShowStyleAllLeft ){
                self.showStyle = SCCommodityTagsViewShowStyleAllRight;
            }
        }
        return [RACSignal empty];
    }];
    //observe showStyle

    
    [[[RACObserve(self, showStyle).distinctUntilChanged
       doNext:^(id x) {
           @strongify(self)
           //reset animation
           [CATransaction begin];
           [CATransaction setDisableActions:true];
           self.brandNameLayer.strokeEnd = 0;
           self.priceCurrencyLayer.strokeEnd = 0;
           self.countyAddressLayer.strokeEnd = 0;
           [CATransaction commit];
           //animation
           [self resetAnimations];
           [self showLineAnimationWithCompletionBlock:NULL];
       }]skip:1]subscribeNext:^(id x) {
           @strongify(self)
           //refresh frame && path
           [self adjustTouchPoint];
           [self layoutFrames];
           [self layoutLayerPaths];
       }];
    

    //update model info
    RAC(self,tagModel.tagsDisplayStyle) = RACObserve(self, showStyle).distinctUntilChanged;
    
    RAC(self,tagModel.leftProportion) = [RACObserve(self, touchPoint) map:^id(NSValue *point) {
        @strongify(self);
        return @(point.CGPointValue.x / self.tagModel.superviewSize.width);
    }].distinctUntilChanged;
    RAC(self,tagModel.TopProportion) = [RACObserve(self, touchPoint) map:^id(NSValue *point) {
        @strongify(self);
        return @(point.CGPointValue.y / self.tagModel.superviewSize.height);
    }].distinctUntilChanged;
    
    
    self.brandNameGesContainerView = UIView.new;
    [self addSubview:self.brandNameGesContainerView];
    
    self.priceGesContainerView = UIView.new;
    [self addSubview:self.priceGesContainerView];
    
    self.addressGesContainerView = UIView.new;
    [self addSubview:self.addressGesContainerView];
    
    

    NSValue* (^ChangeFrame)(NSValue *) = ^(NSValue *frame) {
        return [NSValue valueWithCGRect:CGRectInset(frame.CGRectValue, 0, -5)];
    };
    //udpate subView frames
    RAC(self.brandNameGesContainerView,frame) = [RACObserve(self.brandNameLabel, frame).distinctUntilChanged
                                        map:ChangeFrame];
    RAC(self.priceGesContainerView,frame) = [RACObserve(self.priceCurrencyLabel, frame).distinctUntilChanged
                                        map:ChangeFrame];
    RAC(self.addressGesContainerView,frame) = [RACObserve(self.countyAddressLabel, frame).distinctUntilChanged
                                        map:ChangeFrame];
    RAC(self.changeShowStyleButton, center) = RACObserve(self.circleContainerView, center);
    

    UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc]initWithTarget:nil action:NULL];
    UITapGestureRecognizer *click2 = [[UITapGestureRecognizer alloc]initWithTarget:nil action:NULL];
    UITapGestureRecognizer *click3 = [[UITapGestureRecognizer alloc]initWithTarget:nil action:NULL];
    [self.addressGesContainerView addGestureRecognizer:click];
    [self.brandNameGesContainerView addGestureRecognizer:click2];
    [self.priceGesContainerView addGestureRecognizer:click3];
    
    
    //subscribe click event
    [[RACSignal merge:@[click.rac_gestureSignal,
                      click2.rac_gestureSignal,
                      click3.rac_gestureSignal]]
                subscribeNext:^(id x) {
                    @strongify(self)
                    self.didSelectClickLabelCallBack ? self.didSelectClickLabelCallBack() : nil;
    }];
    
    //longGes to cancle Tag
    UILongPressGestureRecognizer *longGes = [[UILongPressGestureRecognizer alloc]initWithTarget:nil action:NULL];
    [self addGestureRecognizer:longGes];
    
    [[longGes.rac_gestureSignal filter:^BOOL(UILongPressGestureRecognizer *gesture) {
        return gesture.state == UIGestureRecognizerStateBegan;
    }] subscribeNext:^(UILongPressGestureRecognizer *gesture) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:@"确定要删除此条标签吗？"
                                                      delegate:nil
                                             cancelButtonTitle:@"取消"
                                             otherButtonTitles:@"确定", nil];
        [alert show];
        @weakify(self)
        [[alert.rac_buttonClickedSignal ignore:@0]
         subscribeNext:^(id x) {
             @strongify(self)
             [self.superview removeTagView:self];
             [self removeFromSuperview];
         }];
        
    }];

}
- (void)changeShowStyleToShowMoreContent{
    //编辑状态默认是AllRight
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat superWidth = CGRectGetWidth(self.superview.frame);
    if (self.touchPoint.x + width > superWidth) {
        if ( self.showStyle == SCCommodityTagsViewShowStyleAllRight) {
            self.showStyle = SCCommodityTagsViewShowStyleAllLeft;
        }else if ( self.showStyle == SCCommodityTagsViewShowStyleRightLeft){
            self.showStyle = SCCommodityTagsViewShowStyleLeftRight;
        }
    }

    [self adjustTouchPoint];
}
#pragma mark - Touch Event

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (touches.count > 1) {
        return;
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (touches.count > 1) {
        return;
    }
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.superview];
    CGPoint previous = [touch previousLocationInView:self.superview];

    self.center = CGPointMake(self.center.x + point.x - previous.x, self.center.y + point.y - previous.y);
  
    [self adjustTouchPoint];
}

- (void)adjustTouchPoint{
    CGFloat maxX = CGRectGetMaxX(self.frame);
    CGFloat minX = CGRectGetMinX(self.frame);
    CGFloat minY = CGRectGetMinY(self.frame);
    CGFloat maxY = CGRectGetMaxY(self.frame);
    CGFloat superWidth = CGRectGetWidth(self.superview.frame);
    CGFloat superHeight = CGRectGetHeight(self.superview.frame);
    CGRect  frame = self.frame;
    //right
    if (maxX > superWidth) {
        frame.origin.x =  superWidth - frame.size.width;
    }
    //left
    if (minX < 0) {
        frame.origin.x = 0;
    }
    //top
    if (minY < 0) {
        frame.origin.y = 0;
    }
    //bottom
    if (maxY > superHeight ) {
        frame.origin.y = superHeight - frame.size.height;
    }
    self.frame = frame;
    CGPoint touchPoint =  [self convertPoint:self.circleContainerView.center
                                      toView:self.superview];
    
    self.touchPoint = touchPoint;
}
@end
