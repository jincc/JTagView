//
//  SCCommodityTagsView.m
//  Module
//
//  Created by junlongj on 16/1/22.
//  Copyright © 2016年 junlongj. All rights reserved.
//

#import "SCCommodityTagsBaseView.h"
#import "SCCommodityTagsView.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <pop/POP.h>
#import <objc/runtime.h>
static CGFloat const kCircleWidth = 14.f;
static CGFloat const kOffsetY = 30.f;//3行时上下间距
static CGFloat const kOffsetY2 = 40.f;//2行时上下间距
static CGFloat const kBeyondWidthOffset = 8.f; //line 与 text之间的offset
static CGFloat const kLineBeyondLabelWidthOffset = 5.f;
static CGFloat const kLabelHeight = 30.f;
static CGFloat const kLayerLineWidth = .8f;
static NSInteger const kCircleContainerViewLeftRightMargin = 15.f;

static CGFloat const kPriceSizeMaxLength = 100.f;

@interface SCCommodityTagsBaseView()
{
    CGSize _circleSize;
    UIFont *_labelFont;
    UIColor *_labelColor;
    UIColor *_shaderColor;
    
    CGSize _branchSize;
    CGSize _priceSize;
    CGSize _countrySize;
}
//外层放大
@property (nonatomic  ,strong) CALayer *circleLayer;
//里层小白点
@property (nonatomic  ,strong) UIImageView  *circleContainerView;

//绘制label下面的line路径
@property (nonatomic  ,strong) CAShapeLayer *brandNameLayer;
@property (nonatomic  ,strong) CAShapeLayer *priceCurrencyLayer;
@property (nonatomic  ,strong) CAShapeLayer *countyAddressLayer;

@property (nonatomic  ,strong) SCStrokeLabel *brandNameLabel;
@property (nonatomic  ,strong) SCStrokeLabel *priceCurrencyLabel;
@property (nonatomic  ,strong) SCStrokeLabel *countyAddressLabel;

/**
 *  几行label，用来限制showStyle的切换样式
 */
@property (nonatomic  ,assign,readwrite) NSInteger lineCount;
@end


@implementation SCCommodityTagsBaseView
+ (instancetype)creatView{
    return [[[self class] alloc]initWithFrame:CGRectZero];
}

- (instancetype)init{
    self = [self initWithFrame:CGRectZero];
    if (self){}
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
        [self setup];
    }
    return self;
}

- (void)initialization{
    _circleSize  = CGSizeMake(kCircleWidth, kCircleWidth);
    _labelFont = [UIFont systemFontOfSize:13];
    _labelColor = [UIColor whiteColor];
    _shaderColor = [[UIColor blackColor]colorWithAlphaComponent:.6];
}

- (void)setup{

    //addsubviews
    self.circleLayer.hidden = true;
    [self.layer addSublayer:self.circleLayer];
    [self.layer addSublayer:self.brandNameLayer];
    [self.layer addSublayer:self.priceCurrencyLayer];
    [self.layer addSublayer:self.countyAddressLayer];

    
    [self addSubview:self.priceCurrencyLabel];
    [self addSubview:self.countyAddressLabel];
    [self addSubview:self.circleContainerView];
    [self addSubview:self.brandNameLabel];
}


#pragma make - Getter

-(CALayer *)circleLayer{
    if (!_circleLayer) {
        _circleLayer = [CALayer layer];
        _circleLayer.backgroundColor = [UIColor whiteColor].CGColor;
        _circleLayer.position = CGPointMake(_circleSize.width / 2, _circleSize.height / 2);
        _circleLayer.bounds = CGRectMake(0, 0, _circleSize.width, _circleSize.height);
        _circleLayer.cornerRadius = _circleSize.width / 2.;
    }
    return _circleLayer;
}

-(UIImageView *)circleContainerView{
    if (!_circleContainerView) {
        _circleContainerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _circleSize.width, _circleSize.height)];
        _circleContainerView.image = [UIImage imageNamed:@"tagShowPoint"];
        
    }
    return _circleContainerView;
}

