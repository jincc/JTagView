//
//  SCUIAnimation.m
//  JMSocial
//
//  Created by junlongj on 15/12/1.
//  Copyright © 2015年 Jian Ning. All rights reserved.
//

#import "SCUIAnimation.h"
#import <POP.h>
CGFloat const kAnimationOffsetY_FromRightTop = 80;
CGFloat const kDefaultDelayTime = 0.1;


//WOOL ANIMATION
CGFloat const SCWoolAddAnimationYoffSet  = 15.f;
CGFloat const SCWoolAddAnimationMoveY = 20.f;

CGFloat const SCWoolAddAnimationPauseTime = 1.f;
@implementation SCUIAnimation


+ (POPSpringAnimation *)springAnimationWithPropertyName:(nonnull NSString *)propertyName
                       springBounciness:(NSNumber *)springBounciness
                            springSpeed:(NSNumber *)springSpeed
                              fromValue:(NSValue *)from
                                toValue:(nonnull NSValue *)to
                                                  delay:(NSTimeInterval)delay
                        completionBlock:(void (^)(POPAnimation *anim, BOOL finished))completionBlock{
    
    
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animation];
    scaleAnimation.springBounciness = 16;
    scaleAnimation.springSpeed = 14;
    if (springBounciness) {
        scaleAnimation.springBounciness = [springBounciness integerValue];
    }
    if (springSpeed) {
        scaleAnimation.springSpeed = [springSpeed integerValue];
    }
    if (from) {
        scaleAnimation.fromValue = from;
    }
    scaleAnimation.property = [POPAnimatableProperty propertyWithName:propertyName];
    scaleAnimation.toValue = to;
    scaleAnimation.completionBlock  = completionBlock;
    scaleAnimation.beginTime = CACurrentMediaTime()  + delay;
    return scaleAnimation;
    
}
+ (POPBasicAnimation *)basicAnimationWithPropertyName:(nonnull NSString *)propertyName
                                            fromValue:(NSValue *)from
                                              toValue:(nonnull NSValue *)to
                                             duration:(NSTimeInterval)duration
                                                delay:(NSTimeInterval)delay
                                      completionBlock:(void (^)(POPAnimation *anim, BOOL finished))completionBlock{
    POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:propertyName];
    if (from) {
          animation.fromValue = from;
    }
    animation.toValue = to;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.duration = duration;
    animation.beginTime =  CACurrentMediaTime()  + delay;
    animation.completionBlock = completionBlock;
    return animation;
}

+(void)praiseAnimationWithStartPoint:(CGPoint)startPoint
                           superView:(UIView *)superView
                            addCount:(NSInteger)loveCount{
    
    CGFloat percent = kDefaultDelayTime / 100;
    CGFloat delayTime = kDefaultDelayTime - percent * loveCount;
    if (delayTime < 0 ) {
        delayTime = 0;
    }
    void(^Animation)(NSInteger ) = ^(NSInteger index) {
        CGFloat addDistance =  [UIScreen mainScreen].bounds.size.height / 4.5;
        
        CGFloat distance_1 = addDistance / 3.5;
        CGFloat distance_2 = addDistance / 4;
        //    CGFloat distance_3 = addDistance - distance_1 - distance_2;
        
        
        __block NSInteger offsex_X = arc4random() % 15;
        __block NSInteger offset_Y = arc4random() % 50;
        __block NSInteger offset_direction = arc4random() % 2;
        if (offset_direction == 0) {
            offsex_X = -offsex_X;
        }
        //add subview
        UIImageView* animateView = [[UIImageView alloc] initWithImage:
                                    [UIImage imageNamed:@"点赞_红"]];
        animateView.frame = CGRectMake(0, 0, 25, 23);
        animateView.center = startPoint;
        [superView addSubview:animateView];
        animateView.transform = CGAffineTransformMakeScale(0, 0);
        
        
        void(^MoveYAndAlphaAnimtion)(BOOL) = ^(BOOL finished) {
            offsex_X = arc4random() % 15;
            offset_direction = arc4random() % 2;
            if (offset_direction == 0) {
                offsex_X = -offsex_X;
            }
            [UIView animateWithDuration:2 animations:^{
                animateView.center = CGPointMake(animateView.center.x + offsex_X, animateView.center.y - addDistance);
                animateView.alpha = 0;
            }completion:^(BOOL finished) {
                [animateView removeFromSuperview];
            }];
        };
        void(^MoveYAnimation)(BOOL ) = ^(BOOL finished) {
            offsex_X = arc4random() % 25;
            offset_direction = arc4random() % 2;
            if (offset_direction == 0) {
                offsex_X = -offsex_X;
            }
            [UIView animateWithDuration:.8 animations:^{
                animateView.center = CGPointMake(animateView.center.x + offsex_X, animateView.center.y - distance_1 - distance_2);
            }completion:MoveYAndAlphaAnimtion];
        };
        
        void(^ScaleIdentityAnimation)(BOOL) = ^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                animateView.transform = CGAffineTransformMakeScale(1, 1);
            }completion:MoveYAnimation];
        };
        
        //start animation
        [UIView animateWithDuration:.5 delay:0+ index*delayTime usingSpringWithDamping:0.7 initialSpringVelocity:0.7 options:UIViewAnimationOptionCurveEaseOut animations:^{
            animateView.transform = CGAffineTransformMakeScale(1.1, 1.1);
            animateView.center = CGPointMake(animateView.center.x + offsex_X, animateView.center.y - distance_1 - offset_Y); //40
        }completion:ScaleIdentityAnimation];
    };
    
    
    
    for (int i  =  0;  i<  loveCount; i ++ ) {
        Animation(i);
    }
}


