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
 *  工厂方法
 *
 */
+(instancetype)moleWithTexture:(SKTexture *)texture andLaughs:(NSArray *)laughs andThumps:(NSArray *)thumps;


/**
 *  鼹鼠出洞动画
 */
-(void)moveUp;
@end
