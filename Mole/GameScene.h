//
//  GameScene.h
//  Mole
//

//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef void (^AssetLoadCompletionHandler)();

@interface GameScene : SKScene

/**
 *  统一加载游戏素材
 *
 *  @param callback 回调函数
 */
+(void)loadSceneAssetsWithCompletionHandler:(AssetLoadCompletionHandler)callback;

@end
