//
//  GameScene.m
//  Mole
//
//  Created by dengwei on 15/12/18.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "GameScene.h"
#import "SKTextureAtlas+Helper.h"
#import "Mole.h"

#define DEFAULT_SPEED 10

static long steps = 0;//用来调整动画速度
static long speed = 0;//根据分数来加速

@interface GameScene()
{
    NSArray *_moles; //鼹鼠
    SKLabelNode *_scoreLabel; //得分标签
    NSInteger _score; //用户得分
    SKLabelNode *_timerLabel; //时钟标签
    NSDate *_startTime; //游戏开始时间
}

@end

@implementation GameScene

//所有材质的静态变量，在加载材质方法中被设置
static SKTexture *sShareDirtTexture = nil;
static SKTexture *sShareUpperTexture = nil;
static SKTexture *sShareLowerTexture = nil;
static SKTexture *sShareMoleTexture = nil;
static NSArray *sShareMoleLaughFrames = nil;
static NSArray *sShareMoleThumpFrames = nil;

#pragma mark - 私有方法
#pragma mark 设置界面
-(void)setupUI
{
    CGPoint center = CGPointMake(self.size.width / 2.0, self.size.height / 2.0);
    //1.设置背景
    SKSpriteNode *dirt = [SKSpriteNode spriteNodeWithTexture:sShareDirtTexture];
    dirt.position = center;
    //设置图片缩放比例
    [dirt setScale:2.0f];
    [self addChild:dirt];
    //2.设置草地
    //2.1上面的草
    SKSpriteNode *upper = [SKSpriteNode spriteNodeWithTexture:sShareUpperTexture];
    //设置锚点
    upper.anchorPoint = CGPointMake(0.5, 0.0);
    upper.position = center;
    if (IS_IPHONE_5) {
        //设置图片缩放比例
        [upper setScale:0.7f];
    }
    [self addChild:upper];
    //2.2下面的草
    SKSpriteNode *lower = [SKSpriteNode spriteNodeWithTexture:sShareLowerTexture];
    //设置锚点
    lower.anchorPoint = CGPointMake(0.5, 1.0);
    lower.position = center;
    lower.zPosition = 2;
    if (IS_IPHONE_5) {
        //设置图片缩放比例
        [lower setScale:0.7f];
    }
    [self addChild:lower];
    
    //3.添加得分标签
    SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    scoreLabel.text = @"Score: 0";
    scoreLabel.fontSize = 10;
    scoreLabel.fontColor = [SKColor whiteColor];
    scoreLabel.position = CGPointMake(20, 200);
    scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    scoreLabel.zPosition = 4;
    [self addChild:scoreLabel];
    _scoreLabel = scoreLabel;
    
    //4.添加时间标签
    SKLabelNode *timerLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    timerLabel.text = @"00:00:00";
    timerLabel.fontSize = 10;
    timerLabel.fontColor = [SKColor whiteColor];
    timerLabel.position = CGPointMake(self.size.width - 60, self.size.height - 10 - 200);
    timerLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    timerLabel.zPosition = 4;
    [self addChild:timerLabel];
    _timerLabel = timerLabel;
}

#pragma mark 加载鼹鼠到数组
-(void)loadMoles
{
    //2.存放到数组
    NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:3];
    for (NSInteger i = 0; i < 3; i++) {
        //精灵节点
        Mole *mole = [Mole moleWithTexture:sShareMoleTexture andLaughs:sShareMoleLaughFrames andThumps:sShareMoleThumpFrames];
        if (IS_IPHONE_5){
            [mole setScale:0.7f];
        }
        [arrayM addObject:mole];
    }
    _moles = arrayM;
}

#pragma mark 设置鼹鼠的位置
-(void)setupMoles
{
    CGFloat xOffSet = 110.0;
    CGPoint startPoint = CGPointMake(self.size.width / 2.0 - xOffSet, self.size.height / 2.0 - 80);
    [_moles enumerateObjectsUsingBlock:^(Mole *mole, NSUInteger idx, BOOL *stop) {
        CGPoint p = CGPointMake(startPoint.x + idx * xOffSet, startPoint.y);
        [mole setPosition:p];
        mole.hiddenY = p.y;
        [self addChild:mole];
    }];
}

-(instancetype)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        [self setupUI];
        [self loadMoles];
        [self setupMoles];
        //记录游戏开始时间
        _startTime = [NSDate date];
    }
    return self;
}

#pragma mark 屏幕每次刷新时调用，在SpriteKit中不需要自行指定时钟
-(void)update:(NSTimeInterval)currentTime
{
    steps++;
    //获得当前系统时间，并计算与开始时间间隔
    NSInteger dt = [[NSDate date] timeIntervalSinceDate:_startTime];
    NSString *timeStr = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(dt/3600),((dt%3600)/60), (dt%60)];
    _timerLabel.text = timeStr;
    speed = ((_score / 100) > 9 ? 9 : speed);
    if (steps % (DEFAULT_SPEED - speed) == 0) {
        NSInteger num = arc4random_uniform(3);
        Mole *mole = _moles[num];
        [mole moveUp];
    }
}

#pragma mark - 加载素材
#pragma mark 真正的加载素材的方法
//由于游戏开发中，素材经常会发生变化，因此加载素材的方法，最好单独使用一个方法完成，这样便于应用程序的维护
+(void)loadSceneAssets
{
    XLog(@"实际加载素材");
    //加载场景所需的素材
    //背景材质
    SKTextureAtlas *atlas = [SKTextureAtlas atlasWithNamed:@"background"];
    sShareDirtTexture = [atlas textureNamed:@"bg_dirt"];
    //上面的草
    SKTextureAtlas *foreAtlas = [SKTextureAtlas atlasWithNamed:@"foreground"];
    sShareUpperTexture = [foreAtlas textureNamed:@"grass_upper"];
    //下面的草
    sShareLowerTexture = [foreAtlas textureNamed:@"grass_lower"];
    //鼹鼠
    SKTextureAtlas *moleAtlas = [SKTextureAtlas atlasWithNamed:@"sprites"];
    sShareMoleTexture = [moleAtlas textureNamed:@"mole_1"];
    //鼹鼠笑数组
    sShareMoleLaughFrames = @[[moleAtlas textureNamed:@"mole_laugh1"],
                              [moleAtlas textureNamed:@"mole_laugh2"],
                              [moleAtlas textureNamed:@"mole_laugh3"]];
    //鼹鼠挨揍数组
    sShareMoleThumpFrames = @[[moleAtlas textureNamed:@"mole_thump1"],
                              [moleAtlas textureNamed:@"mole_thump2"],
                              [moleAtlas textureNamed:@"mole_thump3"],
                              [moleAtlas textureNamed:@"mole_thump4"]];
}

#pragma mark 统一加载素材，完成后执行回调
+(void)loadSceneAssetsWithCompletionHandler:(AssetLoadCompletionHandler)callback
{
    //使用多线程加载素材
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self loadSceneAssets];
        if (callback) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //因为回调函数涉及到实例化场景以及展现，因此需要在主线程执行
                callback();
            });
        }
    });
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //获取到用户打到鼹鼠
    UITouch *touch = [touches anyObject];
    CGPoint loaction = [touch locationInNode:self];
    //取出用户点击的节点
    SKNode  *node = [self nodeAtPoint:loaction];
    if ([node.name isEqualToString:@"mole"]) {
        Mole *mole = (Mole *)node;
        [mole beThumped];
        _score += 10;
        _scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", _score];
        XLog(@"打到啦");
    }
}

@end