-(CAShapeLayer *)brandNameLayer{
    if (!_brandNameLayer) {
        _brandNameLayer = [CAShapeLayer new];
        _brandNameLayer.fillColor = nil;
        _brandNameLayer.strokeColor = [[UIColor whiteColor]CGColor];
        _brandNameLayer.lineWidth = kLayerLineWidth;
        _brandNameLayer.lineCap = kCALineCapSquare;
        _brandNameLayer.lineJoin = kCALineJoinRound;

    }
    return _brandNameLayer;
}
-(CAShapeLayer *)priceCurrencyLayer{
    if (!_priceCurrencyLayer) {
        _priceCurrencyLayer = [CAShapeLayer new];
        _priceCurrencyLayer.fillColor = nil;
        _priceCurrencyLayer.strokeColor = [[UIColor whiteColor]CGColor];
        _priceCurrencyLayer.lineWidth = kLayerLineWidth;
        _priceCurrencyLayer.lineCap = kCALineCapSquare;
        _priceCurrencyLayer.lineJoin = kCALineJoinRound;
    }
    return _priceCurrencyLayer;
}
-(CAShapeLayer *)countyAddressLayer{
    if (!_countyAddressLayer) {
        _countyAddressLayer = [CAShapeLayer new];
        _countyAddressLayer.fillColor = nil;
        _countyAddressLayer.strokeColor = [[UIColor whiteColor]CGColor];
        _countyAddressLayer.lineWidth = kLayerLineWidth;
        _countyAddressLayer.lineCap = kCALineCapSquare;
        _countyAddressLayer.lineJoin = kCALineJoinRound;

        
    }
    return _countyAddressLayer;
}

-(SCStrokeLabel *)brandNameLabel{
    if (!_brandNameLabel) {
        _brandNameLabel = [[SCStrokeLabel alloc]initWithFrame:CGRectZero];
        _brandNameLabel.font = _labelFont;
        _brandNameLabel.textColor = _labelColor;
        _brandNameLabel.delegate = self;
        _brandNameLabel.glowColor = _shaderColor;
        _brandNameLabel.innerGlowColor = _shaderColor;
        _brandNameLabel.glowSize = 1;
    }
    return _brandNameLabel;
}
-(SCStrokeLabel *)priceCurrencyLabel{
    if (!_priceCurrencyLabel) {
        _priceCurrencyLabel = [[SCStrokeLabel alloc]initWithFrame:CGRectZero];
        _priceCurrencyLabel.font = _labelFont;
        _priceCurrencyLabel.textColor = _labelColor;
        _priceCurrencyLabel.layer.shadowColor = UIColorFromRGB(0xDFDFDF).CGColor;
        _priceCurrencyLabel.layer.shadowOffset = CGSizeMake(1, 1);
        _priceCurrencyLabel.delegate = self;
        _priceCurrencyLabel.glowColor = _shaderColor;
        _priceCurrencyLabel.innerGlowColor = _shaderColor;
        _priceCurrencyLabel.glowSize = 1;
    }
    return _priceCurrencyLabel;
}
-(SCStrokeLabel *)countyAddressLabel{
    if (!_countyAddressLabel) {
        _countyAddressLabel = [[SCStrokeLabel alloc]initWithFrame:CGRectZero];
        _countyAddressLabel.font = _labelFont;
        _countyAddressLabel.textColor = _labelColor;
        _countyAddressLabel.layer.shadowColor = UIColorFromRGB(0xDFDFDF).CGColor;
        _countyAddressLabel.layer.shadowOffset = CGSizeMake(1, 1);
        _countyAddressLabel.delegate = self;
        _countyAddressLabel.glowColor = _shaderColor;
        _countyAddressLabel.innerGlowColor = _shaderColor;
        _countyAddressLabel.glowSize = 1;
    }
    return _countyAddressLabel;
}


