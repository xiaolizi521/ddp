






#import "MenuLayer.h"

@implementation MenuLayer

-(id) init{
	self = [super init];
	
	CCLabelTTF *titleLeft = [CCLabelTTF labelWithString:@"Fruit " fontName:@"Marker Felt" fontSize:48];
	CCLabelTTF *titleRight = [CCLabelTTF labelWithString:@" Pair" fontName:@"Marker Felt" fontSize:48];
	
    // 开始
    [CCMenuItemFont setFontName: @"Marker Felt"];
    CCMenuItemFont *startNew = [CCMenuItemFont itemWithString:NSLocalizedString(@"Play", nil) block:^(id sender) {
        [self onStartNew:nil];
    }];
    
    // 继续
    CCMenuItemFont *resume = [CCMenuItemFont itemWithString:NSLocalizedString(@"Continue", nil)  block:^(id sender) {
        [self onResume:nil];
    }];
    
    // 排行
    CCMenuItemFont *highscores = [CCMenuItemFont itemWithString:NSLocalizedString(@"Record", nil)  block:^(id sender) {
        [self onHighscores:nil];
    }];
   
    // 配置
    CCMenuItemFont *credits = [CCMenuItemFont itemWithString:NSLocalizedString(@"Setting", nil)  block:^(id sender) {
        [self onCredits:nil];
    }];
    
	
	CCMenu *menu = [CCMenu menuWithItems:startNew, resume, highscores, credits, nil];
	
	float delayTime = 0.3f;
	
	for (CCMenuItemFont *each in [menu children]) {
		each.scaleX = 0.0f;
		each.scaleY = 0.0f;
		CCAction *action = [CCSequence actions:
		 [CCDelayTime actionWithDuration: delayTime],
		 [CCScaleTo actionWithDuration:0.5F scale:1.0],
		 nil];
		delayTime += 0.2f;
		[each runAction: action];
	}
	
	titleLeft.position = ccp(-80, 340);
	CCAction *titleLeftAction = [CCSequence actions:
			[CCDelayTime actionWithDuration: delayTime],
			[CCEaseBackOut actionWithAction:
			 [CCMoveTo actionWithDuration: 1.0 position:ccp(120,340)]],
			nil];
	[self addChild: titleLeft];
	[titleLeft runAction: titleLeftAction];
	
	titleRight.position = ccp(400, 340);
	CCAction *titleRightAction = [CCSequence actions:
								 [CCDelayTime actionWithDuration: delayTime],
								 [CCEaseBackOut actionWithAction:
								  [CCMoveTo actionWithDuration: 1.0 position:ccp(200,340)]],
								 nil];
	[self addChild: titleRight];
	[titleRight runAction: titleRightAction];
	
	menu.position = ccp(160, 240);
	[menu alignItemsVerticallyWithPadding: 40.0f];
	[self addChild:menu z: 2];

	return self;
}


#pragma mark - # Action method

- (void)onStartNew:(id)sender{
    
	[MusicHandler notifyButtonClick];
    [UserInfo init];
	[self onResume: sender];
}
- (void)onResume:(id)sender{
	[MusicHandler notifyButtonClick];
	[SceneManager goPlay];
}

- (void)onHighscores:(id)sender{
	[MusicHandler notifyButtonClick];
	[SceneManager goHighScores];
}
- (void)onCredits:(id)sender{
	[MusicHandler notifyButtonClick];
	[SceneManager goCredits];
}


@end
