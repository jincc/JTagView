//
//  SCListCommodityTagsView.m
//  Module
//
//  Created by junlongj on 16/1/25.
//  Copyright © 2016年 junlongj. All rights reserved.
//

#import "SCListCommodityTagsView.h"
#import "SCListCommodityTagsModel.h"
#import "SCUIAnimation.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <pop/POP.h>
#import <objc/runtime.h>
static char kTagsViewKey;
static char kTapGestureRecognizerKey;
NSTimeInterval const delay = 0.25;
NSTimeInterval const hiddenDelay = 0.4;


@interface SCListCommodityTagsView()

@property (nonatomic , assign) BOOL show;
@end


@implementation SCListCommodityTagsView
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    SCListCommodityTagsView *view  = [super allocWithZone:zone];
    @weakify(view)
    [[view rac_signalForSelector:@selector(initWithFrame:)]
     subscribeNext:^(id x) {
         @strongify(view)
         view.show = true;
         [view prepareCircleLayerRepeatScaleAnimation];
     }];
    return view;
}

+ (instancetype)creatTagViewWithTagModel:(SCListCommodityTagsModel *)tagModel
                               superView:(UIView *)superView{
    SCListCommodityTagsView *tagView =  [[self class]creatView];
    [superView addSubview:tagView];
    [superView addTagView:tagView];
    tagView.tagModel = tagModel;
    
    //add click
    UITapGestureRecognizer *tapClick =  superView.tagViewClickTapGestureRecognizer;
    if (!tapClick) {
        tapClick = [[UITapGestureRecognizer alloc]initWithTarget:nil
                                                          action:NULL];
        [superView setTagViewClickTapGestureRecognizer:tapClick];
        [superView addGestureRecognizer:tapClick];
    }
    [tapClick.rac_gestureSignal subscribeNext:^(UITapGestureRecognizer *ges) {
        ges.enabled = false;
        //animation
        if (tagView.show) {
            [tagView hiddenAnimationWithCompletionBlock:^{
                ges.enabled = true;
            }];
            tagView.isShowExpandAnimation = false;
        }else{
            [tagView showCircleContainerViewScaleAnimationWithcompletionBlock:NULL];
            [tagView showLineAnimationWithCompletionBlock:^{
                ges.enabled = true;
            }];
//            [tagView showCircleLayerRepeatScaleAnimation];
            tagView.isShowExpandAnimation = true;
        }
    }];
    return tagView;
}

-(void)setTagModel:(SCListCommodityTagsModel *)tagModel{
    
    if ([self.tagModel isEqual:tagModel]) {
        return;
    }
    _tagModel = tagModel;
    self.superViewSize = _tagModel.superviewSize;
    self.touchPoint = [_tagModel tagViewTouchPoint];
    self.showStyle = _tagModel.tagsDisplayStyle;
    self.showTexts = [_tagModel transformToTagsViewData];
}



- (BOOL)label:(PPLabel*)label didBeginTouch:(UITouch*)touch onCharacterAtIndex:(CFIndex)charIndex{
    
        //检查是否在点击区域里，如果在点击区域里，执行complete
        void(^CheckIfClick)(NSString * , dispatch_block_t ) = ^(NSString *text , dispatch_block_t  complete) {
            NSRange brandNameRange = [label.text rangeOfString:text];
            if (charIndex > brandNameRange.location &&
                charIndex < brandNameRange.location + brandNameRange.length) {
                complete();
            }
        };
        
        CheckIfClick(self.tagModel.brandName,^{
            self.tagViewDidSelectBrandCallBack && self.tagModel.brandId ? self.tagViewDidSelectBrandCallBack(self.tagModel.brandId) : nil;
        });
        
        CheckIfClick(self.tagModel.tradeName,^{
            self.tagViewDidSelectTradeCallBack && self.tagModel.tradeId  ? self.tagViewDidSelectTradeCallBack(self.tagModel.tradeId) : nil;
        });
    
        CheckIfClick(self.tagModel.commonTagTextDes,^{
            //点击普通标签
            self.tagViewDidSelectTextDesCallBack && self.tagModel.commonTagId ? self.tagViewDidSelectTextDesCallBack(self.tagModel.commonTagId) : nil;
        });
    
    return false;
}
- (BOOL)label:(PPLabel*)label didMoveTouch:(UITouch*)touch onCharacterAtIndex:(CFIndex)charIndex{
    return false;
}
- (BOOL)label:(PPLabel*)label didEndTouch:(UITouch*)touch onCharacterAtIndex:(CFIndex)charIndex{
    return false;
}
- (BOOL)label:(PPLabel*)label didCancelTouch:(UITouch*)touch{
    return false;
}
-(void)dealloc{
    
}


