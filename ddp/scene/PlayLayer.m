






#import "PlayLayer.h"
#import "SceneManager.h"
#import "SetUserInfoLayer.h"



static NSString *DEFAULT_FONT = @"Marker Felt";

@interface PlayLayer()

-(void)afterOneShineTrun: (id) node;
-(void)initGameUI;

@end

@implementation PlayLayer

CCLabelTTF * ccL(NSString * value, float fontSize){
	return [CCLabelTTF labelWithString:value fontName:DEFAULT_FONT fontSize:fontSize];
}

CCLabelTTF * ccLP(NSString * value, float fontSize, CGPoint pos){
	CCLabelTTF * result = [CCLabelTTF labelWithString:value fontName:DEFAULT_FONT fontSize:fontSize];
	result.position = pos;
	return result;
}


+(id) scene{
    
	CCScene *scene = [CCScene node];
	PlayLayer *layer = [PlayLayer node];
	[scene addChild: layer];
	return scene;
}

-(void)dealloc{
    CCLOG(@"method:dealloc");
    [game release];
    [box release];
    [super dealloc];
}

-(id) init{
    
	if (self = [super init]) {
        CCLOG(@"method:init");
        CCLOG(@"开始初始化游戏...");
        
        //初始化游戏数据
        game = [[Game alloc] init];
        
        //初始化游戏区
        box = [[Box alloc] initWithSize:CGSizeMake(kBoxWidth, kBoxHeight) level:[game level]];
        box.layer = self;
        box.lock = YES;
        
        //初始化技能
        
        [game setState:kGameStatePrepare];
        startIntroIndex = 0;
        NSString *strLevel = [NSString stringWithFormat:@"Level %d", [game.level num]];
        startIntroArray = [NSArray arrayWithObjects:strLevel, @"Ready", @"Go!", nil];
        [startIntroArray retain];
        
        //初始化游戏UI界面
        [self initGameUI];
    }

	return self;
}


#pragma mark - #game logic
-(void) onEnterTransitionDidFinish{
    CCLOG(@"method:onEnterTransitionDidFinish");
    
    [super onEnterTransitionDidFinish];
    [self schedule:@selector(checkGameState) interval:kScheduleInterval];
}


-(void) onEnter{
    CCLOG(@"method:onEnter");
    
	[super onEnter];
    
	if (!startIntroArray) {
		[self schedule:@selector(checkGameState) interval: kScheduleInterval];
	}
}
-(void) onExit{
    
    CCLOG(@"method:onExit");
    
	[super onExit];
	[self unschedule:@selector(checkGameState)];
}

/**
 *  游戏状态切换
 *
 */
-(void) checkGameState{
    
    CCLOG(@"method:checkGameState");
    
    switch (game.state) {
        case kGameStatePrepare:
        {
            [self unschedule:@selector(checkGameState)];
            if(startIntroArray){
                [self showStartIntro];
            }else{
                game.state = kGameStatePlaying;
                [self schedule:@selector(checkGameState) interval:kScheduleInterval];
            }
            break;
        }
        case kGameStateIntro://场景介绍
        {
            break;
        }
        case kGameStatePlaying://进行中
        {
            [self unschedule:@selector(checkGameState)];
            [box check];
            break;
        }
        case kGameStatePause:
        {
            CCLOG(@"method:actionPause");
            [SceneManager goPause];
            break;
        }
        case kGameStateWin://胜利
        {
            [self unschedule:@selector(checkGameState)];
            
            CCLabelTTF *levelClear = ccLP(@"Level Clear", 28.0f, ccp(240, 160));
            levelClear.opacity = 60;
            [self addChild: levelClear z: 5];
            [levelClear runAction: [CCSequence actions:
                                    [CCFadeTo actionWithDuration:0.5f opacity:244],
                                    [CCDelayTime actionWithDuration:1.0f],
                                    [CCCallFunc actionWithTarget:self selector:@selector(goNextLevel)],
                                    nil]];
            break;
        }
        case kGameStateLost://失败
        {
            [self unschedule:@selector(checkGameState)];
            
            CCLabelTTF *timerUp = ccLP(@"Time Out", 28.0f, ccp(240, 160));
            timerUp.opacity = 60;
            [self addChild: timerUp z: 5];
            [timerUp runAction: [CCSequence actions:
                                 [CCFadeTo actionWithDuration:0.5f opacity:244],
                                 [CCDelayTime actionWithDuration:1.0f],
                                 [CCCallFunc actionWithTarget:self selector:@selector(goNextLevel)],
                                 nil]];
            
            return;
            break;
        }
        default:
        {
            NSString *timeString = [NSString stringWithFormat:@"%f", [game usedTime]];
            CCLabelTTF *timeLabel = (CCLabelTTF *)[self getChildByTag:kTimeLabelTag];
            [timeLabel setString:timeString];
            break;
        }
    }
    
    [game plusUsedTime:kScheduleInterval];
    
}