+ (void)alphaAnimationWithView:(UIView *)view
                       toValue:(CGFloat )alpha
                      duration:(NSTimeInterval)duration
                         delay:(NSTimeInterval)delay
             animationFinished:(dispatch_block_t)animationFinished{
    
    POPBasicAnimation *alphaAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    alphaAnimation.duration = duration;
    alphaAnimation.fromValue = @(view.alpha);
    alphaAnimation.beginTime = CACurrentMediaTime() + delay;
    alphaAnimation.toValue = @(alpha);
    alphaAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    alphaAnimation.completionBlock = ^(POPAnimation *ani , BOOL finished){
        if (finished && animationFinished) {
            animationFinished();
        }
    };
    [view pop_addAnimation:alphaAnimation forKey:nil];
    
    
}
+ (void)alphaAnimationWithView:(UIView *)view
                      duration:(NSTimeInterval)duration
                         delay: (NSTimeInterval)delay
                    willHidden:(BOOL)willHidden
             animationFinished:(dispatch_block_t)animationFinished{
    CGFloat startAlpha = willHidden ? 1 : 0;
    CGFloat endAlpha =  willHidden ? 0 : 1;
    
    POPBasicAnimation *alphaAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    alphaAnimation.duration = duration;
    alphaAnimation.fromValue = @(startAlpha);
    alphaAnimation.beginTime = CACurrentMediaTime() + delay;
    alphaAnimation.toValue = @(endAlpha);
    alphaAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    alphaAnimation.completionBlock = ^(POPAnimation *ani , BOOL finished){
        if (finished && animationFinished) {
            animationFinished();
        }
    };
    [view pop_addAnimation:alphaAnimation forKey:nil];
}

+ (void)numberAddAnimationWithLabel:(UILabel *)label
                         fromNumber:(NSNumber *)from
                           toNumber:(NSNumber *)to
                           duration:(NSTimeInterval)duration
                              delay:(NSTimeInterval)delay
                  animationFinished:(dispatch_block_t)animationFinished{
    POPAnimatableProperty *addProp = [POPAnimatableProperty
                                      propertyWithName:@"addProp"
                                      initializer:^(POPMutableAnimatableProperty *prop) {
                                          prop.threshold = 0.01;//速度
                                          prop.readBlock = ^(id obj, CGFloat values[]) {
                                              values[0] = [[obj description] floatValue];
                                          };
                                          prop.writeBlock = ^(id obj, const CGFloat values[]) {
                                              [obj setText:[NSString stringWithFormat:@"%lld",(long long ) values[0]]];
                                          };
                                      }];
    
    
    POPBasicAnimation *anim = [POPBasicAnimation linearAnimation];
    anim.property = addProp;
    anim.fromValue = from;
    anim.toValue = to;
    anim.duration = duration;
    anim.beginTime = CACurrentMediaTime() + delay;
    anim.completionBlock = ^(POPAnimation *ani , BOOL finished){
        if (finished && animationFinished) {
            animationFinished();
        }
    };
    [label pop_addAnimation:anim forKey:addProp.name];
}