#pragma mark - Public
-(void)setShowTexts:(NSArray<NSString *> *)showTexts{
    if (showTexts.count != 3 ) {
        return;
    }
    NSString *first = showTexts[0];
    NSString *second = showTexts[1];
    NSString *third = showTexts[2];
    //排序
    _lineCount = (first.length != 0) +
                            (second.length != 0) +
                            (third.length != 0);
    //如果只有1行label，数组中间保留值
    if (_lineCount == 1) {
        NSString *middleLineText;
        for (NSString *str in showTexts) {
            if (str.length) {
                middleLineText = str;
                break;
            }
        }
        showTexts = @[@"",
                      middleLineText,
                      @""];
    }else if (_lineCount == 2){
        //如果有2行label，数组中间置为空
        if (!first.length) {
            showTexts = @[second,
                          @"",
                          third];
        }else{
            showTexts = @[first,
                          @"",
                          second.length ? second : third];
        }
        if (self.showStyle != SCCommodityTagsViewShowStyleRightLeft &&
            self.showStyle != SCCommodityTagsViewShowStyleLeftRight) {
            self.showStyle = SCCommodityTagsViewShowStyleRightLeft;
        }
    }
    _showTexts = showTexts;
    _brandNameLabel.text = _showTexts[0];
    _priceCurrencyLabel.text = _showTexts[1];
    _countyAddressLabel.text = _showTexts[2];

    _branchSize = [self boundingRectWithText:_brandNameLabel.text ];
    _priceSize  = [self boundingRectWithText:_priceCurrencyLabel.text ];
    _countrySize = [self boundingRectWithText:_countyAddressLabel.text ];
    
    [self layoutFrames];
    [self layoutLayerPaths];
    [self lineAddShades];

}