-(void) goNextLevel{
    
    CCLOG(@"method:goNextLevel");
    
    
	if (kGameStateLost == game.state) {
		[SceneManager goMenu];
	}else {
		[UserInfo saveScore: game.score + [UserInfo score]];
		[UserInfo saveWinedLevel: [game.level num]];
		[UserInfo saveUsedTime: game.usedTime];
		
		if([game.level num] == kMaxLevelNo){
			[NameInputAlertViewDelegate showWinView];
		}else{
			[SceneManager goPlay];
		}
	}
}

- (void)ccTouchesBegan:(NSSet*)touches withEvent:(UIEvent*)event{
    
    CCLOG(@"method:ccTouchesBegan");
    
	
    if ([box lock]) {
		return;
	}
	
	UITouch* touch = [touches anyObject];
	CGPoint location = [touch locationInView: touch.view];
	location = [[CCDirector sharedDirector] convertToGL: location];
	
	
	int x = (location.x - kStartX) / kTileSize;
	int y = (location.y - kStartY) / kTileSize;
	
	
	if (selectedTile && selectedTile.x ==x && selectedTile.y == y) {
		return;
	}
	
	Tile *tile = [box objectAtX:x Y:y];
	
	if (selectedTile && [selectedTile nearTile:tile]) {
		[box setLock:YES];
		[self changeWithTileA: selectedTile TileB: tile sel: @selector(check:data:)];
		selectedTile = nil;
	}else {
		selectedTile = tile;
		[self afterOneShineTrun:tile.sprite];
	}
}

-(void) changeWithTileA: (Tile *) a TileB: (Tile *) b sel : (SEL) sel{
    CCLOG(@"method:changeWithTileA");
    
	CCAction *actionA = [CCSequence actions:
						 [CCMoveTo actionWithDuration:kMoveTileTime position:[b pixPosition]],
						 [CCCallFuncND actionWithTarget:self selector:sel data: a],
						 nil
						 ];
	
	CCAction *actionB = [CCSequence actions:
						 [CCMoveTo actionWithDuration:kMoveTileTime position:[a pixPosition]],
						 [CCCallFuncND actionWithTarget:self selector:sel data: b],
						 nil
						 ];
	[a.sprite runAction:actionA];
	[b.sprite runAction:actionB];
	
	[a trade:b];
}

-(void) backCheck: (id) sender data: (id) data{
    
    CCLOG(@"method:backCheck");
    
	if(nil == firstOne){
		firstOne = data;
		return;
	}
	firstOne = nil;
	[box setLock:NO];
}

-(void) check: (id) sender data: (id) data{
    
    CCLOG(@"method:check");
    
	if(nil == firstOne){
		firstOne = data;
		return;
	}
	BOOL result = [box check];
	if (result) {
		[box setLock:NO];	
	}else {
		[self changeWithTileA:(Tile *)data TileB:firstOne sel:@selector(backCheck:data:)]; 
		[self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:kMoveTileTime + 0.03f],
						 [CCCallFunc actionWithTarget:box selector:@selector(unlock)],
						 nil]];
	}

	firstOne = nil;
}