@end


@implementation SCListCommodityTagsView(Animation)

- (void)prepareCircleLayerRepeatScaleAnimation{
    self.circleLayer.hidden = false;
    @weakify(self)
    void(^next)(id x ) = ^(id x ) {
        //circle layer
        POPBasicAnimation *circleLayerfadeAni =
        circleLayerfadeAni = [SCUIAnimation basicAnimationWithPropertyName:kPOPLayerOpacity
                                                                 fromValue:@0.8
                                                                   toValue:@0
                                                                  duration:0.6
                                                                     delay:0
                                                           completionBlock:NULL];
        circleLayerfadeAni.repeatCount = 2;
        
        POPBasicAnimation *circleLayerScaleAni =
        circleLayerScaleAni = [SCUIAnimation basicAnimationWithPropertyName:kPOPLayerScaleXY
                                                                  fromValue:[NSValue valueWithCGPoint:CGPointMake(1, 1)]
                                                                    toValue:[NSValue valueWithCGPoint:CGPointMake(3.5, 3.5)]
                                                                   duration:0.6 delay:0
                                                            completionBlock:NULL];
        circleLayerScaleAni.repeatCount = 2;
        @strongify(self)
        [self.circleLayer pop_addAnimation:circleLayerfadeAni forKey:nil   ];
        [self.circleLayer pop_addAnimation:circleLayerScaleAni forKey:nil  ];

    };

    RACSignal *cancleSignal = [RACSignal merge:@[self.rac_willDeallocSignal,
                                                 [RACObserve(self, isShowExpandAnimation) filter:^BOOL(NSNumber* state) {
        return !state.boolValue;
    }]]].distinctUntilChanged;
    
    [[[RACObserve(self, isShowExpandAnimation).distinctUntilChanged
        ignore:@(false)]
        flattenMap:^RACStream *(id value) {
        return [[[RACSignal interval:3 onScheduler:[RACScheduler mainThreadScheduler]]
                  delay:0]
                 takeUntil:cancleSignal]
                ;
    }]subscribeNext:next];
    //first 
    next(nil);

}
-(void)showCircleLayerRepeatScaleAnimation{
    self.circleLayer.hidden = false;
    //circle layer
    POPBasicAnimation *circleLayerfadeAni =
    circleLayerfadeAni = [SCUIAnimation basicAnimationWithPropertyName:kPOPLayerOpacity
                                                             fromValue:@0.8
                                                               toValue:@0
                                                              duration:1
                                                                 delay:0
                                                       completionBlock:NULL];
    circleLayerfadeAni.repeatForever = true;
    
    POPBasicAnimation *circleLayerScaleAni =
    circleLayerScaleAni = [SCUIAnimation basicAnimationWithPropertyName:kPOPLayerScaleXY
                                                              fromValue:[NSValue valueWithCGPoint:CGPointMake(1, 1)]
                                                                toValue:[NSValue valueWithCGPoint:CGPointMake(3.5, 3.5)]
                                                               duration:1 delay:0
                                                        completionBlock:NULL];
    circleLayerScaleAni.repeatForever  = true;
    [self.circleLayer pop_addAnimation:circleLayerfadeAni forKey:nil   ];
    [self.circleLayer pop_addAnimation:circleLayerScaleAni forKey:nil  ];
}

