//
//  GameScene_iPad.m
//  Mole
//
//  Created by dengwei on 15/12/20.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "GameScene_iPad.h"

@implementation GameScene_iPad

#pragma mark 设置鼹鼠的位置
-(void)setupMoles
{
    CGFloat xOffSet = 310.0;
    CGPoint startPoint = CGPointMake(self.size.width / 2.0 - xOffSet, self.size.height / 2.0 - 180);
    [self.moles enumerateObjectsUsingBlock:^(Mole *mole, NSUInteger idx, BOOL *stop) {
        CGPoint p = CGPointMake(startPoint.x + idx * xOffSet, startPoint.y);
        [mole setPosition:p];
        mole.hiddenY = p.y;
        [self addChild:mole];
    }];
}

@end
