//
//  GameScene.m
//  Mole
//
//  Created by dengwei on 15/12/18.
//  Copyright (c) 2015年 dengwei. All rights reserved.
//

#import "GameScene.h"
#import "SKTextureAtlas+Helper.h"

#define DEFAULT_SPEED 10
#define kFontSize (IS_IPAD ? 30 : 10)

static long steps = 0;//用来调整动画速度
static long speed = 0;//根据分数来加速
static long gameOver = 10; //判断游戏结束

@interface GameScene()
{
    SKLabelNode *_scoreLabel; //得分标签
    NSInteger _score; //用户得分
    SKLabelNode *_timerLabel; //时钟标签
    NSDate *_startTime; //游戏开始时间
    SKLabelNode *_loseLabel; //lose标签
    NSInteger _lose; //lose计数
    SKLabelNode *_noteLabel; //游戏提示标签
    BOOL _isGameOver; //游戏结束
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
    [self addChild:upper];
    //2.2下面的草
    SKSpriteNode *lower = [SKSpriteNode spriteNodeWithTexture:sShareLowerTexture];
    //设置锚点
    lower.anchorPoint = CGPointMake(0.5, 1.0);
    lower.position = center;
    lower.zPosition = 2;
    [self addChild:lower];
    
    //3.添加得分标签
    SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    scoreLabel.text = @"Score: 0";
    scoreLabel.fontSize = kFontSize;
    scoreLabel.fontColor = [SKColor whiteColor];
    CGFloat ScoreX = (IS_IPAD ? (20) : (20));
    CGFloat ScoreY = (IS_IPAD ? (200) : (100));
    XLog(@"scoreLabel x:%f,y:%f",ScoreX,ScoreY);
    scoreLabel.position = CGPointMake(ScoreX, ScoreY);
    scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    scoreLabel.zPosition = 4;
    [self addChild:scoreLabel];
    _scoreLabel = scoreLabel;
    
    //4.添加时间标签
    SKLabelNode *timerLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    timerLabel.text = @"00:00:00";
    timerLabel.fontSize = kFontSize;
    timerLabel.fontColor = [SKColor whiteColor];
    CGFloat timerX = (IS_IPAD ? (self.size.width - 160) : (self.size.width - 60));
    CGFloat timerY = (IS_IPAD ? (self.size.height - 30 - 160) : (self.size.height - 10 - 60));
    XLog(@"timerLabel x:%f,y:%f",timerX,timerY);
    timerLabel.position = CGPointMake(timerX, timerY);
    timerLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    timerLabel.zPosition = 4;
    [self addChild:timerLabel];
    _timerLabel = timerLabel;
    
    //5.添加lose标签
    SKLabelNode *loseLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    loseLabel.text = @"Lose: 0";
    loseLabel.fontSize = kFontSize;
    loseLabel.fontColor = [SKColor whiteColor];
    CGFloat loseX = (IS_IPAD ? (260) : (120));
    CGFloat loseY = (IS_IPAD ? (200) : (100));
    XLog(@"loseLabel x:%f,y:%f",loseX,loseY);
    loseLabel.position = CGPointMake(loseX, loseY);
    loseLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    loseLabel.zPosition = 4;
    [self addChild:loseLabel];
    _loseLabel = loseLabel;
    
    //6.添加note标签
    SKLabelNode *noteLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    noteLabel.fontSize = (IS_IPAD ? 30 : 20);
    noteLabel.fontColor = [SKColor redColor];
    CGFloat noteX = (IS_IPAD ? (260) : (self.size.width / 2.0 - 40));
    CGFloat noteY = (IS_IPAD ? (200) : (200));
    XLog(@"noteLabel x:%f,y:%f",noteX,noteY);
    noteLabel.position = CGPointMake(noteX, noteY);
    noteLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    noteLabel.zPosition = 4;
    [self addChild:noteLabel];
    _noteLabel = noteLabel;
}

#pragma mark 加载鼹鼠到数组
-(void)loadMoles
{
    //2.存放到数组
    NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:3];
    for (NSInteger i = 0; i < 3; i++) {
        //精灵节点
        Mole *mole = [Mole moleWithTexture:sShareMoleTexture andLaughs:sShareMoleLaughFrames andThumps:sShareMoleThumpFrames];
 
        [arrayM addObject:mole];
    }
    _moles = arrayM;
}

#pragma mark 设置鼹鼠的位置
-(void)setupMoles
{
    CGFloat xOffSet = 155.0;
    CGPoint startPoint = CGPointMake(self.size.width / 2.0 - xOffSet, self.size.height / 2.0 - 100);
    [_moles enumerateObjectsUsingBlock:^(Mole *mole, NSUInteger idx, BOOL *stop) {
        CGPoint p = CGPointMake(startPoint.x + idx * xOffSet, startPoint.y);
        [mole setPosition:p];
        mole.hiddenY = p.y;
        [self addChild:mole];
    }];
}

-(void)startGame
{
    [self setupUI];
    [self loadMoles];
    [self setupMoles];
    //记录游戏开始时间
    _startTime = [NSDate date];
    //得分
    _score = 0;
    //lose计数
    _lose = 0;
    //游戏标识符
    _isGameOver = NO;
    steps = 0;
    _noteLabel.text = @"";
    _scoreLabel.text = [NSString stringWithFormat:@"Score: %zi", _score];
    _loseLabel.text = [NSString stringWithFormat:@"Lose: %zi", _lose];
}

-(void)stopGame
{
    for (NSInteger i = 0; i < 3; i++) {
        [_moles[i] stopAction];
    }
}

-(void)isGameOver
{
    if (_lose == gameOver) {
        _noteLabel.text = @"Game Over!";
        [self stopGame];
        _isGameOver = YES;
    }
}

-(instancetype)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        [self startGame];
    }
    return self;
}

#pragma mark 屏幕每次刷新时调用，在SpriteKit中不需要自行指定时钟
-(void)update:(NSTimeInterval)currentTime
{
    steps++;
    //获得当前系统时间，并计算与开始时间间隔
    NSInteger dt = [[NSDate date] timeIntervalSinceDate:_startTime];
    NSString *timeStr = [NSString stringWithFormat:@"%02zi:%02zi:%02zi",(dt/3600),((dt%3600)/60), (dt%60)];
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
        _scoreLabel.text = [NSString stringWithFormat:@"Score: %zi", _score];
        XLog(@"打到啦");
    }else{
        _lose++;
        _loseLabel.text = [NSString stringWithFormat:@"Lose: %zi", _lose];
        XLog(@"没有打中");
        [self isGameOver];
        if (_isGameOver == YES) {
            [self startGame];
        }
    }
}

@end
