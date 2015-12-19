//
//  GameViewController.m
//  Mole
//
//  Created by dengwei on 15/12/18.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"
#import "GameScene_iPad.h"

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    if (!skView.scene) {
        //统一加载游戏素材
        [GameScene loadSceneAssetsWithCompletionHandler:^{
            //关闭指示器
            
            // Create and configure the scene.
            GameScene *scene = nil;
            if (IS_IPAD) {
                scene = [GameScene_iPad sceneWithSize:skView.bounds.size];
            }else{
                scene = [GameScene sceneWithSize:skView.bounds.size];
            }
            scene.scaleMode = SKSceneScaleModeAspectFill;
            
            // Present the scene.
            [skView presentScene:scene];
        }];
        //以下方法通常是用于显示指示器
        skView.showsFPS = YES;
        skView.showsNodeCount = YES;
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = YES;
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