- (void)adjustLabelsWidth{

    if (self.showStyle == SCCommodityTagsViewShowStyleAllLeft ||
        self.showStyle == SCCommodityTagsViewShowStyleAllRight) {
            CGFloat maxWidth = self.superViewSize.width -  kBeyondWidthOffset  - kLineBeyondLabelWidthOffset  - kCircleContainerViewLeftRightMargin - kCircleWidth/2.;

            if (_branchSize.width > maxWidth) {
                _branchSize.width = maxWidth;
            }
            if (_priceSize.width > maxWidth) {
                _priceSize.width = maxWidth;
            }
            if (_countrySize.width > maxWidth) {
                _countrySize.width = maxWidth;
            }
    }else{
        if (_lineCount == 3) {
            if (_priceSize.width > kPriceSizeMaxLength) {
                _priceSize.width = kPriceSizeMaxLength;
            }
            CGFloat maxWidth = self.superViewSize.width -  kBeyondWidthOffset * 2  - kLineBeyondLabelWidthOffset  * 2 - _priceSize.width - kOffsetY2 - kCircleContainerViewLeftRightMargin;
            if (_branchSize.width > maxWidth) {
                _branchSize.width = maxWidth;
            }
            if (_countrySize.width > maxWidth) {
                _countrySize.width = maxWidth;
            }
        }else if (_lineCount == 2){
           CGFloat maxWidth = self.superViewSize.width -  kBeyondWidthOffset   - kLineBeyondLabelWidthOffset  - kCircleWidth/2. - kOffsetY2/2.  - kCircleContainerViewLeftRightMargin ;
            if (_branchSize.width > maxWidth) {
                _branchSize.width = maxWidth;
            }
            if (_priceSize.width > maxWidth) {
                _priceSize.width = maxWidth;
            }
            if (_countrySize.width > maxWidth) {
                _countrySize.width = maxWidth;
            }
        }
    }
    
}
- (void)layoutFrames{
    
    [self adjustLabelsWidth];
    CGRect rect;
    rect.origin = CGPointZero;
    CGFloat  offsetY =  -4;
    CGPoint originPoint;
    CGFloat superViewHeight = [self calculateViewHeight];
    CGFloat superViewWidth;
    switch (self.showStyle) {
        case SCCommodityTagsViewShowStyleAllRight:
        {
        
            _priceCurrencyLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            _brandNameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            _countyAddressLabel.lineBreakMode = NSLineBreakByTruncatingTail;

            superViewWidth = MAX(MAX(_branchSize.width ,_priceSize.width), _countrySize.width) + kBeyondWidthOffset + kLineBeyondLabelWidthOffset + kCircleContainerViewLeftRightMargin;
            if (_lineCount == 3) {
                 self.frame = CGRectMake(self.touchPoint.x - kCircleContainerViewLeftRightMargin , self.touchPoint.y - kOffsetY - kLabelHeight , superViewWidth , superViewHeight);
                 self.circleContainerView.center = CGPointMake(kCircleContainerViewLeftRightMargin,superViewHeight - kOffsetY);
            }else{
                 self.frame = CGRectMake(self.touchPoint.x - kCircleContainerViewLeftRightMargin , self.touchPoint.y  - kLabelHeight , superViewWidth , superViewHeight);
                 self.circleContainerView.center = CGPointMake(kCircleContainerViewLeftRightMargin,superViewHeight -kCircleWidth / 2);
            }
            //labels frame
            originPoint = self.circleContainerView.center;
            
            originPoint.x = originPoint.x + kBeyondWidthOffset;
            originPoint.y = originPoint.y - offsetY - kLabelHeight;
            
            rect.size = _priceSize;
            rect.origin = originPoint;
            _priceCurrencyLabel.frame = rect;
            
            
            rect.size = _branchSize;
            rect.origin = CGPointMake(originPoint.x, originPoint.y - kOffsetY);
            _brandNameLabel.frame = rect;
            
            rect.size = _countrySize;
            rect.origin = CGPointMake(originPoint.x, originPoint .y + kOffsetY);
            _countyAddressLabel.frame = rect;

            
        }
            break;
        case SCCommodityTagsViewShowStyleAllLeft:
        {
            _priceCurrencyLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
            _brandNameLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
            _countyAddressLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
            
            
            CGFloat const lMargin = kCircleContainerViewLeftRightMargin;

            superViewWidth = MAX(MAX(_branchSize.width ,_priceSize.width), _countrySize.width) +  kBeyondWidthOffset + kLineBeyondLabelWidthOffset + lMargin;
         
            
            if (_lineCount == 3) {
                self.frame = CGRectMake(self.touchPoint.x  - superViewWidth + lMargin, self.touchPoint.y - kOffsetY - kLabelHeight , superViewWidth, superViewHeight);
                self.circleContainerView.center = CGPointMake(superViewWidth - lMargin,superViewHeight - kOffsetY);
            }else{
                self.frame = CGRectMake(self.touchPoint.x  - superViewWidth + lMargin, self.touchPoint.y  - kLabelHeight , superViewWidth, superViewHeight);
                self.circleContainerView.center = CGPointMake(superViewWidth - lMargin,superViewHeight - kCircleWidth / 2);
            }

            //labels frame
            originPoint = self.circleContainerView.center;
            
            rect.size = _priceSize;
            rect.origin = CGPointMake(originPoint.x - kBeyondWidthOffset - _priceSize.width, originPoint.y - offsetY - kLabelHeight);
            _priceCurrencyLabel.frame = rect;
            
            
            rect.size = _branchSize;
            rect.origin = CGPointMake(originPoint.x - kBeyondWidthOffset - _branchSize.width, _priceCurrencyLabel.frame.origin.y - kOffsetY);
            _brandNameLabel.frame = rect;
            
            rect.size = _countrySize;
            rect.origin = CGPointMake(originPoint.x - kBeyondWidthOffset - _countrySize.width, _priceCurrencyLabel.frame.origin.y + kOffsetY);
            _countyAddressLabel.frame = rect;
            
            
        }
            break;
        case SCCommodityTagsViewShowStyleRightLeft:
            
        {
            _priceCurrencyLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            _brandNameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            _countyAddressLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            
            CGFloat originX;
            
            if (_lineCount == 3) {
                superViewWidth = kLineBeyondLabelWidthOffset*2 + kOffsetY2 + kBeyondWidthOffset*2 + _priceSize.width + MAX(_branchSize.width, _countrySize.width);
                originX = ( kOffsetY2 / 2. + kBeyondWidthOffset + _priceSize.width + kLineBeyondLabelWidthOffset);
            }else{
                
                superViewWidth = kLineBeyondLabelWidthOffset + kOffsetY2/2 + kBeyondWidthOffset + MAX(_branchSize.width, _countrySize.width) + kCircleWidth /2.;
                originX = kCircleWidth/2.;
                
            }
        
            CGFloat offsetXFromTOuchPoint = self.touchPoint.x - originX;
            self.frame = CGRectMake(offsetXFromTOuchPoint, self.touchPoint.y - (superViewHeight - kOffsetY2/2.) , superViewWidth, superViewHeight);
            
            self.circleContainerView.center = CGPointMake(originX,superViewHeight - kOffsetY2 / 2. );
         
            
            //labels frame
            originPoint = self.circleContainerView.center;
            
   
            
            
            rect.size = _branchSize;
            rect.origin = CGPointMake(originPoint.x + kOffsetY2 / 2.0 + kBeyondWidthOffset , originPoint.y - offsetY - kOffsetY2 / 2.0 - kLabelHeight);
            _brandNameLabel.frame = rect;
            
            rect.size = _countrySize;
            rect.origin = CGPointMake(CGRectGetMinX(_brandNameLabel.frame) ,
                                      CGRectGetMinY(_brandNameLabel.frame) + kOffsetY2);
            _countyAddressLabel.frame = rect;
            
            
            rect.size = _priceSize;
            rect.origin = CGPointMake(originPoint.x - kOffsetY2 / 2.0 - kBeyondWidthOffset - _priceSize.width,CGRectGetMinY(_countyAddressLabel.frame));
            _priceCurrencyLabel.frame = rect;
            
            
        }
            
            break;
        case SCCommodityTagsViewShowStyleLeftRight:
        {
            _priceCurrencyLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
            _brandNameLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
            _countyAddressLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
            CGFloat originX;
            if (_lineCount == 3) {
                superViewWidth = kLineBeyondLabelWidthOffset*2 + kOffsetY2 + kBeyondWidthOffset*2 + _priceSize.width + MAX(_branchSize.width, _countrySize.width);
                originX =  kOffsetY2 / 2. + kBeyondWidthOffset + MAX(_branchSize.width, _countrySize.width) + kLineBeyondLabelWidthOffset;
            }else{
                
                superViewWidth = kLineBeyondLabelWidthOffset + kOffsetY2/2 + kBeyondWidthOffset + MAX(_branchSize.width, _countrySize.width) + kCircleWidth /2.;
                originX =  superViewWidth - kCircleWidth/2.;
            }
            
            CGFloat offsetXFromTOuchPoint = self.touchPoint.x - originX;
            
            self.frame = CGRectMake(offsetXFromTOuchPoint, self.touchPoint.y - (superViewHeight - kOffsetY2/2.) , superViewWidth, superViewHeight);
            
            self.circleContainerView.center = CGPointMake(originX,superViewHeight - kOffsetY2/2.);
            //labels frame
            originPoint = self.circleContainerView.center;
            
            rect.size = _branchSize;
            rect.origin = CGPointMake(originPoint.x - kOffsetY2 / 2.0 - kBeyondWidthOffset - _branchSize.width , originPoint.y - offsetY - kOffsetY2 / 2.0 - kLabelHeight);
            _brandNameLabel.frame = rect;
            
            rect.size = _priceSize;
            rect.origin = CGPointMake(originPoint.x + kOffsetY2 / 2.0 + kBeyondWidthOffset, CGRectGetMinY(_brandNameLabel.frame) + kOffsetY2);
            _priceCurrencyLabel.frame = rect;
            
            rect.size = _countrySize;
            rect.origin = CGPointMake(originPoint.x - kOffsetY2 / 2.0 - kBeyondWidthOffset - _countrySize.width , CGRectGetMinY(_brandNameLabel.frame) + kOffsetY2);
            _countyAddressLabel.frame = rect;
        

        }
            break;
            
        default:
            break;
    }
    
    
    [CATransaction begin];
    [CATransaction setDisableActions:true];
    self.circleLayer.position = self.circleContainerView.center;
    [CATransaction commit];
    
    
}