- (void)showCircleContainerViewScaleAnimationWithcompletionBlock:(void (^)())completionBlock{
    
    self.circleContainerView.hidden = false;
    // scale
    POPBasicAnimation *scaleSpringAnimation =
    scaleSpringAnimation = [SCUIAnimation basicAnimationWithPropertyName:kPOPViewScaleXY
                                                               fromValue:nil
                                                                 toValue:[NSValue valueWithCGPoint:CGPointMake(1.5, 1.5)]
                                                                duration:0.15
                                                                   delay:0
                                                         completionBlock:NULL];
    
    
    
    //reset trans
    POPBasicAnimation *smallSpringAnimation =
    smallSpringAnimation =  [SCUIAnimation basicAnimationWithPropertyName:kPOPViewScaleXY
                                                                fromValue:nil
                                                                  toValue:[NSValue valueWithCGPoint:CGPointMake(1., 1.)]
                                                                 duration:0.15
                                                                    delay:0.15
                                                          completionBlock:^(POPAnimation *ani,BOOL finished){
                                                              completionBlock ? completionBlock() : nil;
                                                          }];
    
    [self.circleContainerView pop_addAnimation:scaleSpringAnimation forKey:nil];
    [self.circleContainerView pop_addAnimation:smallSpringAnimation forKey:nil];
}
- (void)showLineAnimationWithCompletionBlock:(void (^)(void))completionBlock {
    [self resetAnimations];
    
    self.brandNameLabel.hidden = true;
    self.priceCurrencyLabel.hidden = true;
    self.countyAddressLabel.hidden = true;
   
    self.brandNameLayer.hidden = false;
    self.priceCurrencyLayer.hidden = false;
    self.countyAddressLayer.hidden = false;
    self.circleLayer.hidden = false;
    self.circleContainerView.hidden = false;
  @weakify(self)
    [self showStrokeEndAnimationWithLayer:self.brandNameLayer
                      completionBlock:^(POPAnimation *anim, BOOL finished) {
                          @strongify(self)
                          self.brandNameLabel.hidden = false;
                          self.priceCurrencyLabel.hidden = false;
                          self.countyAddressLabel.hidden = false;
                          self.show = true;
                          completionBlock ? completionBlock() : nil;
                      }];
    [self showStrokeEndAnimationWithLayer:self.priceCurrencyLayer
                      completionBlock:NULL];
    [self showStrokeEndAnimationWithLayer:self.countyAddressLayer completionBlock:NULL];
}

- (void)hiddenAnimationWithCompletionBlock:(void (^)(void))completionBlock{
    [self resetAnimations];
    
    self.brandNameLabel.hidden = true;
    self.priceCurrencyLabel.hidden = true;
    self.countyAddressLabel.hidden = true;
    self.circleLayer.hidden = true;
    
    @weakify(self)
    [self showCircleContainerViewScaleAnimationWithcompletionBlock:^{
        @strongify(self)
        self.circleContainerView.hidden = true;
    }];
    [self hiddenStrokeEndAnimationWithLayer:self.brandNameLayer completionBlock:^(POPAnimation *anim, BOOL finished) {
        @strongify(self)
        self.brandNameLayer.hidden = true;
        self.priceCurrencyLayer.hidden = true;
        self.countyAddressLayer.hidden = true;
        self.show = false;
        completionBlock ? completionBlock() : nil;
    }];
    [self hiddenStrokeEndAnimationWithLayer:self.priceCurrencyLayer completionBlock:NULL];
    [self hiddenStrokeEndAnimationWithLayer:self.countyAddressLayer completionBlock:NULL];
}


