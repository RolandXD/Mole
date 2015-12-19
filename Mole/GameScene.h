//
//  GameScene.h
//  Mole
//

//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Mole.h"

typedef void (^AssetLoadCompletionHandler)();

@interface GameScene : SKScene

/**
 *  鼹鼠数组
 */
@property (nonatomic, strong) NSArray *moles;

/**
 *  统一加载游戏素材
 *
 *  @param callback 回调函数
 */
+(void)loadSceneAssetsWithCompletionHandler:(AssetLoadCompletionHandler)callback;

/**
 *  设置鼹鼠的位置
 */
-(void)setupMoles;

@end
