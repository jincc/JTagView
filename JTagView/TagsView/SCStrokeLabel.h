//
//  SCStrokeLabel.h
//  JuMei
//
//  Created by junlongj on 16/2/3.
//  Copyright © 2016年 Jumei Inc. All rights reserved.
//

#import "PPLabel.h"
/**
 *  glow
 */
@interface SCStrokeLabel : PPLabel

@property (nonatomic, assign) CGFloat glowSize;
@property (nonatomic) UIColor *glowColor;
@property (nonatomic, assign) CGFloat innerGlowSize;
@property (nonatomic) UIColor *innerGlowColor;
@end