//TODO rename
-(void) scoreAddLabelActionDone: (id) node{
    
    CCLOG(@"method:scoreAddLabelActionDone");
    
	CCLabelTTF *scoreLabel = (CCLabelTTF *)[self getChildByTag: kScoreLabelTag];
	[scoreLabel setString: [NSString stringWithFormat:@"%d", game.score]];
    
}

-(void)afterOneShineTrun: (id) node{
    
    CCLOG(@"method:afterOneShineTrun");
    
	if (selectedTile && node == selectedTile.sprite) {
		CCSprite *sprite = (CCSprite *)node;
		CCSequence *someAction = [CCSequence actions: 
								  [CCScaleBy actionWithDuration:kMoveTileTime scale:0.5f],
								  [CCScaleBy actionWithDuration:kMoveTileTime scale:2.0f],
								  [CCCallFuncN actionWithTarget:self selector:@selector(afterOneShineTrun:)],
								  nil];
		
		[sprite runAction:someAction];
	}
}


#pragma mark - #ui action methods

// 返回主菜单
-(void) actionBack:(id)sender{
    CCLOG(@"method:actionBack");
    
	[SceneManager goMenu];
}


// 更换头像
- (void) actionChangerAvatar{
    
    CCLOG(@"更换头像！");
    
    CCLayer *pUserInfoLayer = [SetUserInfoLayer node];
    [pUserInfoLayer setSkewX:10];
    [self addChild:pUserInfoLayer z:1];
}

#pragma mark - #game render
/**
 * 初始化游戏界面
 */
- (void) initGameUI{
    CCLOG(@"method:initGameUI");
    //头像 按钮
    CCMenuItemImage *pAvatar = [CCMenuItemImage itemWithNormalImage:@"q1.png" selectedImage:nil block:^(id sender){
        
        [self actionChangerAvatar];
    }];
    
    CCMenu *mAvatar = [CCMenu menuWithItems:pAvatar, nil];
    pAvatar.anchorPoint = ccp(0.0, 1);
    mAvatar.position = ccp(20.0, 480.0 - 20.0);
    [self addChild:mAvatar z:0];
    
    // 昵称
    NSString *strName = @"Player1";//[UserInfo name];
    CCLabelTTF *lblName = [CCLabelTTF labelWithString:strName fontName:@"Courier New" fontSize:20.0];
    lblName.anchorPoint = ccp(0.0, 1.0);
    lblName.position = ccp(70.0, 480.0 - 20.0);
    [self addChild:lblName z:0];
    
    // 等级
    NSString *strLevel = @"Level 1";
    CCLabelTTF *lblLevel = [CCLabelTTF labelWithString:strLevel fontName:@"Courier New" fontSize:20.0];
    lblLevel.anchorPoint = ccp(0.0, 1.0);
    lblLevel.position = ccp(70.0, 480.0 - 40.0);
    [self addChild:lblLevel z:0];
    
    // 积分
    NSString *strScore = @"1000";
    CCLabelTTF *lblScore = [CCLabelTTF labelWithString:strScore fontName:@"Courier New" fontSize:30.0];
    lblScore.anchorPoint = ccp(0.0, 1.0);
    lblScore.position = ccp(220.0, 480.0 - 25.0);
    [self addChild:lblScore z:0];
    
    //初始化时间进度条
    [self initProgress];
    
    //返回按钮
    CCMenuItemFont *pBack = [CCMenuItemFont itemWithString:@"back" block:^(id sender){
        [self actionBack:nil];
    }];
    pBack.fontName = @"Courier New";
    
    CCMenu *menu = [CCMenu menuWithItems:pBack, nil];
    [menu setPosition:ccp(320 - 40.0, 20.0)];
    [self addChild:menu z:0];
    
}


/**
 * 初始化时间进度条
 */
