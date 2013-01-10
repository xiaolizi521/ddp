//
//  GameLayer.m
//  T01
//
//  Created by li zeyao on 10-10-27.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Progress.h"


@implementation Progress

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Progress *layer = [Progress node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}
- (id)init{

	if((self=[super init] )) {
		i = 1;
		//背景
		CCSprite *spImage = [CCSprite spriteWithFile:@"ww.png"];
		spImage.anchorPoint = CGPointZero;
		//[self addChild:spImage z:0 tag:1];
		
		//左背景进度条
		CCSprite *spriteLeftBG = [CCSprite spriteWithFile:@"pb_bg_left.png"];
		spriteLeftBG.position = ccp(104,50);
		spriteLeftBG.anchorPoint = CGPointZero;
		[self addChild:spriteLeftBG z:0 tag:1];
		
		//右背景进度条
		CCSprite *spriterightBG = [CCSprite spriteWithFile:@"pb_bg_right.png"];
		spriterightBG.position = ccp(400,50);
		spriterightBG.anchorPoint = CGPointZero;
		[self addChild:spriterightBG z:0 tag:1];
		
		//中间背景进度条
		CCSprite *spriteBG = [CCSprite spriteWithFile:@"pb_bg.png"];
		spriteBG.position = ccp(254,53);
		spriteBG.scaleX = 292; 
		[self addChild:spriteBG z:0 tag:1];
        
		[self setPb_bar];

	}
	return self;
	
}

- (void) setPb_bar{
	
	//左进度条
	CCSprite *spriteLeftBAR = [CCSprite spriteWithFile:@"pb_bar_left.png"];
	spriteLeftBAR.position = ccp(104,50);
	spriteLeftBAR.anchorPoint = CGPointZero;
	[self addChild:spriteLeftBAR z:0 tag:1];
	
	[self schedule:@selector(step:) interval:1];
		
}
-(void) step:(ccTime) dt
{
	time = dt + time;
	NSString *string = [NSString stringWithFormat:@"%d", (int)time];
	NSLog(@"~~~~~~%@~~~~~~~~~",string);
	i++;
	[self progress];

}
- (void) progress{

	
	if (i<=292) {
		
	//中间背景进度条
	CCSprite *spriteBAR = [CCSprite spriteWithFile:@"pb_bar.png"];
	spriteBAR.position = ccp(107+i,53);
	[self addChild:spriteBAR z:0 tag:2];
	
	}else if (i==293){
		//右背景进度条
		CCSprite *spriterightBAR = [CCSprite spriteWithFile:@"pb_bar_right.png"];
		spriterightBAR.position = ccp(106+i,53);
		[self addChild:spriterightBAR z:0 tag:2];
	}

}
@end