- (UIBezierPath *)calculateLineShadePathWithOriginPoint:(CGPoint)origin
                                   endPoint:(CGPoint)end{
    UIBezierPath *path = [UIBezierPath bezierPath];
    if (origin.x == end.x) {
        [path moveToPoint:CGPointMake(origin.x, origin.y - kLayerLineWidth/2.)];
        [path addLineToPoint:CGPointMake(end.x, end.y - kLayerLineWidth /2. )];
        [path addLineToPoint:CGPointMake(end.x, end.y + kLayerLineWidth /2. )];
        [path addLineToPoint:CGPointMake(origin.x, origin.y + kLayerLineWidth /2. )];
        [path fill];
    }else if (origin.y == end.y){
        [path moveToPoint:CGPointMake(origin.x -  kLayerLineWidth/2., origin.y )];
        [path addLineToPoint:CGPointMake(end.x -  kLayerLineWidth/2., end.y )];
        [path addLineToPoint:CGPointMake(end.x +  kLayerLineWidth/2., end.y )];
        [path addLineToPoint:CGPointMake(origin.x +  kLayerLineWidth/2., origin.y  )];
        [path fill];
    }else{
        
    }
    return path;
}
- (CGFloat)calculateViewHeight{
    CGFloat height;
    if (self.showStyle == SCCommodityTagsViewShowStyleAllRight ||
        self.showStyle == SCCommodityTagsViewShowStyleAllLeft) {
        //根据内容
        if (_lineCount == 3) {
            height  = kOffsetY * 2  +  kLabelHeight;
        }else{
            height  =  kLabelHeight;
        }
    }else{
         height  = kOffsetY2 + kLabelHeight;
    }
    return height;
}

