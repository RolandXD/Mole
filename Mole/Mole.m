//
//  Mole.m
//  Mole
//
//  Created by dengwei on 15/12/19.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "Mole.h"

@interface Mole ()
//鼹鼠笑操作
@property(nonatomic, strong)SKAction *laughAction;
//鼹鼠挨揍操作
@property (nonatomic, strong) SKAction *thumpAction;

@end

@implementation Mole

#pragma mark 工厂方法
+(instancetype)moleWithTexture:(SKTexture *)texture andLaughs:(NSArray *)laughs andThumps:(NSArray *)thumps
{
    Mole *mole = [Mole spriteNodeWithTexture:texture];
    //设置层次
    mole.zPosition = 1;
    //mole.laughAction = [SKAction animateWithTextures:laughs timePerFrame:0.1f];
    SKAction *laugh = [SKAction animateWithTextures:laughs timePerFrame:0.1f];
    SKAction *laughSound = [SKAction playSoundFileNamed:@"laugh.caf" waitForCompletion:NO];
    mole.laughAction = [SKAction group:@[laugh, laughSound]];
    
    //mole.thumpAction = [SKAction animateWithTextures:thumps timePerFrame:0.1f];
    SKAction *thump = [SKAction animateWithTextures:thumps timePerFrame:0.1f];
    SKAction *thumpSound = [SKAction playSoundFileNamed:@"ow.caf" waitForCompletion:NO];
    mole.thumpAction = [SKAction group:@[thump, thumpSound]];
    
    return mole;
}
#pragma mark 鼹鼠出洞动画
-(void)moveUp
{
    if ([self hasActions]) {
        return;
    }
    //1.先出来
    SKAction *moveUp = [SKAction moveToY:self.position.y + self.size.height+20 duration:0.2f];
    [moveUp setTimingMode:SKActionTimingEaseOut];
    //2.等0.5秒
    SKAction *delay = [SKAction waitForDuration:0.5f];
    //3.再藏起来
    SKAction *moveDown = [SKAction moveToY:self.position.y duration:0.2f];
    [moveDown setTimingMode:SKActionTimingEaseIn];
    
    SKAction *s = [SKAction sequence:@[moveUp, self.laughAction, delay, moveDown]];
    [self runAction:s];
}

@end
