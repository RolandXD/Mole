//
//  Mole.m
//  Mole
//
//  Created by dengwei on 15/12/19.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "Mole.h"

@interface Mole ()
{
    BOOL _isThumped; //鼹鼠被打的标识
    SKAction *_upSequence; //鼹鼠出洞动画组
    SKAction *_thumpSequence; //鼹鼠被打动画组
}
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
    
    mole.name = @"mole";
    
    return mole;
}

#pragma mark 鼹鼠出洞动画Spue
-(void)moveUp
{
    if ([self hasActions]) {
        return;
    }
    //1.先出来
    SKAction *moveUp = [SKAction moveToY:_hiddenY + self.size.height+20 duration:0.2f];
    [moveUp setTimingMode:SKActionTimingEaseOut];
    //2.等0.5秒
    SKAction *delay = [SKAction waitForDuration:0.5f];
    //3.再藏起来
    SKAction *moveDown = [SKAction moveToY:_hiddenY duration:0.2f];
    [moveDown setTimingMode:SKActionTimingEaseIn];
    
    SKAction *s = [SKAction sequence:@[moveUp, self.laughAction, delay, moveDown]];
    [self runAction:s];
}

#pragma mark 鼹鼠被打了
-(void)beThumped
{
    //鼹鼠是否已经被击中的标识
    if (_isThumped) {
        return;
    }
    _isThumped = YES;
    //1.删除所有的Action
    [self removeAllActions];
    //2.创建新的Action
    //2.1.鼹鼠 藏起来的动画
    SKAction *moveDown = [SKAction moveToY:_hiddenY duration:0.2f];
    [moveDown setTimingMode:SKActionTimingEaseIn];
    SKAction *s = [SKAction sequence:@[self.thumpAction, moveDown]];
    [self runAction:s completion:^{
        _isThumped = NO;
    }];
}

#pragma mark 停止鼹鼠动画
-(void)stopAction
{
    XLog(@"停止鼹鼠动画");
    [self removeAllActions];
}

@end
