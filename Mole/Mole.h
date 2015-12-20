//
//  Mole.h
//  Mole
//
//  Created by dengwei on 15/12/19.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Mole : SKSpriteNode

/**
 *  鼹鼠隐藏时的Y轴坐标
 */
@property (nonatomic, assign) CGFloat hiddenY;

/**
 *  工厂方法
 *
 */
+(instancetype)moleWithTexture:(SKTexture *)texture andLaughs:(NSArray *)laughs andThumps:(NSArray *)thumps;

/**
 *  鼹鼠出洞动画
 */
-(void)moveUp;

/**
 *  鼹鼠被击中的动画
 */
-(void)beThumped;

/**
 *  停止鼹鼠动画
 */
-(void)stopAction;
@end
