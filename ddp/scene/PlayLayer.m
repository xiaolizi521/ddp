






#import "PlayLayer.h"
#import "SceneManager.h"

#define kProBarWidth    210
#define kProBarLeftX    30
#define kProBarY        160

@interface PlayLayer()

-(void)afterOneShineTrun: (id) node;

@end

@implementation PlayLayer

+(id) scene{
	CCScene *scene = [CCScene node];
	PlayLayer *layer = [PlayLayer node];
	[scene addChild: layer];
	return scene;
}

-(id) init{
	self = [super init];

  
    //返回按钮
    CCMenuItemFont *back = [CCMenuItemFont itemWithString:@"back" block:^(id sender){
        [self back:nil];
    }];
    back.fontName = @"Courier New";
    
    CCMenu *menu = [CCMenu menuWithItems:back, nil];
    [menu setPosition:ccp(320 - 40.0, 20.0)];
    [self addChild:menu z:0];
    
    //初始化时间哦进度条
    [self initProgress];
    
    
	box = [[Box alloc] initWithSize:CGSizeMake(kBoxWidth,kBoxHeight) factor:6];
	box.layer = self;
	box.lock = YES;
	return self;
}

/**
 * 初始化时间进度条
 */
- (void) initProgress{
    
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

-(void) onEnterTransitionDidFinish{
	[box check];
}

- (void)ccTouchesBegan:(NSSet*)touches withEvent:(UIEvent*)event{
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
	if(nil == firstOne){
		firstOne = data;
		return;
	}
	firstOne = nil;
	[box setLock:NO];
}

-(void) check: (id) sender data: (id) data{
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


-(void)afterOneShineTrun: (id) node{
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


-(void) back:(id)sender{
	[SceneManager goMenu];
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
	NSLog(@"~~~~~~%@~~~~~~~~~",string);
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