- (void) initProgress{
    
    CCLOG(@"method:initProgress");
    
    proDt = 1;
    
    //背景
    CCSprite *spImage = [CCSprite spriteWithFile:@"ww.png"];
    spImage.anchorPoint = CGPointZero;
    //[self addChild:spImage z:0 tag:1];
    
    //左背景进度条
    CCSprite *spriteLeftBG = [CCSprite spriteWithFile:@"pb_bg_left.png"];
    spriteLeftBG.position = ccp(kProBarLeftX, kProBarY);
    spriteLeftBG.anchorPoint = CGPointZero;
    [self addChild:spriteLeftBG z:0 tag:1];
    
    //右背景进度条
    CCSprite *spriterightBG = [CCSprite spriteWithFile:@"pb_bg_right.png"];
    spriterightBG.position = ccp(kProBarLeftX + kProBarWidth + 5, kProBarY);
    spriterightBG.anchorPoint = CGPointZero;
    [self addChild:spriterightBG z:0 tag:1];
    
    //中间背景进度条
    CCSprite *spriteBG = [CCSprite spriteWithFile:@"pb_bg.png"];
    spriteBG.position = ccp(kProBarLeftX + 5, kProBarY);
    spriteBG.anchorPoint = CGPointZero;
    spriteBG.scaleX = kProBarWidth;
    [self addChild:spriteBG z:0 tag:1];
    
    [self setPb_bar];
    
}

#pragma mark - #游戏引导

-(void) showStartIntro{
    CCLOG(@"method:showStartIntro");
    
	if (startIntroIndex >= [startIntroArray count]) {//引导结束开始游戏
        
        game.state = kGameStatePlaying;
		[self schedule:@selector(checkGameState) interval: kScheduleInterval];
		[startIntroArray release];
		startIntroArray = nil;
        
	}else {//引导进行...
		NSString *hintText = [startIntroArray objectAtIndex:startIntroIndex];
		
		CCLabelTTF *label = ccLP(hintText, 30.0f, ccp(160,240));
		label.opacity = 170;
		CCAction *action = [CCSequence actions:
							[CCSpawn actions:
							 [CCScaleTo actionWithDuration:0.8f scaleX:2.5f scaleY:2.5f],
							 [CCSequence actions:
							  [CCFadeTo actionWithDuration: 0.6f opacity:255],
							  [CCFadeTo actionWithDuration: 0.2f opacity:128],
							  nil],
							 nil],
							[CCCallFuncN actionWithTarget:self  selector:@selector(startIntroCallback:)],
							nil
							];
		[self addChild:label z:5 tag: kStartHint];
		[label runAction: action];
		startIntroIndex++;
	}
}

//引导回调
-(void) startIntroCallback: (id) sender{
    CCLOG(@"method:startIntroCallback");
    
	[self removeChild:sender cleanup:YES];
	[self showStartIntro];
}

#pragma mark - # 时间进度条

- (void) setPb_bar{
	
	//左进度条
	CCSprite *spriteLeftBAR = [CCSprite spriteWithFile:@"pb_bar_left.png"];
	spriteLeftBAR.position = ccp(kProBarLeftX, kProBarY);
	spriteLeftBAR.anchorPoint = CGPointZero;
	[self addChild:spriteLeftBAR z:0 tag:1];
	
	[self schedule:@selector(step:) interval:1];
    
}
-(void) step:(ccTime) dt
{
	time = dt + time;
	NSString *string = [NSString stringWithFormat:@"%d", (int)time];
	//CCLOG(@"~~~~~~%@~~~~~~~~~",string);
	proDt++;
	[self progress];
    
}

- (void) progress{
    
	
	if (proDt <= 99) {
		
        //中间背景进度条
        CCSprite *spriteBAR = [CCSprite spriteWithFile:@"pb_bar.png"];
        spriteBAR.position = ccp(kProBarLeftX + 2 + proDt * 210 / 98, kProBarY + 2);
        [self addChild:spriteBAR z:0 tag:2];
        
	}else if (proDt == 100){
		//右背景进度条
		CCSprite *spriterightBAR = [CCSprite spriteWithFile:@"pb_bar_right.png"];
		spriterightBAR.position = ccp(kProBarLeftX + kProBarWidth + 5 + proDt * 210 / 98, kProBarY + 3);
		[self addChild:spriterightBAR z:0 tag:2];
	}
    
}

@end