- (CAMediaTimingFunction *)easeOutTimingFunction{
    return [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
}

- (void)showStrokeEndAnimationWithLayer:(CAShapeLayer *)layer
                    completionBlock:(void (^)(POPAnimation *anim, BOOL finished))completionBlock{
    
    
    POPBasicAnimation *brandStrokeEndAni = [SCUIAnimation basicAnimationWithPropertyName:kPOPShapeLayerStrokeEnd
                                                                               fromValue:@0
                                                                                 toValue:layer.segmentPoint
                                                                                duration:0.1
                                                                                   delay:0.3
                                                                         completionBlock:NULL];
    POPBasicAnimation *brandStrokeEndAni2 =  [SCUIAnimation basicAnimationWithPropertyName:kPOPShapeLayerStrokeEnd
                                                                                 fromValue:layer.segmentPoint
                                                                                   toValue:@1
                                                                                  duration:0.1
                                                                                     delay:0.3 + 0.1 + delay
                                                                           completionBlock:completionBlock];
    
    [layer pop_addAnimation:brandStrokeEndAni forKey:nil];
    [layer pop_addAnimation:brandStrokeEndAni2 forKey:nil];
}

- (void)hiddenStrokeEndAnimationWithLayer:(CAShapeLayer *)layer
                          completionBlock:(void (^)(POPAnimation *anim, BOOL finished))completionBlock{
    
    POPBasicAnimation *brandStrokeEndAni = [SCUIAnimation basicAnimationWithPropertyName:kPOPShapeLayerStrokeEnd
                                                                               fromValue:@1
                                                                                 toValue:layer.segmentPoint
                                                                                duration:0.06
                                                                                   delay:0.3
                                                                         completionBlock:NULL];
    POPBasicAnimation *brandStrokeEndAni2 =  [SCUIAnimation basicAnimationWithPropertyName:kPOPShapeLayerStrokeEnd
                                                                                 fromValue:layer.segmentPoint
                                                                                   toValue:@0
                                                                                  duration:0.06
                                                                                     delay:0.3 + 0.06 + delay
                                                                           completionBlock:completionBlock];
    
    [layer pop_addAnimation:brandStrokeEndAni forKey:nil];
    [layer pop_addAnimation:brandStrokeEndAni2 forKey:nil];
}

@end


@implementation UIView(TagView)
-(void)setTagViews:(NSArray<SCListCommodityTagsView *> *)tagViews{
     objc_setAssociatedObject(self, &kTagsViewKey, tagViews, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSArray<SCListCommodityTagsView *> *)tagViews{
    NSArray<SCListCommodityTagsView *> *tagViews = objc_getAssociatedObject(self, &kTagsViewKey);
    if (tagViews) {
        return tagViews;
    }
    tagViews = [NSArray array];
    objc_setAssociatedObject(self, &kTagsViewKey, tagViews, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return tagViews;
}
-(void)resetTagViews{
    self.tagViews = [NSArray array];
}

- (void)addTagView:(SCListCommodityTagsView *)tagView{
    NSMutableArray *array = [NSMutableArray arrayWithArray:[self tagViews]];
    [array addObject:tagView];
    self.tagViews = [array copy];
}
- (void)removeTagView:(SCListCommodityTagsView *)tagView{
    NSMutableArray<SCListCommodityTagsView *> *tagsView = [NSMutableArray arrayWithArray:[self tagViews]];
    if ([tagsView containsObject:tagView]) {
        [tagsView removeObject:tagView];
        self.tagViews = [tagsView copy];
    }
}

- (UITapGestureRecognizer *)tagViewClickTapGestureRecognizer{
    return objc_getAssociatedObject(self, &kTapGestureRecognizerKey);
}
-(void)setTagViewClickTapGestureRecognizer:(UITapGestureRecognizer *)tagViewClickTapGestureRecognizer{
    objc_setAssociatedObject(self, &kTapGestureRecognizerKey, tagViewClickTapGestureRecognizer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end