#pragma mark - Helper
- (void)lineAddShades{
    if (_showTexts[0].length) {
        [self addShadeWithLayer:_brandNameLayer];
    }
    if (_showTexts[1].length) {
        [self addShadeWithLayer:_priceCurrencyLayer];
    }
    if (_showTexts[2].length) {
        [self addShadeWithLayer:_countyAddressLayer];
    }
    self.layer.shouldRasterize = YES;
    // Don't forget the rasterization scale
    // I spent days trying to figure out why retina display assets weren't working as expected
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

- (void)addShadeWithLayer:(CAShapeLayer *)layer{
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOpacity = 0.6;
    layer.shadowRadius = 1;
    layer.shadowOffset = CGSizeMake(0, 0.5);
//    UIBezierPath *path =  [UIBezierPath bezierPathWithRect:CGRectInset(layer.bounds, -1, 0)] ;
//    UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:layer.path];
//    path.usesEvenOddFillRule = true;
//    [path applyTransform:CGAffineTransformMakeScale(1.1, 1.1)];
//    layer.shadowPath =  path.CGPath;
//    layer.masksToBounds = false;
  
}

- (CGSize )boundingRectWithText:(NSString *)text{
    CGSize size =  [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, kLabelHeight)
                                                   options:
                        NSStringDrawingTruncatesLastVisibleLine |
                        NSStringDrawingUsesLineFragmentOrigin |
                        NSStringDrawingUsesFontLeading
                                                attributes:@{NSFontAttributeName: _labelFont}
                                                   context:nil].size;

    return CGSizeMake(ceil(size.width),kLabelHeight);
}