+ (void)labelTextColorChangeAnimationWithLabel:(UILabel *)label
                                     fromColor:(UIColor *)fromColor
                                       toColor:(UIColor *)toColor
                                      duration:(NSTimeInterval)duration{
    POPBasicAnimation *textColorAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLabelTextColor];
    textColorAnimation.duration = duration;
    textColorAnimation.fromValue = fromColor;
    textColorAnimation.toValue = toColor;
    textColorAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [label pop_addAnimation:textColorAnimation forKey:nil];
}

+ (void)layerBorderColorChangeAnimationWithLayer:(CALayer *)layer
                                       fromColor:(UIColor *)fromColor
                                         toColor:(UIColor *)toColor
                                        duration:(NSTimeInterval)duration
{
    POPBasicAnimation *textColorAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerBorderColor];
    textColorAnimation.duration = duration;
    textColorAnimation.fromValue = fromColor;
    textColorAnimation.toValue = toColor;
    textColorAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [layer pop_addAnimation:textColorAnimation forKey:nil];
}

+(void)backGroundColorChangeAnimationWithView:(UIView *)view
                                    fromColor:(UIColor *)fromColor
                                      toColor:(UIColor *)toColor
                                     duration:(NSTimeInterval)duration{
    
    POPBasicAnimation *textColorAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewBackgroundColor];
    textColorAnimation.duration = duration;
    textColorAnimation.fromValue = fromColor;
    textColorAnimation.toValue = toColor;
    textColorAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [view pop_addAnimation:textColorAnimation forKey:nil];
    
}
+(void)layoutConstraintConstantAnimationWithConstraint:(NSLayoutConstraint *)constraint
                                                  from:(CGFloat)from
                                                    to:(CGFloat)to
                                                 delay:(NSTimeInterval)delay;{
    
    
    POPSpringAnimation *layoutAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayoutConstraintConstant];
    layoutAnimation.toValue = @(to);
    layoutAnimation.fromValue = @(from);
    layoutAnimation.springBounciness = 14;
    layoutAnimation.springSpeed = 15;
    layoutAnimation.beginTime = CACurrentMediaTime() + delay;
    [constraint pop_addAnimation:layoutAnimation forKey:nil];
    
}

