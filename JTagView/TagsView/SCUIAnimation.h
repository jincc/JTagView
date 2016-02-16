//
//  SCUIAnimation.h
//  JMSocial
//
//  Created by junlongj on 15/12/1.
//  Copyright © 2015年 Jian Ning. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <pop/POP.h>
@interface SCUIAnimation : NSObject


+ (POPSpringAnimation *)springAnimationWithPropertyName:( NSString *)propertyName
                                       springBounciness:(NSNumber *)springBounciness
                                            springSpeed:(NSNumber *)springSpeed
                                              fromValue:(NSValue *)from
                                                toValue:( NSValue *)to
                                                  delay:(NSTimeInterval)delay
                                        completionBlock:(void (^)(POPAnimation *anim, BOOL finished))completionBlock;

+ (POPBasicAnimation *)basicAnimationWithPropertyName:( NSString *)propertyName
                                            fromValue:(NSValue *)from
                                              toValue:( NSValue *)to
                                             duration:(NSTimeInterval)duration
                                                delay:(NSTimeInterval)delay
                                      completionBlock:(void (^)(POPAnimation *anim, BOOL finished))completionBlock;
+ (void)alphaAnimationWithView:(UIView *)view
                      duration:(NSTimeInterval)duration
                         delay: (NSTimeInterval)delay
                    willHidden:(BOOL)willHidden
             animationFinished:(dispatch_block_t)animationFinished;

+ (void)alphaAnimationWithView:(UIView *)view
                       toValue:(CGFloat )alpha
                      duration:(NSTimeInterval)duration
                         delay:(NSTimeInterval)delay
             animationFinished:(dispatch_block_t)animationFinished;
/**
 *  点赞动画 ++
 *
 */
+(void)praiseAnimationWithStartPoint:(CGPoint)startPoint
                           superView:(UIView *)superView
                            addCount:(NSInteger)loveCount;

/**
 *  numbers线性增加
 *
 */
+ (void)numberAddAnimationWithLabel:(UILabel *)label
                         fromNumber:(NSNumber *)from
                           toNumber:(NSNumber *)to
                           duration:(NSTimeInterval)duration
                              delay:(NSTimeInterval)delay
                  animationFinished:(dispatch_block_t)animationFinished;

+ (void)labelTextColorChangeAnimationWithLabel:(UILabel *)label
                                     fromColor:(UIColor *)fromColor
                                       toColor:(UIColor *)toColor
                                      duration:(NSTimeInterval)duration;


+ (void)layerBorderColorChangeAnimationWithLayer:(CALayer *)layer
                                       fromColor:(UIColor *)fromColor
                                         toColor:(UIColor *)toColor
                                        duration:(NSTimeInterval)duration;


+ (void)backGroundColorChangeAnimationWithView:(UIView *)view
                                     fromColor:(UIColor *)fromColor
                                       toColor:(UIColor *)toColor
                                      duration:(NSTimeInterval)duration;


+(void)layoutConstraintConstantAnimationWithConstraint:(NSLayoutConstraint *)constraint
                                            from:(CGFloat)from
                                              to:(CGFloat)to
                                           delay:(NSTimeInterval)delay;


/**
 *  点赞、评论、发布帖子成功后，羊毛++的动画
 *
 *  @param numbers <#numbers description#>
 */
+(void)woolAddAniamtionWithNumber:(NSString *)numbers
                        superView:(UIView *)superView
                       startPoint:(CGPoint)startPoint
 animationFinished:(dispatch_block_t)animationFinished;


+(void)woolAddAnimationShowOnWindowWithNumber:(NSString *)numbers
 animationFinished:(dispatch_block_t)animationFinished;

@end