- (void)layoutLayerPaths {

    
    SCTwoSegmentPath *segmentPath,*segmentPath2,*segmentPath3;
    CGPoint point = CGPointMake(ceil(self.circleContainerView.center.x),
                                ceil(self.circleContainerView.center.y));
    
    CGFloat branchNameWidth = ceil(self.brandNameLabel.bounds.size.width);
    CGFloat priceWidth = ceil(self.priceCurrencyLabel.bounds.size.width);
    CGFloat countryWidth = ceil(self.countyAddressLabel.bounds.size.width);
    //x多出的部分
    CGFloat offsetX3 = ceil(kBeyondWidthOffset + kLineBeyondLabelWidthOffset);
    CGFloat halfOffsetY2 = ceil(kOffsetY2 / 2.);
    switch (self.showStyle) {
        case SCCommodityTagsViewShowStyleAllRight:
            
        {
            segmentPath = [SCTwoSegmentPath pathWithFirstPoint:point
                                                   middlePoint:CGPointMake(point.x,
                                                                           point.y - kOffsetY)
                                                      endPoint:CGPointMake(point.x +  branchNameWidth  + offsetX3,
                                                                           point.y - kOffsetY)];
            
            segmentPath2 = [SCTwoSegmentPath pathWithFirstPoint:point
                                                    middlePoint:CGPointMake(point.x + kOffsetY,
                                                                            point.y)
                                                       endPoint:CGPointMake(point.x  + priceWidth + offsetX3,
                                                                            point.y)];
            segmentPath3 = [SCTwoSegmentPath pathWithFirstPoint:point
                                                    middlePoint:CGPointMake(point.x,
                                                                            point.y + kOffsetY)
                                                       endPoint:CGPointMake(point.x + countryWidth + offsetX3,
                                                                            point.y + kOffsetY)];
        }
            
            break;
        case SCCommodityTagsViewShowStyleAllLeft:
        {
            segmentPath = [SCTwoSegmentPath pathWithFirstPoint:point
                                                   middlePoint:CGPointMake(point.x,
                                                                           point.y - kOffsetY)
                                                      endPoint:CGPointMake(point.x - offsetX3 - branchNameWidth , point.y - kOffsetY)];
            segmentPath2 = [SCTwoSegmentPath pathWithFirstPoint:point
                                                    middlePoint:CGPointMake(point.x - kOffsetY ,
                                                                            point.y)
                                                       endPoint:CGPointMake(point.x - offsetX3 - priceWidth ,
                                                                            point.y)];
            
            segmentPath3 = [SCTwoSegmentPath pathWithFirstPoint:point
                                                    middlePoint:CGPointMake(point.x,
                                                                            point.y + kOffsetY)
                                                       endPoint:CGPointMake(point.x - offsetX3 - countryWidth  ,
                                                                            point.y + kOffsetY)];
        }
            
            break;
        case SCCommodityTagsViewShowStyleRightLeft:
        {
            segmentPath = [SCTwoSegmentPath pathWithFirstPoint:point
                                                   middlePoint:CGPointMake(point.x + halfOffsetY2,
                                                                           point.y - halfOffsetY2)
                                                      endPoint:CGPointMake(point.x + halfOffsetY2  + branchNameWidth + offsetX3,
                                                                           point.y - halfOffsetY2)];
            segmentPath2 = [SCTwoSegmentPath pathWithFirstPoint:point
                                                    middlePoint:CGPointMake(point.x - halfOffsetY2,
                                                                            point.y + halfOffsetY2)
                                                       endPoint:CGPointMake(point.x - halfOffsetY2  - priceWidth - offsetX3,
                                                                            point.y + halfOffsetY2)];
            
            segmentPath3 = [SCTwoSegmentPath pathWithFirstPoint:point
                                                    middlePoint:CGPointMake(point.x + halfOffsetY2,
                                                                            point.y + halfOffsetY2)
                                                       endPoint:CGPointMake(point.x + halfOffsetY2 + offsetX3 + countryWidth ,
                                                                            point.y + halfOffsetY2)];
        }
            break;
        case SCCommodityTagsViewShowStyleLeftRight:
        {
            segmentPath = [SCTwoSegmentPath pathWithFirstPoint:point
                                                   middlePoint:CGPointMake(point.x - halfOffsetY2,
                                                                           point.y - halfOffsetY2)
                                                      endPoint:CGPointMake(point.x - halfOffsetY2 - offsetX3 - branchNameWidth ,
                                                                           point.y - halfOffsetY2)];
            segmentPath2 = [SCTwoSegmentPath pathWithFirstPoint:point
                                                    middlePoint:CGPointMake(point.x + halfOffsetY2,
                                                                            point.y + halfOffsetY2)
                                                       endPoint:CGPointMake(point.x + halfOffsetY2 + offsetX3 + priceWidth ,
                                                                            point.y + halfOffsetY2)];
            
            segmentPath3 = [SCTwoSegmentPath pathWithFirstPoint:point
                                                    middlePoint:CGPointMake(point.x - halfOffsetY2,
                                                                            point.y + halfOffsetY2)
                                                       endPoint:CGPointMake(point.x - halfOffsetY2 - offsetX3 - countryWidth,
                                                                            point.y + halfOffsetY2)];
            
            
        }
            break;
            
        default:
            break;
    }
    
    self.brandNameLayer.path = [segmentPath drawPath].CGPath;
    self.priceCurrencyLayer.path = [segmentPath2 drawPath].CGPath;
    self.countyAddressLayer.path = [segmentPath3 drawPath].CGPath;
    self.brandNameLayer.segmentPoint = [segmentPath calculateSegmentPoint];
    self.priceCurrencyLayer.segmentPoint = [segmentPath2 calculateSegmentPoint];
    self.countyAddressLayer.segmentPoint = [segmentPath3 calculateSegmentPoint];

    if (!_showTexts[0].length) {
        self.brandNameLayer.path = nil;
    }
    
    if (!_showTexts[1].length) {
        self.priceCurrencyLayer.path = nil;
    }
    if (!_showTexts[2].length) {
        self.countyAddressLayer.path = nil;
    }
}

/**
 *  利用CGGlyph，将字符图形转换成CGPath
 */