//+(void)woolAddAniamtionWithNumber:(NSString *)numbers
//                        superView:(UIView *)superView
//                       startPoint:(CGPoint)startPoint
//animationFinished:(dispatch_block_t)animationFinished{
//    
//    if (!(numbers.length &&
//          ![numbers isEqualToString:@"0"])) {
//        return;
//    }
//    //animation
//    SCWoolAddAnimationView *animationView = [SCWoolAddAnimationView creatView];
//    [animationView fillViewWithNumber:numbers];
//    
//    //hidden
//    animationView.addLabel.hidden = true;
//    [superView addSubview:animationView];
//    [superView bringSubviewToFront:animationView];
//    //更新
//    [animationView layoutIfNeeded];
//    //animation
//    startPoint  = CGPointMake(startPoint.x, startPoint.y - SCWoolAddAnimationYoffSet);
//    
//    
//    
////    //move 2/y
////    POPBasicAnimation *containerViewMoveAnimation  = [self basicAnimationWithPropertyName:kPOPViewCenter
////                                                                                fromValue:[NSValue valueWithCGPoint:startPoint]
////                                                                                  toValue:[NSValue valueWithCGPoint:CGPointMake(startPoint.x, startPoint.y -  SCWoolAddAnimationYoffSet / 2.0)]
////                                                                                 duration:.3f
////                                                                                    delay:0
////                                                                          completionBlock:^(POPAnimation *anim, BOOL finished) {
////                                                                                        animationView.addLabel.hidden = false;
////                                                                                    }];
////    //alpha 0.4 - 1
////    POPBasicAnimation *containerViewAlaphaAnimation = [self basicAnimationWithPropertyName:kPOPViewAlpha
////                                                                                 fromValue:@0.4
////                                                                                   toValue:@1
////                                                                                  duration:.3f
////                                                                                     delay:0
////                                                                           completionBlock:NULL];
////    //move 2/y
////    POPBasicAnimation *containerViewMove2Animation  = [self basicAnimationWithPropertyName:kPOPViewCenter
////                                                                                 fromValue:[NSValue valueWithCGPoint:CGPointMake(startPoint.x, startPoint.y -  SCWoolAddAnimationYoffSet / 2.0)]
////                                                                                   toValue:[NSValue valueWithCGPoint:CGPointMake(startPoint.x, startPoint.y -  SCWoolAddAnimationYoffSet)]
////                                                                                  duration:0.4f
////                                                                                     delay:SCWoolAddAnimationPauseTime + 0.3
////                                                                           completionBlock:NULL];
////    //hidden
////    POPBasicAnimation *containerViewAlapha2Animation  =  [self basicAnimationWithPropertyName:kPOPViewAlpha
////                                                                                    fromValue:@1
////                                                                                      toValue:@0
////                                                                                     duration:.4f
////                                                                                        delay:SCWoolAddAnimationPauseTime + 0.3
////                                                                              completionBlock:^(POPAnimation *anim, BOOL finished) {
////                                                                                            animationFinished ? animationFinished () : nil;
////                                                                                            [animationView removeFromSuperview];
////                                                                                        }];
////    
////    POPSpringAnimation *addSpringAnimation = [self springAnimationWithPropertyName:kPOPViewCenter
////                                                                  springBounciness:@18
////                                                                       springSpeed:@16
////                                                                         fromValue:[NSValue valueWithCGPoint:CGPointMake(animationView.addLabel.center.x, animationView.addLabel.center.y  + 15)]
////                                                                           toValue:[NSValue valueWithCGPoint:CGPointMake(animationView.addLabel.center.x, animationView.addLabel.center.y )]
////                                                                             delay:0.3
////                                                                   completionBlock:NULL];
////    
////    [animationView pop_addAnimation:containerViewMoveAnimation forKey:nil];
////    [animationView pop_addAnimation:containerViewAlaphaAnimation forKey:nil];
////    [animationView pop_addAnimation:containerViewMove2Animation forKey:nil];
////    [animationView pop_addAnimation:containerViewAlapha2Animation forKey:nil];
////    [animationView.addLabel pop_addAnimation:addSpringAnimation forKey:nil];
//    
//    
//    animationView.center = startPoint;
//    animationView.alpha = .4;
//    animationView.addLabel.center = CGPointMake(animationView.addLabel.center.x, animationView.addLabel.center.y  + 15);
//    [UIView animateWithDuration:.3f
//                     animations:^{
//                         animationView.center = CGPointMake(startPoint.x, startPoint.y -  SCWoolAddAnimationYoffSet / 2.0);
//                         animationView.alpha = 1;
//                     } completion:^(BOOL finished) {
//                         animationView.addLabel.hidden = false;
//                         [UIView animateWithDuration:.4
//                                               delay:SCWoolAddAnimationPauseTime options:UIViewAnimationOptionCurveEaseOut animations:^{
//                                                   animationView.center = CGPointMake(startPoint.x, startPoint.y -  SCWoolAddAnimationYoffSet);
//                                                   animationView.alpha = 0;
//                                               } completion:^(BOOL finished) {
//                                                   animationFinished ? animationFinished () : nil;
//                                                   [animationView removeFromSuperview];
//                                               }];
//                     }];
//    
//    
//    [UIView animateWithDuration:.4
//                          delay:.3
//         usingSpringWithDamping:.7
//          initialSpringVelocity:.7
//                        options:UIViewAnimationOptionCurveEaseOut
//                     animations:^{
//        animationView.addLabel.center = CGPointMake(animationView.addLabel.center.x, animationView.addLabel.center.y - 15);
//    } completion:^(BOOL finished) {
//        
//    }];
//    
//    
//    
//}
//
//+(void)woolAddAnimationShowOnWindowWithNumber:(NSString *)numbers
//                            animationFinished:(dispatch_block_t)animationFinished{
////    加载主window上面会卡，所以加在keywindow上面
////    JuMeiAppDelegate *appDelegate = (JuMeiAppDelegate *)[UIApplication sharedApplication].delegate;
////    UIWindow *window = appDelegate.window;
//    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:1];
//    CGPoint startPoint = CGPointMake(window.bounds.size.width / 2, window.bounds.size.height - 25);
//    
//    [self woolAddAniamtionWithNumber:numbers
//                           superView:window
//                          startPoint:startPoint
//     animationFinished:animationFinished];
//    
//    
//}
@end