- (void)drawTextLayerPath{

    for (NSString *text in _showTexts) {
        
        CGMutablePathRef letters = CGPathCreateMutable();
        
        CTFontRef font = CTFontCreateWithName(CFSTR("HSFUIText-Regular"), 12.0f, NULL);
        NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                               (__bridge id)font, kCTFontAttributeName,
                               nil];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:text
                                                                         attributes:attrs];
        CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)attrString);
        CFArrayRef runArray = CTLineGetGlyphRuns(line);
        
        // for each RUN
        for (CFIndex runIndex = 0; runIndex < CFArrayGetCount(runArray); runIndex++)
        {
            // Get FONT for this run
            CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runArray, runIndex);
            CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);
            
            // for each GLYPH in run
            for (CFIndex runGlyphIndex = 0; runGlyphIndex < CTRunGetGlyphCount(run); runGlyphIndex++)
            {
                // get Glyph & Glyph-data
                CFRange thisGlyphRange = CFRangeMake(runGlyphIndex, 1);
                CGGlyph glyph;
                CGPoint position;
                CTRunGetGlyphs(run, thisGlyphRange, &glyph);
                CTRunGetPositions(run, thisGlyphRange, &position);
                
                // Get PATH of outline
                {
                    CGPathRef letter = CTFontCreatePathForGlyph(runFont, glyph, NULL);
                    CGAffineTransform t = CGAffineTransformMakeTranslation(position.x, position.y);
                    CGPathAddPath(letters, &t, letter);
                    CGPathRelease(letter);
                }
            }
        }
        CFRelease(line);
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointZero];
        [path appendPath:[UIBezierPath bezierPathWithCGPath:letters]];
    }
    
}
@end

@implementation SCCommodityTagsBaseView(Animation)

-(void)resetAnimations{

        [self.circleLayer pop_removeAllAnimations];
        [self.brandNameLayer pop_removeAllAnimations];
        [self.priceCurrencyLayer pop_removeAllAnimations];
        [self.countyAddressLayer pop_removeAllAnimations];
        [self.brandNameLabel pop_removeAllAnimations];
        [self.priceCurrencyLabel pop_removeAllAnimations];
        [self.countyAddressLabel pop_removeAllAnimations];
    
}

@end


@implementation CAShapeLayer(TwoSegment)
static const char* kSegmentPointKey = "kSegmentPointKey";
-(NSNumber *)segmentPoint{
    return objc_getAssociatedObject(self, kSegmentPointKey);
}
-(void)setSegmentPoint:(NSNumber *)segmentPoint{
    objc_setAssociatedObject(self, kSegmentPointKey, segmentPoint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end


@interface SCTwoSegmentPath()

@property (nonatomic , strong) NSNumberFormatter *formatter;
@end
@implementation SCTwoSegmentPath

+(instancetype)pathWithFirstPoint:(CGPoint)startPoint
                      middlePoint:(CGPoint)middlePoint
                         endPoint:(CGPoint)endPoint{
    
    SCTwoSegmentPath *path = [[SCTwoSegmentPath alloc]init];
    path.startPoint = startPoint;
    path.middlePoint = middlePoint;
    path.endPoint = endPoint;
    
    return path;
}

- (UIBezierPath *)drawPath{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:self.startPoint];
    [path addLineToPoint:self.middlePoint];
    [path addLineToPoint:self.endPoint];
    return path;
}
- (NSNumber *)calculateSegmentPoint{
    return [self calculateSegmentPointWithOriginPoint:self.startPoint
                                               middle:self.middlePoint
                                                  end:self.endPoint];
}

- (CGFloat)calculateDistanceWithPoint:(CGPoint)start
                                  to:(CGPoint)end{
    CGFloat distance;
    CGFloat x = (end.x - start.x);
    CGFloat y = (end.y - start.y);
    distance = sqrt((x * x) + (y * y));
    return ceil(distance);
}
- (NSNumber *)calculateSegmentPointWithOriginPoint:(CGPoint)origin
                                            middle:(CGPoint)middle
                                               end:(CGPoint)end{
    
    CGFloat distance  = [self calculateDistanceWithPoint:origin
                                                      to:middle];
    CGFloat distance2 = [self calculateDistanceWithPoint:middle
                                                      to:end];
    CGFloat sum = distance + distance2;
    CGFloat segment = distance / sum;
    NSString *string = [NSString stringWithFormat:@"%0.2f",segment];
    NSNumber *value = [self.formatter numberFromString:string];
    return value;
}

-(NSNumberFormatter *)formatter{
    if (!_formatter) {
        _formatter = [[NSNumberFormatter alloc] init];
        [_formatter setPositiveFormat:@"0.00"];
    }
    return _formatter;
}

@end

